# Configure basic telemetry settings
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
$settingName = "AllowTelemetry"
$desiredValue = "0" # Security

# Check if the setting exists and update if necessary
if ((Get-ItemProperty -Path $registryPath -Name $settingName -ErrorAction SilentlyContinue).$settingName -ne $desiredValue) {
    Write-Host "Updating telemetry settings..."
    New-ItemProperty -Path $registryPath -Name $settingName -Value $desiredValue -PropertyType DWORD -Force | Out-Null
} else {
    Write-Host "Telemetry settings already configured."
}

# Show file extensions by default in Windows Explorer
$registryPath = "HKU:\UserHive\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$settingName = "HideFileExt"
$desiredValue = "0"

# Load the default user registry hive
$null = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
$null = reg load HKU\UserHive C:\Users\Default\NTUSER.DAT

# Check if the setting exists and update if necessary
if ((Get-ItemProperty -Path $registryPath -Name $settingName -ErrorAction SilentlyContinue).$settingName -ne $desiredValue) {
    Write-Host "Updating file extension visibility settings..."
    New-ItemProperty -Path $registryPath -Name $settingName -Value $desiredValue -PropertyType DWORD -Force
} else {
    Write-Host "File extension visibility settings already configured."
}

# Clean up
[gc]::Collect() # Required for unloading to be possible
$null = reg unload HKU\UserHive
$null = Remove-PSDrive -Name HKU

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) *> $null
