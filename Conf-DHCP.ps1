<#
.SYNOPSIS
    Installs the DHCP service and sets a basic DHCP configuration.
    PowerSploit Function: Conf-DHCP
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-DHCP Installs the DHCP service and sets a basic DHCP configuration.

.EXAMPLE
    PS C:\> Conf-DNS -ZoneName heh.lan
    -NetworkID 172.16.120.0 -Prefix 24 -RevZoneName 120.16.172.in-addr.arpa
    -SRVPri SRVDNSPrimary -SRVSec SRVDNSSecondary

.NOTES
    You can verify the DHCP installation with:
    # `Get-WindowsFeature`

    You can verify the DHCP configuration with:
    `Get-DhcpServerv4Scope -cn srvdnsprimary | select scopeid, name, description`
#>
Import-Module ServerManagement
Add-WindowsFeature -Name DHCP -IncludeManagementTools

# 242 employees ==> Scope: 172.16.1.0 -> 172.16.2.255
# Scope Gateway: 172.16.1.1
# DomainName: 015DNSDOMAINNAME

Add-DhcpServerv4Scope -Name 'employees scope' -StartRange 172.16.1.1 -EndRange 172.16.2.254 -SubnetMask 255.255.0.0 -Description 'created for the employees' –cn srvdnsprimary
