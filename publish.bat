@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ============================================================
echo   Job Hunter veroeffentlichen  --^>  jobs.arndt-software.de
echo ============================================================

if not exist "..\results.json" (
  echo FEHLER: ..\results.json nicht gefunden.
  pause
  exit /b 1
)

copy /Y "..\results.json" "results.json" >nul
echo   results.json aktualisiert.

rem --- Stehengebliebene Sperrdatei entfernen (sonst schlaegt jedes git add fehl) ---
if exist ".git\index.lock" (
  tasklist /FI "IMAGENAME eq git.exe" 2>nul | find /I "git.exe" >nul
  if errorlevel 1 (
    del /F /Q ".git\index.lock" >nul 2>&1
    echo   Alte Sperrdatei .git\index.lock entfernt.
  ) else (
    echo FEHLER: Es laeuft gerade ein anderer git-Prozess. Bitte warten und erneut starten.
    pause
    exit /b 1
  )
)

git add -A
if errorlevel 1 (
  echo.
  echo FEHLER bei "git add". Meldung oben pruefen.
  pause
  exit /b 1
)

git diff --cached --quiet
if %errorlevel%==0 (
  echo   Keine neuen Aenderungen - pruefe nur noch, ob alles gepusht ist.
) else (
  for /f "tokens=1-3 delims=." %%a in ("%date:~-10%") do set STAMP=%%c-%%b-%%a
  git commit -m "Job-Hunter-Update %STAMP% %time:~0,5%"
  if errorlevel 1 (
    echo.
    echo FEHLER beim Commit. Meldung oben pruefen.
    pause
    exit /b 1
  )
)

rem --- Immer pushen: holt auch einen Commit nach, der frueher haengen geblieben ist ---
git push
if errorlevel 1 (
  echo.
  echo FEHLER beim Push. Bitte Meldung oben pruefen.
  pause
  exit /b 1
)

echo.
echo   Push erledigt. ACHTUNG: Coolify deployt NICHT automatisch,
echo   solange der GitHub-Webhook fehlt - bitte in Coolify auf Redeploy klicken.
echo.
pause
