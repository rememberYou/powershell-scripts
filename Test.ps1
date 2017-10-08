New-SMBShare -Name "Share" -Path "C:\Shared"

Get-Acl C:\Shared | Format-List

$acl = Get-Acl C:\Shared
$acl.SetAccessRuleProtection($True, $True)

# Shared
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Direction",
								      "FullControl",
								      "ContainerIherxit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)



$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","Read",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)


# RH
$acl = Get-Acl C:\Shared\Ressources humaines

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("ag.mathieu","Modify",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("fl.alaert","Modify",
								      "ContainerInherit, ObjectInherit",
								      "None", "Allow")
$acl.AddAccessRule($rule)


$acl = Get-Acl C:\Shared:\Ressources humaines:\

Set-Acl C:\Shared $acl

Get-Acl C:\Shared | Format-List
