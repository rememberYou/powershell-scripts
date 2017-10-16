<#
.SYNOPSIS
    Creates authority-signed certificates to signing scripts.
    PowerSploit Function: Create-Cert
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Create-AuthorityCert creates authority-signed certificates to signing scripts.

.EXAMPLE
    PS C:\> Create-AuthorityCert

.NOTES
    Navigate to http://<IP of your server>/certsvr to request a certificate
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
