@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title VYRO AI Frontend Build

echo ==========================================
echo       VYRO AI - Frontend Build
echo ==========================================
where node >nul 2>nul
if errorlevel 1 (echo [ERROR] Node.js is not installed or not on PATH.& goto :fail)
where npm >nul 2>nul
if errorlevel 1 (echo [ERROR] npm is not installed or not on PATH.& goto :fail)
for /f "tokens=1 delims=v" %%V in ('node --version') do set NODEVER=%%V
for /f "tokens=1 delims=." %%V in ("%NODEVER%") do set NODEMAJOR=%%V
if %NODEMAJOR% LSS 20 (echo [ERROR] Node.js 20+ is required. Detected %NODEVER%.& goto :fail)
if not exist "web\package-lock.json" (echo [ERROR] web\package-lock.json is missing.& goto :fail)

pushd web
echo [1/2] Installing exact locked dependencies...
call npm ci --include=optional --no-audit --no-fund --fetch-retries=5 --fetch-timeout=120000
if errorlevel 1 (popd& echo [ERROR] npm dependency installation failed. Check internet/proxy/firewall and retry.& goto :fail)
echo [2/2] Building production frontend...
call npm run build
if errorlevel 1 (popd& echo [ERROR] Production build failed. See TypeScript/Vite diagnostics above.& goto :fail)
popd

echo.
echo [SUCCESS] Frontend production build completed.
echo Output: web\dist\
echo This verifies the production bundle; it does not run real-video product tests.
echo.
pause
exit /b 0

:fail
echo.
echo [FAILED] Frontend setup/build did not complete.
echo.
pause
exit /b 1
