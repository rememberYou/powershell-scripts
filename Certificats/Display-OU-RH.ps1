<#
.SYNOPSIS
    Useless script to test the self-signed certificate by displaying users from RH
    PowerSploit Function: Display-OU-RH
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Display-OU-RH is an useless script to test the self-signed certificate by
    displaying users from RH.

.EXAMPLE
    PS C:\> Display-OU-Rh

.NOTES
    Don't forget to first create your certificate with `Create-Cert`
    and sign your script like shown below:

    $cert =(dir Cert:\CurrentUser\My -CodeSigningCert)[0]
    Set-AuthenticodeSignature .\foo.ps1 -Certificate $cert

    To check if the script is well signed:
    `Get-AuthenticodeSignature .\foo.ps1 | ft -AutoSize`
#>

Get-ADUser -Filter * -SearchBase "OU=Ressources Humaines,DC=heh,DC=lan" | Select samaccountname
