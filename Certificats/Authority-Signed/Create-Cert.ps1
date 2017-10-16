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

Import-Module ServerManager
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools
Install-AdcsCertificationAuthority -CAType EnterpriseRootCa `
  -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
  -KeyLength 2048 -HashAlgorithmName SHA512 `
  -CACommonName "HEH-CA" -CADistinguishedNameSuffix "DC=heh,DC=lan" `
  -ValidityPeriod Years -ValidityPeriodUnits 3 -Force

Add-WindowsFeature Adcs-Web-Enrollment
Install-AdcsWebEnrollment -Force
Install-WindowsFeature Web-Mgmt-Console
