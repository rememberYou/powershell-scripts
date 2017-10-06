<#
.SYNOPSIS
    Configures the default password policy for a specified domain.
    PowerSploit Function: Conf-ADDirPWD
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-ADDirPWD Configures the default password policy for a specified domain.

.EXAMPLE
    PS C:\> Conf-ADDirPWD -Domain Direction -Length 15
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $Domain,

    [ValidateNotNullOrEmpty()]
    [String]
    $Length
)

Set-ADDefaultDomainPasswordPolicy -Identity $Domain -LockoutDuration 00:40:00 `
    -LockoutObservationWindow 00:15:00 -ComplexityEnabled $True `
    -ReversibleEncryptionEnabled $False -MaxPasswordAge 10.00:00:00 `
    -MinPasswordLength $Length
