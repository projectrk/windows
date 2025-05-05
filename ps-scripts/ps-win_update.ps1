# Force Windows Update Silently
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