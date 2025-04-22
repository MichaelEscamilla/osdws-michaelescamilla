########################################
# Add PortableGit to the Boot Image and Add it to the PATH      
########################################

# Download PortableGit
$SaveLocation = "$($env:TEMP)"
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Downloading PortableGit to: [$($SaveLocation)]"
$PortableGitDownload = Save-WebFile -SourceUrl 'https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/PortableGit-2.49.0-64-bit.7z.exe' -DestinationDirectory "$($SaveLocation)"

# Run the PortableGit exe and expand it to the Boot Image
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Expanding PortableGit to BootImage"
& "$($PortableGitDownload.FullName)" -y -o"$MountPath\PortableGit"

# Add PortableGit PATH to WinPE
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Adding PortableGit to WinPE PATH"
Invoke-Exe reg load HKLM\Mount "$MountPath\Windows\System32\Config\SYSTEM"
Start-Sleep -Seconds 3
$RegistryKey = 'HKLM:\Mount\ControlSet001\Control\Session Manager\Environment'
$CurrentPath = (Get-Item -path $RegistryKey ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
$NewPath = $CurrentPath + ';%SystemDrive%\PortableGit\cmd\'
$Result = New-ItemProperty -Path $RegistryKey -Name 'Path' -PropertyType ExpandString -Value $NewPath -Force 

Get-Variable Result | Remove-Variable
Get-Variable RegistryKey | Remove-Variable
[gc]::collect()
Start-Sleep -Seconds 3
Invoke-Exe reg unload HKLM\Mount | Out-Null

# Delete PortableGit Download
Start-Sleep -Seconds 10
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Deleting PortableGit Download"
Remove-Item -Path "$($PortableGitDownload.FullName)" -Force
