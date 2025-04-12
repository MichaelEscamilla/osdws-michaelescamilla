########################################
# Add CMTrace to the Boot Image and make it the default log viewer
########################################

# Copy CMTrace to the Boot Image
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Copying [CMTrace.exe] to BootImage [Windows\System32]"
Copy-Item -Path "$PSScriptRoot\CMTrace.exe" -Destination "$MountPath\Windows\System32\CMTrace.exe" -Force

# Make CMTrace the default log viewer
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Making CMTrace the Default Log Viewer"

# Mount the Boot Image Registry
Invoke-Exe reg load HKLM\Mount "$MountPath\Windows\System32\Config\Software"
Start-Sleep -Seconds 5

# Add an association for .lo_ files
$RegistryKey = 'HKLM:\Mount\Classes\.lo_'
if(!(Test-Path -Path $RegistryKey))
{
    New-Item -Path $RegistryKey -Force | Out-Null
}
New-ItemProperty -Path $RegistryKey -PropertyType String -Name '(Default)' -Value 'Log.File' -Force | Out-Null

# Add an association for .log files
$RegistryKey = 'HKLM:\Mount\Classes\.log'
if(!(Test-Path -Path $RegistryKey))
{
    New-Item -Path $RegistryKey -Force | Out-Null
}
New-ItemProperty -Path $RegistryKey -PropertyType String -Name '(Default)' -Value 'Log.File' -Force | Out-Null

# Add a command to execute when associated file extensions is opened
$RegistryKey = 'HKLM:\Mount\Classes\Log.File\shell\open\command'
if(!(Test-Path -Path $RegistryKey))
{
    New-Item -Path $RegistryKey -Force | Out-Null
}
New-ItemProperty -Path $RegistryKey -PropertyType String -Name '(Default)' -Value "X:\Windows\System32\CMTrace.exe `"%1`"" -Force | Out-Null

# Clean Up variables to unload the registry without errors
Get-Variable RegistryKey | Remove-Variable
Start-Sleep -Seconds 3

# Collect Garbage
[System.GC]::Collect()
Start-Sleep -Seconds 3

# Unload the registry
Invoke-Exe reg unload HKLM\Mount | Out-Null