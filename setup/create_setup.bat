rem Procedura di compilazione pacchetto di setup e versione portabile
echo off
cls

rem Lettura numero versione da file .INI
for /F "tokens=*" %%I in (..\sources\distro\version.txt) do set %%I

rem Impostazione variabili
set innoExe="D:\Program Files\Inno Setup 7\ISCC.exe"
set zipper="d:\Program Files\7-Zip\7z.exe"
set OutFolder="d:\temp\output\"
set FileName="%OutFolder%portable-rscite-%Major%.zip"
set FileNameSetup="%OutFolder%setup-rscite-%Major%.exe"
set FileNameSetupZip="%OutFolder%setup-rscite-%Major%.zip"

if not exist %innoExe% (
    echo.
    echo Errore Inno Setup: il file "%innoExe%" non esiste.
    echo.
    pause
    exit /b 1
)

if not exist %zipper% (
    echo.
    echo Errore 7-Zip: il file "%zipper%" non esiste.
    echo.
    pause
    exit /b 1
)

rem Eliminazione versioni precedenti
del %FileName%
del %FileNameSetup%
del %FileNameSetupZip%

rem Creazione procedura di setup
%innoExe% rscite.iss
rem Creazione zip contenente procedura di setup
%zipper% a %FileNameSetupZip% %FileNameSetup%

rem Creazione versione portabile
%zipper% a %FileName% "..\sources\distro"
%zipper% a %FileName% "..\sources\distro_dll\*.*"
%zipper% rn %FileName% "distro" "RSciTE"
%zipper% rn %FileName% "wscitecm64_en.dll" "RSciTE\wscitecm64_en.dll"
%zipper% rn %FileName% "wscitecm64_it.dll" "RSciTE\wscitecm64_it.dll"

rem echo %Major%
rem echo %FileName%

pause
