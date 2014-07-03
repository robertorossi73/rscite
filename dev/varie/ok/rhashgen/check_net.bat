rem test presenza net framework 1.1
@ECHO OFF
SET FileName=%windir%\Microsoft.NET\Framework\v1.1.4322
IF EXIST %FileName% GOTO ok
ECHO.You currently do not have the Microsoft® .NET Framework 1.1 installed.
ECHO.This is required by the setup program for MyApplication.
ECHO.
ECHO.The Microsoft® .NET Framework 1.1 will now be installed on you system.
ECHO.After completion setup will continue to install MyApplication on your system.
ECHO.
Exit
:ok
echo Net OK
Exit 