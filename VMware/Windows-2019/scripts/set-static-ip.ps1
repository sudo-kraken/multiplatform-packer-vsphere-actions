# Setting Static IP
$IPType='IPv4';
$adapter=Get-NetAdapter | ?{$_.Status -eq 'up' -and $_.Name -like'*Ethernet*'};
$interfaceIndex=$adapter.ifIndex;
$interface=Get-NetIPInterface -InterfaceIndex $interfaceIndex -AddressFamily $IPType;

# The desired IP address.
$desiredIP = 'x.x.x.x'

# Start checking if IP is assigned.
while ($true) {
    Clear-Host 
    # Set IP settings.
    Set-NetIPInterface -InterfaceIndex $interfaceIndex -DHCP Disabled | Out-Null;
    New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $desiredIP -PrefixLength xx -DefaultGateway 'x.x.x.x' | Out-Null;
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ('1.1.1.1','1.0.0.1') | Out-Null

    $currentIP = (Get-NetIPAddress -InterfaceIndex $interfaceIndex -AddressFamily $IPType).IPAddress
    if ($currentIP -eq $desiredIP) {
        Write-Host "IP is assigned correctly, exiting loop."
        break
    } else {
        Start-Sleep 5
        Write-Host "IP not assigned correctly. Current IP: $currentIP. Retrying..."
    }
}
