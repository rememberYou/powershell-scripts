$Acl = Get-Acl "C:\shared\"

$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("user", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

$Acl.SetAccessRule($Ar)
Set-Acl "C:\shared\" $Acl
