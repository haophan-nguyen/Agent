param([switch]$ValidateOnly)
$ErrorActionPreference='Stop'

function Convert-TdMiText([string]$Line){
    if($Line -match '^[~@&](".*")$'){return ($Matches[1] | ConvertFrom-Json)}
    return ''
}
function Convert-TdMiMemory([string]$Row,[long]$Address,[int]$Count){
    $tdBytes=[byte[]]::new($Count)
    $tdCoverage=[bool[]]::new($Count)
    foreach($tdBlock in [regex]::Matches($Row,'\{[^{}]*contents="[0-9A-Fa-f]*"[^{}]*\}')){
        $tdBeginMatch=[regex]::Match($tdBlock.Value,'begin="0x([0-9A-Fa-f]+)"')
        $tdHexMatch=[regex]::Match($tdBlock.Value,'contents="([0-9A-Fa-f]*)"')
        if(-not $tdBeginMatch.Success -or -not $tdHexMatch.Success){throw 'Malformed MI memory block'}
        $tdOffset=[Convert]::ToInt64($tdBeginMatch.Groups[1].Value,16)-$Address
        $tdBlockBytes=[Convert]::FromHexString($tdHexMatch.Groups[1].Value)
        if($tdOffset -lt 0 -or $tdOffset+$tdBlockBytes.Length -gt $Count){throw 'Out-of-range MI memory block'}
        [Array]::Copy($tdBlockBytes,0,$tdBytes,[int]$tdOffset,$tdBlockBytes.Length)
        for($tdJ=0;$tdJ -lt $tdBlockBytes.Length;$tdJ++){$tdCoverage[[int]$tdOffset+$tdJ]=$true}
    }
    if(@($tdCoverage | Where-Object {-not $_}).Count -gt 0){throw 'Incomplete MI memory coverage'}
    return ,$tdBytes
}
if($ValidateOnly){
    $tdSample='4^done,memory=[{begin="0x00000400",offset="0x0",end="0x00000402",contents="0102"},{begin="0x00000402",offset="0x2",end="0x00000404",contents="0304"}]'
    if([Convert]::ToHexString((Convert-TdMiMemory $tdSample 1024 4)) -ne '01020304'){throw 'Memory parser self-check failed'}
    if((Convert-TdMiText '@"PriMask=0x00\nBasePri=0x00\nFaultMask=0x00\n"') -notmatch 'BasePri=0x00'){throw 'MI string parser self-check failed'}
    $tdRejected=$false
    try{Convert-TdMiMemory '1^done,memory=[{begin="0x400",contents="01"}]' 1024 4 | Out-Null}catch{$tdRejected=$true}
    if(-not $tdRejected){throw 'Partial memory coverage was not rejected'}
    'Native MI parser self-checks passed; no GDB or hardware process launched'
    exit 0
}

$tdRoot=$PSScriptRoot
$tdLedgerPath=Join-Path $tdRoot 'approval-ledger.json'
$tdExecPath=Join-Path $tdRoot 'execution-continuation.json'
$tdLedger=Get-Content -Raw -LiteralPath $tdLedgerPath | ConvertFrom-Json
$tdExec=Get-Content -Raw -LiteralPath $tdExecPath | ConvertFrom-Json
$tdH6=$tdLedger.checkpoints | Where-Object checkpointId -eq 'TD01-P3-H6'
if(-not $tdH6 -or $tdH6.state -ne 'APPROVED'){throw 'Fresh H6 approval required'}
$tdPlan=Get-Content -Raw -LiteralPath (Join-Path $tdRoot 't09-native-plan.json') | ConvertFrom-Json
foreach($tdInput in $tdPlan.inputIdentities){$tdItem=Get-Item -LiteralPath $tdInput.path;if($tdItem.Length -ne $tdInput.bytes -or (Get-FileHash -LiteralPath $tdInput.path -Algorithm SHA256).Hash -ne $tdInput.sha256){throw ('Frozen H6 input changed: '+$tdInput.path)}}
$tdCapturePath=Join-Path $tdRoot 't09-native-capture.json'
if((Test-Path -LiteralPath $tdCapturePath) -or (Test-Path -LiteralPath (Join-Path $tdRoot 't09-native-operation.json'))){throw 'Native session already issued; no automatic retry'}
$tdOwned=Get-CimInstance -ClassName Win32_Process -Filter 'ProcessId=22292' -OperationTimeoutSec 10 -ErrorAction Stop
if(-not $tdOwned -or $tdOwned.Name -ne 'LinkServer.exe' -or $tdOwned.ExecutablePath -ne 'C:\NXP\LinkServer_26.9.130\LinkServer.exe' -or $tdOwned.CommandLine -notmatch 'gdbserver' -or $tdOwned.CommandLine -notmatch '3337' -or $tdOwned.CommandLine -notmatch 'SPOBEAQ0BCREX' -or $tdOwned.CommandLine -notmatch 'MCXN236:FRDM-MCXN236'){throw 'Owned waiting server identity changed; do not connect elsewhere'}
if(@([Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners() | Where-Object {$_.Port -eq 3337 -and $_.Address.ToString() -eq '127.0.0.1'}).Count -ne 1){throw 'Owned loopback server listener unavailable/ambiguous'}
$tdNow=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
$script:tdState=[ordered]@{executionId='TD01-P3-T09-A02';testId='T09';requirementId='R5';failureIds=@('P3-F07','P3-F05');recordedAt=$tdNow;status='BLOCKED';imageSha256=$tdLedger.image.sha256;ownedServerPid=22292;events=@();imageReadback=@();snapshots=[ordered]@{};checks=[ordered]@{};cleanup=@()}
function Save-TdState{$script:tdState | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdCapturePath -Encoding utf8}
$tdOperation=[ordered]@{executionId='TD01-P3-T09-A02';testId='T09';checkpointId='TD01-P3-H6';issuedAt=$tdNow;workingDirectory=$tdPlan.workingDirectory;clientCommand=$tdPlan.clientCommand;server='Explicitly authorized reuse of owned H5 PID22292 at 127.0.0.1:3337';scope='One native MI client, one load/readback, one planned monitor reset, two capture points, cleanup stop/disconnect';P3F05Attempt=3;P3F07Attempt=1;automaticRetry=$false;nativePermission='Concrete require_escalated invocation; actual result retained by native tool'}
$tdOperation | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Join-Path $tdRoot 't09-native-operation.json') -Encoding utf8
Save-TdState
$tdF05=$tdExec.issues | Where-Object failureId -eq 'P3-F05'
$tdF07=$tdExec.issues | Where-Object failureId -eq 'P3-F07'
if($tdF05.consumed -ne 2 -or $tdF07.consumed -ne 0){throw 'Unexpected carried recovery counters; do not dispatch'}
$tdF05.consumed=3;$tdF05.remaining=0
$tdF05.recoveryAttempts=@($tdF05.recoveryAttempts)+@([ordered]@{recordedAt=$tdNow;attempt=3;operation='H6 final same-image load-containing native MI client dispatch, with associated three-region validation';executionId='TD01-P3-T09-A02';state='DISPATCHED';outcome='Pending actual result; no fourth intervention permitted'})
$tdF07.consumed=1;$tdF07.remaining=2
$tdF07.recoveryAttempts=@($tdF07.recoveryAttempts)+@([ordered]@{recordedAt=$tdNow;attempt=1;operation='Replace unsupported Python capture with prepared native GDB/MI helper and retest once';executionId='TD01-P3-T09-A02';state='DISPATCHED';outcome='Pending actual result'})
foreach($tdCounter in $tdExec.recoveryCounters){if($tdCounter.failureId -eq 'P3-F05'){$tdCounter.consumed=3;$tdCounter.remaining=0};if($tdCounter.failureId -eq 'P3-F07'){$tdCounter.consumed=1;$tdCounter.remaining=2}}
$tdExec.counts.hardwareRecoveryInterventions=3
$tdExec.counts.tdHardwareTestAttempts=3
$tdExec.counts.newTargetInvocations=[int]$tdExec.counts.newTargetInvocations+1
($tdExec.testGateEntries | Where-Object testId -eq 'T09').attemptsStarted=2
$tdExec.workflowState='H6_FINAL_T09_SESSION_DISPATCHED'
$tdExec | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdExecPath -Encoding utf8
$tdLedger.workflowState=$tdExec.workflowState
$tdLedger.events=@($tdLedger.events)+@([ordered]@{recordedAt=$tdNow;event='H6_NATIVE_MI_RETEST_DISPATCHED';executionId='TD01-P3-T09-A02';P3F05Attempt=3;P3F07Attempt=1;detail='Final existing image/recovery allowance; no automatic retry, no counter renewal'})
$tdLedger | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $tdLedgerPath -Encoding utf8
$script:tdClient=[Diagnostics.Process]::new()
$script:tdClient.StartInfo.FileName=$tdPlan.clientCommand.executable
foreach($tdArg in $tdPlan.clientCommand.arguments){$script:tdClient.StartInfo.ArgumentList.Add([string]$tdArg)}
$script:tdClient.StartInfo.WorkingDirectory=$tdPlan.workingDirectory
$script:tdClient.StartInfo.UseShellExecute=$false
$script:tdClient.StartInfo.CreateNoWindow=$true
$script:tdClient.StartInfo.RedirectStandardInput=$true
$script:tdClient.StartInfo.RedirectStandardOutput=$true
$script:tdClient.StartInfo.RedirectStandardError=$true
$script:tdRaw=[IO.StreamWriter]::new((Join-Path $tdRoot 't09-native-gdb-stdout.log'),$false,[Text.UTF8Encoding]::new($false))
$script:tdRaw.AutoFlush=$true
$script:tdToken=0
$script:tdStops=[Collections.Generic.Queue[string]]::new()
$script:tdConnected=$false
$script:tdUnsafe=$false
$script:tdTimedOut=$false
$script:tdRunning=$false
$script:tdClientStarted=$false
$script:tdSessionClock=[Diagnostics.Stopwatch]::StartNew()
function Read-TdMiLine([Diagnostics.Stopwatch]$Clock,[int]$Seconds){
    while(-not $script:tdReadTask.IsCompleted){
        if($Clock.Elapsed.TotalSeconds -ge $Seconds -or $script:tdSessionClock.Elapsed.TotalSeconds -ge 120){$script:tdTimedOut=$true;throw 'MI observation deadline; no further command or forced interruption'}
        Start-Sleep -Milliseconds 25
    }
    $tdLine=$script:tdReadTask.GetAwaiter().GetResult()
    if($null -eq $tdLine){throw 'GDB MI output closed before expected result'}
    $script:tdRaw.WriteLine($tdLine)
    $script:tdReadTask=$script:tdClient.StandardOutput.ReadLineAsync()
    if($tdLine.StartsWith('*stopped')){$script:tdStops.Enqueue($tdLine)}
    return $tdLine
}
function Send-TdMi([string]$Command,[int]$Seconds=10){
    if($script:tdTimedOut){throw 'No command after timeout'}
    $script:tdToken++
    $tdCurrent=$script:tdToken
    $tdEvent=[ordered]@{recordedAt=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o');token=$tdCurrent;command=$Command;state='ISSUING'}
    $script:tdState.events+=@($tdEvent)
    Save-TdState
    $script:tdClient.StandardInput.WriteLine(([string]$tdCurrent+$Command))
    $script:tdClient.StandardInput.Flush()
    $tdClock=[Diagnostics.Stopwatch]::StartNew()
    $tdConsole=[Collections.Generic.List[string]]::new()
    while($true){
        $tdLine=Read-TdMiLine $tdClock $Seconds
        $tdText=Convert-TdMiText $tdLine
        if($tdText){$tdConsole.Add($tdText)}
        if($tdLine.StartsWith(([string]$tdCurrent+'^'))){
            $tdEvent['result']=$tdLine;$tdEvent['console']=($tdConsole -join '')
            $tdEvent.state='COMPLETED';Save-TdState
            if($tdLine -match '^\d+\^error'){$tdEvent.state='ERROR';Save-TdState;throw ('GDB MI command error: '+$tdLine)}
            return [pscustomobject]@{Row=$tdLine;Console=($tdConsole -join '')}
        }
    }
}
function Send-TdConsole([string]$Command,[int]$Seconds=10){return Send-TdMi ('-interpreter-exec console '+(ConvertTo-Json -InputObject $Command -Compress)) $Seconds}
function Read-TdMemory([long]$Address,[int]$Count){
    $tdReply=Send-TdMi ('-data-read-memory-bytes 0x{0:X} {1}' -f $Address,$Count)
    return ,(Convert-TdMiMemory $tdReply.Row $Address $Count)
}
function Get-TdWord([long]$Address){return [BitConverter]::ToUInt32((Read-TdMemory $Address 4),0)}
function Continue-TdToStop{
    $script:tdStops.Clear()
    $script:tdRunning=$true
    Send-TdMi '-exec-continue' | Out-Null
    $script:tdStops.Clear()
    $tdClock=[Diagnostics.Stopwatch]::StartNew()
    while($script:tdStops.Count -eq 0){Read-TdMiLine $tdClock 10 | Out-Null}
    $script:tdRunning=$false
    $tdStop=$script:tdStops.Dequeue()
    $script:tdState.events+=@([ordered]@{recordedAt=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o');stopRecord=$tdStop})
    Save-TdState
}
function Capture-TdRegisters([string]$Label,[long]$ExpectedPC){
    $tdPcReply=Send-TdMi '-data-evaluate-expression "$pc"'
    $tdPcMatch=[regex]::Match($tdPcReply.Row,'value="0x([0-9A-Fa-f]+)')
    if(-not $tdPcMatch.Success -or [Convert]::ToInt64($tdPcMatch.Groups[1].Value,16) -ne $ExpectedPC){throw ('Unexpected actual PC for '+$Label+': '+$tdPcReply.Row)}
    $tdCore=(Send-TdConsole 'monitor register_display core').Console
    $tdMasks=[ordered]@{}
    foreach($tdName in @('PriMask','BasePri','FaultMask')){$tdMatches=[regex]::Matches($tdCore,('(?im)(?:^|[}\s])'+$tdName+'\s*=\s*(0x[0-9a-f]+)'));if($tdMatches.Count -ne 1){throw ('Missing/ambiguous actual '+$tdName+' at '+$Label)};$tdMasks[$tdName]=[Convert]::ToUInt32($tdMatches[0].Groups[1].Value.Substring(2),16)}
    $tdPriority=Read-TdMemory 0xE000ED23 1
    $tdCtrl=Get-TdWord 0xE000E010
    $tdSnapshot=[ordered]@{recordedAt=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o');pc=$ExpectedPC;priorityRawByte=[int]$tdPriority[0];ctrlRaw=$tdCtrl;ctrlConfiguration=($tdCtrl -band 7);load=(Get-TdWord 0xE000E014);systemCoreClock=(Get-TdWord 0x20000000);interruptMasks=$tdMasks;coreRegisterOutput=$tdCore;method='Halted debug capture; CTRL read clears COUNTFLAG; no timing inference'}
    $script:tdState.snapshots[$Label]=$tdSnapshot
    Save-TdState
    return $tdSnapshot
}
try{
    if(-not $script:tdClient.Start()){throw 'GDB MI process did not start'}
    $script:tdClientStarted=$true
    $script:tdState['clientProcessId']=$script:tdClient.Id
    $script:tdReadTask=$script:tdClient.StandardOutput.ReadLineAsync()
    $tdStderrTask=$script:tdClient.StandardError.ReadToEndAsync()
    Send-TdMi '-gdb-set pagination off' | Out-Null
    Send-TdMi '-gdb-set confirm off' | Out-Null
    Send-TdMi '-gdb-set remotetimeout 10' | Out-Null
    Send-TdMi '-gdb-set mi-async on' | Out-Null
    Send-TdMi '-gdb-set style enabled off' | Out-Null
    Send-TdMi ('-file-exec-and-symbols '+(ConvertTo-Json -InputObject $tdLedger.image.path.Replace('\','/') -Compress)) | Out-Null
    Send-TdMi '-target-select remote 127.0.0.1:3337' | Out-Null
    $script:tdConnected=$true
    Send-TdConsole 'monitor ondisconnect stop' | Out-Null
    Send-TdConsole 'monitor kill_server' | Out-Null
    Send-TdConsole 'monitor flash_load_option no_mass_at_0' | Out-Null
    Send-TdConsole 'monitor flash_load_option no_mass_not_0' | Out-Null
    $script:tdUnsafe=$true
    Send-TdConsole 'load' 30 | Out-Null
    $script:tdUnsafe=$false
    $tdImageBytes=[IO.File]::ReadAllBytes($tdLedger.image.path)
    foreach($tdRegion in $tdPlan.imageReadbackRegions){
        $tdActual=Read-TdMemory $tdRegion.address $tdRegion.bytes
        $tdExpected=[byte[]]$tdImageBytes[$tdRegion.fileOffset..($tdRegion.fileOffset+$tdRegion.bytes-1)]
        $tdActualHash=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($tdActual))
        $tdExpectedHash=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($tdExpected))
        $tdSame=[Convert]::ToHexString($tdActual) -ceq [Convert]::ToHexString($tdExpected)
        $script:tdState.imageReadback+=@([ordered]@{address=$tdRegion.address;fileOffset=$tdRegion.fileOffset;bytes=$tdRegion.bytes;matches=$tdSame;actualSha256=$tdActualHash;expectedSha256=$tdExpectedHash})
        Save-TdState
        if(-not $tdSame){throw 'Loaded-image identity mismatch; do not continue application'}
    }
    $script:tdState['loadedImageVerified']=$true
    $tdBeforeBp=Send-TdMi '-break-insert -h "*0x00001e7a"'
    $tdBeforeId=[regex]::Match($tdBeforeBp.Row,'number="(\d+)"').Groups[1].Value
    if(-not $tdBeforeId){throw 'Before hardware breakpoint identity missing'}
    Send-TdConsole 'monitor reset' | Out-Null
    Continue-TdToStop
    $tdBefore=Capture-TdRegisters 'before' 0x1E7A
    Send-TdMi ('-break-delete '+$tdBeforeId) | Out-Null
    $tdAfterBp=Send-TdMi '-break-insert -h "*0x00001ea4"'
    $tdAfterId=[regex]::Match($tdAfterBp.Row,'number="(\d+)"').Groups[1].Value
    if(-not $tdAfterId){throw 'After hardware breakpoint identity missing'}
    Continue-TdToStop
    $tdAfter=Capture-TdRegisters 'after' 0x1EA4
    $script:tdState.checks=[ordered]@{priorityPreserved=($tdBefore.priorityRawByte -eq $tdAfter.priorityRawByte);ctrlPreserved=($tdBefore.ctrlConfiguration -eq $tdAfter.ctrlConfiguration);processorClockTimerAndInterruptEnabled=($tdBefore.ctrlConfiguration -eq 7 -and $tdAfter.ctrlConfiguration -eq 7);interruptMasksPreserved=($tdBefore.interruptMasks.PriMask -eq $tdAfter.interruptMasks.PriMask -and $tdBefore.interruptMasks.BasePri -eq $tdAfter.interruptMasks.BasePri -and $tdBefore.interruptMasks.FaultMask -eq $tdAfter.interruptMasks.FaultMask);finalLoad5999999=($tdAfter.load -eq 5999999)}
    $script:tdState.status=if(@($script:tdState.checks.Values | Where-Object {-not $_}).Count -eq 0){'PASS'}else{'FAIL'}
    Send-TdMi ('-break-delete '+$tdAfterId) | Out-Null
    Send-TdMi '-target-disconnect' | Out-Null
    $script:tdConnected=$false
    Send-TdMi '-gdb-exit' | Out-Null
    $script:tdState.cleanup+=@('Owned breakpoints removed; disconnected with stop policy; GDB exit requested; no reset/run restoration')
}catch{
    $script:tdState['error']=$_.Exception.Message
    if($script:tdConnected -and -not $script:tdTimedOut -and -not $script:tdUnsafe -and -not $script:tdRunning){
        try{Send-TdConsole 'delete breakpoints' | Out-Null;Send-TdMi '-target-disconnect' | Out-Null;$script:tdConnected=$false;Send-TdMi '-gdb-exit' | Out-Null;$script:tdState.cleanup+=@('Error path cleanup only while no command/continue was in progress; stop/disconnect, no restoration')}catch{$script:tdState.cleanup+=@('Cleanup uncertain: '+$_.Exception.Message)}
    }else{$script:tdState.cleanup+=@('No explicit cleanup command on timeout/in-progress/unknown connection; preserve state and obtain disposition')}
}finally{
    $script:tdState['completedOrCheckpointedAt']=[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(7)).ToString('o')
    $script:tdState['timedOut']=$script:tdTimedOut
    $script:tdState['lastKnownState']='Refer to actual capture/cleanup; no restoration reset or run issued'
    Save-TdState
    $script:tdRaw.Flush()
    if($script:tdClientStarted -and $script:tdClient.HasExited -and $tdStderrTask.IsCompleted){[IO.File]::WriteAllText((Join-Path $tdRoot 't09-native-gdb-stderr.log'),$tdStderrTask.GetAwaiter().GetResult())}
    $script:tdRaw.Dispose()
}
[ordered]@{executionId=$script:tdState.executionId;status=$script:tdState.status;error=$script:tdState.error;imageReadback=$script:tdState.imageReadback;snapshots=$script:tdState.snapshots;checks=$script:tdState.checks;cleanup=$script:tdState.cleanup;timedOut=$script:tdState.timedOut;clientPid=$script:tdState.clientProcessId;fullEvidence='t09-native-capture.json and t09-native-gdb-stdout.log';P3F05Consumed=3;P3F07Consumed=1} | ConvertTo-Json -Depth 12
if($script:tdState.status -ne 'PASS' -or $script:tdState.error){exit 1}
