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
                         -Path "DC=heh,DC=lan"

.NOTES
    Be careful, this script only working with `New-SWRandomPassword.ps1`

    Take a look at the "users-example.csv" file for the specific structure
    and change it with yours.

    You can verify your ADForest configuration with:
    `Get-ADForest`

    You can verify your ADDomain configuration with:
    `Get-ADDomain`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $File,

    [ValidateNotNullOrEmpty()]
    [String]
    $Path
)

Import-Module .\New-SWRandomPassword.ps1

Try {
    $csv = Import-Csv -Encoding "UTF8" -Path "$File" `
      -Header Name, Firstname, Description, Department, OfficePhone, Office
} Catch {
    Write-Host "Can't load the file: $file" -Foreground Red
}

foreach ($user in $csv) {
    $San = ($user.Firstname).substring(0, 2) + "." + $user.Name

    $GenPassword = New-SWRandomPassword -MinPasswordLength 12 -MaxPasswordLength 16 -Count 1

    While ($San.length -gt 19) {
	$San = ($user.Firstname).substring(0, 2) + "." `
	  + $user.Name.substring(0, ($user.Name).length / 2)
    }

    If ($San.Contains(" ")) {
	$San = ($user.Firstname).substring(0, 2) + "." `
	  + $user.Name.Split(" ")[-1]
    }

    $Sf = $Path.Split("paysbas")

    # If ($San.Contains("é")) {
    # 	$San = $San -replace "é", "e"
    # }

    # If ($San.Contains("è")) {
    # 	$San = $San -replace "è", "e"
    # }

    # If ($San.Contains("ê")) {
    # 	$San = $San -replace "ê", "e"
    # }

    # You should  add more conditions if needed to replace accents on letters...

    $Mail = ("$($user.Firstname).$($user.Name)@paysbas.lan" -replace " ", "").ToLower()

    $Upn = ("$San@paysbas.lan").ToLower()

    $Ou = "OU=$($user.Department)" -replace "/", ",OU="

    New-ADUser -Name "$($user.Firstname) $($user.Name)" `
    -DisplayName "$($user.Firstname) $($user.Name)" `
    -SamAccountName $San -UserPrincipalName "$upn" `
    -GivenName $user.Firstname -Surname $user.Name `
      -EmailAddress $Mail -Description $user.Description `
      -OfficePhone $user.OfficePhone -Office $user.Office
    -AccountPassword (ConvertTo-SecureString $GenPassword -AsPlainText -Force) `
    -Enabled $true -Path "$Ou,$Path"

    $user.Department = $user.Department -replace " ", '_'

    If ($user.Department.Contains('/')) {
	Add-ADGroupMember -Identity "GS_$($user.Department.Split('/')[0])" -Members "$San"
    } Else {
	Add-ADGroupMember -Identity "GR_$($user.Department)" -Members "$San"
    }
}

Write-Host "Done."
Write-Host "$($(Get-ADUser -Filter *).Count) Users added."
