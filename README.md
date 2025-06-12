# Mise en place d'une VM Windows 10 avec passthrough GPU

Ce dépôt fournit des scripts de base pour déployer automatiquement une machine virtuelle Windows 10 orientée jeu vidéo. L'objectif est de partager la carte graphique AMD 6950 XT de l'hôte et d'assurer la compatibilité audio.

## Prérequis
- Hôte Linux avec KVM et IOMMU activé (Intel VT-d ou AMD-Vi).
- `libvirt` et `virt-install` installés.
- ISO d'installation de Windows 10.
- Adresses PCI du GPU et de son périphérique audio.

## Déploiement
1. Personnaliser les variables dans `scripts/deploy_windows10_vm.sh` (chemin de l'ISO, adresse PCI du GPU, quantité de RAM, etc.).
2. Exécuter le script en tant que root :
   ```bash
   sudo bash scripts/deploy_windows10_vm.sh
   ```
3. Suivre l'installation classique de Windows 10 dans la VM.
4. Après installation, exécuter le script `guest/windows_setup.ps1` dans la VM pour installer Steam et Parsec et nettoyer certaines applications.

## Notes supplémentaires
- Vérifiez que votre système supporte bien le passthrough PCI (IOMMU actif, GPU réservé à la VM…).
- Les performances et la latence dépendent fortement des pilotes et de la configuration réseau pour Parsec.
- Le script `guest/windows_setup.ps1` installe aussi automatiquement les pilotes GPU AMD.

## Tests
Un script `scripts/test_scripts.sh` permet de vérifier rapidement la syntaxe des autres scripts du dépôt.

```bash
./scripts/test_scripts.sh
```

Il utilise `bash -n` et, si disponible, `pwsh` pour valider le script PowerShell.
