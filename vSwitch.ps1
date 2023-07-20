# Create vSwitch shared vmnic

Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$newConnect = connect-viserver $vcCreds.newServer -Protocol https -User $vcCreds.newUser -Password $vcCreds.newPassword

$HostwithNetwork = get-cluster -name $vcCreds.newCluster | Get-VMHost | Get-VirtualSwitch -name $vcCreds.vSwitch

for ($i = 204 ; $i -lt 208 ; $i++){
   $HostwithNetwork | New-VirtualPortGroup -Name "VM $i" -VLanId $i
}

disconnect-viserver -Server * -Force -confirm:$false