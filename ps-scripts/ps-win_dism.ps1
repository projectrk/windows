# Run DISM Health Check
Write-Output "Starting DISM Health Check..."
$scanResult = dism /Online /Cleanup-Image /ScanHealth

# Display output
$scanResult | ForEach-Object { Write-Output $_ }

# Check for corruption or repairable issues
if ($scanResult -match "The component store is repairable" -or
    $scanResult -match "corrupt" -or
    $scanResult -match "repair") {

    Write-Output "`nCorruption detected. Starting DISM Repair..."
    
    # Perform DISM RestoreHealth
    dism /Online /Cleanup-Image /RestoreHealth | ForEach-Object { Write-Output $_ }
    
    Write-Output "DISM Repair process completed."
} else {
    Write-Output "`nNo corruption detected. System is healthy."
}