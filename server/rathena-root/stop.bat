@echo off
chcp 65001 >nul
title RO-King 5.0 - Stop Server
cd /d "%~dp0tools\docker"
echo Stopping RO-King 5.0 server...
docker compose down
echo.
echo Server stopped. Characters/accounts are saved (DB persists).
echo Start again anytime with 2-start.bat
pause
