$domainname = "lv.asb-mv.de"
$servername = "files22.lv.asb-mv.de"
$NuGetInstalled = $null
$NuGetInstalled = "Get-PackageProvider | findstr NuGet"
$CredentialManagerInstalled = $null
$CredentialManagerInstalled = Get-InstalledModule -Name CredentialManager > $null

if ($NuGetInstalled -eq $null) {
Write-Host "NuGet ist nicht instaliert. Installiere..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
}
else {
Write-Host "NuGet ist installiert. Installation wird übersprungen.."
}

if ($CredentialManagerInstalled -eq $null) {
Write-Host "CredentialManager ist nicht installiert. Installiere.."
Try {
Install-Module CredentialManager -Force -SkipPublisherCheck -Scope CurrentUser -Confirm:$False
}
#maybe nuget needs a restart of powershell
catch {
Write-Host "CredentailManager Install failed. Trying again.."
start powershell $PSCommandPath
exit
}
Import-Module CredentialManager 
}
else {
Write-Host "CredentialManager ist installiert. Installation wird übersprungen.."
}

$PW = $null
Write-Host "Damit die Netzlaufwerke der ASB Umgebung angebunden werden können, ist eine Authentifizierung mit Ihrem ASB Nutzer erforderlich."

$PW = Get-Credential -Message "Damit die Netzlaufwerke der ASB Umgebung angebunden werden können, ist eine Authentifizierung mit Ihrem ASB Nutzer erforderlich." -User "$domainname\"
if ($PW -eq $null) {
    exit
}
New-StoredCredential -Credentials $PW -Target $servername -Type DomainPassword -Persist Enterprise
gpupdate
