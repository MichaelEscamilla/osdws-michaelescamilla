# Adds the Windows 11 24H2 esd to the 'Media' folder of your build
# The esd will be included within the built ISO file.
# This allows you to not need to download the esd when deploying from the ISO.
# Helpful for VM deployments
# This will cause the Media folder to be larger than what can fit on the USB drive. So only use for ISO Deployments.

# Volume
$ImageName = "Windows 11 24H2 x64 en-us Volume*"
# Retail
$ImageName = "Windows 11 24H2 x64 en-us Retail*"

# Define the OS Image to download
$CloudOSInfo = Get-OSDCloudOperatingSystems | Where-Object { $_.Name -like $ImageName }

# Define a Temporary Save Path for the OS Image
$TempSavePath = "$Env:TEMP"

# Check that an image was found
if ($CloudOSInfo) {
    # Set the OSDCloud Path within the Media folder
    $OSDCloudOSPath = "$MediaPath\OSDCloud\OS"

    # Check if Path Exists, if not create it
    if (-not (Test-Path -Path $OSDCloudOSPath)) {
        New-Item -Path $OSDCloudOSPath -ItemType Directory -Force | Out-Null
    }

    # Check if the OS Image already exists in the Temporary folder
    if (Test-Path -Path "$TempSavePath\$($CloudOSInfo.FileName)") {
        Write-Host -ForegroundColor Yellow "[$((Get-Date).ToString('HH:mm:ss'))] Found [$($CloudOSInfo.Name)] in [$TempSavePath]"

        # Get the existing file from the Temporary folder
        $OSDCloudOSImageFile = Get-Item -Path "$TempSavePath\$($CloudOSInfo.FileName)"
    }
    else {
        Write-Host -ForegroundColor Yellow "[$((Get-Date).ToString('HH:mm:ss'))] Downloading [$($CloudOSInfo.Name)] to [$TempSavePath]"

        # Download the esd to the Temporary folder
        $OSDCloudOSImageFile = Save-WebFile -SourceUrl $CloudOSInfo.Url -DestinationDirectory "$TempSavePath" -DestinationName $CloudOSInfo.FileName
    }

    # Check if an OS Image file was found
    if ($OSDCloudOSImageFile) {
        Write-Host -ForegroundColor Green "[$((Get-Date).ToString('HH:mm:ss'))] Copying to [$OSDCloudOSPath]"

        # Copy the OS Image file to the OSDCloudOSPath
        Copy-Item -Path "$($OSDCloudOSImageFile.FullName)" -Destination "$OSDCloudOSPath" -Force
    }
}
else {
    Write-Host -ForegroundColor Red "[$((Get-Date).ToString('HH:mm:ss'))] No image found matching $ImageName"
}