<#
.SYNOPSIS
    Installs the DNS service and sets a basic DNS configuration.
    PowerSploit Function: Conf-DNS
    Author: Terencio Agozzino (@rememberYou)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0
 
.DESCRIPTION
    Conf-DNS Installs the DNS service and sets a basic DNS configuration.

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan -ReplicationZone Domain 
    -NetworkID 172.16.120.0 -Prefix 24 -RevZoneName 120.16.172.in-addr.arpa
    -SRVPri SRVDNSPrimary -SRVSec SRVDNSSecondary

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan -ReplicationZone Domain 
    -NetworkID 172.16.120.0 -Prefix 24 -RevZoneName 120.16.172.in-addr.arpa
    -SRVPri SRVDNSPrimary -SRVSec SRVDNSSecondary

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan -NetworkID 172.16.120.0 -Prefix 24 
    -RevZoneName 120.16.172.in-addr.arpa -SRVPri SRVDNSPrimary -SRVSec SRVDNSSecondary

.NOTES
    You can verify the DNS installation with:
    `Get-WindowsFeature`

    You can verify the DNS zones with:
    `Get-DnsServerZone`
#>

Param(    
    [ValidateNotNullOrEmpty()]
    [String]
    $ZoneName,
        
    [String]
    $ReplicationZone=Domain
    
    [ValidateNotNullOrEmpty()]
    [String]
    $NetworkID,
    
    [ValidateNotNullOrEmpty()]
    [String]
    $Prefix,
    
    [ValidateNotNullOrEmpty()]
    [String]
    $RevZoneName
)

Import-Module ServerManager
Add-WindowsFeature -Name DNS -IncludeManagementTools

# Create Forward Lookup Zones
Add-DnsServerPrimaryZone -Name "$ZoneName" -ZoneFile "$ZoneName.dns" -DynamicUpdate Secure -ReplicationZone "$ReplicationZone"

# Create Reverse Lookup Zones
Add-DnsServerPrimaryZone -NetworkID "$NetworkID/$Prefix" -ZoneFile "$RevZoneName.dns"

# Create Records
Add-DnsServerResourceRecordA -Name "$SRVPri" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "172.16.120.10" -CreatePtr
Add-DnsServerResourceRecordAAAA -Name "$SRVPri" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::10" -CreatePtr 

Add-DnsServerResourceRecordA -Name "$SRVSec" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "172.16.120.11" -CreatePtr
Add-DnsServerResourceRecordAAAA -Name "$SRVSec" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::11" -CreatePtr

# Create Alias
Add-DnsServerResourceRecordCName -Name "www" -HostNameAlias "$SRVPri.$ZoneName" -ZoneName "$ZoneName"
