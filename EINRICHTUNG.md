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

---

## Stand 28./29.08.2026 – was jetzt eingerichtet ist

- **Live:** https://jobs.arndt-software.de (Coolify, Build Pack Static, Repo `andre69190-del/job-hunter`)
- **Geschützt mit Cloudflare Access.** Anmeldung per E-Mail-Einmalcode. Zugelassen sind:
  `Oliver.arndt3@gmail.com`, `andre69190@googlemail.com`, `Andre.arndt69190@gmail.com`.
  Sitzungsdauer 30 Tage. Änderung der Liste: Cloudflare → Zero Trust →
  Zugriffssteuerungen → Anwendungen → `jobs` → Richtlinie „Andre und Oliver".
- **DNS:** Eigener A-Eintrag `jobs` → 159.195.159.150, **proxied** (orange Wolke).
  Die anderen Subdomains bleiben bewusst „Nur DNS".
- **Anmeldemethoden:** „One-time PIN" wurde als Identitätsanbieter ergänzt – ohne ihn
  gäbe es nur „Sign in with Cloudflare", was ein Cloudflare-Konto voraussetzt.
- **Scout:** geplante Aufgabe Mo + Do 23:00, schreibt `..\results.json`.
  Muss in der Claude-App an den Rechner gebunden werden, sonst läuft sie ins Leere.

### Noch offen: Webhook für Auto-Deploy

GitHub verlangte beim Anlegen eine Identitätsbestätigung per E-Mail (sudo mode),
deshalb ist der Webhook noch nicht eingerichtet. Selbst nachholen:

1. Coolify → Anwendung `job-hunter` → **Webhooks**: URL
   `https://coolify.arndt-software.de/webhooks/source/github/events/manual`
   und das **GitHub Webhook Secret** (Augensymbol zum Anzeigen) kopieren.
2. GitHub → Repo → **Settings → Webhooks → Add webhook**:
   Payload URL einfügen, Content type `application/json`, Secret einfügen,
   *Just the push event*, **Add webhook**.

Bis dahin gilt: nach `publish.bat` einmal in Coolify auf **Redeploy** klicken.

---

## Stand 03.09.2026 — Umbau nach dem Prüfbericht

**Oberfläche**

- Kopfzeile zeigt nur noch Zahlen und Datenstand. Ziel, Lagebericht, Skill-Gap und
  Portfolio-Ideen stecken hinter dem Knopf **Lagebericht** oben rechts; der Zustand
  wird gemerkt und ist standardmäßig zu.
- **Job-Status pro Karte**: ★ Gemerkt · ✔ Beworben · ✖ Erledigt. Wird im Browser
  gespeichert (localStorage-Schlüssel `jh_jobstate`, Schlüssel ist die neue `id`).
  Das Auswahlfeld *Bearbeitungsstand* blendet Erledigte standardmäßig aus.
- Begründungstexte sind auf vier Zeilen gekürzt, „mehr anzeigen" klappt auf.
- Kategorie-, Regionen- und Artenliste bauen sich aus den Daten der jeweiligen Person.
  Damit verschwinden Karteileichen wie die frühere Art „Remote" von selbst.
- „Filter zurücksetzen" erscheint in der Filterleiste, sobald ein Filter aktiv ist.
  Der Leerzustand nennt die schuldigen Filter.
- Sortierung „Neueste zuerst" nutzt jetzt `first_seen` (vorher `last_seen`, wirkungslos).
  Neu: Sortierung „Frist zuerst".
- NEU bedeutet: aus dem jüngsten Lauf dieser Person. Vorher war `is_new` für Oliver
  immer leer und für Leonard immer voll.
- Abgelaufene Anmeldung wird als Klartext gemeldet statt als SyntaxError.
- Der 15-Minuten-Auto-Reload ist raus.
- Browser-Tab trägt den Namen der gewählten Person.

**Daten**

- Jeder Eintrag hat eine stabile `id` (SHA1 aus Arbeitgeber, Titel, URL, 12 Zeichen).
  Der Scout muss sie bei jedem Lauf gleich vergeben, sonst geht der Job-Status verloren.
- `deadline` wird befüllt, wo eine Frist eindeutig im Text steht (aktuell 4 Einträge).
  **Besser: der Scout schreibt Fristen künftig direkt ins Feld.**
- `link_code` und `link_checked` je Eintrag. Karten mit einem anderen Code als 200/403
  zeigen eine Warnung. 403 bedeutet Bot-Sperre, nicht tot.
- Toter IONOS-SE-Eintrag entfernt (echter 404), Accenture-URL von camelot-itlab.com
  (HTTP 500) auf accenture.com umgestellt.

**Rechtstexte entfernt** — impressum.html und datenschutz.html liegen in `_to_delete/`
und stehen in `.gitignore`. Grund: zugangsgeschütztes, nicht-kommerzielles
Familienwerkzeug, damit keine Impressumspflicht nach § 5 DDG; der Datenschutztext
behauptete außerdem „keine Anmeldung, keine Cookies, keine externen Skripte",
was mit Cloudflare Access alles drei nicht stimmte.

**Wichtig:** Der Server liest die Oberfläche jetzt aus `web/index.html`. Nach dieser
einen letzten Neustartrunde wirken künftige Änderungen an der Seite sofort —
`build_site.py` genügt, kein Serverneustart mehr.
