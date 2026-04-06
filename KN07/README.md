# KN07 - Kubernetes II

## Teil A: Begriffe und Konzepte

Die Erklärungen zu den Begriffen befinden sich in [teil_a.md](./teil_a.md).

---

## Teil B: Demo Projekt

### Übersicht

Dieses Projekt部署 eine Web-Anwendung (Mongo Express) mit einer MongoDB Datenbank auf einem Kubernetes Cluster.

### Verwendete Dateien

| Datei | Beschreibung |
|-------|---------------|
| `mongo-config.yaml` | ConfigMap mit MongoDB URL |
| `mongo-deployment.yaml` | Deployment für MongoDB |
| `mongo-service.yaml` | Service für MongoDB (ClusterIP) |
| `webapp-deployment.yaml` | Deployment für Web-App |
| `webapp-service.yaml` | Service für Web-App (NodePort) |

### Deployment

Alle Manifeste anwenden:

```bash
kubectl apply -f mongo-config.yaml
kubectl apply -f mongo-deployment.yaml
kubectl apply -f mongo-service.yaml
kubectl apply -f webapp-deployment.yaml
kubectl apply -f webapp-service.yaml
```

---

### Fragen und Antworten

#### 1. Konzeptuelle Abweichung

**Frage**: Welchen Teil haben Sie anders umgesetzt als im Tutorial erklärt?

**Antwort**: Die MongoDB wurde als Deployment statt als StatefulSet umgesetzt. Für dieses Demo-Projekt ist dies akzeptabel, da keine persistenten Volumes benötigt werden. Für produktive Datenbanken sollte jedoch ein StatefulSet mit persistentem Storage verwendet werden.

---

#### 2. MongoUrl in ConfigMap

**Frage**: Wieso ist der Wert `mongo-service` korrekt?

**Antwort**: Kubernetes verfügt über einen internen DNS (CoreDNS). Der Name `mongo-service` wird automatisch in die Cluster-IP des MongoDB-Services aufgelöst. Die Web-App kann dadurch den Datenbank-Service über diesen DNS-Namen erreichen.

---

#### 3. Service Webapp Screenshots

**Befehl**:
```bash
microk8s kubectl describe service webapp-service
```

**Screenshots**: [images/webapp-service-node1.png](images/webapp-service-node1.png), [images/webapp-service-node2.png](images/webapp-service-node2.png)

---

#### 4. Unterschiede mongo-service vs webapp-service

**Befehl**:
```bash
microk8s kubectl describe service mongo-service
```

**Screenshots**: [images/mongo-service.png](images/mongo-service.png)

**Unterschied**:
- `mongo-service`: Typ ClusterIP (nur intern erreichbar, Port 27017)
- `webapp-service`: Typ NodePort (extern erreichbar, NodePort 30100)

---

#### 5. Web-App aufrufen

**URL**: `http://<NODE_IP>:30100`

**Screenshots**: 
- [images/webapp-browser-node1.png](images/webapp-browser-node1.png)
- [images/webapp-browser-node2.png](images/webapp-browser-node2.png)

**Erklärung**: Die Web-App ist über den NodePort 30100 auf jedem Node des Clusters erreichbar. Kubernetes leitet die Anfragen automatisch zum richtigen Pod.

---

#### 6. MongoDB Compass Verbindung

**Frage**: Wieso geht die Verbindung nicht?

**Antwort**: Der mongo-service ist vom Typ ClusterIP und daher nur intern erreichbar. Von aussen ist kein Zugriff möglich. Um MongoDB Compass zu verwenden, müsste der Service auf LoadBalancer oder NodePort geändert werden.

---

#### 7. Update: Port 32000 und 3 Replicas

**Änderungen in webapp-service.yaml**:
- `nodePort`: 30100 → 32000
- `replicas`: 1 → 3 (im Deployment)

**Anwenden**:
```bash
kubectl apply -f webapp-service.yaml
kubectl apply -f webapp-deployment.yaml
```

**Screenshots**:
- [images/webapp-updated.png](images/webapp-updated.png)
- [images/webapp-service-updated.png](images/webapp-service-updated.png)

**Erklärung**: Nach dem Update sind unter `Endpoints` drei IP-Adressen ersichtlich, was zeigt, dass der Traffic auf alle 3 Replicas verteilt wird.
