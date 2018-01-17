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
    Be careful, for this example some of the groups contains accents because
    of french typing. If you use PowerShell ISE, it going to have some errors
    if you forgot configure it with UTF-8.

    You can verify NTFS permissions with:
    `Get-Acl "C:\path-to-folder" | Format-List`
#>

Import-Module .\Conf-NTFS-Permission.ps1

If (!(Get-SMBShare -Name "Share" -ea 0)) {
    New-SMBShare -Name "Share" -Path "C:\Shared"
}

# Everyone from the "GR_Ressources_Humaines" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Ressources_Humaines" `
  -Shared "C:\Shared\Ressources Humaines" -Permission "R"

$acl = Get-Acl "C:\Shared"
$acl.SetAccessRuleProtection($True, $True)
Set-Acl -Path "C:\Shared" -AclObject $acl

# [ RESSOURCES HUMAINES ]

# Everyone from the "GR_Ressources_Humaines" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Ressources_Humaines" `
  -Shared "C:\Shared\Ressources Humaines" -Permission "R"

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

# [ R&D ]

# Everyone from the "GR_R&D" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_R&D" `
  -Shared "C:\Shared\R&D" -Permission "R"

# Heads of "Recherche" and "Testing" groups has Read/Write
# permission on "R&D" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Th.VIVIER" `
  -Shared "C:\Shared\R&D" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Al.VICCA" `
  -Shared "C:\Shared\R&D" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Recherche" `
  -Shared "C:\Shared\R&D\Recherche" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Testing" `
  -Shared "C:\Shared\R&D\Testing" -Permission "R/W"

# [ MARKETING ]

# Everyone from the "GR_Marketing" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Marketing" `
  -Shared "C:\Shared\Marketing" -Permission "R"

# Heads of "Site 1", "Site 2", "Site 3" and "Site 4" groups has Read/Write
# permission on "Marketing" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ro.SCHIFANO" `
  -Shared "C:\Shared\Marketing" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Iv.POGLAJEN" `
  -Shared "C:\Shared\Marketing" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ni.BALEINE" `
  -Shared "C:\Shared\Marketing" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Xa.POLLARA" `
  -Shared "C:\Shared\Marketing" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Site1" `
  -Shared "C:\Shared\Marketing\Site1" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Site2" `
  -Shared "C:\Shared\Marketing\Site2" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Site3" `
  -Shared "C:\Shared\Marketing\Site3" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Site4" `
  -Shared "C:\Shared\Marketing\Site4" -Permission "R/W"

# [ FINANCES ]

# Everyone from the "GR_Finances" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Finances" `
  -Shared "C:\Shared\Finances" -Permission "R"

# Heads of "Comptabilité" and "Investissements" groups has Read/Write
# permission on "Finances" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Is.COLSON" `
  -Shared "C:\Shared\Finances" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Do.GHYS" `
  -Shared "C:\Shared\Finances" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Comptabilité" `
  -Shared "C:\Shared\Finances\Comptabilité" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Investissements" `
  -Shared "C:\Shared\Finances\Investissements" -Permission "R/W"

# [ TECHNIQUE ]

# Everyone from the "GR_Technique" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Technique" `
  -Shared "C:\Shared\Technique" -Permission "R"

# Heads of "Techniciens" and "Achat" groups has Read/Write
# permission on "Technique" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ad.SOLITO" `
  -Shared "C:\Shared\Technique" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Ji.MEYERS" `
  -Shared "C:\Shared\Technique" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Techniciens" `
  -Shared "C:\Shared\Technique\Techniciens" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Achat" `
  -Shared "C:\Shared\Technique\Achat" -Permission "R/W"

# [ INFORMATIQUE ]

# Everyone from the "GR_Informatique" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Informatique" `
  -Shared "C:\Shared\Informatique" -Permission "R"

# Heads of "Développement", "HotLine" and "Système' groups has Read/Write
# permission on "Informatique" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Vi.DUFOUR" `
  -Shared "C:\Shared\Informatique" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "An.RENAUX" `
  -Shared "C:\Shared\Informatique" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "La.DEMARET" `
  -Shared "C:\Shared\Informatique" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Systèmes" `
  -Shared "C:\Shared\Informatique\Systèmes" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Développement" `
  -Shared "C:\Shared\Informatique\Développement" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_HotLine" `
  -Shared "C:\Shared\Informatique\HotLine" -Permission "R/W"

# [ COMMERCIAUX ]

# Everyone from the "GR_Commerciaux" group can read the subfolders.
.\Conf-NTFS-Permission -Lan "HEH" -Users "GR_Commerciaux" `
  -Shared "C:\Shared\Commerciaux" -Permission "R"

# Heads of "Technico" and "Sédentaires" groups has Read/Write
# permission on "Technique" folder.
.\Conf-NTFS-Permission -Lan "HEH" -Users "Te.LAECKE" `
  -Shared "C:\Shared\Technique" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "Al.OMEY" `
  -Shared "C:\Shared\Technique" -Permission "R/W"

.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Sédentaires" `
  -Shared "C:\Shared\Commerciaux\Sédentaires" -Permission "R/W"
.\Conf-NTFS-Permission -Lan "HEH" -Users "GS_Technico" `
  -Shared "C:\Shared\Commerciaux\Technico" -Permission "R/W"

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
