# Removes the en-gb language folder from the BootMedia

# Language to Remove
$Languages = @(
    'en-gb'
)

Start-Transcript
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Removing en-gb language artifacts from BootMedia"
foreach ($Language in $Languages) {
    if (Test-Path "$MediaPath\$Language") {
        Remove-Item -Path "$MediaPath\$Language" -Recurse
    }
    if (Test-Path "$MediaPath\Boot\$Language") {
        Remove-Item -Path "$MediaPath\Boot\$Language" -Recurse
    }
    if (Test-Path "$MediaPath\EFI\Boot\$Language") {
        Remove-Item -Path "$MediaPath\EFI\Boot\$Language" -Recurse
    }
    if (Test-Path "$MediaPath\EFI\Microsoft\Boot\$Language") {
        Remove-Item -Path "$MediaPath\EFI\Microsoft\Boot\$Language" -Recurse
    }
}
Stop-Transcript
