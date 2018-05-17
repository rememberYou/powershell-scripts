<#
.SYNOPSIS
    Sets a basic firewall configuration.
    PowerSploit Function: Conf-Firewall
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-Firewall sets a basic firewall configuration.

.EXAMPLE
    PS C:\> Conf-Firewall

.NOTES
    You can verify if the rule is enabled with:
    Get-NetFirewallRule -DisplayGroup "File And Printer Sharing"
#>

# Enables ICMPv4 and IMCPv6 to ping to the system.
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True
