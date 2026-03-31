#!/bin/bash

# KN06 MicroK8s Setup Script
# Führe dies auf JEDER der 3 EC2 Instanzen aus

echo "=== KN06 MicroK8s Installation ==="

# 1. System Update
echo "[1/4] System update..."
sudo apt update && sudo apt upgrade -y

# 2. Snapd und MicroK8s installieren
echo "[2/4] Snapd und MicroK8s installieren..."
sudo apt install -y snapd
sudo systemctl enable --now snapd.seeded.service
sudo snap install microk8s --classic

# 3. User zur microk8s Gruppe hinzufügen
echo "[3/4] User konfigurieren..."
sudo usermod -aG microk8s $USER

# 4. Status prüfen
echo "[4/4] Status prüfen..."
echo ""
echo "Bitte jetzt neu einloggen oder: newgrp microk8s"
echo ""
microk8s status