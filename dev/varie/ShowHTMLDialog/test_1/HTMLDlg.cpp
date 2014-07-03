/**************************************************************************
   THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
   ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
   PARTICULAR PURPOSE.

   Copyright 2000 Microsoft Corporation.  All Rights Reserved.
**************************************************************************/

/**************************************************************************

   File:          HTMLDlg.cpp
   
**************************************************************************/

/**************************************************************************
   Include Files
**************************************************************************/

#include <windows.h>
#include <urlmon.h>
#include <mshtmhst.h>

#define ARRAYSIZE(a)    (sizeof(a)/sizeof((a)[0]))

int BSTRToLocal(LPTSTR pLocal, BSTR pWide, DWORD dwChars);
int LocalToBSTR(BSTR pWide, LPTSTR pLocal, DWORD dwChars);

/**************************************************************************

   WinMain()

**************************************************************************/

int PASCAL WinMain(  HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR lpCmdLine,
                     int nCmdShow)
{
HINSTANCE   hinstMSHTML = LoadLibrary(TEXT("MSHTML.DLL"));

if(hinstMSHTML)
   {
   SHOWHTMLDIALOGFN  *pfnShowHTMLDialog;
      
   pfnShowHTMLDialog = (SHOWHTMLDIALOGFN*)GetProcAddress(hinstMSHTML, TEXT("ShowHTMLDialog"));

   if(pfnShowHTMLDialog)
      {
      IMoniker *pmk;
      TCHAR    szTemp[MAX_PATH*2];
      OLECHAR  bstr[MAX_PATH*2];

      lstrcpy(szTemp, TEXT("res://"));
      GetModuleFileName(hInstance, szTemp + lstrlen(szTemp), ARRAYSIZE(szTemp) - lstrlen(szTemp));
      lstrcat(szTemp, TEXT("/HTML_RESOURCE"));

      LocalToBSTR(bstr, szTemp, ARRAYSIZE(bstr));

      CreateURLMoniker(NULL, bstr, &pmk);

      if(pmk)
         {
         HRESULT  hr;
         VARIANT  varArgs, varReturn;
         
         VariantInit(&varReturn);

         varArgs.vt = VT_BSTR;
         varArgs.bstrVal = SysAllocString(L"Argument 1;Argument 2;Argument 3;Argument 4");

         hr = (*pfnShowHTMLDialog)(NULL, pmk, &varArgs, NULL, &varReturn);

         VariantClear(&varArgs);
         
         pmk->Release();

         if(SUCCEEDED(hr))
            {
            switch(varReturn.vt)
               {
               case VT_BSTR:
                  {
                  TCHAR szData[MAX_PATH];

                  BSTRToLocal(szData, varReturn.bstrVal, ARRAYSIZE(szData));

                  wsprintf(szTemp, TEXT("The selected item was \"%s\"."), szData);

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

