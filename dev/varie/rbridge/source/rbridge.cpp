/*********************************************************************
RLuaBridge
Copyright (C) 2011 Roberto Rossi 
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

extern "C"
{
	#include <lauxlib.h>
}

#ifndef WIN32
  #error "Only for Win32!"
#endif

#include <windows.h>
#include "rbridge.h"
#include "clFxLink.h"

int errorCode = 0;

BOOL WINAPI DllMain(
    HINSTANCE hinstDLL,  // handle to DLL module
    DWORD fdwReason,     // reason for calling function
    LPVOID lpReserved )  // reserved
{

    // Perform actions based on the reason for calling.
    switch( fdwReason ) 
    { 
        case DLL_PROCESS_ATTACH:
         // Initialize once for each new process.
         // Return FALSE to fail DLL load.
            break;
        case DLL_THREAD_ATTACH:
         // Do thread-specific initialization.
            break;
        case DLL_THREAD_DETACH:
         // Do thread-specific cleanup.
            break;
        case DLL_PROCESS_DETACH:
         // Perform any necessary cleanup.
            break;
    }
    return TRUE;  // Successful DLL_PROCESS_ATTACH.
}

LUALIB_API int c_fxbridbe(lua_State *L)
{
	/* TODO : da implementare
		- funzione con parametri variabili
		- il primo argomento è il nome della libreria da caricare
		- il secondo argomento è il nome della funzione da richiamare
		- il terzo parametro è il tipo di dato ritornato dalla funzione chiamata
		- a seguire, gruppi di due parametri in cui il primo è tipo di dato
			e il secondo è il dato da passare alla funzione chiamata

		I tipi di dato supportati sono :
		- STRING = 1;
		- INTEGER = 2;
		- REAL = 3;
		- NULL = 0;

		Il numero massimo di parametri passabili alla funzione chiamata è 10
	*/

	//TODO : verifica correttezza tipi
	const int n = lua_gettop(L); //numero parametri
	int i = 0;
	bool errorState = false;
	bool isType = true;
	div_t res;
	int value_first_par;
	lua_Integer valueint;
	lua_Number valuereal;
	const char *valuestring;
	
	if (n < 3) 
	{
		//pochi parametri
		errorCode = 100;
		errorState = true;
	}

	if (n > ((BRIDGE_MAX_PAR * 2) + 3) ) 
	{
		//troppi parametri
		errorCode = 110;
		errorState = true;
	}


	if(!errorState)
	{
		//verifica tipi parametri
		if ((lua_type(L,1) != LUA_TSTRING) ||
			(lua_type(L,2) != LUA_TSTRING) ||
			(lua_type(L,3) != LUA_TNUMBER))
		{
			//tipo primi 3 parametri errato
			errorCode = 200;
			errorState = true;
		}

		//verifica numero parametri successivi
		if (n > 3)
		{
			res = div((n - 3), 2);
			if (res.rem > 0)
			{
				//il numero di parametri dopo il terzo deve essere
				//multiplo di 2
				errorCode = 201;
				errorState = true;
			}
		}

		i = 4; //analisi parametri dal quarto
		while ((!errorState) && (i <= n))
		{
			if (isType && (lua_type(L,n) != LUA_TNUMBER))
			{
				//errore in un parametro che specifica il tipo
				errorCode = 210;
				errorState = true;
			}

			if (isType && (lua_type(L,n) == LUA_TNUMBER))
			{
				value_first_par = lua_tointeger(L, n);
			}

			//TODO : verifica secondo parametro
			if (!isType)
			{
				if(value_first_par == BRIDGE_TYPE_INT)
				{
					valueint = lua_tointeger(L, n);
				} else if(value_first_par == BRIDGE_TYPE_REAL)
				{
					valuereal = lua_tonumber(L, n);
				} else if(value_first_par == BRIDGE_TYPE_STRING)
				{
					valuestring = lua_tostring(L, n);
				}
			}

			isType = !isType;
		}

	}


	if (errorState)
	{
		lua_error(L); 
		lua_pushnil(L);
	}
 return 1;
}

LUALIB_API int c_test(lua_State *L)
{

	lua_pushstring(L, "Essere o non essere questo è il problema");
 return 1;
}