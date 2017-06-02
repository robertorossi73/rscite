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

/*
Modulo gestione dialog
*/
#include <windows.h>
#include "commutil.h"
#include "cdialog.h"
#include "resource.h"
#include "maindlg.h"

stDataDialog public_dataDialog; //dati dialog

long public_tmpSelectedItem; //elemento selezionato(temporaneo)
const char *public_tmpItemsString; //elenco voci da inserire nella lista(temporaneo)
const char *public_tmpDialogTitle; //titolo dialog(temporaneo);
const char *public_tmpDialogPrompt; //prompt dialog(temporaneo);
char *public_tmpResultsString; //trasferimento stringa (temporaneo);

char public_DllFileName[_MAX_PATH]; //file dll corrente comprensivo di percorso


//riempie la lista degli elementi della dialog lista
//ritorna il numero di elementi della lista
void LstDlg_FillList (HWND hwndDlg, char *filtro)
{
  char ch[2];
  size_t lstr;
  int i, nelementi, idx, idxOriginal;
  char item[LSTDLG_MAX_ITEM_LEN], itemMax[LSTDLG_MAX_ITEM_LEN], itemTemp[LSTDLG_MAX_ITEM_LEN];
  size_t maxLen, tmpLen;

  //svuota lista
  SendMessage(GetDlgItem(hwndDlg,IDC_LIST1),LB_RESETCONTENT, 0, 0);

  //riempimento lista in dialog
  lstr = strlen(public_tmpItemsString);
  memset(item,'\0',LSTDLG_MAX_ITEM_LEN);
  memset(itemMax,'\0',LSTDLG_MAX_ITEM_LEN);
  memset(itemTemp,'\0',LSTDLG_MAX_ITEM_LEN);
  ch[1] = '\0';
  nelementi = 0;
  maxLen = 0;
  idx = 0;
  idxOriginal = 0;
  filtro = _strupr(filtro);
  for (i=0 ; i < (int)lstr; i++)
  {
    ch[0] = public_tmpItemsString[i];          
    if (ch[0] == '|')
    {
      strcpy(itemTemp, item);
      _strupr(itemTemp);
      if((strstr(itemTemp,filtro) != NULL) || (filtro[0]=='\0'))
      {
        //aggiunta elemento a lista
        SendMessage(GetDlgItem(hwndDlg,IDC_LIST1),LB_ADDSTRING, 0, (LPARAM) item);
        //indice elemento nella lista e sua mappatura su lista originale
        public_LstDlg_data.elementMapper[idx]=idxOriginal;
        idx++;
      }
      idxOriginal++;

      tmpLen = strlen(item);
      if (maxLen < tmpLen){
        maxLen = tmpLen;
        strcpy(itemMax, item);
      }
      nelementi++;
      memset(item,'\0',LSTDLG_MAX_ITEM_LEN);
    } else {
      strcat(item, ch);
    }
  }
  if (maxLen == 0)
    strcpy(itemMax, item);

  if (item[0]!='\0') {
			strcpy(itemTemp, item);
      _strupr(itemTemp);
      if((strstr(itemTemp,filtro) != NULL) || (filtro[0]=='\0'))
      {
        //aggiunta elemento a lista
        SendMessage(GetDlgItem(hwndDlg,IDC_LIST1),LB_ADDSTRING, 0, (LPARAM) item);
        //indice elemento nella lista e sua mappatura su lista originale
        public_LstDlg_data.elementMapper[idx]=idxOriginal;
        nelementi++;
      }
  }
  //FINE riempimento lista in dialog
  
  //preselezione primo elemento
  if (nelementi > 0) 
  {
    if (public_dataDialog.tmpSelectedItemIndex > idx)
      i = 0;
    else
      i = public_dataDialog.tmpSelectedItemIndex;
    SendMessage(GetDlgItem(hwndDlg,IDC_LIST1),LB_SETCURSEL,
                i,0);
  }

  strcpy(public_LstDlg_data.itamMax,itemMax);
  public_LstDlg_data.nelementi = nelementi;
}

//salva le dimensioni e la posizione della dialog ListBox in base a 
//quanto riportato nei registri del sistema
BOOL LstDlg_SaveDimension(HWND hwndDlg, BOOL savePosDimDialog)
{
  int dimensionX, dimensionY; //dimensioniFinestra
  int posX, posY;
  RECT rcDlg;
  HKEY hk; 
  DWORD dwDisp;

  //se non è specificata l'opzione di salvataggio o non è
  //indicato il percorso di registro per il salvataggio,
  //evita di proseguire
  if ((!savePosDimDialog) || (public_dataDialog.registerKey[0]=='\0'))
    return TRUE;

  GetWindowRect(hwndDlg, &rcDlg); //dimensioni finestra client
  dimensionX = rcDlg.right - rcDlg.left;
  dimensionY = rcDlg.bottom - rcDlg.top;

  posX = rcDlg.left;
  posY = rcDlg.top;
  
  //evita di scrivere i dati se questi non sono cambiati
  if ((public_dataDialog.tmpDimensionX == dimensionX) &&
      (public_dataDialog.tmpDimensionY == dimensionY) &&
      (public_dataDialog.tmpPositionX == posX) &&
      (public_dataDialog.tmpPositionY == posY))
      return TRUE;

   if (RegCreateKeyEx(HKEY_CURRENT_USER, public_dataDialog.registerKey, 
          0, NULL, REG_OPTION_NON_VOLATILE,
          KEY_WRITE, NULL, &hk, &dwDisp) != ERROR_SUCCESS) 
   {
      //printf("Could not create the registry key."); 
      return FALSE;
   }

   //salva posizione X
   if (RegSetValueEx(hk,              // subkey handle 
           "ListPositionX",        // value name 
           0,                         // must be zero 
           REG_DWORD,             // value type 
           (LPBYTE) &posX,        // pointer to value data 
           (DWORD) sizeof(posX))) // length of value data 
   {
      //printf("Could not set the event message file."); 
      RegCloseKey(hk);
      return FALSE;
   }

   //salva posizione Y
   if (RegSetValueEx(hk,              // subkey handle 
           "ListPositionY",        // value name 
           0,                         // must be zero 
           REG_DWORD,             // value type 
           (LPBYTE) &posY,        // pointer to value data 
           (DWORD) sizeof(posY))) // length of value data 
   {
      //printf("Could not set the event message file."); 
      RegCloseKey(hk);
      return FALSE;
   }

   //salva dimensione X
   if (RegSetValueEx(hk,              // subkey handle 
           "ListDimensionX",        // value name 
           0,                         // must be zero 
           REG_DWORD,             // value type 
           (LPBYTE) &dimensionX,        // pointer to value data 
           (DWORD) sizeof(dimensionX))) // length of value data 
   {
      //printf("Could not set the event message file."); 
      RegCloseKey(hk);
      return FALSE;
   }

   //salva dimensione Y
   if (RegSetValueEx(hk,              // subkey handle 
           "ListDimensionY",        // value name 
           0,                         // must be zero 
           REG_DWORD,             // value type 
           (LPBYTE) &dimensionY,        // pointer to value data 
           (DWORD) sizeof(dimensionY))) // length of value data 
   {
      //printf("Could not set the event message file."); 
      RegCloseKey(hk);
      return FALSE;
   }

  RegCloseKey(hk);

  return TRUE;
}


//ridimensionamento elementi dialog ListBox
void LstDlg_Resize(HWND hwndDlg)
{
  RECT rc, rcDlg, rcText;
  int distanzaElementi = 10;
  int hpulsante; //altezza pulsanti
  int wpulsante; //larghezza pulsanti
  int dimensioneX, dimensioneY; //dimensioniFinestra
  int posX, posY;

    GetClientRect(hwndDlg, &rcDlg); //dimensioni finestra client
    dimensioneX = rcDlg.right;
    dimensioneY = rcDlg.bottom;
    GetClientRect(GetDlgItem(hwndDlg,IDOK), &rc); //dimensioni tasto OK
    hpulsante = rc.bottom;
    wpulsante = rc.right;

    GetWindowRect(GetDlgItem(hwndDlg,IDC_EDIT1), &rcText); //dimensioni editBox

    //dimensionamento editBox
    SetWindowPos(GetDlgItem(hwndDlg,IDC_EDIT1),NULL,0, 0, 
                          dimensioneX, 
                          (rcText.bottom - rcText.top),
                          SWP_NOZORDER | SWP_NOMOVE);

    //dimensionamento lista
    SetWindowPos(GetDlgItem(hwndDlg,IDC_LIST1),NULL,0, 0, 
                          dimensioneX, 
                          dimensioneY - (distanzaElementi * 2) - hpulsante - (rcText.bottom - rcText.top),
                          SWP_NOZORDER | SWP_NOMOVE);

    GetWindowRect(GetDlgItem(hwndDlg,IDC_LIST1), &rc); //dimensioni lista    
    posY = (rcText.bottom - rcText.top) + (rc.bottom - rc.top) + distanzaElementi;
    posX = distanzaElementi;// (dimensioneX - (distanzaElementi * 2) - (wpulsante * 2)) / 2;

    //Spostamento pulsante OK
    SetWindowPos(GetDlgItem(hwndDlg,IDOK),NULL,
                          posX,
                          posY,
                          0, 0, SWP_NOZORDER | SWP_NOSIZE);


    posX = dimensioneX - distanzaElementi - wpulsante;
    //Spostamento pulsante ANNULLA
    SetWindowPos(GetDlgItem(hwndDlg,IDCANCEL),NULL,
                          posX,
                          posY,
                          0, 0, SWP_NOZORDER | SWP_NOSIZE);

}

//callback per la casella di editazione della dialog
//questa funzione consente l'uso della frecca verso il basso nella casella di testo
long CALLBACK LstDlg_Edit_SubProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
  LRESULT idx, last;
  HWND hlista;
  char funzione[10];

	switch(message)
	{
		case WM_KEYDOWN:
			switch(LOWORD(wParam))
			{
        //attiva l'ultimo elemento della lista
		    case VK_UP: //freccia su
          //se è selezionata la prima voce, si sposta sull'ultima
          //in alternativa si sposta sulla voce precedente
          hlista = GetDlgItem(GetParent(hwnd),IDC_LIST1);
          last = SendMessage(hlista,LB_GETCOUNT,0, 0);
          idx = SendMessage(hlista,LB_GETCURSEL,0, 0);
          if ((last > 1) && (idx == 0))
            SendMessage(hlista,LB_SETCURSEL,last - 1, 0); //seleziona ultimo
          else
            SendMessage(hlista,LB_SETCURSEL,idx - 1, 0); //seleziona precedente

          if (last > 0)
            SetFocus(hlista);
          return 0;
        case VK_END: //tasto fine
          hlista = GetDlgItem(GetParent(hwnd),IDC_LIST1);
          last = SendMessage(hlista,LB_GETCOUNT,0, 0);
          if (last > 1)
            SendMessage(hlista,LB_SETCURSEL,last - 1, 0);

          if (last > 0)
            SetFocus(hlista);
          return 0;
        //attiva la lista
		    case VK_DOWN: //freccia giù
          hlista = GetDlgItem(GetParent(hwnd),IDC_LIST1);

          // attiva l'elemento successivo a quello corrente
          last = SendMessage(hlista,LB_GETCOUNT,0, 0);
          idx = SendMessage(hlista,LB_GETCURSEL,0, 0);
          if ((idx < (last - 1)) && (idx != LB_ERR))
            SendMessage(hlista,LB_SETCURSEL,idx + 1, 0);
          
          if (last > 0)
					  SetFocus(hlista);
					return 0;
			case VK_F1:
			case VK_F2:
			case VK_F3:
			case VK_F4:
			case VK_F5:
			case VK_F6:
			case VK_F7:
			case VK_F8:
			case VK_F9:
			//case VK_F10: //attiva menu finestra
			case VK_F11:
			case VK_F12:
			case VK_F13:
			case VK_F14:
			case VK_F15:
			case VK_F16:
			case VK_F17:
			case VK_F18:
			case VK_F19:
			case VK_F20:
			case VK_F21:
			case VK_F22:
			case VK_F23:
			case VK_F24:
				memset(funzione, '\0', sizeof(funzione));
				sprintf(funzione,"F%u",(LOWORD(wParam) - VK_F1 + 1));
				SendMessage(hwnd, WM_SETTEXT, 0, (LPARAM) funzione); 
				SendMessage(hwnd,EM_SETSEL, strlen(funzione),strlen(funzione)); 
			default:
				return (long)CallWindowProc(public_LstDlg_data.LstDlg_EditProc, hwnd, message, wParam, lParam);
				//return 0;
			}
		default:
			return (long)CallWindowProc(public_LstDlg_data.LstDlg_EditProc, hwnd, message, wParam, lParam);
	}
return TRUE;
}

//callback dialog ListBox
BOOL CALLBACK LstDlg_Proc(HWND hwndDlg, UINT message, WPARAM wParam, LPARAM lParam) 
{ 
HWND hwndOwner;
RECT rc, rcDlg, rcOwner, rcDesktop;
int nelementi;
int posX, posY;
long idx;
char itemMax[LSTDLG_MAX_ITEM_LEN];
size_t maxLen;
SIZE sz;
HDC hdc;
HFONT hFont;
char filtro[500]; //filtro digitato dall'utente

hdc=0;
maxLen=0;

    switch (message) 
    { 
			case WM_KEYDOWN:
				hdc=0;
				break;
      case WM_INITDIALOG:
				//impostazione callback per editbox
				public_LstDlg_data.LstDlg_EditProc = (WNDPROC)GetWindowLong(GetDlgItem(hwndDlg,IDC_EDIT1), GWL_WNDPROC);
				SetWindowLong(GetDlgItem(hwndDlg,IDC_EDIT1), GWL_WNDPROC, (LONG)LstDlg_Edit_SubProc);

        //centratura posizionamento dialog
		if ((hwndOwner = GetActiveWindow()) == NULL)
		{
			if ((hwndOwner = GetParent(hwndDlg)) == NULL) {
				hwndOwner = GetDesktopWindow();
			}
		}
        GetWindowRect(hwndOwner, &rcOwner); 
        GetWindowRect(hwndDlg, &rcDlg);
        GetWindowRect(GetDesktopWindow(), &rcDesktop);

		//multi - monitor
		HMONITOR hMonitor;
		MONITORINFO mi;
		hMonitor = MonitorFromRect(&rcDlg, MONITOR_DEFAULTTONEAREST);
		mi.cbSize = sizeof(mi);
		GetMonitorInfo(hMonitor, &mi);
		rcDesktop = mi.rcMonitor;

        if (
            (public_dataDialog.tmpPositionX >= 0) && 
            (public_dataDialog.tmpPositionY >= 0)
           )
        {
          if (public_dataDialog.tmpRelativePosition)
          {
            //posizionamento relativo a finestra padre
            posX = rcOwner.left + (int)public_dataDialog.tmpPositionX;
            posY = rcOwner.top + (int)public_dataDialog.tmpPositionY;
          } else {
            //posizionamento assoluto
            posX = (int)public_dataDialog.tmpPositionX;
            posY = (int)public_dataDialog.tmpPositionY;
          }

          //controllo uscita da schermo
          if (posX >= (rcDesktop.right - 10))
            posX = rcDesktop.right - (rcDlg.right - rcDlg.left);

          //controllo uscita da schermo
          if (posY >= (rcDesktop.bottom - 10))
            posY = posY - (rcDlg.bottom - rcDlg.top);

          SetWindowPos(hwndDlg, 
              HWND_TOP, posX, posY,
              0, 0,          // ignores size arguments 
              SWP_NOSIZE); 
        } else {
          CopyRect(&rc, &rcOwner);
          OffsetRect(&rcDlg, -rcDlg.left, -rcDlg.top);
          OffsetRect(&rc, -rc.left, -rc.top); 
          OffsetRect(&rc, -rcDlg.right, -rcDlg.bottom);
          SetWindowPos(hwndDlg, 
              HWND_TOP, 
              rcOwner.left + (rc.right / 2), 
              rcOwner.top + (rc.bottom / 2), 
              0, 0,          // ignores size arguments 
              SWP_NOSIZE); 
        }
        //FINE posizionamento dialog
        
        //INIZIO impostazione dimensioni dialog
        if (
            (public_dataDialog.tmpDimensionX > 0) && 
            (public_dataDialog.tmpDimensionY > 0)
           )
        {
          SetWindowPos(hwndDlg,NULL,0,0,
                                (int)public_dataDialog.tmpDimensionX,
                                (int)public_dataDialog.tmpDimensionY,
                                SWP_NOZORDER | SWP_NOMOVE); 
          //TODO : da implementare
        }        
        //FINE impostazione dimensioni dialog
        
        LstDlg_FillList(hwndDlg, ""); //riempimento lista e impostazione public_LstDlg_data
        nelementi = public_LstDlg_data.nelementi;
        strcpy(itemMax, public_LstDlg_data.itamMax);        
        
        hdc = GetDC(GetDlgItem(hwndDlg,IDC_LIST1));
        hFont = (HFONT)SendMessage(GetDlgItem(hwndDlg,IDC_LIST1), WM_GETFONT,(WPARAM)NULL, (LPARAM)NULL);        
        SelectObject(hdc, hFont);
        GetTextExtentPoint32(hdc, itemMax, (int)strlen(itemMax), &sz);
        SendMessage(GetDlgItem(hwndDlg,IDC_LIST1),(UINT) LB_SETHORIZONTALEXTENT,
                    (WPARAM)sz.cx + 2,(LPARAM)NULL);

        //titolo finestra
        SendMessage(hwndDlg,WM_SETTEXT,0, (LPARAM)public_tmpDialogTitle);

        if (isEnglishLang()==1)
          //impostazione lingua inglese per pulsante annulla
          SendMessage(GetDlgItem(hwndDlg,IDCANCEL),WM_SETTEXT,0, (LPARAM)"&Cancel");

        //impostazione layout interno
        LstDlg_Resize(hwndDlg);

        return TRUE; 
      case WM_SIZE:
        //impostazione layout interno
        LstDlg_Resize(hwndDlg);
        break;
      case WM_COMMAND:
        switch (LOWORD(wParam)) 
        { 
          case IDC_EDIT1:
            switch (HIWORD(wParam)) 
            { 
              case EN_CHANGE:
                SendMessage((HWND)lParam,WM_GETTEXT,(WPARAM)sizeof(filtro),(LPARAM)filtro);
                LstDlg_FillList(hwndDlg, filtro); //riempimento lista
                break;
            }
            break;
          case IDC_LIST1:
            switch (HIWORD(wParam)) 
            { 
              case LBN_DBLCLK:
                idx = (long)SendMessage((HWND)lParam,LB_GETCURSEL,0,0);
                public_tmpSelectedItem = public_LstDlg_data.elementMapper[idx];
                EndDialog(hwndDlg, IDOK);
                return TRUE;
            }
            break;
          case IDOK: 
            idx = (long)SendMessage(GetDlgItem(hwndDlg,IDC_LIST1),LB_GETCURSEL,0,0);
            if (idx != LB_ERR)
              public_tmpSelectedItem = public_LstDlg_data.elementMapper[idx];
            else
              public_tmpSelectedItem = -1;

            LstDlg_SaveDimension(hwndDlg, public_dataDialog.tmpSavePosDimDialog);
            EndDialog(hwndDlg, wParam);
            return TRUE;
          case IDCANCEL:
            public_tmpSelectedItem = -1;
            LstDlg_SaveDimension(hwndDlg, public_dataDialog.tmpSavePosDimDialog);
            EndDialog(hwndDlg, wParam);
            return TRUE;
        }
    }
    return FALSE; 
} 

//gestione dialog ListBox
long Execute_LstDlg(HINSTANCE hinst, HWND hwndParent)
{
  if (DialogBox(hinst, MAKEINTRESOURCE(IDD_LSTDLG), 
            hwndParent, (DLGPROC)LstDlg_Proc)==IDOK)
  {
    return public_tmpSelectedItem;
  } else {
    return -1;
  }  
}


//callback dialog InputBox
BOOL CALLBACK InputDlg_Proc(HWND hwndDlg, UINT message, WPARAM wParam, LPARAM lParam) 
{ 
  LRESULT ltext;

    switch (message) 
    { 
      case WM_INITDIALOG: //inizializzazione finestra
        //titolo finestra
        SendMessage(hwndDlg,WM_SETTEXT,0, (LPARAM)public_tmpDialogTitle);
        
        //testo visualizzato in finestra
        SendMessage(GetDlgItem(hwndDlg,IDC_EDIT2),WM_SETTEXT,0, (LPARAM)public_tmpItemsString);

        //prompt
        SendMessage(GetDlgItem(hwndDlg,IDC_EDIT1),WM_SETTEXT,0, (LPARAM)public_tmpDialogPrompt);

        if (isEnglishLang()==1)
          //impostazione lingua inglese per pulsante annulla
          SendMessage(GetDlgItem(hwndDlg,IDCANCEL),WM_SETTEXT,0, (LPARAM)"&Cancel");

        return TRUE;
      case WM_COMMAND: 
        switch (LOWORD(wParam)) 
        {
          case IDOK:
            ltext = 0;
            ltext = SendMessage(GetDlgItem(hwndDlg,IDC_EDIT1),WM_GETTEXTLENGTH,(WPARAM)0,(LPARAM)0);
            ltext = ltext + 1;
            public_tmpResultsString = (char *)malloc(ltext);
            public_tmpResultsString[ltext-1] = '\0';
            SendMessage(GetDlgItem(hwndDlg,IDC_EDIT1),WM_GETTEXT,(WPARAM)ltext,(LPARAM)public_tmpResultsString);
            EndDialog(hwndDlg, wParam);
            return TRUE;
          case IDCANCEL:
            EndDialog(hwndDlg, wParam);
            return TRUE;
        }
    }
    return FALSE; 
}

//gestione dialog InputBox
long Execute_InputDlg(HINSTANCE hinst, HWND hwndParent)
{
  if (DialogBox(hinst, MAKEINTRESOURCE(IDD_INPDLG), 
            hwndParent, (DLGPROC)InputDlg_Proc)==IDOK)
  {
    return IDOK;
  } else {
    return -1;
  }  
}

