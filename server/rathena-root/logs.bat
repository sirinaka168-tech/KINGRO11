@echo off
chcp 65001 >nul
title RO-King 5.0 - Server Logs
cd /d "%~dp0tools\docker"
echo Showing live server logs. Press Ctrl+C to exit (server keeps running).
echo Look for: "Server is ready and waiting for connections"
echo.
docker compose logs -f login char map
