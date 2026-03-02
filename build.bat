@echo off
setlocal
echo Code pulled successfully
echo Build started...

REM The /nobreak prevents keypress checks; redirect both stdout and stderr
timeout /t 2 /nobreak >nul 2>&1

echo Build completed!
endlocal

exit /b 0
