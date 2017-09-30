<#
.SYNOPSIS
    Creates certificats to signing scripts.
    PowerSploit Function: Create-Cert
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Create-Cert creates certificats to signing scripts.

.NOTES
    To use create certificats, you need to install `makecert` from
    Windows SDK (or Visual Studio).

    Link: https://developer.microsoft.com/en-US/windows/downloads/windows-10-sdk

    Tutorial: https://www.darkoperator.com/blog/2013/3/5/powershell-basics-execution-policy-part-1.html
#>

Add-WindowsFeature AD-Certificat `
# Set-ExecutionPolicy AllSigned `

# Download Windows SDK
(Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/p/?linkid=845298").Links.Href

# Install the Windows SDK
.\winsdksetup.exe

# Create a self-signed certificate.
Set-Location "C:\Program Files (x86)\Windows Kits\10\bin\10.0.15063.0\x86"
.\makecert.exe -n "CN=Powershell Local Certificate Root" -a sha1 `
  -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr localMachine
.\makecert.exe -pe -n "CN=Server PowerShell CSC" -ss MY -a sha1 `
  -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer

# Now, you can sign your scripts like the following:
# $acert =(dir Cert:\CurrentUser\My -CodeSigningCert)[0]
# Set-AuthenticodeSignature .\foo.ps1 -Certificate $acert
