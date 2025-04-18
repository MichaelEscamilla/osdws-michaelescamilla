# Set Startnet.cmd
$StartnetCMD = @"
@ECHO OFF
wpeinit
cd\
title OSDK Start Hardware Error Table
mode 800
powershell -NoL -NoE -C "Get-CimInstance -ClassName Win32_PnPEntity | Select Status,DeviceID,Name,Manufacturer,PNPClass,Service | Where Status -ne 'OK' | Sort Status,DeviceID | Format-Table"
"@

$StartnetCMD | Out-File -FilePath "$MountPath\Windows\System32\Startnet.cmd" -Encoding ascii -Width 2000 -Force


# powershell -NoL -NoE -C "Get-CimInstance -ClassName Win32_PnPEntity | Select Status,DeviceID,Name,Manufacturer,PNPClass,Service | Where Status -eq 'Error' | Sort Status,DeviceID | Format-Table"

# powershell -NoL -NoE -C "Get-CimInstance -ClassName Win32_PnPEntity | Select Status,DeviceID,Name,Manufacturer,PNPClass,Service | Where Status -eq 'Error' | Sort Status,DeviceID | Format-Table"