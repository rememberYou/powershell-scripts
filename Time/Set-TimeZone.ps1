<#
.SYNOPSIS
    Sets the time of the server according to a time zone.
    PowerSploit Function: Conf-DNS
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Set-TimeZone sets the time of the server according to a time zone.

.EXAMPLE
    PS C:\> Set-TimeZone -TimeZone "Romance Standard Time"

.NOTES
    You can list the available time zone with:
    `TZUTIL /l`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $TimeZone
)

TZUTIL /s $TimeZone
