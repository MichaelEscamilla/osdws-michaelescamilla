# Adds the Windows 11 24H2 esd to ISO.
# Allows for quicker or offline OSDCloud v1 deployments.

$ImageName = "Windows 11 24H2 x64 en-us Volume*"

$CloudOSInfo = Get-OSDCloudOperatingSystems | Where-Object { $_.Name -like $ImageName }

# Create OSDCloud Path
$OSDCloudOSPath = "$MediaPath\OSDCloud\OS"

# Check if Path Exists
if (-not (Test-Path -Path $OSDCloudOSPath)) {
    New-Item -Path $OSDCloudOSPath -ItemType Directory -Force | Out-Null
}

$OSDCloudUsbOS = Save-WebFile -SourceUrl $CloudOSInfo.Url -DestinationDirectory "$OSDCloudOSPath" -DestinationName $CloudOSInfo.FileName

if ($OSDCloudUsbOS) {
    Write-Host -ForegroundColor Green "[$((Get-Date).ToString('HH:mm:ss'))] Downloaded $($CloudOSInfo.Name) to $OSDCloudOSPath"
} else {
    Write-Host -ForegroundColor Red "[$((Get-Date).ToString('HH:mm:ss'))] Failed to download $($CloudOSInfo.Name) to $OSDCloudOSPath"
}