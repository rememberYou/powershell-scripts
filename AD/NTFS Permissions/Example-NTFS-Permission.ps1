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

.NOTES
    You can verify NTFS permissions with:
    `Get-Acl "C:\path-to-folder" | Format-List`
#>

Import-Module .\Conf-NTFS-Permission.ps1

If (!(Get-SMBShare -Name "Share" -ea 0)) {
    New-SMBShare -Name "Share" -Path "C:\Shared"
}

$acl = Get-Acl "C:\Shared"
$acl.SetAccessRuleProtection($False, $True)

# Everyone from the "GR_Ressources_Humaines" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Ressources_Humaines" `
  -Shared "C:\Shared\Ressources Humaines\Recrutement" -Permission "R"

# Heads of "Gestion du personnel" and "Recrutement" groups has Read/Write
# permission on "Ressources humaines" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ta.DUPONT" `
  -Shared "C:\Shared\Ressources Humaines" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ca.LECLERCQ" `
  -Shared "C:\Shared\Ressources Humaines" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Gestion_du_Personnel" `
  -Shared "C:\Shared\Ressources Humaines\Gestion du Personnel" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Recrutement" `
  -Shared "C:\Shared\Ressources Humaines\Recrutement" -Permission "R/W"

# The direction group has Read/Write permission on all folders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Direction" `
  -Shared "C:\Shared\" -Permission "R/W"

# By default, all users got Read permissions on the common shared folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Users" `
  -Shared "C:\Shared\Common\" -Permission "R"

# Heads of departments has Read/Write permission on the common folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Te.LAECKE",
                                     "Al.OMEY",
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
