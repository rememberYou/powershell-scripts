New-SMBShare -Name "Share" -Path "C:\Shared"

Get-Acl C:\Shared | Format-List

$acl = Get-Acl C:\Shared
$acl.SetAccessRuleProtection($True, $False)

# Shared
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("GS_Direction",
								      "Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","Read",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl C:\Shared $acl

# Common
$acl = Get-Acl C:\Shared\Common

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("T.LAECKE","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Al.OMEY","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Is.COLSON","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Do.GHYS","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Vi.DUFOUR","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("An.RENAUX","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("La.DEMARET","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Ro.SCHIFANO","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Iv.POGLAJEN","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Ni.BALEINE","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Xa.POLLARA","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Th.VIVIER","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Al.VICCA","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Ta.DUPONT","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Ca.LECLERCQ","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Ad.SOLITO","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Ji.MEYERS","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl C:\Shared\Common $acl
Get-Acl C:\Shared\Common | Format-List

# Ressources humaines
$acl = Get-Acl "C:\Shared\Ressources humaines"

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\GS_Recrutement","Read",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\GS_Gestion du personnel","Read",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\Ta.DUPONT","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\Ca.LECLERCQ","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl "C:\Shared\Ressources humaines" $acl
Get-Acl "C:\Shared\Ressources humaines" | Format-List

# Recrutement
$acl = Get-Acl "C:\Shared\Ressources humaines\Recrutement"

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\GS_Recrutement","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\GS_Gestion du personnel","Read",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl "C:\Shared\Ressources humaines\Recrutement" $acl
Get-Acl "C:\Shared\Ressources humaines\Recrutement" | Format-List

# Gestion du personnel
$acl = Get-Acl "C:\Shared\Ressources humaines\Gestion du personnel"

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\GS_Gestion du personnel","Read, Write",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("HEH\GS_Recrutement","Read",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl "C:\Shared\Ressources humaines\Gestion du personnel" $acl
Get-Acl "C:\Shared\Ressources humaines\Gestion du personnel" | Format-List
