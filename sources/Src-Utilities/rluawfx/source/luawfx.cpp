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

extern "C" 
{
	#include <lauxlib.h>
}
//#include <lua.h>

#ifndef WIN32
  #error "Only for Win32!"
#endif

#include <shlwapi.h>
#include <io.h>
#include <windows.h>
#include <shlobj.h>
#include <direct.h>

#include "cdialog.h"
#include "commutil.h"
#include "genguid.h"

#include "rMsgBx.h"
#include "rHDialog.h"

HINSTANCE public_DllInstance; //istanza corrente DLL

BOOL WINAPI DllMain(
    HINSTANCE hinstDLL,  // handle to DLL module
    DWORD fdwReason,     // reason for calling function
    LPVOID lpReserved )  // reserved
{

    // Perform actions based on the reason for calling.
    switch( fdwReason ) 
    { 
        case DLL_PROCESS_ATTACH:
         // Initialize once for each new process.
         // Return FALSE to fail DLL load.
            public_DllInstance = hinstDLL;
			rMsgBx_new(); //initialize customized messagebox buttons
            GetModuleFileName(hinstDLL,public_DllFileName, sizeof(public_DllFileName));
            break;
        case DLL_THREAD_ATTACH:
         // Do thread-specific initialization.
            break;
        case DLL_THREAD_DETACH:
         // Do thread-specific cleanup.
            break;
        case DLL_PROCESS_DETACH:
         // Perform any necessary cleanup.
            break;
    }
    return TRUE;  // Successful DLL_PROCESS_ATTACH.
}

//ritorna 1 se il nome della dll corrente contiene rluawfxen.dll.
//ciò significa che la dll deve visualizzare i messaggi in lingua inglese
int isEnglishLang(void)
{
  char *copy1;

  copy1 = _strlwr(_strdup( public_DllFileName ));
  if (strstr(copy1,"rluawfx-en.dll")!=NULL) {
    //LocalFree(copy1); //lingua inglese
    free(copy1);
    return 1;
  } else {
    //LocalFree(copy1); //italiano
    free(copy1);
    return 0;
  }
}

//customize MessageBox button
LUALIB_API int c_MsgBox_Customize_Btn(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *text;
  lua_Integer opt;

  if ((n == 2) && (lua_type(L,1)==LUA_TNUMBER) && (lua_type(L,2)==LUA_TSTRING)) 
  {
    opt = lua_tointeger( L, 1 );
    text = lua_tostring( L, 2 );
    rMsgBx_setLabel(opt, text);
  } else {
    showErrorMsg("Arguments Error! - MsgBox_Customize_Btn(buttonId ,text)");
    lua_error(L); 
    lua_pushnil(L);    
  }
  return 1;
}

//implementazione MessageBox
LUALIB_API int c_MsgBox(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *msg;
  const char *title;
  lua_Number opt;
  int res;
  HWND hwndOwner;

  if ((n > 0) && (n < 4) && (lua_type(L,1)==LUA_TSTRING)) {    
    if ((hwndOwner = GetActiveWindow()) == NULL) {
            hwndOwner = GetDesktopWindow();
        }
    msg = lua_tostring(L,1);
    if (n > 1)
      title = lua_tostring( L, 2 );
    else
      title = LS_NAMESPACE;
    if (n > 2)
      opt = lua_tonumber( L, 3 );
    else
      opt = MB_OK;
	
	//res = MessageBox(hwndOwner,msg,title,(UINT)opt);
	res = rMsgBx_show(hwndOwner, msg, title,(UINT)opt);

    lua_pushnumber(L, res);
  } else {
    showErrorMsg("Arguments Error! - MsgBox(messaggio [,titolo [,flag, [custom_button]]])");
    lua_error(L); 
    lua_pushnil(L);
    
  }
  return 1;
}

//implementazione settaggio trasparenza
LUALIB_API int c_SetTransparency(lua_State *L)
{
  const int n = lua_gettop(L);
  lua_Integer opt;
  HWND hwndOwner;

  if ((n == 1) && (lua_type(L,1)==LUA_TNUMBER)) {
    if ((hwndOwner = GetActiveWindow()) != NULL) {
      opt = lua_tointeger( L, 1 );
      // Set WS_EX_LAYERED on this window 
      SetWindowLong(hwndOwner, 
                    GWL_EXSTYLE, 
                    GetWindowLong(hwndOwner, GWL_EXSTYLE) | WS_EX_LAYERED);
      // Make this window opt% alpha
      SetLayeredWindowAttributes(hwndOwner, 0, (255 * opt) / 100, LWA_ALPHA);
      lua_pushboolean(L, 1);
    }
  } else {
    //lua_pushstring(L, "Argomenti errati! - MsgBox(messaggio [,titolo [,flag])");
    showErrorMsg("Arguments error! - SetTransparency(transparencyLevel)");
    lua_error(L); 
    lua_pushnil(L);
  }
  return 1;
}

//dialog con InputBox
LUALIB_API int c_InputBox(lua_State *L)
{ 
  const int n = lua_gettop(L);
  const char *prompt;
  const char *title;
  const char *text;
  const char *fileName;
  int res;

  if ( (lua_type(L,1)==LUA_TSTRING) &&
       (lua_type(L,2)==LUA_TSTRING) &&
       (lua_type(L,3)==LUA_TSTRING) &&
       (lua_type(L,4)==LUA_TSTRING) && 
       /*(lua_type(L,4)==LUA_TNUMBER) &&
       (lua_type(L,5)==LUA_TNUMBER) &&*/
       (n == 4)
      ){

    prompt = lua_tostring(L,1);
    title = lua_tostring(L,2);
    text = lua_tostring(L,3);
    fileName = lua_tostring(L,4);

    public_tmpItemsString = text;
    public_tmpDialogTitle = title;
    public_tmpDialogPrompt = prompt;

    /*public_tmpPositionX = lua_tonumber(L,4);
    public_tmpPositionY = lua_tonumber(L,5);*/
    
    res = Execute_InputDlg(public_DllInstance, GetActiveWindow());

    if (res == -1)
      lua_pushnil(L);
    else {
      //lua_pushstring(L, public_tmpResultsString);
			writeStrinToTmp(public_tmpResultsString, fileName);
      free(public_tmpResultsString);
			lua_pushboolean(L, 1);
    }
  } else {
    //lua_pushstring(L, "Argomenti errati! - InputDlg(prompt ,title ,default)");
    showErrorMsg("Argomenti errati! - InputDlg(prompt ,title ,default, tempFileName)");
    lua_error(L);
    lua_pushnil(L);
		//return 0;
  }
  return 1;
}

//dialog con listbox
LUALIB_API int c_ListDlg(lua_State *L)
{ 
  int res, flagDialog;
  const char *msg;
  const char *title;
  int n;
  
  n = lua_gettop(L);
  
  public_dataDialog.tmpDimensionX=0;
  public_dataDialog.tmpDimensionY=0;
  public_dataDialog.tmpPositionX=0;
  public_dataDialog.tmpPositionY=0;

  if ( (lua_type(L,1)==LUA_TSTRING) && //opzioni lista
       (lua_type(L,2)==LUA_TSTRING) && //titolo
       (lua_type(L,3)==LUA_TBOOLEAN) && //salva posizione (flag)
       (lua_type(L,4)==LUA_TNUMBER) && //posizione x
       (lua_type(L,5)==LUA_TNUMBER) && //posizione y
       (lua_type(L,6)==LUA_TNUMBER) && //dimensione x
       (lua_type(L,7)==LUA_TNUMBER) && //dimensione y
       (lua_type(L,8)==LUA_TBOOLEAN) && //posizione relativa
       (lua_type(L,9)==LUA_TSTRING) && //chiave di registro per i dati
       (lua_type(L,10)==LUA_TNUMBER) && //elemento preselezionato in lista
       (n == 10)
      ){
    msg = lua_tostring(L,1);
    title = lua_tostring(L,2);
    flagDialog = lua_toboolean(L,3);
    public_dataDialog.tmpSavePosDimDialog = flagDialog;
    public_dataDialog.tmpPositionX = lua_tointeger(L,4);
    public_dataDialog.tmpPositionY = lua_tointeger(L,5);
    public_dataDialog.tmpDimensionX = lua_tointeger(L,6);
    public_dataDialog.tmpDimensionY = lua_tointeger(L,7);
    flagDialog = lua_toboolean(L,8);
    public_dataDialog.tmpRelativePosition = flagDialog;
    public_dataDialog.registerKey = lua_tostring(L,9);
    public_dataDialog.tmpSelectedItemIndex = lua_tointeger(L,10);

    public_tmpItemsString = msg;
    public_tmpDialogTitle = title;
    
    res = Execute_LstDlg(public_DllInstance, GetActiveWindow());

    if (res == -1)
      lua_pushnil(L);
    else
      lua_pushnumber(L, res);
  } else {
    //lua_pushstring(L, "Argomenti errati! - ListDlg(Elementi, Titolo, flagDialog)");
    showErrorMsg("Argomenti errati! - ListDlg(Elementi, Titolo, flagDialog, XPosition, YPosition, XDimension, YDimension, RelativePosition, regKey, preselectedItem)");
    lua_error(L); 
    lua_pushnil(L);
  }
  return 1;
}

LUALIB_API int c_GetFileName(lua_State *L)
{
  OPENFILENAME ofn;       // common dialog box structure
  char szFile[_MAX_PATH];       // buffer for file name
  const int n = lua_gettop(L);
  const char *title, *defaultPath, *fileName;
  const char *estensione;
  char bufferExt[255];
  lua_Number opt;

  if ((lua_type(L,1)==LUA_TSTRING) && 
      (lua_type(L,2)==LUA_TSTRING) &&
      (lua_type(L,3)==LUA_TNUMBER) && 
			(lua_type(L,4)==LUA_TSTRING) && 
      (n > 3))
  {

    title = lua_tostring(L,1); //titolo finestra
    defaultPath = lua_tostring(L,2); //percorso di default
    opt = lua_tonumber(L,3); //opzioni 
		fileName = lua_tostring(L,4); //nome file scambio temporaneo
    
    if ( (n==5) &&(lua_type(L,5)==LUA_TSTRING))
    {
      estensione = lua_tostring(L,5);//filtro
      ZeroMemory(bufferExt, sizeof(bufferExt));
      //sostituisce i %c con il carattere '\0'
      sprintf(bufferExt,estensione,'\0');
    } else
      estensione = NULL;

    // Initialize OPENFILENAME
    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    ofn.hwndOwner = GetActiveWindow();
    ofn.lpstrFile = szFile;
    ofn.lpstrFile[0] = '\0';
    ofn.nMaxFile = sizeof(szFile);
    if (estensione == NULL)
      ofn.lpstrFilter = "Tutto\0*.*\0";
    else
      ofn.lpstrFilter = bufferExt;
    ofn.nFilterIndex = 0;
    ofn.lpstrFileTitle = NULL;
    ofn.nMaxFileTitle = 0;
    ofn.lpstrInitialDir = defaultPath;
    ofn.Flags = OFN_HIDEREADONLY | (DWORD)opt;//OFN_CREATEPROMPT | OFN_HIDEREADONLY;
    ofn.lpstrTitle = title;

    // Display the Open dialog box. 
		if (GetOpenFileName(&ofn)==TRUE) {
      //lua_pushstring(L, ofn.lpstrFile);
			writeStrinToTmp(ofn.lpstrFile, fileName);
			lua_pushboolean(L, 1);
		} else
      lua_pushnil(L);
  } else {
    //lua_pushstring(L, "Argomenti errati! - GetFileName(Titolo, Percorso di Default, Opzioni)");
		showErrorMsg("Argomenti errati! - GetFileName(Titolo, Percorso di Default, Opzioni,Path File Temporaneo,[Filtri])");
    lua_error(L); 
    lua_pushnil(L);
  }

  return 1;
}

LUALIB_API int c_GetColorDlg(lua_State *L)
{
CHOOSECOLOR cc;                 // common dialog box structure 
static COLORREF acrCustClr[16]; // array of custom colors 
HBRUSH hbrush;                  // brush handle
static DWORD rgbCurrent;        // initial color selection
const int n = lua_gettop(L);

  if (n == 0)
  {
    rgbCurrent = 0;
    // Initialize CHOOSECOLOR 
    ZeroMemory(&cc, sizeof(cc));
    cc.lStructSize = sizeof(cc);
    cc.hwndOwner = GetActiveWindow();
    cc.lpCustColors = (LPDWORD) acrCustClr;
    cc.rgbResult = rgbCurrent;
    cc.Flags = CC_FULLOPEN | CC_RGBINIT;
 
    if (ChooseColor(&cc)==TRUE) {
      hbrush = CreateSolidBrush(cc.rgbResult);
      rgbCurrent = cc.rgbResult; 
      lua_pushnumber(L, rgbCurrent);
      lua_pushnumber(L, GetRValue(rgbCurrent));
      lua_pushnumber(L, GetGValue(rgbCurrent));
      lua_pushnumber(L, GetBValue(rgbCurrent));
      return 4;
    } else {
      lua_pushnil(L);
      return 1;
    }
  } else {
    //lua_pushstring(L, "Argomenti errati! - GetColorDlg()");
    showErrorMsg("Argomenti errati! - GetColorDlg()");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }

}

LUALIB_API int c_SendCmdScite(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *msg;
  COPYDATASTRUCT cds;
  size_t size; 
  HWND result;

  if ((lua_type(L,1)==LUA_TSTRING) &&
       (n == 1)
     )
  {
    msg = lua_tostring(L,1);
    size = strlen(msg);
    cds.dwData = 0;	
    cds.lpData = (void *)msg;
    cds.cbData = (DWORD)size;
    result = GetHWNDDirectorExtension();
    SendMessage(result, WM_COPYDATA,(WPARAM)NULL,(LPARAM)&cds);
  } else {
    //lua_pushstring(L, "Argomenti errati! - SendCmdScite(comando)");
    showErrorMsg("Argomenti errati! - SendCmdScite(comando)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
  return 0;
}

//PathIsDirectory
LUALIB_API int c_PathIsDirectory(lua_State *L)
{
   const int n = lua_gettop(L);
   const char *path;  
   BOOL ret;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (n == 1))
  {
    path = lua_tostring(L,1);

    if (ret=PathIsDirectory(path))
      lua_pushboolean(L, ret);
    else
      lua_pushnil(L);

  } else {
    //lua_pushstring(L, "Argomenti errati! - PathIsDirectory(path)");
    showErrorMsg("Argomenti errati! - PathIsDirectory(path)");
    lua_error(L); 
    lua_pushnil(L);
  }

  return 1;
}

//SetIniValue Scrive un valore all'interno di un file ini
LUALIB_API int c_SetIniValue(lua_State *L)
{
   const int n = lua_gettop(L);
   const char *path;
   const char *section;
   const char *key;
   const char *value;

  if ((lua_type(L,1)==LUA_TSTRING) &&
	  (lua_type(L,2)==LUA_TSTRING) &&
	  (lua_type(L,3)==LUA_TSTRING) &&
	  (lua_type(L,4)==LUA_TSTRING) &&
      (n == 4))
  {
    path = lua_tostring(L,1);
    section = lua_tostring(L,2);
    key = lua_tostring(L,3);
    value = lua_tostring(L,4);

	if (WritePrivateProfileString(section, key, value, path) == 0)
		lua_pushnil(L); //errore
	else
		lua_pushboolean(L, 1); //tutto ok

  } else {
    showErrorMsg("Argomenti errati! - SetIniValue(pathIniFile, Section, Key, Value)");
    lua_error(L); 
    lua_pushnil(L);
  }

  return 1;
}

LUALIB_API int c_BrowseForFolder(lua_State *L)
{
  char s[MAX_PATH] = "\0";
  BROWSEINFO bi;
  ITEMIDLIST *pidl;
  const int n = lua_gettop(L);
  const char *msg;
  const char *fileName;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (n == 2))
  {
    msg = lua_tostring(L,1);
    fileName = lua_tostring(L,2);

    bi.hwndOwner = GetActiveWindow();
    bi.pidlRoot = NULL;
    bi.pszDisplayName = s;
    bi.lpszTitle = msg;
    bi.ulFlags = BIF_RETURNONLYFSDIRS;
    bi.lpfn = 0;
    bi.lParam = 0;

    pidl = SHBrowseForFolder(&bi);
    if(pidl != NULL) {
	    SHGetPathFromIDList(pidl, s);
      //lua_pushstring(L, s);
			writeStrinToTmp(s, fileName);
			lua_pushboolean(L, 1);
	    CoTaskMemFree(pidl);
    }
    else
      lua_pushnil(L);

  } else {
    //lua_pushstring(L, "Argomenti errati! - BrowseForFolder(title)");
    showErrorMsg("Argomenti errati! - BrowseForFolder(title)");
    lua_error(L); 
    lua_pushnil(L);
  }

 return 1;
}

//c_shellAndWait
LUALIB_API int c_shellAndWait(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *path;  
  STARTUPINFO         si;
  PROCESS_INFORMATION pi;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (n == 1))
  {
    path = lua_tostring(L,1);

    ZeroMemory(&si, sizeof(si));
    si.cb=sizeof (si);

    if (CreateProcess(
                  NULL,
                  (LPSTR)path,                    // command line
                  0,                    // process attributes
                  0,                    // thread attributes
                  0,                    // inherit handles
                  //CREATE_NEW_CONSOLE,   // creation flags
                  CREATE_NO_WINDOW,   // creation flags
                  0,                    // environment
                  0,                    // cwd
                  &si,
                  &pi
                  ) != 0)
    {
      WaitForSingleObject(pi.hProcess,INFINITE);
      lua_pushboolean(L, 1); //tutto OK
      return 1;
    } else {
      lua_pushnil(L);
      return 1;
    }
  } else {
    showErrorMsg("Argomenti errati! - shellAndWait(Command)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }

} //endfunction

//c_shellExecute
LUALIB_API int c_shellExecute(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *path;  
  const char *parameters;  
  HWND hwndOwner;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (n == 2))
  {
    path = lua_tostring(L,1);
    parameters = lua_tostring(L,2);
    if ((hwndOwner = GetActiveWindow()) == NULL) {
          hwndOwner = GetDesktopWindow();
    }
   
    ShellExecute(hwndOwner, "open", path, parameters, NULL, SW_SHOWNORMAL);

    return 0;
  } else {
    //lua_pushstring(L, "Argomenti errati! - ShellExecute(ExePath, Parameters)");
    showErrorMsg("Argomenti errati! - ShellExecute(ExePath, Parameters)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//c_fileOperation
//consente l'esecuzione di queste operazioni: 
//"copy", "delete", "move", "rename"
//sui file indicati
LUALIB_API int c_fileOperation(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *from;
  const char *to;  
  const char *operation;
  char *buffer;
  HWND hwndOwner;
  SHFILEOPSTRUCT lpFileOp;
  long Op=0;
  lua_Integer value;


  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (lua_type(L,3)==LUA_TSTRING) &&
      (lua_type(L,4)==LUA_TNUMBER) &&
      (n == 4))
  {
    from = lua_tostring(L,1); //sorgente
    to = lua_tostring(L,2); //destinazione
    operation = lua_tostring(L,3); //operazione
    value = lua_tointeger(L,4); //flag

    if ((hwndOwner = GetActiveWindow()) == NULL) {
          hwndOwner = GetDesktopWindow();
    }
   
    buffer = (char *)calloc(strlen(from)+2,sizeof(char));
    strcpy(buffer,from);

    lpFileOp.hwnd = hwndOwner;
    lpFileOp.pFrom = buffer;
    lpFileOp.pTo = to;

    lpFileOp.fFlags = (FILEOP_FLAGS)value;

    if (_stricmp(operation, "copy")==0) {
      Op = FO_COPY;
    } else if (_stricmp(operation, "delete")==0) {
      Op = FO_DELETE;
      lpFileOp.pTo = NULL;
      //lpFileOp.fFlags = FOF_ALLOWUNDO;
    } else if (_stricmp(operation, "move")==0) {
      Op = FO_MOVE;
    } else if (_stricmp(operation, "rename")==0) {
      Op = FO_RENAME;
    }

    if (Op > 0) {
      lpFileOp.wFunc = Op;
      if (SHFileOperation(&lpFileOp)==0){
        free(buffer);
        lua_pushboolean(L, 1); //tutto OK
        return 1;
      }else{
        free(buffer);
        lua_pushnil(L); //ipossibile offettuare l'operazione
        return 1;
      }
    } else {
      free(buffer);
      showErrorMsg("Operazione specificata non Valida!");
      lua_error(L); 
      lua_pushnil(L);
      return 1;
    }
    return 0;
  } else {
    showErrorMsg("Argomenti errati! - fileOperation(From, To, Operation, Flag)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//c_createDirectory
//consente la creazione di una cartella 
LUALIB_API int c_createDirectory(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *to;  
  int res;


  if ((lua_type(L,1)==LUA_TSTRING) &&
      (n == 1))
  {
    to = lua_tostring(L,1); //cartella da creare

    res=_mkdir(to);

    if (res==0) {
      lua_pushboolean(L, 1); //tutto OK
      return 1;
    } else {
      lua_pushnil(L); //ipossibile offettuare l'operazione
      return 1;
    }
  } else {
    showErrorMsg("Argomenti errati! - createDirectory(directory)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//c_RegSetInteger
//scrive un valore di tipo intero nel registro,
//all'interno della sezione current_user
LUALIB_API int c_RegSetInteger(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *key;
  const char *valueName;
  lua_Integer value;
  DWORD dat=0;
  HKEY hk; 
  DWORD dwDisp; 

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (lua_type(L,3)==LUA_TNUMBER) &&
      (n == 3))
  {
    key = lua_tostring(L,1);
    valueName = lua_tostring(L,2);
    value = lua_tointeger(L,3);    

    if (RegCreateKeyEx(HKEY_CURRENT_USER, key, 
          0, NULL, REG_OPTION_NON_VOLATILE,
          KEY_WRITE, NULL, &hk, &dwDisp) != ERROR_SUCCESS) 
    {
      //showErrorMsg("Impossibile aprire o creare la chiave indicata!");
      //lua_error(L); 
      lua_pushnil(L);
      return 1;
    }

    if (RegSetValueEx(hk,              // subkey handle 
            valueName,        // value name 
            0,                         // must be zero 
            REG_DWORD,             // value type 
            (LPBYTE) &value,        // pointer to value data 
            (DWORD) sizeof(value))) // length of value data 
    {      
      RegCloseKey(hk);
      //showErrorMsg("Impossibile scrivere il valore indicato!");
      //lua_error(L); 
      lua_pushnil(L);
      return 1;
    }

    RegCloseKey(hk);
    lua_pushboolean(L, 1);
    return 1;

  } else {
    showErrorMsg("Argomenti errati! - RegSetInteger(Key, Value, DataNumber)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//c_RegGetInteger
//legge un valore di tipo intero nel registro,
//all'interno della sezione current_user
LUALIB_API int c_RegGetInteger(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *key;
  const char *valueName;
  DWORD value;
  HKEY hk; 
  LONG lRet;
  DWORD dwBufLen=sizeof(value);
  const char *mainKey;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
	  (lua_type(L,3)==LUA_TSTRING) &&
      (n == 3))
  {
    key = lua_tostring(L,1);
    valueName = lua_tostring(L,2);
	mainKey = lua_tostring(L,3); //chiave principale es: HKEY_CURRENT_USER

	if (strcmp("HKCU",mainKey) == 0) {
		lRet = RegOpenKeyEx( HKEY_CURRENT_USER ,key, 0, KEY_QUERY_VALUE, &hk );
	} else if (strcmp("HKLM",mainKey) == 0) {
		lRet = RegOpenKeyEx( HKEY_LOCAL_MACHINE ,key, 0, KEY_QUERY_VALUE, &hk );
	} else {
      showErrorMsg("Error! Main Key not valid!");
      lua_error(L); 
      lua_pushnil(L);
      return 1;
	}
	
    if( lRet != ERROR_SUCCESS )
    {
      //showErrorMsg("Error! Missing Key!");
      //lua_error(L); 
      lua_pushnil(L);
      return 1;
    }

    lRet = RegQueryValueEx(hk, valueName, NULL, NULL,
      (LPBYTE) &value, &dwBufLen);
    if( (lRet != ERROR_SUCCESS) || (dwBufLen > sizeof(value)) )
    {
      RegCloseKey(hk);
      //showErrorMsg("Impossibile leggere il valore indicato!");
      //lua_error(L); 
      lua_pushnil(L);
      return 1;
    }
    RegCloseKey(hk);
    lua_pushnumber(L, value);
    return 1;
  } else {
    showErrorMsg("Missin Arguments! - RegGetInteger(Key, Value, MainKey)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//c_RegGetString
//legge un valore di tipo stringa dal registro
LUALIB_API int c_RegGetString(lua_State *L)
{
	char buffer_char[255];
  DWORD dwBufLen = 255;
  const int n = lua_gettop(L);
  const char *key;
  const char *valueName;
  const char *fileName;
  HKEY hk; 
  LONG lRet;
  
  const char *mainKey;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
	    (lua_type(L,3)==LUA_TSTRING) &&
	    (lua_type(L,4)==LUA_TSTRING) &&
      (n == 4))
  {
    key = lua_tostring(L,1);
    valueName = lua_tostring(L,2);
    mainKey = lua_tostring(L,3); //chiave principale es: HKEY_CURRENT_USER
    fileName = lua_tostring(L,4); //output filename

	if (strcmp("HKCU",mainKey) == 0) {
		lRet = RegOpenKeyEx( HKEY_CURRENT_USER ,key, 0, KEY_QUERY_VALUE, &hk );
	} else if (strcmp("HKLM",mainKey) == 0) {
		lRet = RegOpenKeyEx( HKEY_LOCAL_MACHINE ,key, 0, KEY_QUERY_VALUE, &hk );
	} else {
      showErrorMsg("Error! Main Key not valid!");
      lua_error(L); 
      lua_pushnil(L);
      return 1;
	}
	
    if( lRet != ERROR_SUCCESS )
    {
      //showErrorMsg("Error! Missing Key!");
      //lua_error(L); 
      lua_pushnil(L);
      return 1;
    }

    lRet = RegQueryValueEx(hk, valueName, NULL, NULL,
      (LPBYTE) &buffer_char, &dwBufLen);
    if(lRet != ERROR_SUCCESS)
    {
      RegCloseKey(hk);
      //showErrorMsg("Impossibile leggere il valore indicato!");
      //lua_error(L); 
      lua_pushnil(L);
      return 1;
    }
    
    RegCloseKey(hk);
    writeStrinToTmp(buffer_char, fileName);
    //lua_pushnumber(L, value);
    return 1;
  } else {
    showErrorMsg("Missin Arguments! - RegGetString(Key, Value, MainKey, outputTempFileName)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//c_Sleep
//Attendo un certo numero di millisecondi prima di proseguire
LUALIB_API int c_Sleep(lua_State *L)
{
  const int n = lua_gettop(L);
  lua_Integer value;

  if ((lua_type(L,1)==LUA_TNUMBER) &&
      (n == 1))
  {
    value = lua_tointeger(L,1);
    
    Sleep(value);
    lua_pushboolean(L, 1);
    return 1;
  } else {
    showErrorMsg("Argomenti errati! - Sleep(Milliseconds)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//genera un GUID
//la funzione dovrà essere usata specificando :
//[File temporaneo da scrivere con le GUID]
LUALIB_API int c_GetGUID(lua_State *L)
{
	const int n = lua_gettop(L);
	const char *fileName;
	GUID id;
	WCHAR buffer[255];
	char buffer_char[255];

  if ((lua_type(L,1)==LUA_TSTRING) && (n == 1))
  {
    fileName = lua_tostring(L,1); //nome file scambio temporaneo
		CoCreateGuid(&id);
		StringFromGUID2(id,buffer,254);
		UnicodeToAnsi(buffer,buffer_char,sizeof(buffer_char)-1);
    writeStrinToTmp(buffer_char, fileName);
    lua_pushboolean(L, 1);
  } else {
    //lua_pushstring(L, "Argomenti errati! - GetFileName(Titolo, Percorso di Default, Opzioni)");
	showErrorMsg("Arguments error! - GetGUID(temporary file path)");
    lua_error(L); 
    lua_pushnil(L);
  }

  return 1;
}

//c_createDirectory
//consente la creazione di una cartella 
LUALIB_API int c_addToRecentDocs(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *doc;  

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (n == 1))
  {
    doc = lua_tostring(L,1); //path del documento

	SHAddToRecentDocs(SHARD_PATH,doc);

    lua_pushboolean(L, 1); //tutto OK
	return 1;
  } else {
    showErrorMsg("Arguments error! - addToRecentDocs(document_path)");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

//verifica la presenza dei parametri necessari al funzionamento
//di c_callFXex
int checkpar_calFXex(lua_State *L)
{
  const int n = lua_gettop(L);
  const int totPar = 16;
  int result = 0;

  if (n != totPar)
  {
	  result = 2; //numero parametri non corretto
  } else {
	  if ((lua_type(L,1) != LUA_TSTRING) || //nome file libreria
		  (lua_type(L,2) != LUA_TSTRING) || //nome funzione esterna
		  (lua_type(L,3) != LUA_TNUMBER) || //dimensione massima buffer risultato
		  (lua_type(L,4) != LUA_TSTRING) || //primo par tipo stringa
		  (lua_type(L,5) != LUA_TSTRING) || //secondo par tipo stringa
		  (lua_type(L,6) != LUA_TSTRING) || //terzo par tipo stringa
		  (lua_type(L,7) != LUA_TSTRING) || //quarto par tipo stringa
		  (lua_type(L,8) != LUA_TSTRING) || //quinto par tipo stringa
		  (lua_type(L,9) != LUA_TNUMBER) || //primo par tipo intero
		  (lua_type(L,10) != LUA_TNUMBER) || //secondo par tipo intero
		  (lua_type(L,11) != LUA_TNUMBER) || //terzo par tipo intero
		  (lua_type(L,12) != LUA_TNUMBER) || //quarto par tipo intero
		  (lua_type(L,13) != LUA_TNUMBER) || //primo par tipo reale
		  (lua_type(L,14) != LUA_TNUMBER) || //secondo par tipo reale
		  (lua_type(L,15) != LUA_TNUMBER) || //terzo par tipo reale
		  (lua_type(L,16) != LUA_TNUMBER) //quarto par tipo reale
		 )
	  {
		  result = 1; //errore : un parametro è di tipo errato
	  }
  }
  return result;
}

//c_callFXex
//consente di richiamare una funzione esterna, presente in una libreria
//a collegamento dinamico, alla quale vengono passati 5 parametri di tipo stringa,
//4 di tipo intero e 4 di tipo reale
//Questa funzione ritorna una stringa
LUALIB_API int c_callFXex(lua_State *L)
{
  const char *libPath, *fx;
  long resultDim; //max result buffer dimension
  const char *par1,*par2,*par3,*par4,*par5;  
  lua_Integer par6,par7,par8,par9;
  lua_Number par10,par11,par12,par13;  
  EXTERNALFX extfx;
  long resultExt; //external function result
  char *resultStr; //result buffer
  HINSTANCE hinstLib; 
  int idp;

  resultExt = 0;

  //la funzione esterna deve essere cosi fatta :
  // int fx(char &[], long size_buffer,
  //                 char*,char*,char*,char*,char*
  //                 int,int,int,int,
  //                 double,double,double,double)

  //questa funzione deve essere chiamata da lua in questo modo :
  // string = fx([nome file libreria esterna], [nome fx in libreria],
  //             [dimensione massima stringa risultante],
  //             string,string,string,string,string,
  //                 integer,integer,integer,integer,
  //                 real,real,real,real)

  if (checkpar_calFXex(L) == 0)
  {
	idp = 1;
    libPath = lua_tostring(L, idp); //path della librerita
	idp++;
	fx = lua_tostring(L, idp); //funzione da richiamare
	idp++;
	resultDim = lua_tointeger(L, idp); //dimensione massima stringa risultante
	idp++;
	par1 = lua_tostring(L,idp);
	idp++;
	par2 = lua_tostring(L,idp);
	idp++;
	par3 = lua_tostring(L,idp);
	idp++;
	par4 = lua_tostring(L,idp);
	idp++;
	par5 = lua_tostring(L,idp);
	idp++;
	par6 = lua_tointeger(L,idp);
	idp++;
	par7 = lua_tointeger(L,idp);
	idp++;
	par8 = lua_tointeger(L,idp);
	idp++;
	par9 = lua_tointeger(L,idp);
	idp++;
	par10 = lua_tonumber(L,idp);
	idp++;
	par11 = lua_tonumber(L,idp);
	idp++;
	par12 = lua_tonumber(L,idp);
	idp++;
	par13 = lua_tonumber(L,idp);	

	//caricamento funzione esterna
	hinstLib = LoadLibrary(libPath);	
	if (hinstLib != NULL) 
	{
		extfx = (EXTERNALFX) GetProcAddress(hinstLib, fx);
		if (extfx != NULL)
		{
			resultStr = (char *)calloc(resultDim , sizeof( char ) );
			resultExt = extfx(resultStr, resultDim,
							  par1, par2, par3, par4, par5,
							  par6, par7, par8, par9,
							  par10, par11, par12, par13);
			lua_pushstring(L, resultStr);
			free(resultStr);
		} else {
			lua_pushstring(L, "");
		}
		FreeLibrary(hinstLib);
	} else {
		lua_pushstring(L, "");
	}
	
	return 1;
  } else {
    showErrorMsg("Arguments error! - c_callFXex");
    lua_error(L); 
    lua_pushnil(L);
    return 1;
  }
}

LUALIB_API int c_ShowHTMLDialog(lua_State *L)
{
	const int n = lua_gettop(L);
	const char *fileName;
	const char *htmlFile;
	const char *options;
	long flags;
	const char *inputData;
	char datao[32000];
	memset(datao, '\0', sizeof(datao));
	int result;

	if ((n == 5) &&
		(lua_type(L, 1) == LUA_TSTRING) && 
		(lua_type(L, 2) == LUA_TSTRING) &&
		(lua_type(L, 3) == LUA_TSTRING) &&
		(lua_type(L, 4) == LUA_TNUMBER) &&
		(lua_type(L, 5) == LUA_TSTRING)
		)
	{
		fileName = lua_tostring(L, 1); //nome file scambio temporaneo
		htmlFile = lua_tostring(L, 2); //nome file html
		options = lua_tostring(L, 3); //opzioni per dialog
		flags = lua_tointeger(L, 4); //flags per dialog
		inputData = lua_tostring(L, 5); //dati di input

		if (flags == 0)
		{
			flags = HTMLDLG_MODAL | HTMLDLG_VERIFY;
		}

		result = start_ShowHTMLDialog(GetActiveWindow(),
										htmlFile,
										flags,
										options,
										inputData,
										datao,
										sizeof(datao));

		if (result > -1)
		{
			if (result == 1)
				writeStrinToTmp(datao, fileName);

			lua_pushnumber(L, result);
		} else
			lua_pushnil(L);
	}
	else {
		showErrorMsg("Arguments error! - c_Test(...)");
		lua_error(L);
		lua_pushnil(L);
	}

	return 1;

}

//implementazione settaggio trasparenza
LUALIB_API int c_SetWindowSize(lua_State *L)
{
	const int n = lua_gettop(L);
	lua_Integer w;
	lua_Integer h;
	HWND hwndOwner;

	if ((n == 2) && 
		(lua_type(L, 1) == LUA_TNUMBER) &&
		(lua_type(L, 2) == LUA_TNUMBER)
		) {
		if ((hwndOwner = GetActiveWindow()) != NULL) {
			w = lua_tointeger(L, 1);
			h = lua_tointeger(L, 2);
			
			SetWindowPos(hwndOwner, HWND_TOP, NULL, NULL, w, h, SWP_NOMOVE);
			lua_pushboolean(L, 1);
		}
	}
	else {
		//lua_pushstring(L, "Argomenti errati! - MsgBox(messaggio [,titolo [,flag])");
		showErrorMsg("Arguments error! - SetWindowsSize(width, height)");
		lua_error(L);
		lua_pushnil(L);
	}
	return 1;
}


LUALIB_API int c_Test(lua_State *L)
{
	return 0;
}

