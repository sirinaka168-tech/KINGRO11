@echo off
chcp 65001 >nul
title RO-King 5.0 - Start Server
cd /d "%~dp0tools\docker"

echo ============================================
echo   RO-King 5.0 - Starting server...
echo ============================================
echo (First start imports the database - may take a minute)
echo.
docker compose up -d
if errorlevel 1 goto err

timeout /t 4 >nul
echo.
docker compose ps
echo.
echo --------------------------------------------
echo   Login : port 6900
echo   Char  : port 6121
echo   Map   : port 5121
echo.
echo   Watch logs : logs.bat
echo   Make GM    : make-gm.bat  (first time only)
echo   Stop       : stop.bat
echo --------------------------------------------
pause
exit /b 0

:err
echo *** Failed. Is Docker Desktop running? Did you run 1-compile.bat first? ***
pause
exit /b 1
