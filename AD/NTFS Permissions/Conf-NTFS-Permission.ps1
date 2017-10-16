<#
.SYNOPSIS
    Configures the NTFS permissions.
    PowerSploit Function: Conf-NTFS-Permission
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Conf-NTFS-Permission Configures the NTFS permissions.

.EXAMPLE
    PS C:\> Conf-NTFS-Permission -Lan HEH -User Ca.LECLERCQ -Shared C:\Shared\Common -Permission R/W

.NOTES
    You can verify NTFS permissions with:
    `Get-Acl "C:\path-to-folder" | Format-List`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $Lan,

    [ValidateNotNullOrEmpty()]
    [String[]]
    $Users,

    [ValidateNotNullOrEmpty()]
    [String]
    $Shared,

    [ValidateNotNullOrEmpty()]
    [String]
    $Permission
)

$acl = Get-Acl "$($Shared)"

Function GetPermission {
    If ($Permission -eq "R") {
	$Permission = "Read"
    } ElseIf ($Permission -eq "W") {
	$Permission = "Write"
    } Else {
	$Permission = "Read, Write"
    }
    return $Permission
}

Function SetAcl
{
    $Permission = GetPermission

    ForEach($user in $Users)
    {
	If ($user -eq "Users") {
	    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", $Permission,
										  "ContainerInherit, ObjectInherit",
										  "None", "Allow")
	} Else {
	    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Lan\$user", $Permission,
										  "ContainerInherit, ObjectInherit",
										  "None", "Allow")
	}
	$acl.AddAccessRule($rule)
    }

    Set-Acl $Shared $acl
    Get-Acl $Shared | Format-List
}

SetAcl
