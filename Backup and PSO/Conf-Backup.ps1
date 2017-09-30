<#
.SYNOPSIS
    Configures the Windows Server Backup.
    PowerSploit Function: Conf-Backup
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-Backup Configures the Windows Server Backup.

.EXAMPLE
    PS C:\> Conf-Backup -Disk D

.NOTES
    You can get a summary of previously run backup operations :
    `Get-WBSummary`

#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $Disk
)


# Install Windows Server Backup
Install-WindowsFeature -Name Windows-Server-Backup #-Restart:$false
#Install-WindowsFeature -Name Windows-Server-Backup -IncludeAllSubfeature -IncludeManagementTools

# Back up the System State
Add-WBSystemState -Policy New-WBPolicy

# Declare the backup location on the chosen Disk
$target = New-WBBackupTarget -VolumePath "${Disk}:"

Add-WBBackupTarget -Policy New-WBPolicy -Target $target

# Start the backup
Start-WBBackup -Policy New-WBPolicy
