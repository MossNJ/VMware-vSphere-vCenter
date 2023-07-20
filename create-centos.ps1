Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$vcConf  = Get-Content $currenPath\config.json| ConvertFrom-Json
$theosConnect = connect-viserver $vcCreds.theosServer -Protocol https -User $vcCreds.theosUser -Password $vcCreds.theosPassword

$template = Get-Template -Name $vcConf.centosTemplate
$ds       = Get-Datastore -Name $vcConf.dsName
$esx      = Get-VMHost -Name $vcConf.hostName

$vm       = New-VM -Name $vcConf.vmName -Template $template -Datastore $ds -VMHost $esx -DiskStorageFormat $vcConf.diskFormat | 
            Set-VM -NumCPU $vcConf.numCpu -CoresPerSocket $vcConf.Cores -MemoryGB $vcConf.memoryGB -Confirm:$false

Get-HardDisk -VM $vm | Set-HardDisk -CapacityGB $vcConf.capacityGB -Confirm:$false

Start-VM -VM $vm -Confirm:$false

Start-Sleep -Seconds 180; Write-Host "3 mins wait for vmWare Tools has been installed"

.\run-centos.ps1

disconnect-viserver -Server * -Force -confirm:$false