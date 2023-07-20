########################################################
#       Created Sogeti System Team                     #
#       February 03 2016                               #
########################################################
# Loads the PowerCLI Module, shutdown VM and export VM #
########################################################

########################################################
# Variables Configuration                              #
########################################################

$MyVcenter = "vsrv-vcenter6.igis.corp"
#$Username = ""
#$Password = ""
$DestFolder = "z:"
$ProjetCore = "nro-cs-*"
$ProjetDmz = "nro-ds-*"

#Import PowerCLI module            
########################
Add-PSSnapin VMware.VimAutomation.Core
 
#Update the title bar
######################
$host.ui.rawui.WindowTitle="PowerShell [PowerCLI Module Loaded]"

# This script adds some helper functions and sets the appearance. You can pick and choose parts of this file for a fully custom appearance.
###########################################################################################################################################
. "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"

Connect-VIServer $MyVcenter #-User $Username -Password $Password


#Shutdown VM Core
######################
get-vm -name $ProjetCore | where {$_.PowerState -eq "PoweredOn"}| where { $_.Name -notmatch "adm1" } | where {$_.Name -notmatch "adm2"} | where {$_.Name -notmatch "vc1"} | Shutdown-VMGuest -Confirm:$false
Start-Sleep -Seconds 30
get-vm -name $ProjetCore | where {$_.PowerState -eq "PoweredOn"}| where {$_.Name -match "adm1" -or $_.Name -match "adm2" -or $_.Name -match "vc1"} | Shutdown-VMGuest -Confirm:$false
Start-Sleep -Seconds 30

#Export VM Core
#####################

get-vm -name $ProjetCore | where {$_.PowerState -eq "PoweredOff"} | Foreach {
  $Name = $_.Name 
  Write-Host "Export VM: $($Name)"
  get-vm -name "$($Name)" | Export-VApp -Destination $DestFolder -Name "$($Name)" -Format Ova
}

#Restart VM Core
#####################
get-vm -name $ProjetCore | where {$_.PowerState -eq "Poweredoff"} | where {$_.Name -match "adm1"} | where {$_.Name -match "adm2"} | Start-VM -Confirm:$false
Start-Sleep -Seconds 30
get-vm -name $ProjetCore | where {$_.PowerState -eq "Poweredoff"} | where {$_.Name -match "vc1"} | Start-VM -Confirm:$false
Start-Sleep -Seconds 30
get-vm -name $ProjetCore | where {$_.PowerState -eq "Poweredoff"} | Start-VM -Confirm:$false



#Shutdown VM Dmz
######################
get-vm -name $ProjetDmz | where {$_.PowerState -eq "PoweredOn"}| where { $_.Name -notmatch "adm1" } | where {$_.Name -notmatch "adm2"} | where {$_.Name -notmatch "vc1"} | Shutdown-VMGuest -Confirm:$false
Start-Sleep -Seconds 30
get-vm -name $ProjetDmz | where {$_.PowerState -eq "PoweredOn"}| where {$_.Name -match "adm1" -or $_.Name -match "adm2" -or $_.Name -match "vc1"} | Shutdown-VMGuest -Confirm:$false
Start-Sleep -Seconds 30

#Export VM Dmz
#####################

get-vm -name $ProjetDmz | where {$_.PowerState -eq "PoweredOff"} | Foreach {
  $Name = $_.Name 
  Write-Host "Export VM: $($Name)"
  get-vm -name "$($Name)" | Export-VApp -Destination $DestFolder -Name "$($Name)" -Format Ova
}

#Restart VM Core
#####################
get-vm -name $ProjetDmz | where {$_.PowerState -eq "Poweredoff"} | where {$_.Name -match "adm1"} | where {$_.Name -match "adm2"} | Start-VM -Confirm:$false
Start-Sleep -Seconds 30
get-vm -name $ProjetDmz | where {$_.PowerState -eq "Poweredoff"} | where {$_.Name -match "vc1"} | Start-VM -Confirm:$false
Start-Sleep -Seconds 30
get-vm -name $ProjetDmz | where {$_.PowerState -eq "Poweredoff"} | Start-VM -Confirm:$false
