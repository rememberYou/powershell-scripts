<#
.SYNOPSIS
    Installs the Active Directory service and sets a basic AD configuration.
    PowerSploit Function: Conf-AD
    Author: Terencio Agozzino (@rememberYou)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0
 
.DESCRIPTION
    Conf-AD Installs the Active Directory service and sets a AD configuration.

.EXAMPLE
    PS C:\> Conf-AD -DomainName heh.lan

.EXAMPLE
    PS C:\> Conf-AD -DomainName heh.lan -NetbiosName HEH-STUDENT

.NOTES
    You can verify your ADForest configuration with:
    `Get-ADForest`

    You can verify your ADDomain configuration with:
    `Get-ADDomain`
#>

Param(    
    [ValidateNotNullOrEmpty()]
    [String]
    $DomainName,
        
    [String]
    $NetbiosName
)

Function Get-NetbiosName($DomainName) {
    return $DomainName.Split(".")[0].ToUpper()
}

Import-Module Servermanager
Add-WindowsFeature AD-Domain-Services

Import-Module ADDSDeployment

If ([string]::IsNullOrEmpty($NetbiosName)) {
    Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Default" `
    -DomainName "$DomainName" `
    -DomainNetbiosName "$(Get-NetbiosName($DomainName))" `
    -ForestMode "Default" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true
} Else {
    Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Default" `
    -DomainName "$DomainName" `
    -DomainNetbiosName "$NetbiosName" `
    -ForestMode "Default" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true
}
