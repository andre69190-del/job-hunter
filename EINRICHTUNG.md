# Einrichtung Schritt für Schritt – jobs.arndt-software.de

Vorbereitet ist bereits: Dieser Ordner ist ein fertiges Git-Repository mit einem
ersten Commit, die DNS (`*.arndt-software.de`) zeigt schon auf den Server.
Es fehlen GitHub-Repo, Coolify-Anwendung und (optional) der Auto-Deploy-Webhook.

Gesamtdauer: ca. 10 Minuten.

---

## Schritt 0 – Vorbereitung (1 Min)

1. Im Explorer diesen Ordner öffnen:
   `C:\Users\Andre\Desktop\Cowork\job-hunter\web`
2. Den Unterordner **`_to_delete`** löschen (leere Git-Hilfsdateien aus der Fernwartung).
3. Eingabeaufforderung im Ordner öffnen: in die **Adressleiste** des Explorers `cmd`
   tippen und Enter drücken. Das Fenster startet direkt in diesem Ordner.
4. Kontrolle:
   ```
   git --version
   git log --oneline
   ```
   Erwartet: eine Git-Version und ein Commit `Job Hunter Web-Version fuer jobs.arndt-software.de`.

---

## Schritt 1 – GitHub-Repository anlegen (2 Min)

1. https://github.com/new öffnen (als `andre69190-del` angemeldet).
2. **Repository name:** `job-hunter`
3. **Visibility:** **Public**
   Grund: Coolify klont über „Public Repository" ohne GitHub-App und ohne Deploy-Key.
   Im Repo liegen nur die Seite und öffentliche Stellenlinks – keine Zugangsdaten.
4. **Wichtig:** *Add a README*, *Add .gitignore* und *Choose a license* **nicht**
   anhaken. Sonst hat das Repo einen eigenen Commit und der erste Push wird abgelehnt.
5. **Create repository** klicken. Die folgende Seite mit den Beispielbefehlen
   kann offen bleiben.

---

## Schritt 2 – Ersten Push machen (2 Min)

Im cmd-Fenster aus Schritt 0:

```
git remote add origin https://github.com/andre69190-del/job-hunter.git
git branch -M main
git push -u origin main
```

- Falls ein Anmeldefenster erscheint: „Sign in with your browser" wählen und
  im Browser bestätigen (Git Credential Manager merkt sich das danach).
- Falls `error: remote origin already exists`:
  `git remote set-url origin https://github.com/andre69190-del/job-hunter.git`
- Falls `src refspec main does not match any`:
  `git branch -M main` wurde übersprungen – noch einmal ausführen.

**Kontrolle:** https://github.com/andre69190-del/job-hunter zeigt jetzt
`index.html`, `results.json`, `publish.bat`, `impressum.html`, `datenschutz.html`,
`robots.txt`, `LIESMICH.md`, `EINRICHTUNG.md`.

---

## Schritt 3 – Coolify: Anwendung anlegen (4 Min)

1. https://coolify.arndt-software.de öffnen und anmelden.
2. Links **Projects** → das Projekt öffnen, in dem GeoQuest / ArcDoc / Bioglow liegen
   → Environment **production**.
3. **+ New** (bzw. *Add New Resource*).
4. Unter *Git Based* → **Public Repository** wählen.
5. **Repository URL:**
   ```
   https://github.com/andre69190-del/job-hunter
   ```
   **Branch:** `main` → *Check repository* / *Continue*.
6. **Build Pack:** **Static** auswählen (nicht Nixpacks, nicht Dockerfile).
   Es gibt nichts zu bauen – nginx liefert die Dateien direkt aus.
7. Verzeichnisse:
   - **Base Directory:** `/`
   - **Publish Directory:** `/`
   - **Port:** `80` (setzt Coolify bei „Static" selbst)
8. Speichern / *Continue* – die Anwendung wird angelegt.
9. In der Anwendung → **Configuration → General → Domains**:
   ```
   https://jobs.arndt-software.de
   ```
   Genau so: **mit** `https://`, **ohne** Schrägstrich am Ende, nur diese eine Domain.
   → **Save**.
10. Oben rechts **Deploy** klicken und die Logs mitlesen, bis dort sinngemäß
    *New container started* steht.

---

## Schritt 4 – Prüfen (1 Min)

1. https://jobs.arndt-software.de öffnen.
2. Erwartet: das dunkle Dashboard „🔭 Astro Career Scout" mit 17 Chancen.
3. **Zertifikatswarnung?** Let's Encrypt braucht nach dem ersten Deploy oft
   30–90 Sekunden. Kurz warten und neu laden. Bleibt es dabei, in Coolify die
   Domain-Schreibweise prüfen (Tippfehler, fehlendes `https://`) und neu deployen.
4. **404 oder leere Seite?** Dann steht *Publish Directory* falsch – auf `/` setzen
   und noch einmal deployen.

---

## Schritt 5 – Automatisches Deployment bei jedem Push (2 Min, optional)

Bei der Quelle „Public Repository" legt Coolify den Webhook nicht selbst an.

1. In Coolify: Anwendung → Tab **Webhooks** → Abschnitt *GitHub* →
   die **Webhook-URL** kopieren. Falls dort ein **Secret** steht, ebenfalls kopieren.
2. Auf GitHub: Repo → **Settings** → **Webhooks** → **Add webhook**
   - **Payload URL:** die kopierte URL
   - **Content type:** `application/json`
   - **Secret:** das kopierte Secret (falls vorhanden)
   - **Which events:** *Just the push event*
   - **Add webhook**
3. Test: `publish.bat` ausführen – in Coolify muss innerhalb weniger Sekunden ein
   neues Deployment auftauchen.

Ohne Webhook funktioniert alles genauso, nur muss nach jedem `publish.bat` einmal
in Coolify auf **Deploy** geklickt werden.

---

## Schritt 6 – Der Alltag danach

1. Der Career Scout (Mo + Do) schreibt `..\results.json`.
2. `publish.bat` doppelklicken.
3. Nach ca. einer Minute ist der neue Stand unter
   https://jobs.arndt-software.de sichtbar.

Der lokale WLAN-Server im Ordner darüber bleibt unverändert nutzbar.

---

## Optional später: echter Passwortschutz

Die Seite ist nicht auffindbar (`robots.txt` + `noindex`, kein Link von der
Startseite), aber wer die Adresse kennt, kommt rein. Soll sie wirklich dicht sein:
in Coolify → Anwendung → **Advanced** → *Basic Authentication* aktivieren und
Benutzer/Passwort setzen. Dann muss der Student das Passwort einmal eingeben.

---

## Wenn etwas klemmt

| Symptom | Ursache | Lösung |
|---|---|---|
| `failed to push some refs` | Repo wurde mit README angelegt | `git push -u origin main --force` (das Repo ist neu und leer) |
| Anmeldefenster kommt immer wieder | Credential Manager speichert nicht | Einmal `git config --global credential.helper manager` setzen |
| Coolify: `repository not found` | Repo ist Private | Auf GitHub unter *Settings → Danger Zone* auf Public stellen |
| Seite zeigt alte Daten | Browser-Cache | Strg + F5 |
| Seite lädt, aber keine Karten | `results.json` fehlt im Repo | Prüfen, ob die Datei auf GitHub liegt; sonst `publish.bat` |
