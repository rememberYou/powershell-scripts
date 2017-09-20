<#
.SYNOPSIS
    Installs the DNS service and sets a basic DNS configuration.
    PowerSploit Function: Conf-DNS
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0
 
.DESCRIPTION
    Conf-DNS Installs the DNS service and sets a basic DNS configuration.

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan -NetworkIDv4 172.16.0.0 -PrefixV4 16 -RevZoneNameV4 16.172.in-addr.arpa -SRVPri SRVDNSPrimary -SRVSec SRVDNSSec

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan -NetworkIDv4 172.16.0.0 -PrefixV4 16 -RevZoneNameV4 16.172.in-addr.arpa -NetworkIDv6 acad:: -PrefixV6 64 -RevZoneNameV6 acad.ip6.arpa -SRVPri SRVDNSPrimary -SRVSec SRVDNSSec

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
    
    [ValidateNotNullOrEmpty()]
    [String]
    $NetworkIDv4,
    
    [ValidateNotNullOrEmpty()]
    [String]
    $PrefixV4,

    [String]
    $NetworkIDv6,
       
    [String]
    $Prefixv6,
   
    [ValidateNotNullOrEmpty()]
    [String]
    $RevZoneNameV4,

    [ValidateNotNullOrEmpty()]
    [String]
    $RevZoneNameV6,

    [ValidateNotNullOrEmpty()]
    [String]
    $SRVPri,

    [ValidateNotNullOrEmpty()]
    [String]
    $SRVSec
)

Function IsFeatureInstalled($Feature)
{
    return Get-WindowsFeature | Where-Object {$_.Name -like "$Feature" -and $($_.InstallState -eq "Installed" -or $_.InstallState -eq "InstallPending")}
}

$Feature = "DNS"
If (-Not IsFeatureInstalled($Feature))
    Import-Module ServerManager
    Add-WindowsFeature -Name DNS -IncludeManagementTools
    # Create Forward Lookup Zones
    Add-DnsServerPrimaryZone -Name "$ZoneName" -ZoneFile "$ZoneName.dns"

    # Create Reverse Lookup Zones
    Add-DnsServerPrimaryZone -NetworkID "$NetworkIDv4/$PrefixV4" -ZoneFile "$RevZoneNameV4.dns"
    Add-DnsServerPrimaryZone -NetworkID "$NetworkIDv6/$PrefixV6" -ZoneFile "$RevZoneNameV6.dns"

    # Create Records
    Add-DnsServerResourceRecordA -Name "$SRVPri" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "172.16.0.10" -CreatePtr
    Add-DnsServerResourceRecordAAAA -Name "$SRVPri" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::10" -CreatePtr

    Add-DnsServerResourceRecordA -Name "$SRVSec" -ZoneName "$ZoneName" -AllowUpdateAny -IPv4Address "172.16.0.11" -CreatePtr
    Add-DnsServerResourceRecordAAAA -Name "$SRVSec" -ZoneName "$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::11" -CreatePtr

    # Create Alias
    Add-DnsServerResourceRecordCName -Name "www" -HostNameAlias "$SRVPri.$ZoneName" -ZoneName "$ZoneName"
}
else
{
    Write-Host "The $Feature feature is already installed."
}
