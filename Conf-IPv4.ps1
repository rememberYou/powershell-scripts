<#
.SYNOPSIS
    Sets a basic IPv4 configuration with the possibility to change the hostname of the machine.
    PowerSploit Function: Conf-IPv4
    Author: Terencio Agozzino (@rememberYou)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0
 
.DESCRIPTION
    Conf-IPv4 sets a basic IPv4 configuration with the possibility to change the hostname of the machine.    

.EXAMPLE
    PS C:\> Conf-IPv4 -Name SRVDNSPrimary -InterfaceIndex 5 -IP 172.16.0.10 -Length 24 -Gateway 172.16.0.1 -DnsPri 172.16.0.10 -DnsSec 172.16.0.11

.NOTES
    You can verify your IP addresses configurations with:
    `netsh interface ipv4 show addresses`

    You can verify your DNS server addresses configurations with:
    `netsh interface ipv4 show dnsservers`
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
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IP -PrefixLength $Length -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses($DnsPri, $DnsSec)

If(-Not [string]::IsNullOrEmpty($Name)) {
    Rename-computer $Name
}
