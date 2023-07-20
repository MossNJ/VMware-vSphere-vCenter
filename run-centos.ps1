Import-Module VMware.VimAutomation.Core
$currenPath = Split-Path -parent $MyInvocation.MyCommand.Definition #$PSScriptRoot
$vcCreds = Get-Content $currenPath\secret.json | ConvertFrom-Json
$vcConf  = Get-Content $currenPath\config.json | ConvertFrom-Json
$theosConnect = connect-viserver $vcCreds.theosServer -Protocol https -User $vcCreds.theosUser -Password $vcCreds.theosPassword

$vmTools = (Get-VM -Name $vcConf.vmName).ExtensionData.Guest.ToolsStatus

$script = @'
    yum update -y
    yum group list
    yum group install "GNOME Desktop" "Graphical Administration Tools" -y
    systemctl set-default graphical
    startx
'@

if ($vmTools -eq "toolsOk"){
    Invoke-VMScript -VM $vcConf.vmName -ScriptText $script -GuestUser $vcCreds.centosUser -GuestPassword $vcCreds.centosUser -ScriptType $vcCreds.Type
    Restart-VMGuest -VM $vcConf.vmName -Confirm:$False
}
else {
    write-output ("The vmWare tool have not been installed.")
}
