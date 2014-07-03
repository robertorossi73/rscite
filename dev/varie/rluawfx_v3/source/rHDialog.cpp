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
#include <urlmon.h>
#include <mshtmhst.h>

#define ARRAYSIZE(a)    (sizeof(a)/sizeof((a)[0]))
#define MAX_DATA_LEN 32000

int BSTRToLocal(LPTSTR pLocal, BSTR pWide, DWORD dwChars);
int LocalToBSTR(BSTR pWide, LPTSTR pLocal, DWORD dwChars);

/**************************************************************************

   WinMain()

**************************************************************************/

extern "C" int start_ShowHTMLDialog(	HWND parent, 
							char* filename, 
							DWORD dwFlags, 
							char* options, 
							char* dataIn, 
							char* dataOut, 
							long dataOutLen)
{
HINSTANCE   hinstMSHTML = LoadLibrary(TEXT("MSHTML.DLL"));

if(hinstMSHTML)
   {
   SHOWHTMLDIALOGEXFN  *pfnShowHTMLDialog;
      
   pfnShowHTMLDialog = (SHOWHTMLDIALOGEXFN*)GetProcAddress(hinstMSHTML, TEXT("ShowHTMLDialogEx"));

   if(pfnShowHTMLDialog)
      {
      IMoniker *pmk;
      TCHAR    szTemp[MAX_PATH*2];
      OLECHAR  bstr[MAX_PATH*2];
	  OLECHAR  bstr2[MAX_PATH*2];
	  OLECHAR  bstrDataIn[MAX_DATA_LEN*2];

      LocalToBSTR(bstr, filename, ARRAYSIZE(bstr));
      CreateURLMoniker(NULL, bstr, &pmk);

      if(pmk)
        {
        HRESULT  hr;
        VARIANT  varArgs, varReturn;
        
        VariantInit(&varReturn);
        varArgs.vt = VT_BSTR;
		LocalToBSTR(bstrDataIn, dataIn, ARRAYSIZE(bstrDataIn));
        varArgs.bstrVal = SysAllocString(bstrDataIn);

		LocalToBSTR(bstr2, options, ARRAYSIZE(bstr2));
		//DWORD dwFlags = (HTMLDLG_MODAL | HTMLDLG_VERIFY);
		hr = (*pfnShowHTMLDialog)(parent, pmk, dwFlags, &varArgs, bstr2, &varReturn);

         VariantClear(&varArgs);
         
         pmk->Release();

         if(SUCCEEDED(hr))
            {
            switch(varReturn.vt)
               {
               case VT_BSTR:
                  {
                  BSTRToLocal(dataOut, varReturn.bstrVal, dataOutLen);
				  wsprintf(szTemp, TEXT("The selected item was \"%s\"."), dataOut);
                  VariantClear(&varReturn);
                  }
                  break;

               default:
                  lstrcpy(szTemp, TEXT("Cancel was selected."));
                  break;
               }
            MessageBox(NULL, szTemp, TEXT("HTML Dialog Sample"), MB_OK | MB_ICONINFORMATION);
            }
         else
            MessageBox(NULL, TEXT("ShowHTMLDialog Failed."), TEXT("HTML Dialog Sample"), MB_OK | MB_ICONERROR);
            
         }
      }
   FreeLibrary(hinstMSHTML);
   }

return 0;
}

/**************************************************************************

   BSTRToLocal()
   
**************************************************************************/

int BSTRToLocal(LPTSTR pLocal, BSTR pWide, DWORD dwChars)
{
*pLocal = 0;

#ifdef UNICODE
lstrcpyn(pLocal, pWide, dwChars);
#else
WideCharToMultiByte( CP_ACP, 
                     0, 
                     pWide, 
                     -1, 
                     pLocal, 
							dwChars, 
                     NULL, 
                     NULL);
#endif

return lstrlen(pLocal);
}

/**************************************************************************

   LocalToBSTR()
   
**************************************************************************/

int LocalToBSTR(BSTR pWide, LPTSTR pLocal, DWORD dwChars)
{
*pWide = 0;

#ifdef UNICODE
lstrcpyn(pWide, pLocal, dwChars);
#else
MultiByteToWideChar( CP_ACP, 
                     0, 
                     pLocal, 
                     -1, 
                     pWide, 
                     dwChars); 
#endif

return lstrlenW(pWide);
}

