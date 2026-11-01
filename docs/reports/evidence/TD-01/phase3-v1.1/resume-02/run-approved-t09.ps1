$ErrorActionPreference='Stop'
$tdRoot=$PSScriptRoot
$tdLedgerPath=Join-Path $tdRoot 'approval-ledger.json'
$tdExecPath=Join-Path $tdRoot 'execution-continuation.json'
$tdLedger=Get-Content -Raw -LiteralPath $tdLedgerPath | ConvertFrom-Json
$tdExec=Get-Content -Raw -LiteralPath $tdExecPath | ConvertFrom-Json
$tdH5=$tdLedger.checkpoints | Where-Object checkpointId -eq 'TD01-P3-H5'
$tdR3=$tdLedger.checkpoints | Where-Object checkpointId -eq 'TD01-P3-R3'
if(-not $tdH5 -or $tdH5.state -ne 'APPROVED' -or $tdR3.state -ne 'APPROVED'){throw 'Current H5 and R3 approvals required'}
$tdPlan=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 't09-plan.json') | ConvertFrom-Json
if((Test-Path -LiteralPath (Join-Path $tdRoot 't09-session-operation.json')) -or (Test-Path -LiteralPath (Join-Path $tdRoot 't09-capture.json'))){throw 'Session already issued/recorded; no automatic retry'}
foreach($tdInput in $tdPlan.inputIdentities){
    $tdItem=Get-Item -LiteralPath $tdInput.path
    if($tdItem.Length -ne $tdInput.bytes -or (Get-FileHash -LiteralPath $tdInput.path -Algorithm SHA256).Hash -ne $tdInput.sha256){throw ('H5 input identity changed: '+$tdInput.path)}
}
if(@([Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners() | Where-Object Port -eq 3337).Count -gt 0){throw 'Private GDB port 3337 already in use; no shared server interaction'}
$tdNow=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
$tdRecord=[ordered]@{executionId='TD01-P3-T09-A01';testId='T09';requirementId='R5';checkpointIds=@('TD01-P3-R3','TD01-P3-H5');issuedAt=$tdNow;operator='Codex';workingDirectory=$tdPlan.workingDirectory;serverCommand=$tdPlan.serverCommand;clientCommand=$tdPlan.clientCommand;imageSha256=$tdLedger.image.sha256;state='STARTING_SERVER';serverReadyDeadlineSeconds=15;clientObservationDeadlineSeconds=120;automaticRetry=$false;forcedInterruptionAuthorized=$false;recoveryCounterBefore=1;loadInterventionIssued=$false;stdout='t09-gdb-stdout.log';stderr='t09-gdb-stderr.log';nativePermission='Concrete require_escalated invocation; native result records actual outcome'}
$tdOperationPath=Join-Path $tdRoot 't09-session-operation.json'
$tdRecord | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $tdOperationPath -Encoding utf8
$tdResult=[ordered]@{}
foreach($tdKey in $tdRecord.Keys){$tdResult[$tdKey]=$tdRecord[$tdKey]}
try{
    $tdServer=Start-Process -FilePath $tdPlan.serverCommand.executable -ArgumentList @($tdPlan.serverCommand.arguments) -WorkingDirectory $tdPlan.workingDirectory -WindowStyle Hidden -RedirectStandardOutput (Join-Path $tdRoot 't09-server-stdout.log') -RedirectStandardError (Join-Path $tdRoot 't09-server-stderr.log') -PassThru
    $tdResult['serverProcessId']=$tdServer.Id
    $tdReady=$false
    $tdWatch=[Diagnostics.Stopwatch]::StartNew()
    while($tdWatch.Elapsed.TotalSeconds -lt 15 -and -not $tdServer.HasExited){
        $tdServerText=[string](Get-Content -Raw -LiteralPath (Join-Path $tdRoot 't09-server-stdout.log') -ErrorAction SilentlyContinue)+[string](Get-Content -Raw -LiteralPath (Join-Path $tdRoot 't09-server-stderr.log') -ErrorAction SilentlyContinue)
        if($tdServerText -match 'listening on port 3337'){$tdReady=$true;break}
        Start-Sleep -Milliseconds 250
    }
    if(-not $tdReady){throw 'Owned server not ready within 15 s; do not launch GDB or issue target recovery'}
    $tdIssue=$tdExec.issues | Where-Object failureId -eq 'P3-F05'
    if($tdIssue.consumed -ne 1 -or $tdIssue.limit -ne 3){throw 'Unexpected persisted recovery counter; do not dispatch load-containing client'}
    $tdIssue.consumed=2
    $tdIssue.remaining=1
    $tdIssue.recoveryAttempts=@($tdIssue.recoveryAttempts)+@([ordered]@{recordedAt=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o');attempt=2;operation='H5 GDB same-image load plus associated three-region validating readback';executionId='TD01-P3-T09-A01';state='DISPATCHED';outcome='Pending actual client/capture result; conservatively counted on dispatch including failed/uncertain launch'})
    $tdCounter=$tdExec.recoveryCounters | Where-Object failureId -eq 'P3-F05'
    $tdCounter.consumed=2
    $tdCounter.remaining=1
    $tdExec.counts.hardwareRecoveryInterventions=2
    $tdExec.counts.tdHardwareTestAttempts=2
    $tdExec.counts.newTargetInvocations=[int]$tdExec.counts.newTargetInvocations+1
    ($tdExec.testGateEntries | Where-Object testId -eq 'T09').attemptsStarted=1
    $tdExec.workflowState='H5_T09_SESSION_DISPATCHED'
    $tdExec | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdExecPath -Encoding utf8
    $tdLedger.workflowState='H5_T09_SESSION_DISPATCHED'
    $tdLedger.events=@($tdLedger.events)+@([ordered]@{recordedAt=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o');event='H5_GDB_LOAD_AND_CAPTURE_DISPATCHED';executionId='TD01-P3-T09-A01';recoveryAttempt=2;detail='One same-image load and validating readback counted separately; monitor reset and hardware-breakpoint captures are approved planned T09 steps, not extra hidden recovery retries'})
    $tdLedger | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdLedgerPath -Encoding utf8
    $tdResult.loadInterventionIssued=$true
    $tdClient=Start-Process -FilePath $tdPlan.clientCommand.executable -ArgumentList @($tdPlan.clientCommand.arguments) -WorkingDirectory $tdPlan.workingDirectory -WindowStyle Hidden -RedirectStandardOutput (Join-Path $tdRoot 't09-gdb-stdout.log') -RedirectStandardError (Join-Path $tdRoot 't09-gdb-stderr.log') -PassThru
    $tdResult['clientProcessId']=$tdClient.Id
    $tdResult['clientLaunchObservedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
    $tdWatch.Restart()
    while(-not $tdClient.HasExited -and $tdWatch.Elapsed.TotalSeconds -lt 120){Start-Sleep -Milliseconds 250}
    if($tdClient.HasExited){
        $tdClient.WaitForExit()
        $tdResult.state='CLIENT_COMPLETED'
        $tdResult['clientExitCode']=$tdClient.ExitCode
        if(Test-Path -LiteralPath (Join-Path $tdRoot 't09-capture.json')){$tdCapture=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 't09-capture.json') | ConvertFrom-Json;$tdResult['captureStatus']=$tdCapture.status;$tdResult['captureEvidence']='t09-capture.json'}
        $tdServer.WaitForExit(5000) | Out-Null
        $tdResult['ownedServerExited']=$tdServer.HasExited
    }else{
        $tdResult.state='RUNNING_AT_CLIENT_OBSERVATION_DEADLINE'
        $tdResult['clientExitCode']=$null
        [ordered]@{recordedAt=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o');reason='120 s observation deadline; do not issue further explicit target commands or force interruption';clientPid=$tdClient.Id;serverPid=$tdServer.Id} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $tdRoot 't09-stop-requested.json') -Encoding utf8
    }
}catch{
    $tdResult.state='LAUNCH_OR_SESSION_ERROR'
    $tdResult['error']=$_.Exception.Message
}
$tdResult['recordedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
$tdResult['safeStop']='No forced process/target interruption, no automatic reset/retry; preserve any active PIDs/logs and request disposition if uncertain'
$tdResult | ConvertTo-Json -Depth 14 | Set-Content -LiteralPath (Join-Path $tdRoot 't09-session-result.json') -Encoding utf8
$tdResult | ConvertTo-Json -Depth 14
foreach($tdLog in @('t09-server-stdout.log','t09-server-stderr.log','t09-gdb-stdout.log','t09-gdb-stderr.log')){if(Test-Path -LiteralPath (Join-Path $tdRoot $tdLog)){Get-Content -LiteralPath (Join-Path $tdRoot $tdLog)}}
if($tdResult.state -ne 'CLIENT_COMPLETED' -or $tdResult.clientExitCode -ne 0 -or $tdResult.captureStatus -ne 'PASS'){exit 1}
