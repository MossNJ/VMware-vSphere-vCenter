Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$wgsConnect = connect-viserver $vcCreds.wgsServer -Protocol https -User $vcCreds.wgsUser -Password $vcCreds.wgsPassword

# Get-VM | Start-VM
get-vm | Get-VMGuest

Disconnect-viserver -Server * -Force -confirm:$false