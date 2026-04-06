# KN07 - Kubernetes II

## Teil A: Begriffe und Konzepte

### 1. Unterschied zwischen Pods und Replicas

**Pod**: Ein Pod ist die kleinste deploybare Einheit in Kubernetes. Er repräsentiert eine einzelne Instanz einer laufenden Anwendung und kann einen oder mehrere Container enthalten, die sich Speichervolumes und eine IP-Adresse teilen.

**Replica**: Ein Replica ist eine identische Kopie eines Pods. Durch Replicas wird die Anwendung skaliert und hochverfügbar gemacht. Wenn ein Pod ausfällt, sorgt Kubernetes dafür, dass ein neues Replica gestartet wird.

---

### 2. Unterschied zwischen Service und Deployment

**Deployment**: Ein Deployment verwaltet den Lebenszyklus der Pods. Es definiert den gewünschten Zustand (Anzahl Replicas, Container-Image, etc.) und sorgt dafür, dass dieser Zustand immer erreicht wird. Es handhabt auch Updates und Rollbacks.

**Service**: Ein Service ist eine Abstraktion, die eine permanente Netzwerkadresse (IP oder DNS-Name) für eine Gruppe von Pods bereitstellt. Da Pods dynamisch erstellt und gelöscht werden können (und dabei ihre IPs ändern), stellt der Service einen stabilen Zugriffspunkt bereit.

---

### 3. Welches Problem löst Ingress?

Ingress löst das Problem des externen Zugriffs auf Services im Cluster. Traditionell musste für jeden Service ein separater LoadBalancer oder NodePort eingerichtet werden. Ingress bietet einen zentralen Eintrittspunkt (typischerweise Port 80/443) und leitet Traffic basierend auf Domain oder Pfad an die internen Services weiter.

---

### 4. Für was ist ein StatefulSet? (Beispiel ohne Datenbank)

Ein StatefulSet ist ähnlich wie ein Deployment, vergibt aber jedem Pod eine stabile, persistente Identität (z.B. `name-0`, `name-1`). Es garantiert:
- Bestimmte Reihenfolge beim Starten/Stoppen
- Stabiles Netzwerk-Identity
- Persistentes Storage

**Beispiel**: Eine Message-Queue Infrastruktur wie Apache Kafka oder RabbitMQ. Diese Systeme benötigen stabile Netzwerkidentitäten und persistente lokale Speicher für die Nachrichten queues.
