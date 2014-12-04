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

#include <vector>
#include "commutil.h"
#include "genguid.h"
#include "mparser.h"

extern "C" 
{
	#include <lauxlib.h>
}

#ifndef WIN32
  #error "Only for Win32!"
#endif

#define MP_MAXFUNCTIONSIZE 2048

wchar_t MP_function[MP_MAXFUNCTIONSIZE];

std::vector<double> MP_values;

//ritorna il valore dell'espressione matematica impostata con c_MP_ParseFunction e c_MP_SetVariable
LUALIB_API int c_MP_Solve(lua_State *L)
{
	mpk::MParser parser;

	mpk::MFunction *f = parser.ParseFunction(MP_function);
	if (f == NULL)
	{
		lua_pushnil(L);
		return 1;
	}

	//Get Variables inside the function
	mpk::MVariablesList list;
	f->GetVariablesList(&list);

	if (list.Count() > MP_values.size())
		MP_values.resize(list.Count());

	//Variables values
	for (int i = 0; i<list.Count(); i++)
	{
		list.GetItem(i)->SetValue(MP_values.at(i));
	}

	//Solve
	mpk::MFunction *ret = f->Solve(&list);

	//Check solution type
	if (ret->GetType() == MF_CONST)
	{
		lua_pushnumber(L, ((mpk::MFConst*)ret)->GetValue());
	} else {
		lua_pushnil(L);
	}
	
	//Release objects
	f->Release();
	ret->Release();

return 1;
}

//imposta una variabile per la risoluzione dell'espressione impostata con c_MP_ParseFunction
LUALIB_API int c_MP_SetVariable(lua_State *L)
{
	const char *varName;
	wchar_t buffer[MP_MAXFUNCTIONSIZE];
	double varValue;
	const int n = lua_gettop(L);
	mpk::MParser parser;

	if ((n == 2) && 
		(lua_type(L,1)==LUA_TSTRING) && //espressione matematica da valutare
		(lua_type(L,2)==LUA_TNUMBER) //file temporaneo per risultati
		)
	{
		varName = lua_tostring(L,1); 
		varValue = lua_tonumber(L,2);

		mpk::MFunction *f = parser.ParseFunction(MP_function);

		if (f == NULL)
		{
			lua_pushnil(L);
			return 1;
		}

		//Get Variables inside the function
		mpk::MVariablesList list;
		f->GetVariablesList(&list);
		//Variables values
		if (list.Count() > 	MP_values.size())
			MP_values.resize(list.Count());

		for (int i = 0; i<list.Count(); i++)
		{
			mbstowcs(buffer, varName, strlen(varName));	
			buffer[strlen(varName)] = '\0';
			if (wcsicmp(list.GetItem(i)->GetName().c_str(), buffer) == 0)
			{
				MP_values.at(i) = varValue;
			}
		}
		f->Release();
		lua_pushboolean(L,1);
	} else {
		lua_pushnil(L);
		return 1;
	}
return 1;
}

//imposta l'espressione matematica da valutare e ritorna l'elenco delle variabili presenti
LUALIB_API int c_MP_ParseFunction(lua_State *L)
{
	wchar_t buffer[MP_MAXFUNCTIONSIZE];
	char buffer_char[MP_MAXFUNCTIONSIZE];
	const char *function;
	wchar_t wfunction[MAX_PATH];
	const char *fileName;
	const int n = lua_gettop(L);
	
	memset(buffer, '\0', sizeof(buffer));
	memset(buffer_char, '\0', sizeof(buffer_char));

	MP_values.clear();

	//Initialize praser
	mpk::MParser parser;

	if ((n == 2) && 
		(lua_type(L,1)==LUA_TSTRING) && //espressione matematica da valutare
		(lua_type(L,2)==LUA_TSTRING) //file temporaneo per risultati
		)
	{
		function = lua_tostring(L,1); //chiave principale es: HKEY_CURRENT_USER
		fileName = lua_tostring(L,2); //output filename

		mbstowcs(wfunction, function, strlen(function));
		wcscpy(MP_function, wfunction);
		MP_function[strlen(function)] = '\0';
		//Parse Parameter
		mpk::MFunction *f = parser.ParseFunction(MP_function);
		if (f == NULL)
		{
			lua_pushnil(L);
			return 1;
		}

		//Get Variables inside the function
		mpk::MVariablesList list;
		f->GetVariablesList(&list);
		//Variables values
		for (int i = 0; i<list.Count(); i++)
		{
			if (i > 0)
				wcscat(buffer, L",");

			wcscat(buffer, list.GetItem(i)->GetName().c_str());
			UnicodeToAnsi(buffer,buffer_char,sizeof(buffer_char)-1);
		}

		f->Release();

		writeStrinToTmp(buffer_char, fileName);
		lua_pushboolean(L,1);
	}

 return 1;
}