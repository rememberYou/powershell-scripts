<#
.SYNOPSIS
    Configures the GPO for the Active Directory.
    PowerSploit Function: Conf-GPO
    Author: Terencio Agozzino (@rememberYou)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-GPO Configures the GPO for the Active Directory.

.EXAMPLE
    PS C:\> Conf-GPO -ZoneName heh.lan

.EXAMPLE
    PS C:\> Conf-GPO -ZoneName heh.lan -MinPasswordAge 1 -MaxPasswordAge 14 -MinPasswordLength 8

.NOTES
    You can verify your ADDefaultDomainPasswordPolicy configuration with:
    `Get-ADDefaultDomainPasswordPolicy`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $ZoneName,

    [TimeSpan]
    $MinPasswordAge=1,

    [TimeSpan]
    $MaxPasswordAge=30,

    [Int32]
    $MinPasswordLength=10
)

Set-ExecutionPolicy AllSigned

# Create GPO
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Set-ADDefaultDomainPasswordPolicy -Identity $ZoneName `
-MinPasswordAge $MinPasswordAge -MaxPasswordAge $MaxPasswordAge `
-MinPasswordLength $MinPasswordLength
Invoke-GPUpdate -Force
