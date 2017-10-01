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
    PS C:\> Conf-Backup -Frequency Daily -Schedule 06:10

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

    You can check the Scheduled Backup in `taskschd.msc`, at this location:
    `\Microsoft\Windows\Powershell\ScheduledJobs\`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $Frequency,

    [ValidateNotNullOrEmpty()]
    [String]
    $Schedule
)

# Configure the Backup disk
Set-Disk 1 -IsOffline $false
Initialize-Disk -Number 1 -PartitionStyle MBR
New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter "E"
Format-volume -DriveLetter "E" -FileSystem NTFS

# Install Windows Server Backup
Install-WindowsFeature -Name Windows-Server-Backup -Restart:$false

Register-ScheduledJob -Name "System State Backup" -Trigger @{Frequency = "$Frequency"; At = "$Schedule"} -ScriptBlock {
    $WBPolicy = New-WBPolicy
    # Back up the System State
    Add-WBSystemState -Policy $WBPolicy

    # Declare the backup location on the chosen Disk
    $target = New-WBBackupTarget -VolumePath "E:"

    Add-WBBackupTarget -Policy $WBPolicy -Target $target
    Set-WBPerformanceConfiguration -OverallPerformanceSetting AlwaysIncremental

    # Start the backup
    Start-WBBackup -Policy $WBPolicy
}
