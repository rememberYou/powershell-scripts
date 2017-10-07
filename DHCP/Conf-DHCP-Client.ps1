<#
.SYNOPSIS
    Configures the IPv6 on the client.
    PowerSploit Function: Conf-DHCP-Client
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-DHCP-Client Configures the IPv6 on the client.

.EXAMPLE
    PS C:\> Conf-DHCP-Client -InterfaceID 11 -Prefix 2001:db8:cafe:10::1

.NOTES
    You can displays a list of connected and disconnected network adapters with:
    `netsh interface ipv6 show interfaces`

#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $InterfaceID,

    [ValidateNotNullOrEmpty()]
    [String]
    $Prefix
)

# Sets the chosen interface to Disable Stateless mode
Netsh interface ipv6 set interface $InterfaceID advertise=enable managed=enable

# Manually sets the Route on the system
Netsh interface ipv6 add route $Prefix/64 $InterfaceID publish=yes
