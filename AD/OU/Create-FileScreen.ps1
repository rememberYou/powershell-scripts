<#
.SYNOPSIS
    Creates the file screen for the shared folder.
    PowerSploit Function: Create-FileScreen
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Create-FileScreen Creates the file screen for the shared folder.
#>



# Create Action
$logAction = New-FsrmAction Event -EventType Information -Body "An user attempted to create a forbidden file in the shared folder." -RunLimitInterval 60

# Create File Group
$allFileGroup = New-FsrmFileGroup -Name "All files" -IncludePattern "*"

# Create File Screen Template
$fsTemplate = New-FsrmFileScreenTemplate -Name "Deny All Type of Files" -IncludeGroup "All files" -Notification $logAction -Active

# Set the File Screen on the shared folder
New-FsrmFileScreen -Path "C:\Shared\" -Template "Deny All Type of Files"

# Set the File Screen Exception on the shared folder
New-FsrmFileScreenException -Path "C:\Shared\" -IncludeGroup "Image Files","Office Files"
