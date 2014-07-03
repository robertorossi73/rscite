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

//#include "stdafx.h"
#include <Windows.h>
//#include <stdio.h>

/*
 * UnicodeToAnsi converts the Unicode string pszW to an ANSI string
 * and returns the ANSI string through ppszA. Space for the
 * the converted string is allocated by UnicodeToAnsi.
 */ 

HRESULT UnicodeToAnsi(LPCOLESTR pszW, char *buffer, int maxLen)
{

    ULONG cbAnsi, cCharacters;
    DWORD dwError;
	LPSTR ppszA;

    // If input is null then just return the same.
    if (pszW == NULL)
    {
        return NOERROR;
    }

    cCharacters = wcslen(pszW)+1;
    // Determine number of bytes to be allocated for ANSI string. An
    // ANSI string can have at most 2 bytes per character (for Double
    // Byte Character Strings.)
    cbAnsi = cCharacters*2;

    // Use of the OLE allocator is not required because the resultant
    // ANSI  string will never be passed to another COM component. You
    // can use your own allocator.
    ppszA = (LPSTR) CoTaskMemAlloc(cbAnsi);
    if (NULL == ppszA)
        return E_OUTOFMEMORY;

    // Convert to ANSI.
    if (0 == WideCharToMultiByte(CP_ACP, 0, pszW, cCharacters, ppszA,
                  cbAnsi, NULL, NULL))
    {
        dwError = GetLastError();
        CoTaskMemFree(ppszA);
        ppszA = NULL;
        return HRESULT_FROM_WIN32(dwError);
    }

	strncpy(buffer, ppszA,maxLen);
	CoTaskMemFree(ppszA);
    return NOERROR;

}
/*int _tmain(int argc, _TCHAR* argv[])
{

	GUID id;
	WCHAR buffer[255];
	char buffer_char[255];
	FILE *stream = NULL;
	int nguid;
	int i;

	if (argc > 1)
	{
		nguid = atoi(argv[1]);
		if (nguid > 0) {
			if (argc > 2)
				stream = fopen( argv[2], "w" );		

			//TODO : gestire msg errore se non si riesce ad aprire il file

			for (i=0;i<nguid;i++) {
				CoCreateGuid(&id);
				StringFromGUID2(id,buffer,254);
				UnicodeToAnsi(buffer,buffer_char,sizeof(buffer_char)-1);
				if (stream != NULL) {
					if (i>0)
						fprintf( stream, "\n", buffer_char);
					fprintf( stream, "%s", buffer_char);
				} else
					printf("%s\n", buffer_char); //se non esiste file, visualizza i valori				
			}

			if (stream != NULL) {
				fclose( stream );
			}//endif
		} else { //controllo nguid
			//TODO : msg errore per numero errato!
		}
	} else {
		//TODO : inserire help
	}
	return 0;
}*/

