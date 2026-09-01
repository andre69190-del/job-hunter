@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "..\results.json" exit /b 1
copy /Y "..\results.json" "results.json" >nul
git add -A
git diff --cached --quiet && exit /b 0
for /f "tokens=1-3 delims=." %%a in ("%date:~-10%") do set STAMP=%%c-%%b-%%a
git commit -m "Job-Hunter-Update %STAMP% %time:~0,5% (automatisch)"
git push
exit /b %errorlevel%
