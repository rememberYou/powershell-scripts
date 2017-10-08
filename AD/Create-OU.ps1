<#
.SYNOPSIS
    Creates Organizational Units according to a ".csv" file.
    PowerSploit Function: Create-OU
    Author: Terencio Agozzino (@rememberYou)
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

New-Item "C:\shared\Common" -Type Directory

Import-Module ActiveDirectory

Try {
    $csv = Import-Csv -Encoding "UTF8" -Path "$File" -Header Name,Parent
} Catch {
    Write-Host "Can't load the file: $file" -Foreground Red
    exit
}

foreach ($ou in $csv) {

    If ($csv.IndexOf($ou) -eq 0) {
        $DirRoot = "C:\shared\$($ou.Name)"
        $NameRoot = $ou.Name
    }

    If ($ou.Parent -ne $NameRoot -and $ou.Parent -ne "") {
        $Path = "OU=$($ou.Parent),OU=$NameRoot,DC=heh,DC=lan"
    } ElseIf ($ou.Parent -eq $NameRoot) {
        $Path = "OU=$($ou.Parent),DC=heh,DC=lan"
    } Else {
        $Path = "DC=heh,DC=lan"
    }

    New-ADOrganizationalUnit -Name $ou.Name -Path $Path `
      -Description "$($ou.Name) Organizational Unit"
    New-ADGroup "$($ou.Name)" -Path "OU=$($ou.Name),$Path" `
      -Description "$($ou.Name) Group" -GroupScope DomainLocal

    If ($ou.Parent -ne "") {
    	Add-ADGroupMember -Identity "$($ou.Parent)" -Members "$($ou.Name)"
    }

    If ($csv.IndexOf($ou) -eq 0) {
    	New-Item "$DirRoot" -Type Directory
    } ElseIf ($ou.Parent -ne $NameRoot) {
    	New-Item "$DirRoot\$($ou.Parent)\$($ou.Name)" -Type Directory
    } Else {
    	New-Item "$DirRoot\$($ou.Name)" -Type Directory
    }
}

Write-Host "$($(Get-ADOrganizationalUnit -Filter *).count) Organizational Units added."
