# Install PowerShell Core
choco install -y powershell-core --force

# PowerShell path to add
$psPath = 'C:\Program Files\PowerShell\7\'

# Get the current system PATH
$currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

# Check if the PowerShell path is already in the system PATH
if ($currentPath -notlike "*$psPath*") {
    Write-Host 'PowerShell path not found in PATH. Adding it now'
    
    # Add the PowerShell path to the system PATH
    $newPath = $currentPath + ';' + $psPath
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
} else {
    Write-Host 'PowerShell path is already in the system PATH'
}

# Install Misc Tools
choco install -y 7zip notepadplusplus putty
