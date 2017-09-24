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
    PS C:\> Conf-DNSSecondary -ZoneName heh.lan -NetworkIDv4 172.16.0.0 `
                              -PrefixV4 16 -RevZoneNameV4 16.172.in-addr.arpa `
                              -MasterServersV4 172.16.0.10

.EXAMPLE    
    PS C:\> Conf-DNSSecondary -ZoneName heh.lan -NetworkIDv4 172.16.0.0 `
                              -PrefixV4 16 -RevZoneNameV4 16.172.in-addr.arpa `
                              -MasterServersV4 172.16.0.10 -NetworkIDv6 acad:: `
                              -PrefixV6 64 `
                              -RevZoneNameV6 0.0.0.0.0.0.0.0.0.0.0.0.d.a.c.a.ip6.arpa `
                              -MasterServersV6 ACAD::10

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

Function IsFeatureInstalled($Feature) {
    return Get-WindowsFeature | Where-Object {$_.Name -like "$Feature" -and `
      $($_.InstallState -eq "Installed" -or $_.InstallState -eq "InstallPending")}
}

If (-Not (IsFeatureInstalled("DNS"))) {
    Import-Module ServerManager
    Add-WindowsFeature -Name DNS -IncludeManagementTools
    
    # Create Forward Lookup Zones
    Add-DnsServerSecondaryZone -Name "$ZoneName" -ZoneFile "$ZoneName.dns" -MasterServers "$MasterServersV4"
    Add-DnsServerPrimaryZone -Name "delegation.$ZoneName" -ZoneFile "delegation.$ZoneName.dns"
    
    # Create Reverse Lookup Zones
    Add-DnsServerSecondaryZone -NetworkId "$NetworkIDv4/$PrefixV4" -ZoneFile "$RevZoneNameV4.dns" -MasterServers "$MasterServersV4"
    If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
	Add-DnsServerSecondaryZone -NeteworkId "$NetworkIDv6/$PrefixV6" -ZoneFile "$RevZoneNameV6.dns" -MasterServers "$MasterServersV6"
    }

    # Create Records
    Add-DnsServerResourceRecordA -Name "SRVDNSPrimary" -ZoneName "delegation.$ZoneName" -AllowUpdateAny -IPv4Address "172.16.0.10"
    If (-Not ([string]::IsNullOrEmpty($NetworkIDv6))) {
	Add-DnsServerResourceRecordAAAA -Name "SRVDNSPrimary" -ZoneName "delegation.$ZoneName" -AllowUpdateAny -IPv6Address "ACAD::10"
    }

    # Create Name Servers
    Add-DnsServerResourceRecord -ZoneName "delegation.$ZoneName" -Name "." -NameServer "SRVDNSPrimary.$ZoneName" -NS    
    Add-DnsServerResourceRecord -ZoneName "delegation.$ZoneName" -Name "." -NameServer "SRVDNSSecondary.$ZoneName" -NS    
} Else { Write-Host "The $Feature feature is already installed." }
