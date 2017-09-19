# This script is to make the DHCP configuration for the server.
#
# You can verify the DHCP installation with:
# `Get-WindowsFeature`
Import-Module ServerManagement
Add-WindowsFeature -Name DHCP -IncludeManagementTools
