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

#include <windows.h>
#include <wchar.h>
#include <sstream>

#ifndef _MODRMSGBX_
#define _MODRMSGBX_

  typedef enum rMsgBx {
	  NullButton1, 
      OkButtonLabel, //1
	  CancelButtonLabel, //2
      AbortButtonLabel, //3
	  RetryButtonLabel, //4
	  IgnoreButtonLabel, //5
	  YesButtonLabel, //6
      NoButtonLabel, //7
	  NullButton2,
	  NullButton3,
	  TryAgainButtonLabel, //10
	  ContinueButtonLabel //11	  
   } rMsgBx;

  int rMsgBx_show(HWND, const wchar_t [], const wchar_t [], UINT); //show messagebox			
  void rMsgBx_setLabel(int, std::wstring label); //set button text
  void rMsgBx_new (void); //initialize dialog
  int rMsgBx_is_customized (void); //check customize button
#endif

