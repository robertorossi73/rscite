
#include <lauxlib.h>
#include <lua.h>

struct stDataDialog {
  lua_Integer tmpPositionX; //posizione X dialog(temporaneo);
  lua_Integer tmpPositionY; //posizione Y dialog(temporaneo);
  lua_Integer tmpDimensionX; //dimensione X dialog(temporaneo);
  lua_Integer tmpDimensionY; //dimensione Y dialog(temporaneo);
  BOOL tmpSavePosDimDialog; //indica se salvare posizione e dimensione all'uscita
  BOOL tmpRelativePosition; //indica se la posizione della finestra è relativa al padre
  const char *registerKey; //chiave di registro per lettura/scrittura dati
  int tmpSelectedItemIndex; //elemento preselezionato nella lista elementi
};

extern stDataDialog public_dataDialog; //dati dialog

extern long public_tmpSelectedItem; //elemento selezionato(temporaneo)
extern const char *public_tmpItemsString; //elenco voci da inserire nella lista(temporaneo)
extern const char *public_tmpDialogTitle; //titolo dialog(temporaneo);
extern const char *public_tmpDialogPrompt; //prompt dialog(temporaneo);
extern char *public_tmpResultsString; //trasferimento stringa (temporaneo);

extern char public_DllFileName[_MAX_PATH]; //file dll corrente comprensivo di percorso

LUALIB_API int c_Test(lua_State *L);

LUALIB_API int c_MsgBox(lua_State *L); //standard message box
LUALIB_API int c_ListDlg(lua_State *L); //list dialog
LUALIB_API int c_InputDlg(lua_State *L); //Input dialog
LUALIB_API int c_GetFileName(lua_State *L); //file box
LUALIB_API int c_GetColorDlg(lua_State *L); //color dialog
LUALIB_API int c_PathIsDirectory(lua_State *L); //controlla se un percorso è una cartella
LUALIB_API int c_BrowseForFolder(lua_State *L); //Dialog BrowseForFolder
LUALIB_API int c_shellExecute(lua_State *L); //esecuzione programma
LUALIB_API int c_RegSetInteger(lua_State *L); //scrive valore intero in registro
LUALIB_API int c_RegGetInteger(lua_State *L); //legge un valore intero dal registro

long Execute_InputDlg(HINSTANCE, HWND);
long Execute_LstDlg(HINSTANCE, HWND);
int isEnglishLang(void);