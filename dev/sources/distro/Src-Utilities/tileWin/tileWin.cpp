/*********************************************************************
tileWin
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

// Questa applicazione, dato il parziale del titolo di una
// finestra, prende tutte le finestre con quelsto titolo e
// le affianca in orizzontale o verticale

#include <windows.h>
#include <string>
#include "tileWin.h"

#define SIZE_LIST 100
#define SIZE 300
#define FIND_APP_NAME " SciTE"

HWND local_windows_list[SIZE_LIST]; //contiene l'elenco delle finestre trovate
int  local_current_index;


void print_info(void)
{
  std::string msg;

  msg.append("*********************************************************************");
  msg.append("\ntileWin");
  msg.append("\nCopyright (C) 2004-2013 Roberto Rossi ");
  msg.append("\nWeb : http://www.redchar.net\n");

  msg.append("\nThis library is free software; you can redistribute it and/or");
  msg.append("\nmodify it under the terms of the GNU Lesser General Public");
  msg.append("\nLicense as published by the Free Software Foundation; either");
  msg.append("\nversion 2.1 of the License, or (at your option) any later version.\n");

  msg.append("\nThis library is distributed in the hope that it will be useful,");
  msg.append("\nbut WITHOUT ANY WARRANTY; without even the implied warranty of");
  msg.append("\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU");
  msg.append("\nLesser General Public License for more details.\n");

  msg.append("\nYou should have received a copy of the GNU Lesser General Public");
  msg.append("\nLicense along with this library; if not, write to the Free Software");
  msg.append("\nFoundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA");
  msg.append("\n*********************************************************************");

  MessageBox(NULL, msg.c_str(), "Info", MB_OK);
}


//ritorna il numero di finestre da affiancare, presenti in local_windows_list
int count_windows()
{
  int i;
  int c=0;

  for(i=0;i<SIZE_LIST;i++)
  {
    if (local_windows_list[i]==0){
      break;
    }
    c++;
  }

  return c;
}

//esegue l'affiancamento delle finestre
void execute_tile(int type_tile)
{
  int i;
  int nw;
  int xvid, yvid; //dimensioni video
  int x,y,w,h; //dimensioni
  HWND hwndWin;
  RECT r;

  nw = count_windows(); //finestre da affiancare
  if (nw > 1) //se esistono più finestre
  {
    SystemParametersInfo(SPI_GETWORKAREA, 0, &r, 0);

    // width
    xvid = r.right;
    // height
    yvid = r.bottom;

    if (type_tile == 0) //allineamento orizzontale
    {
      w = xvid / nw;
      h = yvid;
    } else {
      w = xvid;
      h = yvid / nw;
    }
    
    x = r.left;
    y = r.top;

    for( i=0 ; i < nw ; i++) //ciclo di affiancamento
    {
      hwndWin=local_windows_list[i];
      if (type_tile == 0) //allineamento orizzontale
      {
        x = w * i;
      } else { //allineamento verticale
        y = h * i;
      }
      if (IsZoomed(hwndWin) != 0)
        ShowWindow(hwndWin,SW_RESTORE);
      MoveWindow(hwndWin,x,y,w,h,TRUE);
      SetWindowPos(hwndWin,HWND_TOPMOST,x,y,w,h,SWP_NOMOVE | SWP_NOSIZE | SWP_NOREPOSITION);
      SetWindowPos(hwndWin,HWND_NOTOPMOST,x,y,w,h,SWP_NOMOVE | SWP_NOSIZE | SWP_NOREPOSITION);
      ShowWindow(hwndWin,SW_SHOW);
    }
  }//endif
}

//reset array generale per la lista finestre
void reset_windows_list()
{
  int i;

  for(i=0;i<SIZE_LIST;i++)
  {
    local_windows_list[i]=0;
  }
}

BOOL CALLBACK EnumWndProc(HWND hWnd,LPARAM lParam){
 char pTitle[SIZE];
 char buffer[1000];

 GetWindowText(hWnd,pTitle,SIZE);
 GetClassName(hWnd, buffer, sizeof(buffer));
 if (strstr(pTitle, FIND_APP_NAME))
 {
	if (strstr(buffer, "SciTEWindow"))
	{
   //h = GetParent(hWnd);
   //if (h == 0) {
    local_windows_list[local_current_index]=hWnd;
    local_current_index++;
	}
   //}
 }
 
 return TRUE;
}

int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPTSTR    lpCmdLine,
                     int       nCmdShow)
{
  int type_tile = -1;
  local_current_index = 0;

  if (strcmp(lpCmdLine,"-v") == 0)
    type_tile = 1;

  if (strcmp(lpCmdLine,"-o") == 0)
    type_tile = 0;

  if (type_tile > -1)
  {
    reset_windows_list();
    EnumWindows(EnumWndProc,0);
    execute_tile(type_tile);
  } else
    print_info();

	return (int) 1;
}


