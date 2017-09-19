# This script is to make a basic IPv6 configuration for the server.
#
# You can verify your IP addresses configurations with:
# `netsh interface ipv6 show addresses`
#
# You can verify your DNS server addresses configurations with:
# `netsh interface ipv6 show dnsservers`
Param(    
    [string]$Name,
    [string]$InterfaceIndex = "5",
    [string]$IP = "ACAD::10",
    [string]$Length = "64",
    [string]$Gateway = "FE80::1",
    [string]$DnsSec = "ACAD::11"
)

# Use Get-NetIPInterface to get the InterfaceIndex.
New-NetIPAddress -AddressFamily IPv6 -IPAddress $IP -InterfaceIndex $InterfaceIndex -PrefixLength $Length -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses($IP, $DnsSec)

If(-Not [string]::IsNullOrEmpty($Name))
{
    Rename-computer $Name
}
