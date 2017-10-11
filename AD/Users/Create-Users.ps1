<#
.SYNOPSIS
    Creates users according to a ".csv" file.
    PowerSploit Function: Create-User
    Author: Terencio Agozzino (@rememberYou)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Creates users according to a ".csv" file.

.EXAMPLE
    PS C:\> Create-Users -File C:\Users\Administrator\Desktop\users-example.csv `
                        -RootDir Direction

.NOTES
    Take a look at the "users-example.csv" file for the specific structure
    and change it with yours.

    You can verify your ADForest configuration with:
    `Get-ADForest`

    You can verify your ADDomain configuration with:
    `Get-ADDomain`
#>

Import-module .\New-SWRandomPassword.ps1

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $File
)

Class Employee {
    [string] $Name;
    [string] $Firstname;
    [string] $Description;
    [string] $Department;

    Employee([string] $Name, [string] $Firstname, [string] $Description,
	     [string] $Department) {
        $this.Name = $Name;
	$this.Firstname = $Firstname;
        $this.Description = $Description;
	$this.Department = $Department;
     }

    [string] EmployeeName() { return $this.Name }
}

$Employees = @()

Try {
    $csv = Import-Csv -Encoding "UTF8" -Path "$File" `
      -Header Name, Firstname, Description, Department
} Catch {
    Write-Host "Can't load the file: $file" -Foreground Red
}

# Can make problem with the password complexity. Disable it with the GPO.
# $RandObj = New-Object System.Random

foreach ($user in $csv) {
    $Employees += [Employee]::new($user.Name, $user.Firstname, $user.Description,
				      $user.Department)

    $San = ($user.Firstname).substring(0, 2) + "." + $user.Name

    $GenPassword = New-SWRandomPassword -MinPasswordLength 12 -MaxPasswordLength 16 -Count 1

    While ($San.length -gt 19) {
	$San = ($user.Firstname).substring(0, 1) + "." `
	  + $user.Name.substring(0, ($user.Name).length / 2)
    }

    If ($San.Contains(" ")) {
	$San = ($user.Firstname).substring(0, 1) + "." `
	  + $user.Name.Split(" ")[-1]
    }

    $Mail = ("$($user.Firstname).$($user.Name)" -replace " ", "").ToLower()

    $Upn = ("$San@heh.lan").ToLower()

    $Ou = "OU=$($user.Department)" -replace "/", ",OU="

    New-ADUser -Name "$($user.Firstname) $($user.Name)" `
    -DisplayName "$($user.Firstname) $($user.Name)" `
    -SamAccountName $San -UserPrincipalName "$upn" `
    -GivenName $user.Firstname -Surname $user.Name `
    -EmailAddress $Mail -Description $user.Description `
    -AccountPassword (ConvertTo-SecureString $GenPassword -AsPlainText -Force) `
    -Enabled $true -Path "$Ou,DC=heh,DC=lan"

    If ($User.Department.Contains('/')) {
	Add-ADGroupMember -Identity "GS_$($user.Department.Split('/')[0])" -Members "$San"
    } Else {
	Add-ADGroupMember -Identity "GR_$($user.Department)" -Members "$San"
    }
}

Write-Host "Done."
Write-Host "$($(Get-ADUser -Filter *).Count) Users added."
