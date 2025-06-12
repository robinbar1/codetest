Set-StrictMode -Version Latest

# Lint shell scripts if bash is available
$bash = Get-Command bash -ErrorAction SilentlyContinue
if ($bash) {
    Get-ChildItem -Path "scripts" -Filter "*.sh" -File | ForEach-Object {
        & $bash.Path -n $_.FullName
    }
} else {
    Write-Warning "bash not available; skipping shell script lint"
}

# Validate PowerShell script syntax
$deployScript = Join-Path $PSScriptRoot 'deploy_windows10_vm.ps1'
try {
    [System.Management.Automation.Language.Parser]::ParseFile($deployScript,[ref]$null,[ref]$null) | Out-Null
} catch {
    Write-Error "Syntax error in deploy_windows10_vm.ps1"
    exit 1
}

