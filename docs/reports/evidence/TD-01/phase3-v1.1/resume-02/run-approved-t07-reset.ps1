param([Parameter(Mandatory=$true)][ValidateRange(1,3)][int]$Repetition)
$ErrorActionPreference='Stop'
$tdRoot=$PSScriptRoot
$tdLedgerPath=Join-Path $tdRoot 'approval-ledger.json'
$tdExecutionPath=Join-Path $tdRoot 'execution-continuation.json'
$tdLedger=Get-Content -Raw -LiteralPath $tdLedgerPath | ConvertFrom-Json
$tdExecution=Get-Content -Raw -LiteralPath $tdExecutionPath | ConvertFrom-Json
$tdH4=$tdLedger.checkpoints | Where-Object checkpointId -eq 'TD01-P3-H4'
if($tdH4.state -ne 'APPROVED'){throw 'Current H4 authorization required'}
$tdStem='t07-reset'+$Repetition
$tdOperationPath=Join-Path $tdRoot ($tdStem+'-operation.json')
$tdResultPath=Join-Path $tdRoot ($tdStem+'-result.json')
if((Test-Path -LiteralPath $tdOperationPath) -or (Test-Path -LiteralPath $tdResultPath)){throw 'Reset already issued/recorded; no automatic retry'}
if($Repetition -gt 1){
    $tdPriorObservation=Get-Content -Raw -LiteralPath (Join-Path $tdRoot ('t07-reset'+($Repetition-1)+'-observation.json')) | ConvertFrom-Json
    if(-not $tdPriorObservation.sufficientForPlannedContinuation){throw 'Previous actual observation does not permit next planned reset'}
    $tdPriorResult=Get-Content -Raw -LiteralPath (Join-Path $tdRoot ('t07-reset'+($Repetition-1)+'-result.json')) | ConvertFrom-Json
    if($tdPriorResult.state -ne 'COMPLETED' -or $tdPriorResult.exitCode -ne 0){throw 'Previous reset did not complete successfully'}
}
if((Get-FileHash -LiteralPath $tdLedger.image.path -Algorithm SHA256).Hash -ne $tdLedger.image.sha256){throw 'Designated image file identity changed'}
$tdVerification=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 'verify-after-load-review.json') | ConvertFrom-Json
if(-not $tdVerification.imageContentVerified){throw 'Image verification prerequisite not established'}
$tdSnapshot=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 'resume-identity.json') | ConvertFrom-Json
$tdToolIdentity=$tdSnapshot.protectedAdditionalInputs | Where-Object path -eq $tdH4.command.executable
if((Get-FileHash -LiteralPath $tdH4.command.executable -Algorithm SHA256).Hash -ne $tdToolIdentity.sha256){throw 'Tool identity changed'}
$tdNow=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
$tdStdout=Join-Path $tdRoot ($tdStem+'-stdout.log')
$tdStderr=Join-Path $tdRoot ($tdStem+'-stderr.log')
$tdRecord=[ordered]@{executionId=('TD01-P3-T07-A01-R'+$Repetition);testId='T07';requirementId='R4';operator='Codex reset; engineer visual observation pending';checkpointId='TD01-P3-H4';repetition=$Repetition;plannedRepetitions=3;issuedAt=$tdNow;workingDirectory=$tdH4.workingDirectory;executable=$tdH4.command.executable;arguments=@($tdH4.command.arguments);imageSha256=$tdLedger.image.sha256;loadedImageEvidence='verify-after-load-review.json';stdout=$tdStdout;stderr=$tdStderr;state='ISSUING';automaticRetryAllowed=$false;observationDeadlineSeconds=30;forcedInterruptionAuthorized=$false;recoveryAttemptsConsumed=0;nativePermission='Concrete require_escalated invocation; outcome in native tool result';visualObservation='Not received; no functional PASS asserted'}
$tdRecord | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $tdOperationPath -Encoding utf8
$tdTest=$tdExecution.testGateEntries | Where-Object testId -eq 'T07'
$tdTest.attemptsStarted=1
$tdExecution.counts.tdHardwareTestAttempts=1
$tdExecution.counts.newTargetInvocations=[int]$tdExecution.counts.newTargetInvocations+1
$tdExecution.workflowState='T07_RESET_ISSUED_OBSERVATION_PENDING'
$tdExecution | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdExecutionPath -Encoding utf8
$tdLedger.workflowState='T07_RESET_ISSUED_OBSERVATION_PENDING'
$tdLedger.events=@($tdLedger.events)+@([ordered]@{recordedAt=$tdNow;event='H4_T07_PLANNED_RESET_ISSUED';repetition=$Repetition;executionId=$tdRecord.executionId;detail='One planned repetition, not recovery retry; wait for actual engineer observation before any next reset'})
$tdLedger | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdLedgerPath -Encoding utf8
$tdResult=[ordered]@{}
foreach($tdKey in $tdRecord.Keys){$tdResult[$tdKey]=$tdRecord[$tdKey]}
try{
    $tdProcess=Start-Process -FilePath $tdH4.command.executable -ArgumentList @($tdH4.command.arguments) -WorkingDirectory $tdH4.workingDirectory -WindowStyle Hidden -RedirectStandardOutput $tdStdout -RedirectStandardError $tdStderr -PassThru
    $tdResult['processId']=$tdProcess.Id
    $tdResult['launchObservedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
    if($tdProcess.WaitForExit(30000)){
        $tdProcess.WaitForExit()
        $tdResult.state='COMPLETED'
        $tdResult['exitCode']=$tdProcess.ExitCode
        $tdResult['endedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
    }else{
        $tdResult.state='RUNNING_AT_OBSERVATION_DEADLINE'
        $tdResult['exitCode']=$null
        $tdResult['endedAt']=$null
        $tdResult['stopDecision']='No subsequent target command, forced interruption or automatic reset; obtain engineer disposition'
    }
}catch{
    $tdResult.state='LAUNCH_OR_OBSERVATION_ERROR'
    $tdResult['exitCode']=$null
    $tdResult['error']=$_.Exception.Message
    $tdResult['endedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
}
$tdResult | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $tdResultPath -Encoding utf8
$tdResult | ConvertTo-Json -Depth 12
if(Test-Path -LiteralPath $tdStdout){Get-Content -LiteralPath $tdStdout}
if(Test-Path -LiteralPath $tdStderr){Get-Content -LiteralPath $tdStderr}
if($tdResult.state -ne 'COMPLETED' -or $tdResult.exitCode -ne 0){exit 1}
