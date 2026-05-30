@echo off
chcp 65001 >nul
title RO-King 5.0 - Compile rAthena
cd /d "%~dp0tools\docker"

echo ============================================
echo   RO-King 5.0 - Compile rAthena (Docker)
echo ============================================
echo.
echo [1/2] Starting database + builder containers...
docker compose up -d db builder
if errorlevel 1 goto err

echo.
echo [2/2] Compiling rAthena...
echo       (First time takes ~10-20 min. Go grab a coffee.)
echo.
docker compose exec -w /rathena builder sh -c "./configure $BUILDER_CONFIGURE && make clean server"
if errorlevel 1 goto err

echo.
echo ============================================
echo   DONE! No errors = success.
echo   Next: run  2-start.bat
echo ============================================
pause
exit /b 0

:err
echo.
echo *** Something failed. Make sure Docker Desktop is running. ***
pause
exit /b 1
