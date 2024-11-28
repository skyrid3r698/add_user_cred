$nuget = $null
$nuget = Get-PackageProvider | findstr NuGet
if ($nuget -eq $null) {
Write-Host "NuGet ist nicht instaliert. Installiere..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
}
else {
Write-Host "NuGet ist installiert. Installation wird übersprungen.."
}

if ((Get-InstalledModule -Name CredentialManager) -eq $null) {
Write-Host "CredentialManager ist nicht installiert. Installiere.."
Install-Module CredentialManager -Force -SkipPublisherCheck -Scope CurrentUser -Confirm:$False
Import-Module CredentialManager 
}
else {
Write-Host "CredentialManager ist installiert. Installation wird übersprungen.."
}

$PW = $null
Write-Host "Damit die Netzlaufwerke der ASB Umgebung angebunden werden können, ist eine Authentifizierung mit Ihrem ASB Nutzer erforderlich."

$PW = Get-Credential -Message "Damit die Netzlaufwerke der ASB Umgebung angebunden werden können, ist eine Authentifizierung mit Ihrem ASB Nutzer erforderlich." -User lv.asb-mv.de\
if ($PW -eq $null) {
    exit
}
New-StoredCredential -Credentials $PW -Target files22.lv.asb-mv.de -Type DomainPassword -Persist Enterprise
gpupdate
