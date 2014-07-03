/*********************************************************************
RLuaWfx
Copyright (C) 2004-2013 Roberto Rossi 
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
int writeStrinToTmp (const char* origin, const char *fileName )
{
  FILE *stream;
  int res;

  stream = fopen(fileName,"w");
  if (stream == NULL) 
    return 0; //impossibile aprire file di scambio
  res = fprintf(stream,origin);
  if (res < 0) 
    return -1; //impossibile scrivere nel file di scambio
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
