<#
.SYNOPSIS
    Configures the GPO for the every users.
    PowerSploit Function: Conf-GPOUser
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-GPOUser Configures the GPO for all the users.

.EXAMPLE
    PS C:\> Conf-GPO
#>

# Set a wallpaper for every users on the same OU.
Import-Module GroupPolicy
New-GPO -Name GPO_BG | New-GPLink -Target "OU=All_ICT, DC=heh, DC=lan"
Set-GPPrefRegistryValue -Name GPO_BG -Context User -Action Replace `
  -Key "HKCU\Control Panel\Desktop" -ValueName Wallpaper `
  -Value "C:\Users\Administrator\Documents\My Pictures\Backgrounds\umbrela.jpg" `
  -Type String

Invoke-GPUpdate -Force
