echo off
cls
rem ricerca versione Java
FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment" /v CurrentVersion') DO set JavaCurVer=%%B
IF "%JavaCurVer%"=="" GOTO nontrovato

rem path java
rem FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment\%JavaCurVer%" /v JavaHome') DO set JAVA_HOME=%%B
echo %JavaCurVer%
echo trovato
GOTO fine

:notrovato
@echo NON trovato

:fine
