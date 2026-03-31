#!/bin/bash

# KN06 Cluster Setup - Worker Node Script
# Führe dies auf Worker Node 2 und 3 aus
# Usage: ./setup-worker.sh <master-ip>:<port>/<token>

if [ -z "$1" ]; then
    echo "Usage: $0 <join-token>"
    echo ""
    echo "Beispiel:"
    echo "  ./setup-worker.sh 172.31.16.1:25000/abc123def456789..."
    exit 1
fi

echo "=== KN06 Worker Node Setup ==="

# Prüfen ob MicroK8s installiert ist
if ! command -v microk8s &> /dev/null; then
    echo "Fehler: MicroK8s nicht installiert!"
    echo "Bitte zuerst install-microk8s.sh ausführen"
    exit 1
fi

# Node zum Cluster hinzufügen als Worker
echo "[1/1] Node zum Cluster hinzufügen als Worker..."
microk8s join $1 --worker

echo ""
echo "Warte auf Registration..."
sleep 15

echo ""
echo "Nodes im Cluster:"
microk8s kubectl get nodes