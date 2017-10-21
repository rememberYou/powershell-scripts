<#
.SYNOPSIS
    Configures the GPO for every users of the AD.
    PowerSploit Function: Conf-GPOUser
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-GPOUser Configures the GPO for all the users of the AD.

.EXAMPLE
    PS C:\> Conf-GPO

.NOTES
    You will have to restart your client 2 or 3 times for the wallpaper to be displayed
#>

# Set a wallpaper for every users on the same OU.
Import-Module GroupPolicy
New-GPO -Name GPO_BG | New-GPLink -Target "OU=Direction, DC=heh, DC=lan"
Set-GPPrefRegistryValue -Name GPO_BG -Context User -Action Replace `
  -Key "HKCU\Control Panel\Desktop" -ValueName WallPaper `
  -Value "\\SRVDNSPrimary\Share\giant.jpg" `
  -Type String

Invoke-GPUpdate -Force

Set-GPPrefRegistryValue -Name GPO_BG -Context User -Action Create `
  -Key "HKCU\Control Panel\Desktop" -ValueName WallPaper `
  -Value "\\SRVDNSPrimary\Share\giant.jpg" `
  -Type String