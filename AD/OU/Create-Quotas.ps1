<#
.SYNOPSIS
    Creates the quotas for all departments' shared folder.
    PowerSploit Function: Create-Quotas
    Author: Terencio Agozzino (@rememberYou)
            Alexandre Ducobu (@Harchytekt)
    License: None
    Required Dependencies: None
    Optional Dependencies: None
    Version: 1.0.0

.DESCRIPTION
    Create-Quotas Creates the quotas for all departments' shared folder.
#>

Install-WindowsFeature -Name FS-Resource-Manager, RSAT-FSRM-Mgmt

# Create Templates
New-FsrmQuotaTemplate -Name "500 MB limit" -Description "limit usage to 500 MB." -Size 500MB

# Apply template to the Shared Folder

# Initialize the managers' email addresses
$ofs = ';'
$comm = "al.omey@heh.lan", "t.laecke@heh.lan"
$fin = "is.colson@heh.lan", "do.ghys@heh.lan"
$info = "vi.dufour@heh.lan", "an.renaux@heh.lan", "la.demaret@heh.lan"
$mark = "ro.schifano@heh.lan", "iv.poglajen@heh.lan", "ni.baleine@heh.lan", "xa.pollara@heh.lan"
$rd = "th.vivier@heh.lan", "al.vicca@heh.lan"
$rh = "ca.leclercq@heh.lan", "ca.leclercq@heh.lan"
$tech = "ad.solito@heh.lan", "ji.meyers@heh.lan"

# Set the mail address(es) for the chosen folder
Function SetMail ($folder)
{
    If ($folder -eq "Commerciaux")
    {
        $mail = [string]$comm
    }
    ElseIf ($folder -eq "Commerciaux\Sédentaires")
    {
        $mail = $comm[0]
    }
    ElseIf ($folder -eq "Commerciaux\Technico")
    {
        $mail = $comm[1]
    }
    ElseIf ($folder -eq "Common")
    {
        $mail = [string]([string]$comm, [string]$fin, [string]$info, [string]$mark, [string]$rd, [string]$rh, [string]$tech, "po.botson@heh.lan")
    }
    ElseIf ($folder -eq "Direction")
    {
        $mail = "po.botson@heh.lan"
    }
    ElseIf ($folder -eq "Finances")
    {
        $mail = [string]$fin
    }
    ElseIf ($folder -eq "Finances\Comptabilité")
    {
        $mail = $fin[0]
    }
    ElseIf ($folder -eq "Finances\Investissements")
    {
        $mail = $fin[1]
    }
    ElseIf ($folder -eq "Informatique")
    {
        $mail = [string]$info
    }
    ElseIf ($folder -eq "Informatique\Développement")
    {
        $mail = $info[0]
    }
    ElseIf ($folder -eq "Informatique\HotLine")
    {
        $mail = $info[1]
    }
    ElseIf ($folder -eq "Informatique\Systèmes")
    {
        $mail = $info[2]
    }
    ElseIf ($folder -eq "Marketing")
    {
        $mail = [string]$mark
    }
    ElseIf ($folder -eq "Marketing\Site1")
    {
        $mail = $mark[0]
    }
    ElseIf ($folder -eq "Marketing\Site2")
    {
        $mail = $mark[1]
    }
    ElseIf ($folder -eq "Marketing\Site3")
    {
        $mail = $mark[2]
    }
    ElseIf ($folder -eq "Marketing\Site4")
    {
        $mail = $mark[3]
    }
    ElseIf ($folder -eq "R&D")
    {
        $mail = [string]$rd
    }
    ElseIf ($folder -eq "R&D\Recherche")
    {
        $mail = $rd[0]
    }
    ElseIf ($folder -eq "R&D\Testing")
    {
        $mail = $rd[1]
    }
    ElseIf ($folder -eq "Ressources humaines")
    {
        $mail = [string]$rh
    }
    ElseIf ($folder -eq "Ressources humaines\Gestion du personnel")
    {
        $mail = $rh[0]
    }
    ElseIf ($folder -eq "Ressources humaines\Recrutement")
    {
        $mail = $rh[1]
    }
    ElseIf ($folder -eq "Technique")
    {
        $mail = [string]$tech
    }
    ElseIf ($folder -eq "Technique\Achat")
    {
        $mail = $tech[0]
    }
    Else {
        $mail = $tech[1]
    }
    return $mail
}

# Set the quotas and threshold alerts for the chosen folder
Function SetQuota($folder, $limit)
{
    $mail = SetMail -folder $folder
    $mailAction = New-FsrmAction Email -MailTo $mail -Subject "Warning: Approaching storage limit" -Body "The users are about to reach the end of the available storage in the $folder folder ($limit%)."
    $logAction = New-FsrmAction Event -EventType Information -Body "The $folder folder is mostly full ($limit%)." -RunLimitInterval 60
    $80Threshold = New-FsrmQuotaThreshold -Percentage 80 -Action $mailAction
    $90Threshold = New-FsrmQuotaThreshold -Percentage 90 -Action $mailAction,$logAction
    $100Threshold = New-FsrmQuotaThreshold -Percentage 100 -Action $mailAction,$logAction
    New-FsrmQuota -Path "C:\Shared\$folder" -Template "$limit MB limit" -Threshold $80Threshold,$90Threshold,$100Threshold
}

$Departments = gci -Directory "C:\Shared" | select name

ForEach($folder in $Departments)
{
    $currentFolder = $folder.Name
    SetQuota -folder $currentFolder -limit 500
    if ($currentFolder -ne "Common") {
        $subDepartments = gci -Directory "C:\Shared\$currentFolder" | select name
        ForEach ($folder in $subDepartments)
        {
            $currentSubFolder = $folder.Name
            SetQuota -folder "$currentFolder\$currentSubFolder" -limit 100
        }
    }
}
