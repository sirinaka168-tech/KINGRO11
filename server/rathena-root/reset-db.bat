@echo off
chcp 65001 >nul
title RO-King 5.0 - RESET Database
cd /d "%~dp0tools\docker"

echo ============================================
echo   WARNING - THIS DELETES EVERYTHING
echo   All accounts, characters, items will be
echo   ERASED and the database re-imported fresh.
echo ============================================
echo.
set /p ok="Type YES to confirm: "
if /i not "%ok%"=="YES" (echo Cancelled. & pause & exit /b 0)

docker compose down --volumes
echo.
echo Database wiped. Next 2-start.bat will import a fresh DB.
echo (Re-run make-gm.bat afterwards to recreate the GM account.)
pause
