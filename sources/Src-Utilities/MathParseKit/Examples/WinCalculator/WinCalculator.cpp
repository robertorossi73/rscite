// WinCalculator.cpp: definisce il punto di ingresso dell'applicazione.
//

#include "stdafx.h"
#include "WinCalculator.h"
#include <shellapi.h>
#include <string>
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream
#include <fstream>      // std::ofstream
#include <vector>
#include <MParser.h>

using namespace mpk;

#define MAX_LOADSTRING 100

// Variabili globali:
HINSTANCE hInst;                                // istanza corrente
WCHAR szTitle[MAX_LOADSTRING];                  // Testo della barra del titolo
WCHAR szWindowClass[MAX_LOADSTRING];            // nome della classe di finestre principale

//TODO : da completare
int executeCalc(std::vector<std::wstring> argv)
{
	int argc;
	std::wstring arg;
	bool only_variables = false;
	bool get_variables_from_args = false;
	std::wofstream objFile;

	argc = argv.capacity();

	//Check if parameters are present
	//[output file] [option v/vs] [expression] [var1 value] [var2 value] ...
	if (argc < 4) return 0;

	objFile.open(argv[1], std::ofstream::out);
	
	if (objFile.fail())
	{
		return 0;
	}

	arg.append(argv[2]);

	if (arg == L"-v")
	{ //print only variables
		if (argc < 4) return 0;
		arg.assign(argv[3]);
		only_variables = true;
	}
	else if (arg == L"-vs")
	{ //get variables values from command line
		if (argc < 4) return 0;
		arg.assign(argv[3]);
		get_variables_from_args = true;
	}
	else
	{
		arg.assign(argv[2]);
	}

	//Initialize praser
	MParser parser;
	//Parse Parameter
	MFunction *f = parser.ParseFunction(arg.c_str());
	if (f == NULL)
	{
		//std::wcout << "Error " << parser.GetLastError() << " at Position " << parser.GetErrorPosition();
		return 0;
	}

	//Get Variables inside the function
	MVariablesList list;
	f->GetVariablesList(&list);

	if (get_variables_from_args)
	{
		//verifica presenza di tutti i parametri necessari
		if (argc < 3 + list.Count())
		{
			//std::wcout << "Error.\nMissing Values!";
			return 0;
		}
	}

	//Ask for Variables values
	for (int i = 0; i<list.Count(); i++)
	{
		double value;
		if (!get_variables_from_args)
		{
			if (i > 0)
				objFile << L"|";

			objFile << list.GetItem(i)->GetName();
		}

		if (!only_variables)
		{
			if (get_variables_from_args)
			{
				value = _wtof(argv[i + 4].c_str());
			}
			/*else*
				std::wcin >> value;*/
			list.GetItem(i)->SetValue(value);
		}
	}

	if (!only_variables)
	{
		//Solve
		MFunction *ret = f->Solve(&list);

		//Check solution type
		if (ret->GetType() == MF_CONST)
		{
			objFile << ((MFConst*)ret)->GetValue();
		}

		//Release objects
		ret->Release();
	}

	objFile.close();
	f->Release();

	return 0;
}

//ritorna l'elenco dei parametri passati al programma
std::vector<std::wstring> getPars()
{
	std::vector<std::wstring> result;

	LPWSTR *szArgList;
	int argCount;

	szArgList = CommandLineToArgvW(GetCommandLine(), &argCount);

	for (int i = 0; i < argCount; i++)
	{
		result.push_back(szArgList[i]);
	}

	LocalFree(szArgList);

	return result;
}

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPWSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
	std::vector<std::wstring> pars;

    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);
	// Inizializzare le stringhe globali
	LoadStringW(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadStringW(hInstance, IDC_WINCALCULATOR, szWindowClass, MAX_LOADSTRING);

	pars = getPars();

	executeCalc(pars);

    return 0;
}



