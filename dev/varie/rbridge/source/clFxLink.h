/*
Questa classe gestisce la chimata alla funzione esterna




*/

#ifndef CLFXLINK_HEADER_DEF
#define CLFXLINK_HEADER_DEF

#include "rbridge.h"
#include <Windows.h>
#include <vector>
#include <string>

class clFxParam {
public:
	int typeParam;
	std::string strData;
	long intData;
	double realData;
};

class clFXLink {

private:
	std::vector<clFxParam> listParams;
	std::string dlname;
	std::string fxname;

	long stringResultMaxDim;

	int typeResult;
	std::string stringResult;
	long intResult;
	double realResult;

	int p_execute()
	{
		int result = 0;
		HMODULE hmod;
		int nparams = listParams.size();
		EXTERNALFX0 pFx0;
		EXTERNALFX1 pFx1;
		EXTERNALFX2 pFx2;
		EXTERNALFX3 pFx3;
		EXTERNALFX4 pFx4;
		EXTERNALFX5 pFx5;
		EXTERNALFX6 pFx6;
		EXTERNALFX7 pFx7;
		EXTERNALFX8 pFx8;
		EXTERNALFX9 pFx9;
		EXTERNALFX10 pFx10;
		this->stringResultMaxDim = 300000; //TODO : spostare inizializzazione altrove!
		char *buffer = new char[this->stringResultMaxDim];

		hmod = LoadLibrary(this->dlname.c_str());
		if (hmod)
		{
			switch(nparams)
			{
				case 0:
					pFx0 = (EXTERNALFX0) GetProcAddress(hmod, this->fxname.c_str());
				   if(NULL != pFx0)
				   {
						switch(this->typeResult)
						{
							case BRIDGE_TYPE_NULL:
								pFx0(NULL);
								break;
							case BRIDGE_TYPE_INT:
								pFx0(&this->intResult);
								break;
							case BRIDGE_TYPE_REAL:
								pFx0(&this->realResult);
								break;
							case BRIDGE_TYPE_STRING:
								buffer[0] = '\0';
								pFx0(buffer);
								this->stringResult.assign(buffer);
								break;							
						}
					  
				   }
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
					break;
				case 7:
					break;
				case 8:
					break;
				case 9:
					break;
				case 10:
					break;
			}
			FreeLibrary(hmod);
		}

		free(buffer);
		return result;
	}

public:
	void addParam(int typeParam, std::string strData, int intData, double realData)
	{
		clFxParam objPar;

		objPar.typeParam = typeParam;
		objPar.strData = strData;
		objPar.intData = intData;
		objPar.realData = realData;
		this->listParams.push_back(objPar);
	}

	void setDlData(std::string dlName, std::string fxName, int typeResult)
	{
		//TODO : dati per chiamata
		this->dlname = dlName;
		this->fxname = fxName;
		this->typeResult = typeResult;
	}

	long execute(void)
	{
		this->p_execute();

		return this->intResult;
	}



};

#endif