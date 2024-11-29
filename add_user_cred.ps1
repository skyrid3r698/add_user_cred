# Starting Transcript
$null = Start-Transcript -Append $env:TEMP\add_user_cred.txt
Write-Host $(Get-Date)"[INFO]Starte Logging nach $env:TEMP\add_user_cred-Log.txt"

$domainname = "lv.asb-mv.de"
$servername = "files22.lv.asb-mv.de"
$NuGetInstalled = $null
$NuGetInstalled = "Get-PackageProvider | findstr NuGet"
$CredentialManagerInstalled = Try {Get-InstalledModule -Name CredentialManager -ErrorAction SilentlyContinue} catch {$CredentialManagerInstalled = $null}

if ($NuGetInstalled -eq $null) {
Write-Host $(Get-Date)"[INFO]NuGet ist nicht instaliert. Installiere..."
Try {
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser -ErrorAction SilentlyContinue
}
catch {
Write-Host $(Get-Date)"[ERROR]Es ist ein Fehler während der Installation von NuGet aufgetreten. Prüfe das Log unter" -ForegroundColor Red
}
}
else {
Write-Host $(Get-Date)"[INFO]NuGet ist installiert. Installation wird Übersprungen.."
}

if ($CredentialManagerInstalled -eq $null) {
Write-Host $(Get-Date)"[INFO]CredentialManager ist nicht installiert. Installiere.."
Try {
Install-Module CredentialManager -Force -SkipPublisherCheck -Scope CurrentUser -Confirm:$False -ErrorAction SilentlyContinue
}
#maybe nuget needs a restart of powershell
catch {
Write-Host $(Get-Date)"[WARN]CredentailManager Install failed. Trying again.." -ForegroundColor Yellow
start powershell $PSCommandPath
exit
}
Import-Module CredentialManager 
}
else {
Write-Host $(Get-Date)"[INFO]CredentialManager ist installiert. Installation wird Übersprungen.."
}

$PW = $null
Write-Host $(Get-Date)"[INFO]Damit die Netzlaufwerke der ASB Umgebung angebunden werden können, ist eine Authentifizierung mit Ihrem ASB Nutzer erforderlich."

$PW = Get-Credential -Message "Damit die Netzlaufwerke der ASB Umgebung angebunden werden können, ist eine Authentifizierung mit Ihrem ASB Nutzer erforderlich." -User "$domainname\"
if ($PW -eq $null) {
    exit
}
New-StoredCredential -Credentials $PW -Target $servername -Type DomainPassword -Persist Enterprise
gpupdate
