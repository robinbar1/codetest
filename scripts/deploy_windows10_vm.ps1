# Windows 10 VM deployment using Hyper-V
# Requires Hyper-V enabled with Discrete Device Assignment (DDA) for GPU passthrough
# The script expects environment variables defined by the Bash deployment script:
#   $Env:VM_NAME    - name of the virtual machine
#   $Env:ISO_PATH   - path to the Windows 10 ISO
#   $Env:RAM_GB     - amount of RAM to allocate (in gigabytes)
#   $Env:VHD_PATH   - path to the virtual hard disk (VHDX)
#   $Env:GPU_PCI_ID - PCI location string for the GPU to assign
#
# Example usage:
#   $Env:VM_NAME="win10"; $Env:ISO_PATH="C:\\isos\\Win10.iso"; \
#   $Env:RAM_GB=8; $Env:VHD_PATH="C:\\vms\\win10.vhdx"; \
#   $Env:GPU_PCI_ID="PCIROOT(0)#PCI(1D00)#PCI(0000)"; \
#   ./scripts/deploy_windows10_vm.ps1

param(
    [string]$VmName = $Env:VM_NAME,
    [string]$IsoPath = $Env:ISO_PATH,
    [int]$RamGB = [int]$Env:RAM_GB,
    [string]$VhdPath = $Env:VHD_PATH,
    [string]$GpuPciId = $Env:GPU_PCI_ID
)

if (-not $VmName -or -not $IsoPath -or -not $RamGB -or -not $VhdPath) {
    Write-Host "Required environment variables are missing." -ForegroundColor Red
    Write-Host "VM_NAME, ISO_PATH, RAM_GB and VHD_PATH must be set." -ForegroundColor Red
    exit 1
}

# Create VM
New-VM -Name $VmName -MemoryStartupBytes (${RamGB}GB) -Generation 2 -VHDPath $VhdPath -SwitchName "Default Switch" | Out-Null

# Add DVD drive with installation ISO
Add-VMDvdDrive -VMName $VmName -Path $IsoPath

# Enable Secure Boot for Windows
Set-VMFirmware -VMName $VmName -EnableSecureBoot On

# If GPU PCI ID provided, configure DDA
if ($GpuPciId) {
    # Disable the device in host
    Disable-PnpDevice -InstanceId $GpuPciId -Confirm:$false

    # Dismount from host and assign to VM
    Dismount-VmHostAssignableDevice -LocationPath $GpuPciId
    Add-VMAssignableDevice -LocationPath $GpuPciId -VMName $VmName
}

Write-Host "VM '$VmName' created." -ForegroundColor Green

