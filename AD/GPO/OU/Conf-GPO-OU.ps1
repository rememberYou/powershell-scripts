<#
.SYNOPSIS
    Configures GPO for OU.
    PowerSploit Function: Conf-GPO-UO
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-GPO-OU Configures GPO for OU.

.NOTES
    You need to create OU before execute this script.
#>

# Mount the shared folder of the department to "Y"
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' `
  -name "Y:" -value '\??\C:\Shared\Finances\Comptabilité'

# Mount the "Common" shared folder to "Z"
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' `
  -name "Z:" -value '\??\C:\Shared\Common'
