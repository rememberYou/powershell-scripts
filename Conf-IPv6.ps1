<#
.SYNOPSIS
    Sets a basic IPv6 configuration with the possibility to change the hostname of the machine.
    PowerSploit Function: Conf-IPv6
    Author: Terencio Agozzino (@rememberYou)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0
 
.DESCRIPTION
    Conf-IPv4 sets a basic IPv6 configuration with the possibility to change the hostname of the machine.    

.EXAMPLE
    PS C:\> Conf-IPv6 -Name SRVDNSPrimary -InterfaceIndex 5 -IP ACAD::10 -Length 64 -Gateway ACAD::1 -DnsPri ACAD::10 -DnsSec ACAD::11

.EXAMPLE
    PS C:\> Conf-IPv6 -InterfaceIndex 5 -IP ACAD::10 -Length 64 -Gateway ACAD::1 -DnsPri ACAD::10 -DnsSec ACAD::11

.NOTES
    You can verify your IP addresses configurations with:
    `netsh interface ipv6 show addresses`

    You can verify your DNS server addresses configurations with:
    `netsh interface ipv6 show dnsservers`
#>

Param(    
    [String]
    $Name,

    [ValidateNotNullOrEmpty()]
    [String]
    $InterfaceIndex,
    
    [ValidateNotNullOrEmpty()]
    [String]
    $IP,
    
    [ValidateNotNullOrEmpty()]
    [String]
    $Length,
    
    [ValidateNotNullOrEmpty()]
    [String]
    $Gateway,

    [ValidateNotNullOrEmpty()]
    [String]
    $DnsPri,
    
    [ValidateNotNullOrEmpty()]
    [String]
    $DnsSec
)

# Use Get-NetIPInterface to get the InterfaceIndex.
New-NetIPAddress -AddressFamily IPv6 -IPAddress $IP -InterfaceIndex $InterfaceIndex -PrefixLength $Length -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses($DNSPri, $DnsSec)

If(-Not [string]::IsNullOrEmpty($Name))
{
    Rename-computer $Name
}
