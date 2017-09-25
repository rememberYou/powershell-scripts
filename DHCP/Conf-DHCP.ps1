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
    PS C:\>

.NOTES
    You can verify the DHCP installation with:
    `Get-WindowsFeature`

    You can verify the DHCP configuration with:
    `Get-DhcpServerv4Scope -cn srvdnsprimary | select scopeid, name, description`

    There are 242 employees, we choose this scope: 192.168.1.0 -> 192.168.2.255
    The scope gateway is 192.168.1.1
#>

Function IsFeatureInstalled($Feature)
{
    return Get-WindowsFeature | Where-Object {$_.Name -like "$Feature" -and $($_.InstallState -eq "Installed" -or $_.InstallState -eq "InstallPending")}
}

$Feature = "DHCP"
If (-Not (IsFeatureInstalled($Feature)))
{
    Add-WindowsFeature -Name DHCP -IncludeManagementTools

    # This registry's value has to be updated to tell that the configuration has been completed.
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
    Restart-Service DHCPServer

    # IPv4
    # Lease format is day.hrs:mins:secs
    Add-DhcpServerv4Scope -Name 'employees scope (IPv4)' -StartRange 192.168.1.1 -EndRange 192.168.2.254 -SubnetMask 255.255.0.0 -LeaseDuration 2.00:00:00 -Description 'Created for the employees' -ComputerName 'SRVDNSPrimary' -State Active
    # OptionID 3 stand for Gateway Address
    Set-DhcpServerv4OptionValue -OptionID 3 -Value 192.168.1.1 -ScopeID 192.168.1.0 -ComputerName 'SRVDNSPrimary'
    Set-DhcpServerv4OptionValue -DnsDomain 'heh.lan' -DnsServer 192.168.42.1

    # IPv6
    # LifeTime format is day.hrs:mins:secs
    Add-DhcpServerv6Scope -Name 'employees scope (IPv6)' -Prefix ACAD:: -PreferredLifeTime 2.00:00:00 -ValidLifeTime 2.00:00:00 -Description 'Created for the employees' -ComputerName 'SRVDNSPrimary' -State Active
    Add-DhcpServerv6ExclusionRange -Prefix ACAD:: -StartRange ACAD::1 -EndRange ACAD::FFFF
    Add-DhcpServerv6ExclusionRange -Prefix ACAD:: -StartRange ACAD::1:200 -EndRange ACAD::FFFF:FFFF:FFFF:FFFF
    # OptionID 23 stand for DNS
    Set-DhcpServerv6OptionValue -OptionId 23 -Value ACAD::10 -ComputerName 'SRVDNSPrimary'
}
else
{
    Write-Host "The $Feature feature is already installed."
}
