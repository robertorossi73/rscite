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

#include <wchar.h>
#include <sstream>

//definizione nome modulo LUA
#define LS_NAMESPACE    "rwfx"

//Ritorna l'HWND dell'DirectorExtension di Scite
HWND GetHWNDDirectorExtension (void);

//scrive un testo nel file indicato
int writeStrinToTmp(const char*, const char*);
int writeStrinToTmpW(const wchar_t*, const wchar_t*);

//converte un char in wchar_t
const wchar_t* CharToW(const char*);
void DeleteChToW(const wchar_t*); //elimna la stringa convertita da CharToW

//converte un buffer di char codificato utf-8 in wchar_t
std::wstring UTF8CharToWChar(const char*);

//converte un buffer di wchar_t codificato utf-8 in char_t
std::string WCharToUTF8Char(const wchar_t*);

//visualizza messaggio di errore
void showErrorMsg ( const char*  );

//definizione per funzione esterna
typedef long (__cdecl *EXTERNALFX)(char *, const long,
	const char*, const char*, const char*, const char*, const char*,
	const long, const long, const long, const long,
	const double, const double, const double, const double);