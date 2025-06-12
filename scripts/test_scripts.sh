#!/bin/bash
# Vérifie la syntaxe des scripts Bash et PowerShell du dépôt.

set -e

echo "Checking deploy_windows10_vm.sh syntax..."
bash -n "$(dirname "$0")/deploy_windows10_vm.sh"
echo "OK"

if command -v pwsh >/dev/null 2>&1; then
    echo "Checking windows_setup.ps1 syntax..."
    pwsh -NoProfile -Command "try { [System.Management.Automation.Language.Parser]::ParseFile('guest/windows_setup.ps1',[ref]null,[ref]null) | Out-Null } catch { exit 1 }"
    echo "OK"
else
    echo "PowerShell n'est pas disponible, test ignoré pour windows_setup.ps1"
fi
