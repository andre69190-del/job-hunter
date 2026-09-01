@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   Automatisches Veroeffentlichen einrichten
echo   Montag + Donnerstag, 22:45 Uhr
echo ============================================================
echo.
schtasks /Create /TN "Job Hunter veroeffentlichen" /TR "\"%~dp0publish_auto.bat\"" /SC WEEKLY /D MON,THU /ST 22:45 /F
if errorlevel 1 (
  echo.
  echo FEHLER beim Anlegen der Aufgabe.
  pause
  exit /b 1
)
echo.
echo   Fertig. Ab jetzt wird nach jedem Scout-Lauf automatisch veroeffentlicht.
echo   Bedingung: Der Rechner laeuft um 22:45 Uhr.
echo.
echo   Entfernen mit:  Auto-Publish-entfernen.bat
echo.
pause
