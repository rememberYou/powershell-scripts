<#
.SYNOPSIS
    Creates certificates to signing scripts.
    PowerSploit Function: Create-Cert
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Create-Cert creates certificates to signing scripts.

.EXAMPLE
    PS C:\> Create-Cert

.NOTES
    To use create certificats, you need to install `makecert` from
    Windows SDK (or Visual Studio).

    For that, use the following command to download the last Windows SDK 10
    from a Windows client and send it to the server:

    (Invoke-WebRequest -Uri `
    "https://go.microsoft.com/fwlink/p/?linkid=845298").Links.Href

    Or you can still download it from the Microsoft website.

    Link: https://developer.microsoft.com/en-US/windows/downloads/windows-10-sdk

    If you want to create a SSL Certificate, you should use
    `New-SelfSignedCertificate` as `makecert` is depreciate for this.

    List all your certificates like this:
    `dir Cert:\CurrentUser\My -CodeSigningCert`

    After created your certificates, you can easily sign your script like
    the following:
    $cert =(dir Cert:\CurrentUser\My -CodeSigningCert)[0]
    Set-AuthenticodeSignature .\foo.ps1 -Certificate $cert

    To check if the script is well signed:
    `Get-AuthenticodeSignature .\foo.ps1 | ft -AutoSize`
#>

Add-WindowsFeature AD-Certificate

# Create a self-signed certificate.
$OldDestination = Get-Location
Set-Location "C:\Program Files (x86)\Windows Kits\10\bin\10.0.15063.0\x86"
.\makecert.exe -n "CN=Powershell Local Certificate Root" -a sha1 `
  -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr localMachine
.\makecert.exe -pe -n "CN=Server PowerShell CSC" -ss MY -a sha1 `
  -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer
Set-Location $OldDestination

Set-Location "C:\Program Files (x86)\Windows Kits\10\bin\10.0.15063.0\x86"
Write-Host 'New Certificate added in the "Cert:\CurrentUser\My"'
