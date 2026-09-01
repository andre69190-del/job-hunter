@echo off
chcp 65001 >nul
schtasks /Delete /TN "Job Hunter veroeffentlichen" /F
echo.
echo   Automatisches Veroeffentlichen entfernt.
pause
