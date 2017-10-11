<#
.SYNOPSIS
    Creates the quotas for all departments' shared folder.
    PowerSploit Function: Create_Quotas
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Create_Quotas Creates the quotas for all departments' shared folder.

.EXAMPLE
    PS C:\> Create_Quotas

.NOTES
    Take a look at the "ou-example.csv" file for the specific structure
    and change it with yours.

    You can verify the creation of your Organizatinal Units with:
    `Get-ADOrganizationalUnit -Filter *`
#>

Install-WindowsFeature -Name FS-Resource-Manager, RSAT-FSRM-Mgmt

# Create Templates
New-FsrmQuotaTemplate -Name "500 MB limit" -Description "limit usage to 500 MB." -Size 500MB

# Apply template to the Shared Folder
$Departments = gci -Directory "C:\Shared" | select name

ForEach($folder in $Departments)
{
    $currentFolder = $folder.Name
    New-FsrmQuota -Path "C:\Shared\$currentFolder" -Template "500 MB limit"
    if ($currentFolder -ne "Common") {
        $subDepartments = gci -Directory "C:\Shared\$currentFolder" | select name
        ForEach ($folder in $subDepartments)
        {
            $currentSubFolder = $folder.Name
            New-FsrmQuota -Path "C:\Shared\$currentFolder\$currentSubFolder" -Template "100 MB limit"
        }
    }
}
