# This script is to make the DNS configuration for the server.
#
# You can verify your IP addresses configurations with:
# `Get-WindowsFeature`
Import-Module Servermanager
Add-WindowsFeature 'DNS' -restart

# Add-DnsServerPrimaryZone -Name primaryzone.heh.lan -ReplicationScope Forest
