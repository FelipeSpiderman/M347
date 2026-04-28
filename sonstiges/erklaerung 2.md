# KN05 - Arbeit mit Speicher: Erklärung

## Warum brauchen Container überhaupt Speicher?

Container sind von Natur aus **flüchtig** (ephemeral). Das bedeutet: Wenn ein Container gestoppt oder gelöscht wird, sind alle Daten die darin gespeichert wurden **weg**. Das ist ein Problem, wenn man z.B. eine Datenbank betreibt oder Konfigurationsdateien teilen möchte.

Docker löst das mit drei Speicherarten:
1. **Bind Mounts** – ein Ordner vom Host wird direkt in den Container eingehängt
2. **Named Volumes** – Docker verwaltet den Speicher selbst, mehrere Container können ihn teilen
3. **tmpfs** – temporärer Speicher nur im RAM, wird beim Stopp des Containers gelöscht

---

## A) Bind Mounts

### Was ist ein Bind Mount?

Ein Bind Mount verbindet einen **Ordner auf deinem Host-System** direkt mit einem **Ordner im Container**. Beide zeigen auf denselben Speicherort – Änderungen auf einer Seite sind sofort auf der anderen Seite sichtbar.

```
Host:      /Users/nwehrli/KN05/A/   ←→   Container: /scripts/
```

Das ist wie ein geteilter Ordner zwischen zwei Computern – nur dass der eine der Container ist.

### Wofür ist das nützlich?

Genau für den Fall, den wir simuliert haben: **Entwicklung**. Du arbeitest auf deinem Host an einem Skript, und der Container kann es sofort ausführen – ohne dass du den Container neu starten oder Dateien hineinkopieren musst.

Weitere Anwendungsfälle:
- Konfigurationsdateien von aussen in den Container laden
- Logs aus dem Container auf dem Host lesen

### Wie wird es erstellt?

```bash
docker run -d \
  --name kn05-bindmount \
  -v /Users/nwehrli/Documents/GitHub/m347/KN05/A:/scripts \
  nginx
```

Das `-v` Flag steht für **Volume**. Das Format ist:
```
-v <host-pfad>:<container-pfad>
```

### Was haben wir gemacht?

1. Container mit Bind Mount gestartet
2. Ein Bash-Skript (`info.sh`) auf dem Host erstellt
3. Das Skript im Container ausgeführt → Ausgabe sichtbar
4. Das Skript auf dem Host **geändert**
5. Das Skript erneut im Container ausgeführt → Änderung sofort sichtbar, **ohne Neustart**

### Wichtig zu wissen

- Bei `docker run` muss der Host-Pfad **absolut** angegeben werden (z.B. `/Users/...`, nicht `./`)
- Bei **Docker Compose** kann `./` verwendet werden – Docker Compose löst den Pfad automatisch relativ zur `docker-compose.yml` auf
- Der Ordner auf dem Host muss existieren
- Bind Mounts sind **abhängig vom Host** – nicht portabel auf andere Maschinen

---

## B) Named Volumes

### Was ist ein Named Volume?

Ein Named Volume ist ein Speicherbereich, der **von Docker selbst verwaltet** wird. Docker speichert die Daten irgendwo auf dem Host (unter `/var/lib/docker/volumes/`), aber du musst dich nicht um den genauen Pfad kümmern.

Das Besondere: **Mehrere Container können dasselbe Volume gleichzeitig verwenden.**

### Wofür ist das nützlich?

Wenn mehrere Container auf dieselben Daten zugreifen müssen, z.B.:
- Ein Container schreibt Daten, ein anderer liest sie
- Shared Cache zwischen Microservices
- Persistente Daten für Datenbanken

### Wie wird es erstellt?

```bash
# Volume erstellen
docker volume create kn05-shared-vol

# Container 1 mit diesem Volume starten
docker run -d --name kn05-c1 -v kn05-shared-vol:/data nginx

# Container 2 mit DEMSELBEN Volume starten
docker run -d --name kn05-c2 -v kn05-shared-vol:/data nginx
```

Das Format ist hier:
```
-v <volume-name>:<container-pfad>
```

Docker erkennt, dass es kein Pfad (kein `/` am Anfang) ist, sondern ein Volume-Name.

### Was haben wir gemacht?

1. Ein Named Volume `kn05-shared-vol` erstellt
2. Zwei Container gestartet, beide mit `/data` auf dasselbe Volume gemountet
3. In Container 1: in `/data/shared.txt` geschrieben
4. In Container 2: die Datei gelesen → Inhalt von Container 1 sichtbar
5. In Container 2: weiteren Text geschrieben
6. In Container 1: Datei erneut gelesen → Inhalt von Container 2 ebenfalls sichtbar

Das zeigt: Beide Container teilen sich denselben Speicher in Echtzeit.

### Unterschied zu Bind Mount

| | Bind Mount | Named Volume |
|---|---|---|
| Pfad | Fest auf dem Host | Von Docker verwaltet |
| Portabilität | Schlecht (host-abhängig) | Gut |
| Mehrere Container | Möglich | Möglich |
| Typischer Einsatz | Entwicklung | Produktion |

---

## C) Speicher mit Docker Compose

### Was ist Docker Compose?

Docker Compose erlaubt es, mehrere Container mit einer einzigen YAML-Datei zu definieren und zu starten. Statt viele `docker run`-Befehle zu tippen, beschreibst du alles in `docker-compose.yml`.

### Die drei Speichertypen in einer Datei

```yaml
services:
  nginx1:
    image: nginx
    volumes:
      # 1. Named Volume - Long Syntax
      - type: volume
        source: kn05-named-vol
        target: /data/named
      # 2. Bind Mount - Long Syntax
      - type: bind
        source: ./bindmount
        target: /data/bind
      # 3. tmpfs - Long Syntax
      - type: tmpfs
        target: /data/tmpfs

  nginx2:
    image: nginx
    volumes:
      # Named Volume - Short Syntax
      - kn05-named-vol:/data/named

volumes:
  kn05-named-vol:
```

### Long Syntax vs. Short Syntax

Docker Compose erlaubt zwei Schreibweisen:

**Short Syntax** – kurz und kompakt:
```yaml
- kn05-named-vol:/data/named
```

**Long Syntax** – ausführlich, mehr Optionen möglich:
```yaml
- type: volume
  source: kn05-named-vol
  target: /data/named
```

Beide machen dasselbe, die Long Syntax bietet aber mehr Konfigurationsmöglichkeiten (z.B. `read_only: true`).

### Das Top-Level `volumes` Element

```yaml
volumes:
  kn05-named-vol:
```

Dieser Block am Ende der Datei **deklariert** das Named Volume. Docker Compose erstellt es beim Start automatisch. Ohne diesen Block würde der Start fehlschlagen.

### Was ist tmpfs?

tmpfs (temporary filesystem) ist ein Speicher, der **nur im Arbeitsspeicher (RAM)** existiert:
- Sehr schnell (kein Festplattenzugriff)
- Daten werden beim Stopp des Containers **sofort gelöscht**
- Nützlich für sensible Daten (Passwörter, Tokens) die nicht auf der Festplatte landen sollen

### Was zeigt der `mount` Befehl?

Mit `docker compose exec nginx1 mount` kann man sehen, welche Speicher in einen Container eingehängt sind.

**Container 1 (nginx1)** zeigt drei relevante Einträge:
```
tmpfs on /data/tmpfs type tmpfs          ← tmpfs Mount
/dev/vda1 on /data/named type ext4      ← Named Volume
/run/host_mark/... on /data/bind ...    ← Bind Mount
```

**Container 2 (nginx2)** zeigt nur einen:
```
/dev/vda1 on /data/named type ext4      ← Named Volume
```

Das bestätigt, dass die Konfiguration korrekt funktioniert hat.

---

## Zusammenfassung

| Speichertyp | Verwaltet von | Persistenz | Mehrere Container | Typischer Einsatz |
|---|---|---|---|---|
| Bind Mount | Host (du) | Ja (Host-Datei) | Ja | Entwicklung, Configs |
| Named Volume | Docker | Ja | Ja | Produktion, Datenbanken |
| tmpfs | RAM | Nein (flüchtig) | Nein | Sensible Daten, Cache |
