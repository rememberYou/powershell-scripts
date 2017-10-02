<#
.SYNOPSIS
    Installs the DNS service and sets a basic DNS primary configuration.
    PowerSploit Function: Conf-DNS
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-DNSPrimary Installs the DNS service and sets a basic DNS primary configuration.

.EXAMPLE
    PS C:\> Conf-DNSPrimary -ZoneName heh.lan -NetworkIDv4 192.168.0.0 `
                            -PrefixV4 16 -RevZoneNameV4 168.192.in-addr.arpa `
                            -SRVPri SRVDNSPrimary -SRVSec SRVDNSSecondary

.EXAMPLE
    PS C:\> Conf-DNSPrimary -ZoneName heh.lan -NetworkIDv4 192.168.0.0 `
                            -PrefixV4 16 -RevZoneNameV4 168.192.in-addr.arpa `
                            -NetworkIDv6 acad:: -PrefixV6 64 `
                            -RevZoneNameV6 0.0.0.0.0.0.0.0.0.0.0.0.d.a.c.a.ip6.arpa `
                            -SRVPri SRVDNSPrimary -SRVSec SRVDNSSecondary

.NOTES
    You can verify the DNS installation with:
    `Get-WindowsFeature`

    You can verify the DNS zones with:
    `Get-DnsServerZone`

    For the example above, you can verify the DNS server resource records with:
    `Get-DnsServerResourceRecord -ZoneName heh.lan`
    `Get-DnsServerResourceRecord -ZoneName 168.192.in-addr.arpa`
    `Get-DnsServerResourceRecord -ZoneName 0.0.0.0.0.0.0.0.0.0.0.0.d.a.c.a.ip6.arpa`

    To check if the DNS is working well you can do:
    `nslookup`

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

    [String]
    $NetworkIDv6,

    [String]
    $PrefixV6,

    [String]
    $RevZoneNameV6,

    [ValidateNotNullOrEmpty()]
    [String]
    $SRVPri,

    [ValidateNotNullOrEmpty()]
    [String]
    $SRVSec
)

Import-Module ServerManager
Add-WindowsFeature -Name DNS -IncludeManagementTools

# Create Forward Lookup Zones
Add-DnsServerPrimaryZone -Name "$ZoneName" -ZoneFile "$ZoneName.dns"

# Create Reverse Lookup Zones
Add-DnsServerPrimaryZone -NetworkId "$NetworkIDv4/$PrefixV4" -ZoneFile "$RevZoneNameV4.dns"
If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
    Add-DnsServerPrimaryZone -NetworkId "$NetworkIDv6/$PrefixV6" -ZoneFile "$RevZoneNameV6.dns"
}

# Remove the default Name Server
Remove-DnsServerResourceRecord -ZoneName "$ZoneName" -RRType "Ns" -Name "@" -RecordData "srvdnsprimary" -Force

# Create Records
Add-DnsServerResourceRecordA -Name "$SRVPri" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "192.168.42.1" -CreatePtr
If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
    Add-DnsServerResourceRecordAAAA -Name "$SRVPri" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::10" -CreatePtr
}

Add-DnsServerResourceRecordA -Name "$SRVSec" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "192.168.42.2" -CreatePtr
If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
    Add-DnsServerResourceRecordAAAA -Name "$SRVSec" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::11" -CreatePtr
}

# Create Alias
Add-DnsServerResourceRecordCName -Name "www" -HostNameAlias "$SRVPri.$ZoneName" -ZoneName "$ZoneName"
Add-DnsServerResourceRecordCName -Name "SRV1" -HostNameAlias "$SRVPri.$ZoneName" -ZoneName "$ZoneName"
Add-DnsServerResourceRecordCName -Name "SRV2" -HostNameAlias "$SRVSec.$ZoneName" -ZoneName "$ZoneName"

# Create Name Servers
Add-DnsServerResourceRecord -ZoneName "$ZoneName" -Name "." -NameServer "$SRVPri.$ZoneName" -NS
Add-DnsServerResourceRecord -ZoneName "$ZoneName" -Name "." -NameServer "$SRVSec.$ZoneName" -NS

# Remove the default Name Server
Remove-DnsServerResourceRecord -ZoneName "$RevZoneNameV4" -RRType "Ns" -Name "@" -RecordData "srvdnsprimary" -Force

Add-DnsServerResourceRecord -ZoneName "$RevZoneNameV4" -Name "." -NameServer "$SRVPri.$ZoneName" -NS
Add-DnsServerResourceRecord -ZoneName "$RevZoneNameV4" -Name "." -NameServer "$SRVSec.$ZoneName" -NS

If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
    # Remove the default Name Server
    Remove-DnsServerResourceRecord -ZoneName "$RevZoneNameV6" -RRType "Ns" -Name "@" -RecordData "srvdnsprimary" -Force

    Add-DnsServerResourceRecord -ZoneName "$RevZoneNameV6" -Name "." -NameServer "$SRVPri.$ZoneName" -NS
    Add-DnsServerResourceRecord -ZoneName "$RevZoneNameV6" -Name "." -NameServer "$SRVSec.$ZoneName" -NS
}

# Create a Incremental Transfert Zone where the secondary DNS server gets
# new and changed resource records.
Start-DnsServerZoneTransfer -Name "$ZoneName"

# Create Delegation Zone
Add-DnsServerZoneDelegation -Name "heh.lan" -ChildZoneName "delegation" `
  -NameServer "SRVDNSSecondary.delegation.heh.lan" -IPAddress "192.168.42.2"
