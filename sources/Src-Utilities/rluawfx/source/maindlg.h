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


