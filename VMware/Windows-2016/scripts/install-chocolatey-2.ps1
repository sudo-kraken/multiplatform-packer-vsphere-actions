# Install OpenSSH
choco install -y --package-parameters=/SSHServerFeature openssh

# Remove the specified firewall rule if it exists
$existingRule = Get-NetFirewallRule -DisplayName "SSHD Port OpenSSH (chocolatey package: openssh)" -ErrorAction SilentlyContinue
if ($existingRule) {
    Write-Output "Firewall Rule with display name 'SSHD Port OpenSSH (chocolatey package: openssh)' exists, deleting it..."
    Remove-NetFirewallRule -DisplayName "SSHD Port OpenSSH (chocolatey package: openssh)"
}

# Check if the 'OpenSSH-Server-In-TCP' firewall rule exists
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' already exists. Updating it..."
    Set-NetFirewallRule -Name "OpenSSH-Server-In-TCP"
}

# Install PowerShell Core
choco install -y powershell-core --force
If (Test-Path "C:\Program Files\openssh-win64\Set-SSHDefaultShell.ps1") {
    & "C:\Program Files\openssh-win64\Set-SSHDefaultShell.ps1" -PathSpecsToProbeForShellEXEString "$env:programfiles\PowerShell\7\pwsh.exe;$env:programfiles\PowerShell\7\Powershell.exe;c:\windows\system32\windowspowershell\v1.0\powershell.exe"
}

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
