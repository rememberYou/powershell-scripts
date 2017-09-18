# This script is to make the firewall configuration for the server.
#
# You can verify if the rule is enabled with:
# Get-NetFirewallRule -DisplayGroup "File And Printer Sharing"

# Enable ICMPv4 to ping to the system.
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True
