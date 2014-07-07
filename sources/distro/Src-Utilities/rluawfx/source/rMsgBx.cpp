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
#include <lauxlib.h>
#include "rMsgBx.h"

LRESULT CALLBACK rMsgBx_hookProc(INT, WPARAM, LPARAM );

HHOOK rMsgBx_hhk; //windowsHook
const char *rMsgBx_okButtonLabel;
const char *rMsgBx_yesButtonLabel;
const char *rMsgBx_noButtonLabel;
const char *rMsgBx_cancelButtonLabel;
const char *rMsgBx_retryButtonLabel;
const char *rMsgBx_abortButtonLabel;

void rMsgBx_new (void) //initialize dialog
{
	rMsgBx_okButtonLabel = NULL;
	rMsgBx_yesButtonLabel = NULL;
	rMsgBx_noButtonLabel = NULL;
	rMsgBx_cancelButtonLabel = NULL;
	rMsgBx_retryButtonLabel = NULL;
	rMsgBx_abortButtonLabel = NULL;
}

int rMsgBx_is_customized (void) //check customize button
{
	int result;

	result = 0;
	if ((rMsgBx_okButtonLabel != NULL) ||
		(rMsgBx_yesButtonLabel != NULL) ||
		(rMsgBx_noButtonLabel != NULL) ||
		(rMsgBx_cancelButtonLabel != NULL) ||
		(rMsgBx_retryButtonLabel != NULL) ||
		(rMsgBx_abortButtonLabel != NULL)
		)
		result = 1;

	return result;
}

void rMsgBx_setLabel(int typeLabel, const char label[])
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

int rMsgBx_show(HWND hwnd, const char lpText[], const char lpCaption[], UINT uType)
{
	int result;
	if (rMsgBx_is_customized() > 0)
	{
		rMsgBx_hhk = SetWindowsHookEx(WH_CBT, &rMsgBx_hookProc, 0, GetCurrentThreadId());
	}
	
	result = MessageBox(hwnd, lpText, lpCaption, uType); 
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
      if ((GetDlgItem(hChildWnd,IDYES)!=NULL) && rMsgBx_yesButtonLabel)
      {
		result = SetDlgItemText(hChildWnd,IDYES,rMsgBx_yesButtonLabel);
      }
    if ((GetDlgItem(hChildWnd,IDOK)!=NULL) && rMsgBx_okButtonLabel)
      {
		result = SetDlgItemText(hChildWnd,IDOK,rMsgBx_okButtonLabel);
      }
    if ((GetDlgItem(hChildWnd,IDNO)!=NULL) && rMsgBx_noButtonLabel)
      {
		result = SetDlgItemText(hChildWnd,IDNO,rMsgBx_noButtonLabel);
      }
    if ((GetDlgItem(hChildWnd,IDCANCEL)!=NULL) && rMsgBx_cancelButtonLabel)
      {
		result = SetDlgItemText(hChildWnd,IDCANCEL, rMsgBx_cancelButtonLabel);
      }
    if ((GetDlgItem(hChildWnd,IDRETRY)!=NULL) && rMsgBx_retryButtonLabel)
      {
		result = SetDlgItemText(hChildWnd,IDRETRY,rMsgBx_retryButtonLabel);
      }
    if ((GetDlgItem(hChildWnd,IDABORT)!=NULL) && rMsgBx_abortButtonLabel)
      {
		result = SetDlgItemText(hChildWnd,IDABORT,rMsgBx_abortButtonLabel);
      }

      UnhookWindowsHookEx(rMsgBx_hhk);
   }
   else CallNextHookEx(rMsgBx_hhk, nCode, wParam, lParam);
   return 0;
}


