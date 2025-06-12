#!/bin/bash
# Script de base pour créer une VM Windows 10 avec passthrough GPU/audio
# Nécessite libvirt/virt-install et une machine hôte compatible IOMMU.

set -e

# Variables à personnaliser
VM_NAME="win10-gaming"
RAM_MB=8192
VCPUS=4
DISK_SIZE=60  # en Go
ISO_PATH="/chemin/vers/windows10.iso"
GPU_PCI="0000:03:00.0"     # Adresse PCI de la carte graphique 6950 XT
GPU_AUDIO_PCI="0000:03:00.1" # Adresse PCI de l'audio HDMI de la carte
DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"

# Création du disque si absent
if [ ! -f "$DISK_PATH" ]; then
    qemu-img create -f qcow2 "$DISK_PATH" ${DISK_SIZE}G
fi

virt-install \ 
  --name "$VM_NAME" \ 
  --memory $RAM_MB \ 
  --vcpus $VCPUS \ 
  --cpu host,kvm=on \ 
  --os-type windows \ 
  --os-variant win10 \ 
  --cdrom "$ISO_PATH" \ 
  --disk path="$DISK_PATH",format=qcow2 \ 
  --features hyperv_relaxed=on,hyperv_vapic=on,hyperv_spinlocks=on \ 
  --host-device "$GPU_PCI" \ 
  --host-device "$GPU_AUDIO_PCI" \ 
  --soundhw hda \ 
  --network network=default,model=virtio \ 
  --graphics none \ 
  --boot uefi \ 
  --video none

# Pour se connecter :
# virsh start $VM_NAME
# virsh console $VM_NAME
# ou utiliser un client SPICE/VNC si défini.
