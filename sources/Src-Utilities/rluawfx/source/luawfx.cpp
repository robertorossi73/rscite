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

extern "C" 
{
    #include <..\..\luascite\include\lualib.h>
}
//#include <lua.h>

/*#ifndef WIN32
  #error "Only for Win32!"
#endif*/

#include <shlwapi.h>
#include <io.h>
#include <windows.h>
#include <shlobj.h>
#include <direct.h>

#include <list>

#include "cdialog.h"
#include "commutil.h"

#include "rMsgBx.h"

#include "cprops.h"

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
  std::wstring text;
  lua_Integer opt;

  if ((n == 2) && (lua_type(L,1)==LUA_TNUMBER) && (lua_type(L,2)==LUA_TSTRING)) 
  {
    opt = lua_tointeger( L, 1 );
    text = UTF8CharToWChar(lua_tostring( L, 2 ));
    rMsgBx_setLabel(opt, text.c_str());
  } else {
    showErrorMsg("Arguments Error! - MsgBox_Customize_Btn(buttonId ,text)");
    lua_pushnil(L);    
  }
  return 1;
}

//implementazione MessageBox
LUALIB_API int c_MsgBox(lua_State *L)
{
  const int n = lua_gettop(L);
  std::wstring msg;
  std::wstring title;
  lua_Number opt;
  int res;
  HWND hwndOwner;
  /*std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> convert;
  std::wstring utf8 = convert.to_bytes(0x5e9);*/
  

  if ((n > 0) && (n < 4) && (lua_type(L,1)==LUA_TSTRING)) {    
    if ((hwndOwner = GetActiveWindow()) == NULL) {
            hwndOwner = GetDesktopWindow();
        }
    msg = UTF8CharToWChar(lua_tostring(L,1));

    if (n > 1)
      title = UTF8CharToWChar(lua_tostring( L, 2 ));
    else
      title = UTF8CharToWChar(LS_NAMESPACE);
    if (n > 2)
      opt = lua_tonumber( L, 3 );
    else
      opt = MB_OK;
	
	//res = MessageBox(hwndOwner,msg,title,(UINT)opt);
	res = rMsgBx_show(hwndOwner, msg.c_str(), title.c_str(),(UINT)opt);

    lua_pushnumber(L, res);

  } else {
    showErrorMsg("Arguments Error! - MsgBox(messaggio [,titolo [,flag, [custom_button]]])");
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
    showErrorMsg("Wrong arguments! - InputDlg(prompt ,title ,default, tempFileName)");
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
      lua_pushinteger(L, res);
  } else {
    //lua_pushstring(L, "Argomenti errati! - ListDlg(Elementi, Titolo, flagDialog)");
    showErrorMsg("Wrong arguments! - ListDlg(Elementi, Titolo, flagDialog, XPosition, YPosition, XDimension, YDimension, RelativePosition, regKey, preselectedItem)");
    lua_pushnil(L);
  }
  return 1;
}

LUALIB_API int c_GetFileName(lua_State *L)
{
  OPENFILENAMEW ofn;       // common dialog box structure
  wchar_t szFile[_MAX_PATH];       // buffer for file name
  const int n = lua_gettop(L);
  std::wstring title, defaultPath, fileName;
  std::wstring estensione;
  wchar_t bufferExt[255];
  lua_Number opt;

  if ((lua_type(L,1)==LUA_TSTRING) && 
      (lua_type(L,2)==LUA_TSTRING) &&
      (lua_type(L,3)==LUA_TNUMBER) && 
			(lua_type(L,4)==LUA_TSTRING) && 
      (n > 3))
  {

    title = UTF8CharToWChar(lua_tostring(L,1)); //titolo finestra
    defaultPath = UTF8CharToWChar(lua_tostring(L,2)); //percorso di default
    opt = lua_tonumber(L,3); //opzioni 
	fileName = UTF8CharToWChar(lua_tostring(L,4)); //nome file scambio temporaneo
    
    if ( (n==5) &&(lua_type(L,5)==LUA_TSTRING))
    {
      estensione = UTF8CharToWChar(lua_tostring(L,5));//filtro
      ZeroMemory(bufferExt, sizeof(bufferExt));
      //sostituisce i %c con il carattere '\0'
      swprintf(bufferExt,estensione.c_str(), '\0');
    } else
        estensione = L"";

    // Initialize OPENFILENAME
    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    ofn.hwndOwner = GetActiveWindow();
    ofn.lpstrFile = szFile;
    ofn.lpstrFile[0] = '\0';
    ofn.nMaxFile = sizeof(szFile);
    if (estensione.empty())
      ofn.lpstrFilter = L"Tutto\0*.*\0";
    else
      ofn.lpstrFilter = bufferExt;
    ofn.nFilterIndex = 0;
    ofn.lpstrFileTitle = NULL;
    ofn.nMaxFileTitle = 0;
    ofn.lpstrInitialDir = defaultPath.c_str();
    ofn.Flags = OFN_HIDEREADONLY | (DWORD)opt;//OFN_CREATEPROMPT | OFN_HIDEREADONLY;
    ofn.lpstrTitle = title.c_str();

        // Display the Open dialog box. 
		if (GetOpenFileNameW(&ofn)==TRUE) {
			writeStrinToTmpW(ofn.lpstrFile, fileName.c_str());
			lua_pushboolean(L, 1);
		} else
            lua_pushnil(L);
  } else {
    //lua_pushstring(L, "Argomenti errati! - GetFileName(Titolo, Percorso di Default, Opzioni)");
		showErrorMsg("Wrong arguments! - GetFileName(Titolo, Percorso di Default, Opzioni,Path File Temporaneo,[Filtri])");
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
    showErrorMsg("Wrong arguments! - GetColorDlg()");
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
    showErrorMsg("Wrong arguments! - SendCmdScite(comando)");
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
    showErrorMsg("Wrong arguments! - PathIsDirectory(path)");
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
    showErrorMsg("Wrong arguments! - SetIniValue(pathIniFile, Section, Key, Value)");
    lua_pushnil(L);
  }

  return 1;
}

LUALIB_API int c_BrowseForFolder(lua_State *L)
{
  wchar_t s[MAX_PATH] = L"\0";
  BROWSEINFOW bi;
  LPITEMIDLIST pidl;
  const int n = lua_gettop(L);
  std::wstring msg;
  std::wstring fileName;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (n == 2))
  {
    msg = UTF8CharToWChar(lua_tostring(L,1));
    fileName = UTF8CharToWChar(lua_tostring(L,2));

    bi.hwndOwner = GetActiveWindow();
    bi.pidlRoot = NULL;
    bi.pszDisplayName = s;
    bi.lpszTitle = msg.c_str();
    bi.ulFlags = BIF_RETURNONLYFSDIRS;
    bi.lpfn = 0;
    bi.lParam = 0;

    pidl = SHBrowseForFolderW(&bi);
    if(pidl != NULL) {
        SHGetPathFromIDListW(pidl, s);
      //lua_pushstring(L, s);
        writeStrinToTmpW(s, fileName.c_str());
		lua_pushboolean(L, 1);
	    CoTaskMemFree(pidl);
    }
    else
      lua_pushnil(L);

  } else {
    //lua_pushstring(L, "Argomenti errati! - BrowseForFolder(title)");
    showErrorMsg("Wrong arguments! - BrowseForFolder(title)");
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
    showErrorMsg("Wrong arguments! - shellAndWait(Command)");
    lua_pushnil(L);
    return 1;
  }

} //endfunction

//c_shellExecute
//verbi utilizzabili
const enum SHELLEXECUTEEX_VERB {
    EDIT = 0,
    EXPLORE = 1,
    FIND = 2,
    OPEN = 3,
    OPENAS = 4,
    PRINT = 5,
    PROPERTIES = 6,
    RUNAS = 7
};

//c_shellExecute
LUALIB_API int c_shellExecuteEx(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *path;  
  const char *parameters;  
  HWND hwndOwner;
  std::wstring par1;
  std::wstring par2;
  int parVerb;
  int showFlag;
  SHELLEXECUTEINFOW ShExecInfo;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (lua_type(L,3)==LUA_TNUMBER) &&
      (lua_type(L,4)==LUA_TNUMBER) &&
      (n == 4))
  {
    path = lua_tostring(L,1);
    parameters = lua_tostring(L,2);
    parVerb = lua_tointeger(L,3);
    showFlag = lua_tointeger(L,4);

    par1 = UTF8CharToWChar(path);
    par2 = UTF8CharToWChar(parameters);

    if ((hwndOwner = GetActiveWindow()) == NULL) {
          hwndOwner = GetDesktopWindow();
    }
   
    ZeroMemory(&ShExecInfo, sizeof(SHELLEXECUTEINFOW));
    ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFOW);
    ShExecInfo.fMask = NULL;
    ShExecInfo.hwnd = hwndOwner;
    ShExecInfo.lpVerb = NULL;
    ShExecInfo.lpFile = par1.c_str();
    ShExecInfo.lpParameters = NULL;
    ShExecInfo.lpDirectory = NULL;
    ShExecInfo.nShow = showFlag;
    ShExecInfo.hInstApp = NULL;

    switch (parVerb)
    {
    case SHELLEXECUTEEX_VERB::EDIT :
        ShExecInfo.lpVerb = L"edit";
        break;
    case SHELLEXECUTEEX_VERB::EXPLORE :
        ShExecInfo.lpVerb = L"explore";
        break;
    case SHELLEXECUTEEX_VERB::FIND :
        ShExecInfo.lpVerb = L"find";
        break;
    case SHELLEXECUTEEX_VERB::OPEN :
        ShExecInfo.lpVerb = L"open";
        ShExecInfo.lpParameters = par2.c_str();
        break;
    case SHELLEXECUTEEX_VERB::OPENAS :
        ShExecInfo.lpVerb = L"openas";
        ShExecInfo.fMask = SEE_MASK_INVOKEIDLIST;
        break;
    case SHELLEXECUTEEX_VERB::PRINT :
        ShExecInfo.lpVerb = L"print";
        break;
    case SHELLEXECUTEEX_VERB::PROPERTIES:
        ShExecInfo.lpVerb = L"properties";
        ShExecInfo.fMask = SEE_MASK_INVOKEIDLIST;
        break;
    case SHELLEXECUTEEX_VERB::RUNAS:
        ShExecInfo.lpVerb = L"runas";
        ShExecInfo.lpParameters = par2.c_str();
        break;
    default:
        break;
    }

    if (ShellExecuteExW(&ShExecInfo))
        lua_pushboolean(L, 1);
    else
        lua_pushboolean(L, 0);

    return 1;
  } else {
    showErrorMsg("Wrong arguments! - ShellExecuteEx(ExePath, Parameters, Verb, ShowFlag)");
    lua_pushnil(L);
    return 1;
  }
}

//c_shellExecute
LUALIB_API int c_shellExecute(lua_State *L)
{
  const int n = lua_gettop(L);
  const char *path;  
  const char *parameters;  
  HWND hwndOwner;
  std::wstring par1;
  std::wstring par2;

  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (n == 2))
  {
    path = lua_tostring(L,1);
    parameters = lua_tostring(L,2);

    par1 = UTF8CharToWChar(path);
    par2 = UTF8CharToWChar(parameters);

    if ((hwndOwner = GetActiveWindow()) == NULL) {
          hwndOwner = GetDesktopWindow();
    }
   
    //ShellExecute(hwndOwner, "open", path, parameters, NULL, SW_SHOWNORMAL);
    ShellExecuteW(hwndOwner, L"open", par1.c_str(), par2.c_str(), NULL, SW_SHOWNORMAL);

    return 0;
  } else {
    //lua_pushstring(L, "Argomenti errati! - ShellExecute(ExePath, Parameters)");
    showErrorMsg("Wrong arguments! - ShellExecute(ExePath, Parameters)");
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
  std::wstring from;
  std::wstring to;
  std::wstring operation;
  HWND hwndOwner;
  SHFILEOPSTRUCTW lpFileOp;
  long Op=0;
  lua_Integer value;


  if ((lua_type(L,1)==LUA_TSTRING) &&
      (lua_type(L,2)==LUA_TSTRING) &&
      (lua_type(L,3)==LUA_TSTRING) &&
      (lua_type(L,4)==LUA_TNUMBER) &&
      (n == 4))
  {
    from = UTF8CharToWChar(lua_tostring(L,1)); //sorgente
    to = UTF8CharToWChar(lua_tostring(L,2)); //destinazione
    operation = UTF8CharToWChar(lua_tostring(L,3)); //operazione
    value = lua_tointeger(L,4); //flag

    if ((hwndOwner = GetActiveWindow()) == NULL) {
          hwndOwner = GetDesktopWindow();
    }
   
    lpFileOp.hwnd = hwndOwner;
    lpFileOp.pFrom = from.c_str();
    lpFileOp.pTo = to.c_str();

    lpFileOp.fFlags = (FILEOP_FLAGS)value;

    if (_wcsicmp(operation.c_str(), L"copy") == 0) {
      Op = FO_COPY;
    } else if (_wcsicmp(operation.c_str(), L"delete") == 0) {
      Op = FO_DELETE;
      lpFileOp.pTo = NULL;
      //lpFileOp.fFlags = FOF_ALLOWUNDO;
    } else if (_wcsicmp(operation.c_str(), L"move")==0) {
      Op = FO_MOVE;
    } else if (_wcsicmp(operation.c_str(), L"rename") == 0) {
      Op = FO_RENAME;
    }

    if (Op > 0) {
      lpFileOp.wFunc = Op;
      if (SHFileOperationW(&lpFileOp)==0){
        lua_pushboolean(L, 1); //tutto OK
        return 1;
      }else{
        lua_pushnil(L); //ipossibile offettuare l'operazione
        return 1;
      }
    } else {
      showErrorMsg("Operation not valid!");
      lua_pushnil(L);
      return 1;
    }
    return 0;
  } else {
    showErrorMsg("Missing argoments! - fileOperation(From, To, Operation, Flag)");
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
    showErrorMsg("Wrong arguments! - createDirectory(directory)");
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
	dat = value;

    if (RegCreateKeyEx(HKEY_CURRENT_USER, key, 
          0, NULL, REG_OPTION_NON_VOLATILE,
          KEY_WRITE, NULL, &hk, &dwDisp) != ERROR_SUCCESS) 
    {
      //showErrorMsg("Impossibile aprire o creare la chiave indicata!");
      lua_pushnil(L);
      return 1;
    }

    if (RegSetValueEx(hk,              // subkey handle 
            valueName,        // value name 
            0,                         // must be zero 
            REG_DWORD,             // value type 
            (const PBYTE) &dat,        // pointer to value data 
            (DWORD) sizeof(dat))) // length of value data 
    {      
      RegCloseKey(hk);
      //showErrorMsg("Impossibile scrivere il valore indicato!");
      lua_pushnil(L);
      return 1;
    }

    RegCloseKey(hk);
    lua_pushboolean(L, 1);
    return 1;

  } else {
    showErrorMsg("Wrong arguments! - RegSetInteger(Key, Value, DataNumber)");
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
      lua_pushnil(L);
      return 1;
	}
	
    if( lRet != ERROR_SUCCESS )
    {
      //showErrorMsg("Error! Missing Key!");
      lua_pushnil(L);
      return 1;
    }

    lRet = RegQueryValueEx(hk, valueName, NULL, NULL,
      (LPBYTE) &value, &dwBufLen);
    if( (lRet != ERROR_SUCCESS) || (dwBufLen > sizeof(value)) )
    {
      RegCloseKey(hk);
      //showErrorMsg("Impossibile leggere il valore indicato!");
      lua_pushnil(L);
      return 1;
    }
    RegCloseKey(hk);
    lua_pushnumber(L, value);
    return 1;
  } else {
    showErrorMsg("Missin Arguments! - RegGetInteger(Key, Value, MainKey)");
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
      lua_pushnil(L);
      return 1;
	}
	
    if( lRet != ERROR_SUCCESS )
    {
      //showErrorMsg("Error! Missing Key!");
      lua_pushnil(L);
      return 1;
    }

    lRet = RegQueryValueEx(hk, valueName, NULL, NULL, (LPBYTE) &buffer_char, &dwBufLen);
    if(lRet != ERROR_SUCCESS)
    {
      RegCloseKey(hk);
      //showErrorMsg("Impossibile leggere il valore indicato!");
      lua_pushnil(L);
      return 1;
    }
    
    RegCloseKey(hk);
    writeStrinToTmp(buffer_char, fileName);
    //lua_pushnumber(L, value);
    return 1;
  } else {
    showErrorMsg("Missin Arguments! - RegGetString(Key, Value, MainKey, outputTempFileName)");
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
    showErrorMsg("Wrong arguments! - Sleep(Milliseconds)");
    lua_pushnil(L);
    return 1;
  }
}

//genera un GUID
LUALIB_API int c_GetGUID(lua_State *L)
{
	GUID id;
	WCHAR buffer[256];
	std::string buffer_char;

    buffer[255] = '\0';
    buffer_char = "";

    if (CoCreateGuid(&id) == S_OK)
    {
        if (StringFromGUID2(id, buffer, 255) > 0)
            buffer_char = WCharToUTF8Char(buffer);
    }
    lua_pushstring(L, buffer_char.c_str());
  
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
    lua_pushnil(L);
    return 1;
  }
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
		lua_pushnil(L);
	}
	return 1;
}

void pushStringsTable(lua_State* L, std::list<std::wstring> lst)
{
    lua_Integer i;

    if (lst.size() > 0)
    {
        lua_newtable(L);
        i = 1;
        for (std::list<std::wstring>::iterator it = lst.begin(); it != lst.end(); ++it)
        {
            lua_pushstring(L, WCharToUTF8Char(it->c_str()).c_str());
            lua_rawseti(L, -2, i);
            i++;
        }
    }
    else
    {
        lua_pushnil(L);
    }
}

LUALIB_API int c_GetFilesList(lua_State* L)
{
    const int n = lua_gettop(L);
    bool onlyFolder = false; 
    bool addOk = false;
    std::wstring defaultPath;
    WIN32_FIND_DATAW FindFileData;
    HANDLE hFind;
    DWORD dwError = 0;
    std::list<std::wstring> lst;
    
    if ((lua_type(L, 1) == LUA_TSTRING) && //The directory or path, and the file name.
        (lua_type(L, 2) == LUA_TBOOLEAN) && //get folders
        (n > 1))
    {
        defaultPath = UTF8CharToWChar(lua_tostring(L, 1)); //path
        onlyFolder = lua_toboolean(L, 2); //get folders

        hFind = FindFirstFileW(defaultPath.c_str(), &FindFileData);
        if (hFind == INVALID_HANDLE_VALUE)
        {
            lua_pushnil(L);
        }
        else
        {
            // List all the files in the directory with some info about them.
            do
            {
                if (FindFileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
                {
                    if (onlyFolder)
                        addOk = true;
                    else
                        addOk = false;
                }
                else
                    addOk = !onlyFolder;

                if (addOk)
                {
                    lst.push_back(FindFileData.cFileName);
                }
            } while (FindNextFileW(hFind, &FindFileData) != 0);

            dwError = GetLastError();
            if (dwError == ERROR_NO_MORE_FILES)
            {
                pushStringsTable(L, lst);
            } else
                lua_pushnil(L);

            FindClose(hFind);            
        }
    }
    else {
        //lua_pushstring(L, "Argomenti errati!");
        showErrorMsg("Arguments error! - GetFilesList(path, getOnlyFolders)");
        lua_pushnil(L);
    }

    return 1;
}

//visualizza il menu contestuale di windows per il file/cartella specificato
LUALIB_API int c_ShowProperties(lua_State* L)
{
    const int n = lua_gettop(L);
    std::wstring path;
    int x = 100;
    int y = 100;
    POINT lpPoint;

    if ((lua_type(L, 1) == LUA_TSTRING) && //The directory or path, and the file name.
        (lua_type(L, 2) == LUA_TNUMBER) &&
        (lua_type(L, 3) == LUA_TNUMBER) &&
        (n == 3))
    {
        clPropsDialog props;
        path = UTF8CharToWChar(lua_tostring(L, 1)); //path
        x = lua_tonumber(L, 2); //posizione X
        y = lua_tonumber(L, 3); //posizione Y 

        if ((x < 0) || (y < 0))
        {
            if (GetCursorPos(&lpPoint) != 0)
            {
                x = lpPoint.x;
                y = lpPoint.y;
            }
        }

        props.openMenu(GetActiveWindow(), path, x, y);
        lua_pushboolean(L, 1);
    }
    else {
        //lua_pushstring(L, "Argomenti errati!");
        showErrorMsg("Arguments error! - ShowProperties(path, posX, posY)");
        lua_pushnil(L);
    }

    return 1;
}

//modifica lo stato della finestra corrente
LUALIB_API int c_ShowActiveWindow(lua_State* L)
{
    const int n = lua_gettop(L);
    HWND hwndOwner = NULL;
    int opt;

    if ((lua_type(L, 1) == LUA_TNUMBER) &&
        (n == 1))
    {
        opt = lua_tointeger(L, 1);

        if ((hwndOwner = GetActiveWindow()) == NULL) {
            hwndOwner = GetDesktopWindow();
        }

        ShowWindow(hwndOwner, opt);
        lua_pushboolean(L, 1);
    }
    else {
        //lua_pushstring(L, "Argomenti errati!");
        showErrorMsg("Arguments error! - ShowActiveWindow(option)");
        lua_pushnil(L);
    }

    return 1;
}



LUALIB_API int c_Test(lua_State *L)
{
    std::list<std::wstring> lst;
    
    for (int i = 0; i < 10000; i++)
    {
        lst.push_back(L"Uno");
        lst.push_back(L"D©®u֍Փe");
        lst.push_back(L"Tre");
        lst.push_back(L"");
    }

    pushStringsTable(L, lst);

	return 1;
}

