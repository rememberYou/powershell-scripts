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

# Create A Records
$Name="SRVDNSPrimary"
Add-DnsServerResourceRecordPtr -Name "$Name" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address 172.16.0.10 -CreatePtr 

$Name="SRVDNSSecondary"
Add-DnsServerResourceRecordPtr -Name "$Name" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address 172.16.0.11 -CreatePtr
