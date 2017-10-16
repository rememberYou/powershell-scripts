<#
.SYNOPSIS
    Configures the default password policy for a specified group.
    PowerSploit Function: Conf-ADDirPWD
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-ADDirPWD Configures the default password policy for a specified group.

.EXAMPLE
    PS C:\> Conf-ADDirPWD -Group Direction -Length 15
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $Group,

    [ValidateNotNullOrEmpty()]
    [String]
    $Length
)

Set-ADDefaultDomainPasswordPolicy -Identity $Group -LockoutDuration 00:40:00 `
    -LockoutObservationWindow 00:15:00 -ComplexityEnabled $True `
    -ReversibleEncryptionEnabled $False -MaxPasswordAge 10.00:00:00 `
    -MinPasswordLength $Length
