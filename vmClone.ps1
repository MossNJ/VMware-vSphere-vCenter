Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$sourceConnect = connect-viserver $vcCreds.sourceServer -Protocol https -User $vcCreds.sourceUser -Password $vcCreds.sourcePassword
$newConnect = connect-viserver $vcCreds.newServer -Protocol https -User $vcCreds.newUser -Password $vcCreds.newPassword

$VMsWithPower = get-vm -Server $vcCreds.sourceServer | where {$_.Powerstate -eq "PoweredOff"}

foreach ($vm in $VMsWithPower) {

  New-VM -server $vcCreds.destServer -name clone-$vm.name -vm (get-vm -Name $vm.name -Server $vcCreds.sourceServer) -datastore (get-datastore -Server $vcCreds.destServer -Name $vcCreds.destDatastore) -location (get-folder $vcCreds.destFolder -Type vm -server $vcCreds.destServer) -DiskStorageFormat $vcCreds.Typeguestdisk -ResourcePool ((get-cluster -Server $vcCreds.destServer -Name $vcCreds.destCluster ))
  Get-VM -Name clone-$vm.name -Server $vcCreds.destServer | Start-VM | Get-NetworkAdapter | Set-NetworkAdapter -Type $vcCreds.netType -NetworkName $vcCreds.netAdapter -Connected:$true

}
disconnect-viserver -Server * -Force -confirm:$false