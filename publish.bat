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

git add -A
git diff --cached --quiet
if %errorlevel%==0 (
  echo   Keine Aenderungen - nichts zu veroeffentlichen.
  pause
  exit /b 0
)

for /f "tokens=1-3 delims=." %%a in ("%date:~-10%") do set STAMP=%%c-%%b-%%a
git commit -m "Job-Hunter-Update %STAMP% %time:~0,5%"
git push
if errorlevel 1 (
  echo.
  echo FEHLER beim Push. Bitte Meldung oben pruefen.
  pause
  exit /b 1
)

echo.
echo   Fertig. Coolify deployt automatisch - in ca. 1 Minute live:
echo   https://jobs.arndt-software.de
echo.
pause
