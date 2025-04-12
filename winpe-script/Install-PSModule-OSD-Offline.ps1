Start-Transcript
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Adding OSD PowerShell Module to BootImage"
Copy-PSModuleToFolder -Name 'OSD' -Destination "$MountPath\Program Files\WindowsPowerShell\Modules" -RemoveOldVersions
Stop-Transcript