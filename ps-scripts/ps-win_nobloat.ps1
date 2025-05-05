# Removing bloatware from Windows 10 and later (2025+ compatible)

# List of bloatware to remove
$bloatware = @(
    "Microsoft.3DViewer",
    "Microsoft.XboxApp",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxGameOverlay",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.ZuneMusic",           # Groove Music
    "Microsoft.ZuneVideo",           # Movies & TV
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.MSPaint",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.Todos",
    "Microsoft.Whiteboard",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.YourPhone",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.Office.OneNote",
    "Microsoft.Wallet",
    "Microsoft.XboxIdentityProvider"
)

# Check for Windows version compatibility
$windowsVersion = (Get-ComputerInfo).WindowsVersion
if ($windowsVersion -lt 10) {
    Write-Output "This script is only compatible with Windows 10 and later."
    exit
}

# Remove each app for all users
foreach ($app in $bloatware) {
    Write-Output "Attempting to remove $app..."
    try {
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $app} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    } catch {
        Write-Output "Failed to remove $app. It may not be installed or supported on this version of Windows."
    }
}

Write-Output "Bloatware removal process complete."

# Clean temp folders and recycle bin
try {
    Write-Output "Cleaning temporary files and recycle bin..."
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Output "Cleanup complete."
} catch {
    Write-Output "Failed to clean some temporary files or recycle bin. Please check permissions."
}