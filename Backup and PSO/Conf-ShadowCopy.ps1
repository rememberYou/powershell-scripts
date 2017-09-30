<#
.SYNOPSIS
    Creates and configures the Volum Shadow Copy on the Server.
    PowerSploit Function: Conf-ShadowsCopy
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-ShadowsCopy Creates and configures the Volum Shadow Copy on the Server.

.EXAMPLE
    PS C:\> Conf-ShadowsCopy -Disk C -MaxSize 8128MB -Time 6:00AM -TaskName ShadowCopy_C_6AM

.NOTES
    You can verify how many shadow copies exist :
    `$shadow = get-wmiobject win32_shadowcopy
    "There are {0} shadow copies on this sytem." -f $shadow.count`

    You also can verify if the scheduled tasks are well :
    `Get-ScheduledTask ShadowCopy_C_6AM | Get-ScheduledTaskInfo`

    You can list all the available shadow copies :
    `vssadmin list shadows`

#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $Disk,

    [ValidateNotNullOrEmpty()]
    [String]
    $MaxSize,

    [ValidateNotNullOrEmpty()]
    [String]
    $Time,

    [ValidateNotNullOrEmpty()]
    [String]
    $TaskName
)

# Enables Volume Shadow copy
vssadmin add shadowstorage /for="$Disk": /on="$Disk":  /maxsize="$MaxSize"

# Creates a new shadow copy
vssadmin create shadow /for="$Disk":

"Creating a new shadow copy"
# Sets Shadow Copy Scheduled Task daily at 6AM
$Action=new-scheduledtaskaction -execute "c:\windows\system32\vssadmin.exe" -Argument "create shadow /for=${Disk}:"
$Trigger=new-scheduledtasktrigger -daily -at "$Time"
Register-ScheduledTask -TaskName "$TaskName" -Trigger $Trigger -Action $Action -Description "$TaskName"
