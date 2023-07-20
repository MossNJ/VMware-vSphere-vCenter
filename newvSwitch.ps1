# Create new vSwitch

Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$newConnect = connect-viserver $vcCreds.newServer -Protocol https -User $vcCreds.newUser -Password $vcCreds.newPassword
$HostwithNetwork = get-cluster -name $vcCreds.newCluster | Get-VMHost | Get-VMHostNetworkAdapter -VMHost $vmHost.Name

foreach ($vmHost in $HostwithNetwork){
    for (($i = 204), ($j = 3)  ; $i -le 207 ; $i++,$j++){
        $vswitch = New-VirtualSwitch -VMHost $vmHost.Name -Name "VM $i" -nic "vmnic$j" -mtu 1500 #vSwitch
        New-VirtualPortGroup -VirtualSwitch $vswitch -Name "VM $i" -VLanId $i
        # | Set-NicTeamingPolicy -MakeNicActive "vmnic($j++)" -MakeNicStandby "vmnic($j++)"  #vLAN
     }
}

disconnect-viserver -Server * -Force -confirm:$false