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
#>

Function IsFeatureInstalled($Feature)
{
    return Get-WindowsFeature | Where-Object {$_.Name -like "$Feature" -and $($_.InstallState -eq "Installed" -or $_.InstallState -eq "InstallPending")}
}

$Feature = "DHCP"
If (-Not IsFeatureInstalled($Feature))
    Add-WindowsFeature -Name DHCP -IncludeManagementTools

    # This registry's value has to be updated to tell that the configuration has been completed.
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
    Restart-Service DHCPServer
}
else
{
    Write-Host "The $Feature feature is already installed."
}
