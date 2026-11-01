param([Parameter(Mandatory=$true)][ValidateSet('Load','Verify')][string]$Operation)
$ErrorActionPreference='Stop'
$tdRoot=$PSScriptRoot
$tdApprovalPath=Join-Path $tdRoot 'approval-ledger.json'
$tdExecutionPath=Join-Path $tdRoot 'execution-continuation.json'
$tdApproval=Get-Content -Raw -LiteralPath $tdApprovalPath | ConvertFrom-Json
$tdExecution=Get-Content -Raw -LiteralPath $tdExecutionPath | ConvertFrom-Json
$tdH3=$tdApproval.checkpoints | Where-Object checkpointId -eq 'TD01-P3-H3'
$tdR3=$tdApproval.checkpoints | Where-Object checkpointId -eq 'TD01-P3-R3'
if($tdH3.state -ne 'APPROVED' -or $tdR3.state -ne 'APPROVED'){throw 'Fresh R3/H3 approvals required'}
$tdIsLoad=$Operation -eq 'Load'
$tdStem=if($tdIsLoad){'load'}else{'verify-after-load'}
$tdResultPath=Join-Path $tdRoot ($tdStem+'-result.json')
$tdOperationPath=Join-Path $tdRoot ($tdStem+'-operation.json')
if((Test-Path -LiteralPath $tdResultPath) -or (Test-Path -LiteralPath $tdOperationPath)){throw 'Invocation already issued or recorded; no automatic retry'}
$tdImage=Get-Item -LiteralPath $tdApproval.image.path
if($tdImage.Length -ne $tdApproval.image.bytes -or (Get-FileHash -Algorithm SHA256 -LiteralPath $tdImage.FullName).Hash -ne $tdApproval.image.sha256){throw 'Image does not match approved identity'}
$tdOriginal=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 'resume-identity.json') | ConvertFrom-Json
$tdCommand=$tdH3.commands | Where-Object sequence -eq $(if($tdIsLoad){1}else{2})
foreach($tdCritical in @($tdCommand.executable,'C:\NXP\LinkServer_26.9.130\binaries\ToolScripts\LS_preconnect_MCXN2XX.scp')){
    $tdExpected=$tdOriginal.protectedAdditionalInputs | Where-Object path -eq $tdCritical
    if(-not $tdExpected -or (Get-FileHash -Algorithm SHA256 -LiteralPath $tdCritical).Hash -ne $tdExpected.sha256){throw 'Critical tool/hook identity changed'}
}
if(-not $tdIsLoad){
    $tdLoad=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 'load-result.json') | ConvertFrom-Json
    $tdLoadReview=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 'load-review.json') | ConvertFrom-Json
    if($tdLoad.state -ne 'COMPLETED' -or $tdLoad.exitCode -ne 0 -or -not $tdLoadReview.eligibleForVerify){throw 'Successful expected load result and recorded review required'}
}
$tdNow=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
$tdStdout=Join-Path $tdRoot ($tdStem+'-stdout.log')
$tdStderr=Join-Path $tdRoot ($tdStem+'-stderr.log')
$tdRecord=[ordered]@{executionId=$tdCommand.proposedExecutionId;kind='Approved image programming/identity validation; not a TD functional test';checkpointIds=@('TD01-P3-R3','TD01-P3-H3');operation=$Operation;issuedAt=$tdNow;workingDirectory=$tdH3.workingDirectory;executable=$tdCommand.executable;arguments=@($tdCommand.arguments);imageSha256=$tdApproval.image.sha256;stdout=$tdStdout;stderr=$tdStderr;state='ISSUING';automaticRetryAllowed=$false;observationDeadlineSeconds=30;forcedInterruptionAuthorized=$false;nativePermission='This concrete invocation submitted through require_escalated; returned native tool result is authoritative for outcome'}
$tdRecord | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $tdOperationPath -Encoding utf8
if($tdIsLoad){
    $tdIssue=$tdExecution.issues | Where-Object failureId -eq 'P3-F05'
    if($tdIssue.consumed -ne 0 -or $tdIssue.limit -ne 3){throw 'Unexpected persisted P3-F05 counter; do not issue'}
    $tdIssue.consumed=1
    $tdIssue.remaining=2
    $tdIssue.recoveryAttempts=@($tdIssue.recoveryAttempts)+@([ordered]@{recordedAt=$tdNow;attempt=1;operation='One H3 exact-image load; associated validating verify does not consume second attempt';executionId=$tdCommand.proposedExecutionId;state='ISSUED';outcome='Pending actual command result'})
    $tdCounter=$tdExecution.recoveryCounters | Where-Object failureId -eq 'P3-F05'
    $tdCounter.consumed=1
    $tdCounter.remaining=2
    $tdExecution.counts.hardwareRecoveryInterventions=1
    $tdH3.recoveryAccounting.consumedNow=1
    $tdH3.recoveryAccounting.remainingNow=2
}
$tdExecution.workflowState='AUTHORIZED_IMAGE_OPERATION_ISSUED'
$tdExecution.counts.newTargetInvocations=[int]$tdExecution.counts.newTargetInvocations+1
$tdExecution | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdExecutionPath -Encoding utf8
$tdApproval.workflowState='AUTHORIZED_IMAGE_OPERATION_ISSUED'
$tdApproval.events=@($tdApproval.events)+@([ordered]@{recordedAt=$tdNow;event='H3_OPERATION_ISSUED';executionId=$tdCommand.proposedExecutionId;operation=$Operation;detail='Fresh H3 scope only; no automatic retry or subsequent unapproved target action'})
$tdApproval | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdApprovalPath -Encoding utf8
$tdResult=[ordered]@{}
foreach($tdKey in $tdRecord.Keys){$tdResult[$tdKey]=$tdRecord[$tdKey]}
try{
    $tdProcess=Start-Process -FilePath $tdCommand.executable -ArgumentList @($tdCommand.arguments) -WorkingDirectory $tdH3.workingDirectory -WindowStyle Hidden -RedirectStandardOutput $tdStdout -RedirectStandardError $tdStderr -PassThru
    $tdResult['processId']=$tdProcess.Id
    $tdResult['startedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
    if($tdProcess.WaitForExit(30000)){
        $tdProcess.WaitForExit()
        $tdResult.state='COMPLETED'
        $tdResult['exitCode']=$tdProcess.ExitCode
        $tdResult['endedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
    }else{
        $tdResult.state='RUNNING_AT_OBSERVATION_DEADLINE'
        $tdResult['exitCode']=$null
        $tdResult['endedAt']=$null
        $tdResult['stopDecision']='Do not issue any more target command, force interruption or reset. Preserve PID/logs and obtain engineer disposition.'
    }
}catch{
    $tdResult.state='LAUNCH_OR_OBSERVATION_ERROR'
    $tdResult['exitCode']=$null
    $tdResult['error']=$_.Exception.Message
    $tdResult['endedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
}
$tdResult['targetPostState']='Unknown; no standalone reset/run/attach authorized'
$tdResult | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $tdResultPath -Encoding utf8
$tdResult | ConvertTo-Json -Depth 12
if(Test-Path -LiteralPath $tdStdout){Get-Content -LiteralPath $tdStdout}
if(Test-Path -LiteralPath $tdStderr){Get-Content -LiteralPath $tdStderr}
if($tdResult.state -ne 'COMPLETED' -or $tdResult.exitCode -ne 0){exit 1}
