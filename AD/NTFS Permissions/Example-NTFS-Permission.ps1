<#
.SYNOPSIS
    Gives an example of utilisation of the "Conf-NTFS-Permission" script.
    PowerSploit Function: Example-NTFS-Permission
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Example-NTFS-Permission Gives an example of utilisation of the
    "Conf-NTFS-Permission" script.

.EXAMPLE
    PS C:\> Conf-NTFS-Permission -Lan HEH -User Ca.LECLERCQ -Shared C:\Shared\Common -Permission R/W

.EXAMPLE
    PS C:\> Conf-NTFS-Permission -Lan "HEH" -Users [Ca.LECLERCQ, Ta.DUPONT] "C:\Shared\Common" -Permission "R/W"

.NOTES
    You can verify NTFS permissions with:
    `Get-Acl "C:\path-to-folder" | Format-List`
#>

#Import-Module .\Conf-NTFS-Permission.ps1

If (!(Get-SMBShare -Name "Share" -ea 0)) {
    New-SMBShare -Name "Share" -Path "C:\Shared"
}

$acl = Get-Acl "C:\Shared"
$acl.SetAccessRuleProtection($True, $False)

# By default, all users got Read permissions to the shared folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Users" `
  -Shared "C:\Shared\" -Permission "R"

# Heads of "Gestion du personnel" and "Recrutement" groups has Read/Write
# permission on "Ressources humaines" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ta.DUPONT" `
  -Shared "C:\Shared\Ressources_Humaines" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ca.LECLERCQ" `
  -Shared "C:\Shared\Ressources_Humaines" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Gestion_du_Personnel" `
  -Shared "C:\Shared\Ressources_Humaines\Gestion du Personnel" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Gestion_du_Personnel" `
  -Shared "C:\Shared\Ressources_Humaines\Recrutement" -Permission "R"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Recrutement" `
  -Shared "C:\Shared\Ressources_Humaines\Recrutement" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Recrutement" `
  -Shared "C:\Shared\Ressources_Humaines\Gestion du Personnel" -Permission "R"

# The direction group has Read/Write permission on all folders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Direction" `
  -Shared "C:\Shared\" -Permission "R/W"

# Heads of departments has Read/Write permission on the common folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "T.LAECKE",
                                     "Al.OMEY",
                                     "Al.DUCOBU",
                                     "Is.COLSON",
                                     "Do.GHYS",
                                     "Vi.DUFOUR",
                                     "An.RENAUX",
                                     "La.DEMARET",
                                     "Ro.SCHIFANO",
                                     "Iv.POGLAJEN",
                                     "Ni.BALEINE",
                                     "Xa.POLLARA",
                                     "Th.VIVIER",
                                     "Al.VICCA",
                                     "Ta.DUPONT",
                                     "Ca.LECLERCQ",
                                     "Ad.SOLITO",
                                     "Ji.MEYERS" `
  -Shared "C:\Shared\Common" -Permission "R/W"
