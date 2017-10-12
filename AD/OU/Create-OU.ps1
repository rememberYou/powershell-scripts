<#
.SYNOPSIS
    Creates Organizational Units according to a ".csv" file.
    PowerSploit Function: Create-OU
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Create-OU Creates Organizational Units according to a ".csv" file.

.EXAMPLE
    PS C:\> Create-OU -File C:\Users\Administrator\Desktop\ou-example.csv

.NOTES
    Take a look at the "ou-example.csv" file for the specific structure
    and change it with yours.

    You can verify the creation of your Organizatinal Units with:
    `Get-ADOrganizationalUnit -Filter *`
#>

Param(
    [ValidateNotNullOrEmpty()]
    [String]
    $File
)

New-Item "C:\Shared\Common" -Type Directory

Import-Module ActiveDirectory

Try {
    $csv = Import-Csv -Encoding "UTF8" -Path "$File" -Header Name,Parent
} Catch {
    Write-Host "Can't load the file: $file" -Foreground Red
    exit
}

foreach ($ou in $csv) {

    $Path = "DC=heh,DC=lan"

    If ($csv.IndexOf($ou) -eq 0) {
        $DirRoot = "C:\Shared\"
        $NameRoot = $ou.Name
    }

    If ($ou.Parent -ne "") {
        $Path = "OU=$($ou.Parent),DC=heh,DC=lan"
    }

    New-ADOrganizationalUnit -Name $ou.Name -Path $Path `
      -Description "$($ou.Name) Organizational Unit"

    If ($ou.Parent -eq "") {
	New-ADGroup "GR_$($ou.Name)" -Path "OU=$($ou.Name),$Path" `
	  -Description "$($ou.Name) Group" -GroupScope Global
    } Else {
	New-ADGroup "GS_$($ou.Name)" -Path "OU=$($ou.Name),$Path" `
	  -Description "$($ou.Name) Group" -GroupScope Global
	Add-ADGroupMember -Identity "GR_$($ou.Parent)" -Members "GS_$($ou.Name)"
    }

    If ($csv.IndexOf($ou) -eq 0) {
    	New-Item "$DirRoot\$NameRoot" -Type Directory
    } ElseIf ($ou.Parent -eq "") {
    	New-Item "$DirRoot\$($ou.Name)" -Type Directory
    } Else {
    	New-Item "$DirRoot\$($ou.Parent)\$($ou.Name)" -Type Directory
    }
}

Write-Host "$($(Get-ADOrganizationalUnit -Filter *).Count) Organizational Units added."
