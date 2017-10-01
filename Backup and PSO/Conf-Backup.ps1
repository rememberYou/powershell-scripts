<#
.SYNOPSIS
    Configures the Windows Server Backup as well as the backup Disk.
    PowerSploit Function: Conf-Backup
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-Backup Configures the Windows Server Backup as well as the backup Disk.

.EXAMPLE
    PS C:\> Conf-Backup -Disk E -Schedule 07:00

.EXAMPLE
    PS C:\> Conf-Backup -Disk E -Schedule 07:00 -ConfigureDisk yes

.NOTES
    You can list all the available disks:
    `Get-Disk`

    You can get a summary of previously run backup operations:
    `Get-WBSummary`

    You can get infos about the current backup job:
    `Get-WBJob`

    You can get infos about the backup schedule:
    `$WBPolicy = New-WBPolicy
    Get-WBSchedule -Policy $WBPolicy`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $Disk,

    [ValidateNotNullOrEmpty()]
    [String]
    $Schedule,

    [ValidateNotNullOrEmpty()]
    [String]
    $ConfigureDisk
)

If ($ConfigureDisk -ne $Null) {
    # Configure the Backup disk
    Set-Disk 1 -IsOffline $false
    Initialize-Disk -Number 1 -PartitionStyle MBR
    New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter "$Disk"
    Format-volume -DriveLetter "$Disk" -FileSystem NTFS
}

# Install Windows Server Backup
Install-WindowsFeature -Name Windows-Server-Backup -Restart:$false

$WBPolicy = New-WBPolicy
# Back up the System State
Add-WBSystemState -Policy $WBPolicy

# Declare the backup location on the chosen Disk
$target = New-WBBackupTarget -VolumePath "${Disk}:"

Add-WBBackupTarget -Policy $WBPolicy -Target $target
Set-WBPerformanceConfiguration -OverallPerformanceSetting AlwaysIncremental

# Start the backup
Start-WBBackup -Policy $WBPolicy

# Sets the times to create daily backups for the backup policy
Set-WBSchedule -Policy $WBPolicy -Schedule "$Schedule"
