/*********************************************************************
RLuaWfx
Copyright (C) 2004-2023 Roberto Rossi 
Web : http://www.redchar.net

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
*********************************************************************/

#include <windows.h>
#include <stdio.h>
#include "commutil.h"

//funzione callback per GetHWNDDirectorExtension
BOOL CALLBACK EnumWindowsProcForDirExt(HWND  hwnd, LPARAM lParam)
{
  HWND* result = (HWND*)lParam;
  char buff[256];

  GetClassName(hwnd,buff,sizeof(buff));	
  if (strcmp(buff,"DirectorExtension") == 0) {
	  *result = hwnd;
  }
  return TRUE;
}

//ritorna l'HWND del DirectorExtention di SciTE
HWND GetHWNDDirectorExtension (void)
{
  HWND result;

  result = NULL;
  EnumWindows(EnumWindowsProcForDirExt, (LPARAM)&result);
  return result;
}


//scrive un testo nel file di scambio temporaneo specificato
int writeStrinToTmp(const char* origin, const char* fileName)
{
    FILE* stream;
    int res;

    stream = fopen(fileName, "w");
    if (stream == NULL)
        return 0; //impossibile aprire file di scambio
    res = fprintf(stream, origin);
    if (res < 0)
        return -1; //impossibile scrivere nel file di scambio
    if (fclose(stream) != 0)
        return -2; //impossibile chiudere il file di scambio

    return 1;
}

int writeStrinToTmpW(const wchar_t* origin, const wchar_t* fileName)
{
    FILE* stream;
    int res;
    size_t  strSize;

    stream = _wfopen(fileName, L"wt,ccs=UTF-8");
    if (stream == NULL)
        return 0; //impossibile aprire file di scambio
    
    rewind(stream); //riposiziona all'inizio per eliminare la BOM

    strSize = wcslen(origin);
    if (fwrite(origin, sizeof(wchar_t), strSize, stream) != strSize)
        return -1;

    if (fclose(stream) != 0)
        return -2; //impossibile chiudere il file di scambio

    return 1;
}

//visualizza una dialog di errore contenente il messaggio specificato
void showErrorMsg ( const char* msg )
{
  HWND hwndOwner;
  if ((hwndOwner = GetActiveWindow()) == NULL) {
          hwndOwner = GetDesktopWindow();
      }
  MessageBox(hwndOwner,msg,"Error",MB_OK | MB_ICONERROR);
}

std::wstring UTF8CharToWChar(const char* c)
{
    std::wstring wmsg = L"";
    int convertResult = MultiByteToWideChar(CP_UTF8, 0, c, (int)strlen(c), NULL, 0);
    if (convertResult > 0)
    {
        wmsg.resize(convertResult + 10);
        convertResult = MultiByteToWideChar(CP_UTF8, 0, c, (int)strlen(c), &wmsg[0], (int)wmsg.size());
        if (convertResult <= 0)
        {
            wmsg = L"";
        }
    }
    return wmsg;
}

std::string WCharToUTF8Char(const wchar_t* c)
{
    std::string res;
    size_t len = wcslen(c);
    size_t maxUtf8len = 4 * len + 1;  // Each wchar_t encodes to a max of 4 bytes
    char* utf8String = new char[maxUtf8len];
    WideCharToMultiByte(CP_UTF8, 0, c, len + 1, utf8String, maxUtf8len, NULL, NULL);

    res.assign(utf8String);

    delete[] utf8String;

    return res;
}
