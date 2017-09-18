# This script is to make a basic configuration for the server.
#
# You can verify your IP addresses configurations with:
# Use netsh interface ipv4 show addresses
#
# You can verify your DNS server addresses configurations with:
# Use netsh interface ipv4 show dnsservers
Param(    
    [string]$Name,
    [string]$InterfaceIndex = "5",
    [string]$IP = "172.16.120.10",
    [string]$Length = "24",
    [string]$Gateway = "172.16.120.1",
    [string]$DnsSec = "172.16.120.11"
)

# Use Get-NetIPInterface to get the InterfaceIndex.
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IP -PrefixLength $Length -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses($IP, $DnsSec)

If(-Not [string]::IsNullOrEmpty($Name))
{
    Rename-computer $Name
}
