Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$vcConf  = Get-Content $currenPath\config.json | ConvertFrom-Json
$theosConnect = connect-viserver $vcCreds.theosServer -Protocol https -User $vcCreds.theosUser -Password $vcCreds.theosPassword

$vmTools = (Get-VM -Name $vcConf.vmName).ExtensionData.Guest.ToolsStatus

$script = @'
hostnamectl set-hostname test-script
apt update
echo "y" | sudo apt-get install nginx
'@

if ($vmTools -eq "toolsOk"){
    Invoke-VMScript -VM $vcConf.vmName -ScriptText $script -GuestUser $vcCreds.vmUser -GuestPassword $vcCreds.vmPassword -ScriptType $vcCreds.Type
    Restart-VMGuest -VM $vcConf.vmName -Confirm:$False
}
else {
    write-output ("The vmWare tool have not been installed.")
}
