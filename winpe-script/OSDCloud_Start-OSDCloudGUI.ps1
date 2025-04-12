# Set Variables
$OSDVersion = (Get-Module -Name OSD -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1).Version

# Add OSD to Boot Image
Save-Module -Name OSD -Path "$MountPath\Program Files\WindowsPowerShell\Modules" -Force

# Set Startnet.cmd
$StartnetCMD = @"
@ECHO OFF
wpeinit
cd\
title OSD $OSDVersion
PowerShell -Nol -C Initialize-OSDCloudStartnet
PowerShell -Nol -C Initialize-OSDCloudStartnetUpdate
@ECHO OFF
start /wait PowerShell -NoL -W Mi -C Start-OSDCloudGUI -Brand 'Michael The Admin'
"@

$StartnetCMD | Out-File -FilePath "$MountPath\Windows\System32\Startnet.cmd" -Encoding ascii -Width 2000 -Force