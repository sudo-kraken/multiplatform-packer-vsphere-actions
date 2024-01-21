# Define the URL for the .NET Framework 4.8 installer
$url = "https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe"

# Define the path where the installer will be saved
$folderPath = "C:\Temp"
$installerPath = "$folderPath\ndp48-x86-x64-allos-enu.exe"

# Create the folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

# Download the installer
Invoke-WebRequest -Uri $url -OutFile $installerPath

# Execute the installer silently
Start-Process -FilePath $installerPath -ArgumentList "/q /norestart" -Wait -PassThru

# Remove the installer file after the installation is complete
Remove-Item -Path $installerPath
