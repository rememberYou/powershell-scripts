# This script is to make the DHCP configuration for the server.
#
# You can verify your IP addresses configurations with:
# `Get-WindowsFeature`
Import-Module Servermanager
Add-WindowsFeature 'DHCP' -restart
