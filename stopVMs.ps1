Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$wgsConnect = connect-viserver $vcCreds.wgsServer -Protocol https -User $vcCreds.wgsUser -Password $vcCreds.wgsPassword

Get-VM | Where-object {$_.name -notlike 'vcenter' }  | Stop-VMGuest -Confirm:$false
Stop-VMGuest -VM 'vcenter'
$VMhosts | ForEach-Object {Stop-VMHost -VMHost $_ -Server $_ -RunAsync}

disconnect-viserver -Server * -Force -confirm:$false