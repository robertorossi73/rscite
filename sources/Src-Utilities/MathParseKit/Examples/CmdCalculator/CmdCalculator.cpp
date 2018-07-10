#include <iostream>
#include <MParser.h>

using namespace mpk;

int wmain(int argc, wchar_t* argv[])
{
	std::wstring arg;
	bool only_variables = false;
	bool get_variables_from_args = false;

	//Check if parameter is present
	if (argc < 2) return 0;

	arg.append(argv[1]);

	if (arg == L"-v")
	{ //print only variables
		if (argc < 3) return 0;
		arg.assign(argv[2]);
		only_variables = true;	
	}
	else if (arg == L"-vs")
	{ //get variables values from command line
		if (argc < 3) return 0;
			arg.assign(argv[2]);
			get_variables_from_args = true;
	}
	else
	{
		arg.assign(argv[1]);
	}

	//Initialize praser
	MParser parser;
	//Parse Parameter
	MFunction *f = parser.ParseFunction(arg.c_str());
	if (f == NULL)
	{
		std::wcout << "Error " << parser.GetLastError() << " at Position " << parser.GetErrorPosition();
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
			std::wcout << "Error.\nMissing Values!";
			return 0;
		}
	}

	//Ask for Variables values
	for (int i = 0; i<list.Count(); i++)
	{
		if (i > 0)
			std::wcout << L"|";

		std::wcout << list.GetItem(i)->GetName();
		double value;
		if (!only_variables)
		{
			if (get_variables_from_args)
			{
				value = _wtof(argv[i + 3]);
			}
			else
				std::wcin >> value;
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
			std::cout << "\nResult=" << ((MFConst*)ret)->GetValue();
		}

		//Release objects
		ret->Release();
	}
	f->Release();

	return 0;
}