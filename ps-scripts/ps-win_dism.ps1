<#
DISCLAIMER:

This PowerShell script is provided "as is" without any warranty, express or implied. Use this script at your own risk.

By using this script, you acknowledge and agree that the author shall not be held liable for any damages, data loss, system failures, legal issues, or any other consequences resulting from the use, misuse, or inability to use this script, whether in part or in whole.

This script is intended for educational and personal use only. It is the user's responsibility to ensure compliance with all applicable laws, regulations, and organizational policies before executing or distributing this script.

By running this script, you agree to indemnify and hold the author harmless from any claims, liabilities, or legal actions arising from its use.
#>

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