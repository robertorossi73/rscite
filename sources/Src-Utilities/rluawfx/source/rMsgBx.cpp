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

//#include "stdafx.h"
#include <..\..\luascite\include\lualib.h>
#include "rMsgBx.h"
#include "commutil.h"

LRESULT CALLBACK rMsgBx_hookProc(INT, WPARAM, LPARAM );

HHOOK rMsgBx_hhk; //windowsHook
std::wstring rMsgBx_okButtonLabel;
std::wstring rMsgBx_yesButtonLabel;
std::wstring rMsgBx_noButtonLabel;
std::wstring rMsgBx_cancelButtonLabel;
std::wstring rMsgBx_retryButtonLabel;
std::wstring rMsgBx_abortButtonLabel;

void rMsgBx_new (void) //initialize dialog
{
	rMsgBx_okButtonLabel = L"";
	rMsgBx_yesButtonLabel = L"";
	rMsgBx_noButtonLabel = L"";
	rMsgBx_cancelButtonLabel = L"";
	rMsgBx_retryButtonLabel = L"";
	rMsgBx_abortButtonLabel = L"";
}

int rMsgBx_is_customized (void) //check customize button
{
	int result;

	result = 0;
	if ((rMsgBx_okButtonLabel != L"") ||
		(rMsgBx_yesButtonLabel != L"") ||
		(rMsgBx_noButtonLabel != L"") ||
		(rMsgBx_cancelButtonLabel != L"") ||
		(rMsgBx_retryButtonLabel != L"") ||
		(rMsgBx_abortButtonLabel != L"")
		)
		result = 1;

	return result;
}

void rMsgBx_setLabel(int typeLabel, std::wstring label)
{

  switch (typeLabel)
  {
  case OkButtonLabel:
    rMsgBx_okButtonLabel = label;
    break;
  case YesButtonLabel:
    rMsgBx_yesButtonLabel = label;
    break;
  case NoButtonLabel:
    rMsgBx_noButtonLabel = label;
    break;
  case CancelButtonLabel:
    rMsgBx_cancelButtonLabel = label;
    break;
  case RetryButtonLabel:
    rMsgBx_retryButtonLabel = label;
    break;
  case AbortButtonLabel:
    rMsgBx_abortButtonLabel = label;
    break;
  }
}

int rMsgBx_show(HWND hwnd, const wchar_t lpText[], const wchar_t lpCaption[], UINT uType)
{
	int result;
	if (rMsgBx_is_customized() > 0)
	{
		rMsgBx_hhk = SetWindowsHookEx(WH_CBT, &rMsgBx_hookProc, 0, GetCurrentThreadId());
	}
	
	result = MessageBoxW(hwnd, lpText, lpCaption, uType);
	rMsgBx_new();
   return result;
}

LRESULT CALLBACK rMsgBx_hookProc(INT nCode, WPARAM wParam, LPARAM lParam)
{
   HWND hChildWnd;
   UINT result;

   hChildWnd = (HWND)wParam;

   if (nCode == HCBT_ACTIVATE)
   {
      if ((GetDlgItem(hChildWnd,IDYES)!=NULL) && (rMsgBx_yesButtonLabel != L""))
      {
		result = SetDlgItemTextW(hChildWnd,IDYES,rMsgBx_yesButtonLabel.c_str());
      }
    if ((GetDlgItem(hChildWnd,IDOK)!=NULL) && (rMsgBx_okButtonLabel != L""))
      {
		result = SetDlgItemTextW(hChildWnd,IDOK,rMsgBx_okButtonLabel.c_str());
      }
    if ((GetDlgItem(hChildWnd,IDNO)!=NULL) && (rMsgBx_noButtonLabel != L""))
      {
		result = SetDlgItemTextW(hChildWnd,IDNO,rMsgBx_noButtonLabel.c_str());
      }
    if ((GetDlgItem(hChildWnd,IDCANCEL)!=NULL) && (rMsgBx_cancelButtonLabel != L""))
      {
		result = SetDlgItemTextW(hChildWnd,IDCANCEL, rMsgBx_cancelButtonLabel.c_str());
      }
    if ((GetDlgItem(hChildWnd,IDRETRY)!=NULL) && (rMsgBx_retryButtonLabel != L""))
      {
		result = SetDlgItemTextW(hChildWnd,IDRETRY,rMsgBx_retryButtonLabel.c_str());
      }
    if ((GetDlgItem(hChildWnd,IDABORT)!=NULL) && (rMsgBx_abortButtonLabel != L""))
      {
		result = SetDlgItemTextW(hChildWnd,IDABORT,rMsgBx_abortButtonLabel.c_str());
      }

      UnhookWindowsHookEx(rMsgBx_hhk);
   }
   else CallNextHookEx(rMsgBx_hhk, nCode, wParam, lParam);
   return 0;
}


