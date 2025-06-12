# codetest

This repository contains helper scripts for creating and testing virtual machines.

## Linux host deployment

Use the Bash script `scripts/deploy_vm.sh` (not included here) which defines common
variables such as `VM_NAME`, `ISO_PATH`, `RAM_GB`, `VHD_PATH` and `GPU_PCI_ID`.
These variables are consumed by both Linux and Windows deployment scripts.

## Windows host deployment

For Windows hosts with Hyper-V, run the PowerShell script:

```powershell
# Example environment setup
$Env:VM_NAME = "win10"
$Env:ISO_PATH = "C:\\isos\\Win10.iso"
$Env:RAM_GB = 8
$Env:VHD_PATH = "C:\\vms\\win10.vhdx"
$Env:GPU_PCI_ID = "PCIROOT(0)#PCI(1D00)#PCI(0000)"

./scripts/deploy_windows10_vm.ps1
```

The script provisions a Generation 2 VM and optionally assigns the GPU using
Discrete Device Assignment if `GPU_PCI_ID` is provided.

## Testing scripts

Run `scripts/test_scripts.sh` to lint the shell scripts and validate the
PowerShell syntax when a PowerShell executable is available.
