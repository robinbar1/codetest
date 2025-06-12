#!/usr/bin/env bash

set -euo pipefail

# Lint shell scripts
for script in scripts/*.sh; do
  [ -f "$script" ] || continue
  bash -n "$script"
done

# If PowerShell is available, parse the PowerShell script to check syntax
if command -v pwsh >/dev/null 2>&1; then
  pwsh -NoProfile -Command "try { [System.Management.Automation.Language.Parser]::ParseFile('scripts/deploy_windows10_vm.ps1',[ref]\$null,[ref]\$null) | Out-Null } catch { exit 1 }"
elif command -v powershell >/dev/null 2>&1; then
  powershell -NoProfile -Command "try { [System.Management.Automation.Language.Parser]::ParseFile('scripts/deploy_windows10_vm.ps1',[ref]\$null,[ref]\$null) | Out-Null } catch { exit 1 }"
else
  echo "PowerShell not available; skipping deploy_windows10_vm.ps1 syntax check" >&2
fi

