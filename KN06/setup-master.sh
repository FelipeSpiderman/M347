#!/bin/bash

# KN06 Cluster Setup - Master Node Script
# Führe dies NUR auf der ersten EC2 Instanz (Master) aus

echo "=== KN06 Master Node Setup ==="

# Prüfen ob MicroK8s installiert ist
if ! command -v microk8s &> /dev/null; then
    echo "Fehler: MicroK8s nicht installiert!"
    echo "Bitte zuerst install-microk8s.sh ausführen"
    exit 1
fi

# Cluster-Status prüfen
echo "[1/3] Warte auf MicroK8s ready..."
sleep 10
microk8s status --wait-ready

# Token generieren
echo ""
echo "[2/3] Token für Worker generieren:"
echo "Führe folgenden Befehl auf Workern aus:"
echo ""
microk8s add-node
echo ""

echo "[3/3] Aktuelle Nodes anzeigen:"
microk8s kubectl get nodes