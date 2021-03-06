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
    PS C:\> Conf-DHCP -StartRangeV4 192.168.1.2 -EndRangeV4 192.168.2.254 `
                            -ScopeIDV4 192.168.1.0 -SubnetMaskV4 255.255.0.0 `
                            -DnsServer 192.168.42.1 -ComputerName 'SRVDNSPrimary' `
                            -DnsDomain 'heh.lan' -LifeTime 2.00:00:00

.EXAMPLE
    PS C:\> Conf-DHCP -PrefixV6 2001:db8:cafe:10::1 -ComputerName 'SRVDNSPrimary' `
                            -DnsDomain 'heh.lan' -LifeTime 2.00:00:00

.EXAMPLE
    PS C:\> Conf-DHCP -StartRangeV4 192.168.1.2 -EndRangeV4 192.168.2.254 `
                            -ScopeIDV4 192.168.1.0 -SubnetMaskV4 255.255.0.0 `
                            -DnsServer 192.168.42.1 -ComputerName 'SRVDNSPrimary' `
                            -DnsDomain 'heh.lan' -PrefixV6 2001:db8:cafe:10::1 `
                            -LifeTime 2.00:00:00

.NOTES
    You can verify the DHCP installation with:
    `Get-WindowsFeature`

    You can verify the DHCP configuration with:
    `Get-DhcpServerv4Scope -cn srvdnsprimary | select scopeid, name, description`

    There are 242 employees, we choose this scope: 192.168.1.0 -> 192.168.2.255
    to prevent more than 25% of the current employees.

    The scope gateway is 192.168.1.1
#>

Param(
    [String]
    $StartRangeV4,

    [String]
    $EndRangeV4,

    [String]
    $ScopeIDV4,

    [String]
    $SubnetMaskV4,

    [ValidateNotNullOrEmpty()]
    [String]
    $DnsServer,

    [ValidateNotNullOrEmpty()]
    [String]
    $ComputerName,

    [ValidateNotNullOrEmpty()]
    [String]
    $DnsDomain,

    [String]
    $PrefixV6,

    [ValidateNotNullOrEmpty()]
    [String]
    $LifeTime
)

Add-WindowsFeature -Name DHCP -IncludeManagementTools

# This registry's value has to be updated to tell that the configuration has been completed.
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
Restart-Service DHCPServer

# IPv4
If (-Not ([string]::IsNullOrEmpty($StartRangeV4))) {
    # Lease format is day.hrs:mins:secs
    Add-DhcpServerv4Scope -Name 'employees scope (IPv4)' -StartRange $StartRangeV4 -EndRange $EndRangeV4 -SubnetMask $SubnetMaskV4 -LeaseDuration $LifeTime -Description 'Created for the employees' -ComputerName $ComputerName -State Active
    # OptionID 3 stand for Gateway Address
    Set-DhcpServerv4OptionValue -OptionID 3 -Value $StartRangeV4 -ScopeID $ScopeIDV4 -ComputerName $ComputerName
    Set-DhcpServerv4OptionValue -DnsDomain 'heh.lan' -DnsServer $DnsServer
}

# IPv6
If (-Not ([string]::IsNullOrEmpty($PrefixV6))) {
    # LifeTime format is day.hrs:mins:secs
    Add-DhcpServerv6Scope -Name 'employees scope (IPv6)' -Prefix $PrefixV6 -PreferredLifeTime $LifeTime -ValidLifeTime $LifeTime -Description 'Created for the employees' -ComputerName $ComputerName -State Active
    Add-DhcpServerv6ExclusionRange -Prefix $PrefixV6 -StartRange 2001:db8:cafe:10::1 -EndRange 2001:db8:cafe:10::FFFF
    Add-DhcpServerv6ExclusionRange -Prefix $PrefixV6 -StartRange 2001:db8:cafe:10::1:200 -EndRange 2001:db8:cafe:10:FFFF:FFFF:FFFF:FFFF
    # OptionID 23 stand for DNS
    Set-DhcpServerv6OptionValue -OptionId 23 -Value $PrefixV6 -ComputerName $ComputerName
}
