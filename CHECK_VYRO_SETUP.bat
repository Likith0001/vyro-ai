@echo off
setlocal EnableExtensions
cd /d "%~dp0"
echo ===== VYRO AI Setup Diagnostics =====

where python >nul 2>nul
if errorlevel 1 (echo [MISSING] Python) else (python --version)
where node >nul 2>nul
if errorlevel 1 (echo [MISSING] Node.js) else (node --version)
where npm >nul 2>nul
if errorlevel 1 (echo [MISSING] npm) else (npm --version)

where ffmpeg >nul 2>nul
if errorlevel 1 (
  echo [MISSING] FFmpeg
) else (
  ffmpeg -hide_banner -version 2>nul | findstr /B /C:"ffmpeg version"
)
where ffprobe >nul 2>nul
if errorlevel 1 (echo [MISSING] FFprobe) else (echo [OK] FFprobe)

if exist "web\node_modules\vite\client.d.ts" if exist "web\node_modules\@types\node\package.json" (echo [OK] Frontend dependencies installed) else (echo [MISSING] Frontend dependencies - run BUILD_VYRO_FRONTEND.bat)
if not exist "web\node_modules\vite\client.d.ts" echo [MISSING] Frontend dependencies - run BUILD_VYRO_FRONTEND.bat
set "BACKEND_PYTHON=server\.venv\Scripts\python.exe"
if exist "server\.venv314\Scripts\python.exe" set "BACKEND_PYTHON=server\.venv314\Scripts\python.exe"
if exist "%BACKEND_PYTHON%" (
  echo [OK] Backend virtual environment
  "%BACKEND_PYTHON%" -c "import faster_whisper" >nul 2>nul
  if errorlevel 1 (echo [MISSING] Faster-Whisper - run START_VYRO_WINDOWS.bat) else (echo [OK] Faster-Whisper installed)
) else (
  echo [MISSING] Backend virtual environment - run START_VYRO_WINDOWS.bat
)

powershell -NoProfile -Command "try { $h=Invoke-RestMethod 'http://127.0.0.1:8123/api/health' -TimeoutSec 3; Write-Host ('[API] FFmpeg=' + $h.ffmpeg_available + ', Faster-Whisper=' + $h.transcription_available + ', model=' + $h.transcription_model) } catch { Write-Host '[API] Backend is not running' }"
echo.
pause
