@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title VYRO AI Launcher

echo ==========================================
echo          VYRO AI - Windows Launcher
echo ==========================================

where python >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Python 3.11+ was not found. Install Python and enable Add Python to PATH.
  goto :fail
)
for /f "tokens=2" %%V in ('python --version 2^>^&1') do set PYVER=%%V
for /f "tokens=1,2 delims=." %%A in ("%PYVER%") do (set PYMAJOR=%%A& set PYMINOR=%%B)
if not defined PYMINOR goto :python_version_error
if %PYMAJOR% LSS 3 goto :python_version_error
if %PYMAJOR% EQU 3 if %PYMINOR% LSS 11 goto :python_version_error
echo [OK] Python %PYVER%
set "BACKEND_PYTHON=server\.venv\Scripts\python.exe"
if exist "server\.venv314\Scripts\python.exe" set "BACKEND_PYTHON=server\.venv314\Scripts\python.exe"
if %PYMAJOR% EQU 3 if %PYMINOR% GTR 14 set "BACKEND_PYTHON=server\.venv314\Scripts\python.exe"

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js 20+ was not found. Install Node.js and reopen this window.
  goto :fail
)
for /f "tokens=1 delims=v" %%V in ('node --version') do set NODEVER=%%V
for /f "tokens=1,2 delims=." %%A in ("%NODEVER%") do (set NODEMAJOR=%%A& set NODEMINOR=%%B)
if not defined NODEMAJOR goto :node_version_error
if %NODEMAJOR% LSS 20 goto :node_version_error
echo [OK] Node.js %NODEVER%

where ffmpeg >nul 2>nul
if errorlevel 1 (
  echo [WARNING] FFmpeg missing. Video import, analysis and export will not work.
) else (
  echo [OK] FFmpeg found.
  where ffprobe >nul 2>nul
  if errorlevel 1 echo [WARNING] ffprobe missing. Install the complete FFmpeg tools package.
)

if not exist "%BACKEND_PYTHON%" (
  echo [SETUP] Creating Python virtual environment...
  if "%BACKEND_PYTHON%"=="server\.venv314\Scripts\python.exe" (
    py -3.14 -m venv server\.venv314
  ) else (
    python -m venv server\.venv
  )
  if errorlevel 1 goto :fail
)

echo [SETUP] Installing backend requirements...
call "%BACKEND_PYTHON%" -m pip install -r server\requirements.txt
if errorlevel 1 goto :fail

if not exist "web\node_modules\vite\client.d.ts" goto :install_frontend
if not exist "web\node_modules\@types\node\package.json" goto :install_frontend
echo [OK] Frontend dependencies already installed. Run npm ci in web if you need to refresh them.
goto :frontend_ready

:install_frontend
echo [SETUP] Installing frontend packages from package-lock.json...
pushd web
call npm ci --include=optional --no-audit --no-fund --fetch-retries=5 --fetch-timeout=120000
if errorlevel 1 (popd & goto :fail)
popd

:frontend_ready

netstat -ano | findstr /R /C:":8123 .*LISTENING" >nul
if not errorlevel 1 (
  echo [ERROR] Port 8123 is already in use. Close the existing VYRO backend or change its port.
  goto :fail
)
netstat -ano | findstr /R /C:":5173 .*LISTENING" >nul
if not errorlevel 1 (
  echo [ERROR] Port 5173 is already in use. Close the existing VYRO frontend or change its port.
  goto :fail
)

 echo [START] Opening VYRO backend and frontend...
start "VYRO AI Backend" cmd /k "cd /d ""%~dp0server"" && ""%~dp0%BACKEND_PYTHON%"" -m uvicorn main:app --host 127.0.0.1 --port 8123"
start "VYRO AI Frontend" cmd /k "cd /d ""%~dp0web"" && npm run dev -- --host 127.0.0.1 --strictPort"

echo [WAIT] Waiting for the local API...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$deadline=(Get-Date).AddSeconds(30); do { try { $r=Invoke-RestMethod -Uri 'http://127.0.0.1:8123/api/health' -TimeoutSec 2; Write-Host '[OK] Backend health endpoint responded.'; Write-Host ('FFmpeg: ' + $r.ffmpeg_available + ' | Faster-Whisper: ' + $r.transcription_available); exit 0 } catch { Start-Sleep -Seconds 1 } } while ((Get-Date) -lt $deadline); Write-Host '[WARNING] Backend did not respond within 30 seconds; inspect the backend window.'; exit 1"
start "" http://localhost:5173

echo.
echo VYRO frontend: http://localhost:5173
echo Backend health: http://127.0.0.1:8123/api/health
echo Faster-Whisper downloads the tiny model automatically on first analysis.
echo Keep both terminal windows open while using VYRO.
echo.
pause
exit /b 0

:python_version_error
echo [ERROR] Python 3.11 or newer is required. Faster-Whisper also needs a Python version with compatible ONNX Runtime wheels.
goto :fail

:node_version_error
echo [ERROR] Node.js 20 or newer is required. Detected %NODEVER%.
goto :fail

:fail
echo.
echo [ERROR] VYRO could not be started. Fix the reported issue and run this launcher again.
pause
exit /b 1
