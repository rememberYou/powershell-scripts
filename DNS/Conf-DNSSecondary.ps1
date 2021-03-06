<#
.SYNOPSIS
    Installs the DNS service and sets a basic DNS secondary configuration.
    PowerSploit Function: Conf-DNS
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-DNSSeocndary Installs the DNS service and sets a basic DNS secondary configuration.

.EXAMPLE
    PS C:\> Conf-DNSSecondary -ZoneName heh.lan -NetworkIDv4 192.168.0.0 `
                              -PrefixV4 16 -RevZoneNameV4 168.192.in-addr.arpa `
                              -MasterServersV4 192.168.42.1

.EXAMPLE
    PS C:\> Conf-DNSSecondary -ZoneName heh.lan -NetworkIDv4 192.168.0.0 `
                              -PrefixV4 16 -RevZoneNameV4 168.192.in-addr.arpa `
                              -MasterServersV4 192.168.42.1 -NetworkIDv6 acad:: `
                              -PrefixV6 64 `
                              -RevZoneNameV6 0.1.0.0.e.f.a.c.8.b.d.0.1.0.0.2.ip6.arpa `
                              -MasterServersV6 2001:db8:cafe:10::1

.NOTES
    You can verify the DNS installation with:
    `Get-WindowsFeature`

    You can verify the DNS zones with:
    `Get-DnsServerZone`

    For the example above, you can verify the DNS server resource records with:
    `Get-DnsServerResourceRecord -ZoneName heh.lan`
    `Get-DnsServerResourceRecord -ZoneName 168.192.in-addr.arpa`
    `Get-DnsServerResourceRecord -ZoneName 0.1.0.0.e.f.a.c.8.b.d.0.1.0.0.2.ip6.arpa `

    To check if the DNS is working well you can do:
    `nslookup`
    `ls -d`

    To check if the alias work you can do:
    `nslookup www.heh.lan`
    `nslookup srv1.heh.lan`
    `nslookup srv2.heh.lan`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $ZoneName,

    [ValidateNotNullOrEmpty()]
    [String]
    $NetworkIDv4,

    [ValidateNotNullOrEmpty()]
    [String]
    $PrefixV4,

    [ValidateNotNullOrEmpty()]
    [String]
    $RevZoneNameV4,

    [ValidateNotNullOrEmpty()]
    [String]
    $MasterServersV4,

    [String]
    $NetworkIDv6,

    [String]
    $PrefixV6,

    [String]
    $RevZoneNameV6,

    [String]
    $MasterServersV6
)

Import-Module ServerManager
Add-WindowsFeature -Name DNS -IncludeManagementTools

# Create Forward Lookup Zones
Add-DnsServerSecondaryZone -Name "$ZoneName" -ZoneFile "$ZoneName.dns" -MasterServers "$MasterServersV4"
Add-DnsServerPrimaryZone -Name "delegation.$ZoneName" -ZoneFile "delegation.$ZoneName.dns"

# Create Reverse Lookup Zones
Add-DnsServerSecondaryZone -NetworkId "$NetworkIDv4/$PrefixV4" -ZoneFile "$RevZoneNameV4.dns" -MasterServers "$MasterServersV4"
If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
    Add-DnsServerSecondaryZone -networkId "$NetworkIDv6/$PrefixV6" -ZoneFile "$RevZoneNameV6.dns" -MasterServers "$MasterServersV6"
}

# Create Records
Add-DnsServerResourceRecordA -Name "SRVDNSPrimary" -ZoneName "delegation.$ZoneName" -AllowUpdateAny -IPv4Address "192.168.42.1"
If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
    Add-DnsServerResourceRecordAAAA -Name "SRVDNSPrimary" -ZoneName "delegation.$ZoneName" -AllowUpdateAny -IPv6Address "2001:db8:cafe:10::1"
}

# Create Name Servers
Add-DnsServerResourceRecord -ZoneName "delegation.$ZoneName" -Name "." -NameServer "SRVDNSPrimary.$ZoneName" -NS
Add-DnsServerResourceRecord -ZoneName "delegation.$ZoneName" -Name "." -NameServer "SRVDNSSecondary.$ZoneName" -NS
