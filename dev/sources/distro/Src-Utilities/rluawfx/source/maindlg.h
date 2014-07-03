
//numero massimo voci nella lista di selezione
#define LSTDLG_MAX_LIST_ITEM 1000
//dimensione massima stringa per singola voce nella lista di selezione
#define LSTDLG_MAX_ITEM_LEN 300

//dati per lista di selezione
struct tp_LstDlg_data {
  int nelementi; //numero elementi lista
  char itamMax[LSTDLG_MAX_ITEM_LEN]; //stringa più lunga
  int elementMapper[LSTDLG_MAX_LIST_ITEM]; //indice originale per le voci visualizzate nella lista
  WNDPROC LstDlg_EditProc; //callback standard per la casella di testo in dialog
} public_LstDlg_data;


