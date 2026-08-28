# Astro Career Scout – Web-Version (jobs.arndt-software.de)

Dieser Ordner ist die **online-Version** des Job Hunters. Er enthält genau die Seite,
die der lokale Server bisher angezeigt hat – nur als statische Dateien, die Coolify
auf `https://jobs.arndt-software.de` ausliefert.

## So läuft der Ablauf

1. Der **Career Scout** (geplanter Claude-Task, Mo + Do) schreibt wie bisher
   `..\results.json` im Ordner darüber.
2. Du doppelklickst **`publish.bat`**. Das Skript kopiert `results.json` hierher,
   committet und pusht.
3. Coolify erkennt den Push und deployt automatisch – nach ca. 1 Minute ist der
   neue Stand unter `https://jobs.arndt-software.de` sichtbar.

Der lokale WLAN-Server im Ordner darüber funktioniert weiterhin unverändert und
kann als Fallback bestehen bleiben.

## Dateien

| Datei | Zweck |
|---|---|
| `index.html` | Die Seite (identisch zum lokalen Server, lädt `results.json` direkt). |
| `results.json` | Die veröffentlichten Daten – wird von `publish.bat` aktualisiert. |
| `publish.bat` | Daten übernehmen + committen + pushen. |
| `impressum.html` / `datenschutz.html` | Pflichtangaben für die öffentliche Seite. |
| `robots.txt` | Sperrt Suchmaschinen aus (die Seite ist nicht auffindbar). |

## Sichtbarkeit

Die Seite ist **öffentlich erreichbar, aber nicht auffindbar**: `robots.txt` und
`noindex` halten Suchmaschinen fern, und von `arndt-software.de` führt kein Link
dorthin. Wer die Adresse nicht kennt, findet die Seite nicht.
Soll sie wirklich dicht sein, kann in Coolify zusätzlich Basic Auth vorgeschaltet werden.

## Einmalige Einrichtung

Siehe `EINRICHTUNG.md`.
