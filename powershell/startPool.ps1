param
(
	[string] $AppPoolName
)

Import-Module -Name 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1';


$AppPoolState = (Get-WebAppPoolState -Name $AppPoolName).Value;
$WasStopped = $false;
$Timeout = [System.TimeSpan]::FromMinutes(1);
$StopWatch = New-Object -TypeName 'System.Diagnostics.Stopwatch';
$StopWatch.Start();
# Possible status: "Starting", "Started", "Stopping", "Stopped" and "Unknown".
while ($AppPoolState -ne 'Started') {
  if ($AppPoolState -eq 'Stopped') {
    $WasStopped = $true;
    Start-WebAppPool -Name $AppPoolName;
  }
  Start-Sleep -Seconds 2;
  if ($StopWatch.Elapsed -gt $Timeout) {
    throw New-Object -TypeName 'System.TimeoutException' -ArgumentList "Timeout of $($Timeout.TotalSeconds) seconds exceeded!";
  }
  $AppPoolState = (Get-WebAppPoolState -Name $AppPoolName).Value;
}