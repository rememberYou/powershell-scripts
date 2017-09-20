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
    Conf-DNS Installs the DNS service and sets a basic DNS secondary configuration.

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan -NetworkIDv4 172.16.0.0 -PrefixV4 16 -RevZoneNameV4 16.172.in-addr.arpa -MasterServersV4 @("172.16.0.10")

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan -NetworkIDv4 172.16.0.0 -PrefixV4 16 -RevZoneNameV4 16.172.in-addr.arpa -NetworkIDv6 acad:: -PrefixV6 64 -RevZoneNameV6 acad.ip6.arpa -MasterServersV6 @("172.16.0.10")

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

Function IsFeatureInstalled($Feature)
{
    return Get-WindowsFeature | Where-Object {$_.Name -like "$Feature" -and $($_.InstallState -eq "Installed" -or $_.InstallState -eq "InstallPending")}
}

$Feature = "DNS"
If (-Not (IsFeatureInstalled($Feature)))
{
    # Create Forward Lookup Zones
    Add-DnsServerSecondaryZone -Name "$ZoneName" -ZoneFile "$ZoneName.dns" -MasterServers "$MastersServersV4"

    # Create Reverse Lookup Zones
    Add-DnsServerSecondaryZone -NetworkID "$NetworkIDv4/$PrefixV4" -ZoneFile "$RevZoneNameV4.dns" -MasterServers "$MastersServersV4"
    Add-DnsServerSecondaryZone -NetworkID "$NetworkIDv6/$PrefixV6" -ZoneFile "$RevZoneNameV6.dns" -MasterServers "$MastersServersV6"    
}
else
{
    Write-Host "The $Feature feature is already installed."
}
