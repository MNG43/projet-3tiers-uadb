#!/bin/bash
set -e

# Configuration du dépôt (Vérifiez bien le nom : projet3tiers-uadb)
GITHUB_REPO="https://github.com/MNG43/projet3tiers-uadb.git"
REPO_NAME="projet3tiers-uadb"
VM_ROLE="$1"

if [ -z "$VM_ROLE" ]; then
    echo "Usage: $0 {webserver|database}"
    exit 1
fi

echo "=== Provisionnement de la VM $VM_ROLE ==="

# Mise à jour des dépôts
sudo apt update
sudo apt install -y git ansible python3-pip curl wget

# Nettoyage et récupération du code dans /opt
cd /opt
sudo rm -rf "$REPO_NAME"
sudo git clone "$GITHUB_REPO"
sudo chown -R $USER:$USER "$REPO_NAME"

# Déplacement dans le dossier Ansible
cd "/opt/$REPO_NAME/ansible"

# Lancement de la configuration Ansible selon le rôle
if [ "$VM_ROLE" = "webserver" ]; then
    ansible-playbook provision-vm2.yml -c local
elif [ "$VM_ROLE" = "database" ]; then
    ansible-playbook provision-vm3.yml -c local
fi

echo "=== Provisionnement terminé pour $VM_ROLE ==="
