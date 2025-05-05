<#
DISCLAIMER:

This PowerShell script is provided "as is" without any warranty, express or implied. Use this script at your own risk.

By using this script, you acknowledge and agree that the author shall not be held liable for any damages, data loss, system failures, legal issues, or any other consequences resulting from the use, misuse, or inability to use this script, whether in part or in whole.

This script is intended for educational and personal use only. It is the user's responsibility to ensure compliance with all applicable laws, regulations, and organizational policies before executing or distributing this script.

By running this script, you agree to indemnify and hold the author harmless from any claims, liabilities, or legal actions arising from its use.
#>

# Windows Update Script
Write-Output "Starting Windows Update..."

# Create the Windows Update COM object
$updateSession = New-Object -ComObject Microsoft.Update.Session
$updateSearcher = $updateSession.CreateUpdateSearcher()
$searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")

if ($searchResult.Updates.Count -eq 0) {
    Write-Output "No updates found."
    exit
}

# Create a collection for updates to install
$updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl

foreach ($update in $searchResult.Updates) {
    if ($update.EulaAccepted -eq $false) {
        $update.AcceptEula()
    }
    $updatesToInstall.Add($update) | Out-Null
}

if ($updatesToInstall.Count -gt 0) {
    $downloader = $updateSession.CreateUpdateDownloader()
    $downloader.Updates = $updatesToInstall
    Write-Output "Downloading updates..."
    $downloader.Download()

    $installer = $updateSession.CreateUpdateInstaller()
    $installer.Updates = $updatesToInstall
    Write-Output "Installing updates..."
    $installationResult = $installer.Install()

    Write-Output "Installation complete. Result code: $($installationResult.ResultCode)"
} else {
    Write-Output "No applicable updates to install."
}
# END OF FILE