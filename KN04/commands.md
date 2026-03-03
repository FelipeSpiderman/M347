# KN04: Ausführung und Screenshots

## Teil a) Commands ausführen

```bash
# 1. Docker Compose starten (Original Images)
cd KN04
docker compose up -d --build

# 2. Warten bis DB bereit ist (ca. 30 Sekunden)
sleep 30

# 3. info.php aufrufen
curl http://localhost:8080/info.php

# 4. db.php aufrufen
curl http://localhost:8080/db.php
```

## Teil b) Commands ausführen

```bash
# 1. Eigene Images verwenden (anderer Port!)
docker compose -f docker-compose-own.yml up -d

# 2. Warten
sleep 30

# 3. info.php aufrufen
curl http://localhost:8081/info.php

# 4. db.php aufrufen (wird FEHLER zeigen!)
curl http://localhost:8081/db.php

# 5. Aufräumen
docker compose down
docker compose -f docker-compose-own.yml down
```

## Screenshots die du brauchst

### Teil a)
| Dateiname | Was erfassen |
|-----------|--------------|
| `kn04a-info.png` | Browser: info.php mit sichtbaren IPs (REMOTE_ADDR, SERVER_ADDR) |
| `kn04a-db.png` | Browser: db.php zeigt Datenbank-User Liste |

### Teil b)
| Dateiname | Was erfassen |
|-----------|--------------|
| `kn04b-info.png` | Browser: info.php mit sichtbaren IPs |
| `kn04b-db-error.png` | Browser: db.php zeigt Fehler "Connection failed" |

### Cloud
| Dateiname | Was erfassen |
|-----------|--------------|
| `cloud-info.png` | Browser: info.php mit sichtbaren IPs + URL in Adressleiste |
| `cloud-db.png` | Browser: db.php mit Datenbank-Resultat + URL |

## Bilder verschieben

Nachdem du Screenshots gemacht hast:

```bash
# Bilder nach KN04/Images verschieben
mv kn04a-info.png KN04/Images/
mv kn04a-db.png KN04/Images/
mv kn04b-info.png KN04/Images/
mv kn04b-db-error.png KN04/Images/
mv cloud-info.png KN04/Images/
mv cloud-db.png KN04/Images/
```
