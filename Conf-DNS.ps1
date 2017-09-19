# This script is to make the DNS configuration for the server.
#
# You can verify the DNS installation with:
# `Get-WindowsFeature`
#
# You can verify the DNS zones with:
# `Get-DnsServerZone`

Import-Module ServerManager
Add-WindowsFeature -Name DNS -IncludeManagementTools

# Create Forward Lookup Zones
$ZoneName="heh.lan"
Add-DnsServerPrimaryZone -Name "$ZoneName" -ZoneFile "$ZoneName.dns"

# Create Reverse Lookup Zones
$NetworkID="172.16.120.0"
$Prefix="24"
$RevZoneName="120.16.172.in-addr.arpa"
Add-DnsServerPrimaryZone -NetworkID "$NetworkID/$Prefix" -ZoneFile "$RevZoneName.dns"

# Create Records
$SRVPrimary="SRVDNSPrimary"
Add-DnsServerResourceRecordA -Name "$SRVPrimary" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "172.16.0.10" -CreatePtr
Add-DnsServerResourceRecordAAAA -Name "$SRVPrimary" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::10" -CreatePtr 

$SRVSecondary="SRVDNSSecondary"
Add-DnsServerResourceRecordA -Name "$SRVSecondary" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "172.16.0.11" -CreatePtr
Add-DnsServerResourceRecordAAAA -Name "$SRVSecondary" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::11" -CreatePtr

# Create Alias
Add-DnsServerResourceRecordCName -Name "www" -HostNameAlias "$SRVPrimary.$ZoneName" -ZoneName "$ZoneName"
