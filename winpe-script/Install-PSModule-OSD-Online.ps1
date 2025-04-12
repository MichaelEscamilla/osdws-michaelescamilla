Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Add PowerShell Module OSD to BootImage Online Save"

Save-Module -Name OSD -Path "$MountPath\Program Files\WindowsPowerShell\Modules" -Force