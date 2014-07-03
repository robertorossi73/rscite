rem Batch per Esecuzione compilatore Visual C++ -------------------------------
rem Esecuzione vcvars32/64.bat
rem C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat
cls
call %1
rem esecuzione compilazione file
cl %2
