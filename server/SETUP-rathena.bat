@echo off
chcp 65001 >nul
title RO-King 5.0 - Auto Setup
set "RA=C:\rathena"

echo ============================================
echo   RO-King 5.0 - Auto Setup into %RA%
echo ============================================
echo.

if not exist "%RA%\src\config\renewal.hpp" (
  echo *** ERROR: not found: %RA%\src\config\renewal.hpp
  echo *** Make sure rAthena is extracted to C:\rathena
  echo *** ^(you should see tools, conf, src folders inside C:\rathena^)
  pause & exit /b 1
)

echo [1/4] Switching to Pre-Renewal mode (Episode 5.0)...
powershell -NoProfile -Command "$f='%RA%\src\config\renewal.hpp'; (Get-Content $f) -replace '^\s*#define\s+RENEWAL','//#define RENEWAL' | Set-Content $f -Encoding ascii"

echo [2/4] Copying RO-King scripts to %RA% ...
copy /Y "%~dp0rathena-root\*.*" "%RA%\" >nul

echo [3/4] Installing x50 rate config ...
if not exist "%RA%\conf\import" mkdir "%RA%\conf\import"
copy /Y "%~dp0conf-import\battle_conf.txt" "%RA%\conf\import\" >nul

echo [4/4] Setting server name to "RO-King 5.0" ...
powershell -NoProfile -Command "$f='%RA%\tools\docker\asset\char_conf.txt'; if (-not (Select-String -Path $f -Pattern 'server_name: RO-King' -Quiet)) { Add-Content $f \"`nserver_name: RO-King 5.0\" }"

echo.
echo ============================================
echo   DONE!  RO-King 5.0 config applied.
echo.
echo   Next steps (inside C:\rathena):
echo     1) double-click  1-compile.bat   (~15 min, once)
echo     2) double-click  2-start.bat
echo     3) double-click  make-gm.bat
echo ============================================
pause
