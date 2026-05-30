@echo off
chcp 65001 >nul
title RO-King 5.0 - Create GM Account
cd /d "%~dp0tools\docker"

echo Creating GM account from account-gm.sql ...
docker compose exec -T db mariadb -uragnarok -pragnarok ragnarok < "%~dp0account-gm.sql"
if errorlevel 1 goto err

echo.
echo ============================================
echo   GM account created!
echo     Login : kingadmin
echo     Pass  : ChangeMe_123
echo   >>> CHANGE THE PASSWORD after first login! <<<
echo ============================================
pause
exit /b 0

:err
echo *** Failed. Make sure the server is running (2-start.bat) first. ***
pause
exit /b 1
