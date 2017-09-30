<#
.SYNOPSIS
    Enables the AD Recycle Bin.
    PowerSploit Function: Conf-ADRecycleBin
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-ADRecycleBin Enables the AD Recycle Bin.

.EXAMPLE
    PS C:\> Conf-ADRecycleBin -NetbiosName HEH-STUDENT
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $NetbiosName
)

Import-module ActiveDirectory
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target "$NetbiosName"
