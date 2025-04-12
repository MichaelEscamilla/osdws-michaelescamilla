# Download PortableGit
$SaveLocation = "$($env:TEMP)"
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Downloading PortableGit to: [$($SaveLocation)]"
$PortableGitDownload = Save-WebFile -SourceUrl 'https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/PortableGit-2.47.1.2-64-bit.7z.exe' -DestinationDirectory "$($SaveLocation)"

# Expand PortableGit
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Expanding PortalbleGit to BootImage"
#& "$($PortableGitDownload.FullName)" -y -o"$PSScriptRoot\PortableGit"
& "$($PortableGitDownload.FullName)" -y -o"$MountPath\PortableGit"

# Expand PortableGit to Boot Image
#Write-Host -ForegroundColor DarkCyan "[$((Get-Date).ToString('HH:mm:ss'))] Expanding PortalbleGit to BootImage"
#Expand-Archive -Path "$($PSScriptRoot)\*.zip" -Destination $MountPath

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
