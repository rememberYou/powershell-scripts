<#
.SYNOPSIS
    Sets a basic IPv6 configuration with the possibility to change the hostname
    of the machine.
    PowerSploit Function: Conf-IPv6
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-IPv6 sets a basic IPv6 configuration with the possibility to change the
    hostname of the machine.

.EXAMPLE
    PS C:\> Conf-IPv6 -Name SRVDNSPrimary -InterfaceIndex 5 -IP 2001:db8:cafe:10::1 `
                      -Length 64 -Gateway 2001:db8:cafe:10::254 -DnsPri 2001:db8:cafe:10::1 `
                      -DnsSec 2001:db8:cafe:10::2

.EXAMPLE
    PS C:\> Conf-IPv6 -InterfaceIndex 5 -IP 2001:db8:cafe:10::1 -Length 64 `
                      -Gateway 2001:db8:cafe:10::254 -DnsPri 2001:db8:cafe:10::1 -DnsSec 2001:db8:cafe:10::2

.NOTES
    Check your InterfaceIndex with:
    `Get-NetIPInterface -AddressFamily IPv6 | fl InterfaceAlias, InterfaceIndex, IPv6Address`

    You can verify your IP addresses configurations with:
    `netsh interface ipv6 show addresses`

    You can verify your DNS server addresses configurations with:
    `netsh interface ipv6 show dnsservers`

    You can verify make a IPv6 ping with `Ping -6 <IPv6 ADDRESS>

    You can verify your tunnels configuration with:
    `Get-Net6to4Configuration

    You can verify your IPv6 route configuration with:
    `Get-NetRoute -AdressFamily IPv6 -InterfaceIndex <INT_INDEX_IPv6>
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

New-NetIPAddress -AddressFamily IPv6 -IPAddress $IP `
  -InterfaceIndex $InterfaceIndex -PrefixLength $Length `
  -DefaultGateway $Gateway

Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex `
  -ServerAddresses($DNSPri, $DnsSec)

# Disable tunnels.
Set-Net6to4Configuration -State Disable
Netsh interface isatap set state state=disabled

If(-Not [string]::IsNullOrEmpty($Name))
{
    Rename-computer $Name
}
