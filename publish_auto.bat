@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "..\results.json" exit /b 1
copy /Y "..\results.json" "results.json" >nul

rem Stehengebliebene Sperrdatei entfernen - sonst schlaegt jedes git add fehl
if exist ".git\index.lock" (
  tasklist /FI "IMAGENAME eq git.exe" 2>nul | find /I "git.exe" >nul
  if errorlevel 1 del /F /Q ".git\index.lock" >nul 2>&1
)

git add -A
if errorlevel 1 exit /b 1

git diff --cached --quiet
if not %errorlevel%==0 (
  for /f "tokens=1-3 delims=." %%a in ("%date:~-10%") do set STAMP=%%c-%%b-%%a
  git commit -m "Job-Hunter-Update %STAMP% %time:~0,5% (automatisch)"
)

rem Immer pushen - holt auch einen frueher haengen gebliebenen Commit nach
git push
if errorlevel 1 exit /b 1

rem ===== Coolify anstossen =====
set "CF_URL="
set "CF_TOKEN="
if exist "coolify-deploy.txt" (
  for /f "usebackq eol=# tokens=1,* delims==" %%a in ("coolify-deploy.txt") do (
    if /I "%%a"=="URL" set "CF_URL=%%b"
    if /I "%%a"=="TOKEN" set "CF_TOKEN=%%b"
  )
)
echo %CF_URL% | findstr /B /I "http" >nul || set "CF_URL="

if defined CF_URL (
  if defined CF_TOKEN (
    curl -s -S -m 60 -X POST -H "Authorization: Bearer %CF_TOKEN%" "%CF_URL%" >nul
  ) else (
    curl -s -S -m 60 "%CF_URL%" >nul
  )
)
exit /b %errorlevel%
