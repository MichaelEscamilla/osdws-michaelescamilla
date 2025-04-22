# Adds the Windows 11 24H2 esd to the 'Media' folder of your build
# The esd will be included within the built ISO file.
# This allows you to not need to download the esd when deploying from the ISO.
# Helpful for VM deployments
# This will cause the Media folder to be larger than what can fit on the USB drive. So only use for ISO builds.

# Volume
$ImageName = "Windows 11 24H2 x64 en-us Volume*"
# Retail
$ImageName = "Windows 11 24H2 x64 en-us Retail*"

$CloudOSInfo = Get-OSDCloudOperatingSystems | Where-Object { $_.Name -like $ImageName }

# Check that an image was found
if ($CloudOSInfo) {
    # Set the OSDCloud Path within the Media folder
    $OSDCloudOSPath = "$MediaPath\OSDCloud\OS"

    # Check if Path Exists, if not create it
    if (-not (Test-Path -Path $OSDCloudOSPath)) {
        New-Item -Path $OSDCloudOSPath -ItemType Directory -Force | Out-Null
    }

    # Download the esd to the Media folder
    $OSDCloudUsbOS = Save-WebFile -SourceUrl $CloudOSInfo.Url -DestinationDirectory "$OSDCloudOSPath" -DestinationName $CloudOSInfo.FileName

    if ($OSDCloudUsbOS) {
        Write-Host -ForegroundColor Green "[$((Get-Date).ToString('HH:mm:ss'))] Downloaded $($CloudOSInfo.Name) to $OSDCloudOSPath"
    } else {
        Write-Host -ForegroundColor Red "[$((Get-Date).ToString('HH:mm:ss'))] Failed to download $($CloudOSInfo.Name) to $OSDCloudOSPath"
    }
} else {
    Write-Host -ForegroundColor Red "[$((Get-Date).ToString('HH:mm:ss'))] No image found matching $ImageName"
}