# Script PowerShell à exécuter dans la VM pour installer Steam et Parsec
# et désinstaller certaines applications Microsoft inutiles.

# Installation de winget si nécessaire
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Output "Winget n'est pas disponible. Installez 'App Installer' depuis le Microsoft Store."
}

# Mettre à jour la base de données winget
winget source update

# Installer Steam et Parsec
winget install -e --id Valve.Steam
winget install -e --id Parsec.Parsec

# Installer les pilotes GPU AMD
winget install -e --id AMD.AMDSoftwareCloudEdition

# Quelques réglages pour la latence
reg add "HKCU\Software\Microsoft\GameBar" /v UseGameMode /t REG_DWORD /d 1 /f

# Désinstallation de certaines applications par défaut
$removeApps = @(
    "Microsoft.BingWeather",
    "Microsoft.Getstarted",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)
foreach ($app in $removeApps) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
}

# Désactivation de la télémétrie basique
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
