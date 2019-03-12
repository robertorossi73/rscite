--[[
Version : 1.1.0
Web     : http://www.redchar.net

Gestore avanzato Bookmark

Questo modulo consente il salvataggio dei bookmarks presenti all'interno di
un file e il loro recupero. Questo modulo dovrà essere utilizzato attraverso
la combinazione Ctrl+Shift+F2.

Il database nel quale verranno salvati i dati sarà formato da n linee, ognuna
delle quali riporterà un nome di file con percorso e il relativo elenco di 
bookmarks, es.:

...
c:\cartella1\cartella2\esempio.txt?1,23,45,12,67
c:\esempio2.xml?1
...

Per evitare spiacevoli concomitanze il separatore tra file e bookmarks sarà
il carattere '?'.

-- TODO : Funzioni da implemetare in futuro
. Implementare ottimizzazione DB, eliminando file non più esistenti, al posto
  della semplice apertura del DB
. autosalvataggio bookmarks quando si salva o si chiude file
  corrente. In base a nuova impostazione da inserire in file di
  configurazione

Copyright (C) 2010-2019 Roberto Rossi 
*******************************************************************************
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
*******************************************************************************

V.1.1.0

- TODO : Aggiunte funzioni
  . Elimina linee contrassegnate da segnalibri
  . Svuota linee contrassegnate da segnalibri senza eliminarle

]]

do
  require("luascr/rluawfx")

  -- nome file DB per archiviazione dati
  local GBOOKM_DB_FILE = "gbookmdb.ini"
  
  --ritorna una tabella contenente l'elenco delle linee identificate da un
  --bookmark
  --Se non esiste alcun bookmark ritorna false
  local function getBookLinesNum ()
    local bookmLines = false
    local i = 0
    local id = 0
    local maxline
    
    maxline = editor.LineCount
    
    while (i < maxline) do
      if (editor:MarkerGet(i) > 0) then
        if (not(bookmLines)) then
          bookmLines = {}
        end
        bookmLines[id] = i
        id = id + 1
      end
      i = i + 1
    end
    
    return bookmLines
  end
  
  --copia le linee identificate da un bookmark all'interno della clipboard
  local function copyBookLines ()
    local bookms = getBookLinesNum()
    local i = 0
    local valore
    local text = ""
    local maxt = false
    
    if (bookms) then
      maxt = #bookms
      while (i <= maxt) do
        text = text..editor:GetLine(bookms[i])
        i = i + 1
      end
    end
    
    if (text ~= "") then
      editor:CopyText(text);
    else
      --rwfx_MsgBox("Nessun segnalibro trovato","Attenzione",MB_OK)
      rwfx_MsgBox(_t(172),_t(9),MB_OK)
    end
  end
  
  --dato il path di un file, carica i suoi segnalibri
  --descritti nel file INI
  local function loadBookmFrom(key)
    local result = false
    local bookms
    local tblbook
    local i
    local v
    
    fname = rfx_UserFolderRSciTE().."\\"..GBOOKM_DB_FILE
    key = string.gsub(key, "=", "?") --sistema eventuale carattere =
    bookms = rfx_GetIniVal(fname,"General", key)
    if (bookms ~= "") then
      tblbook = rfx_Split(bookms,",")
      for i,v in ipairs(tblbook) do
        editor:MarkerAdd(v,1)
      end
      result = true
    end
    return result
  end
  
  --carica i segnalibri precedentemente salvati
  --ritorna true nel caso venga salvato almeno un segnalibro
  local function loadBookm ()
    local key
    
    key = props["FilePath"]
    return loadBookmFrom(key)
  end
  
  --salva i segnalibri del file corrente all'interno del database
  --ritorna true nel caso almeno un segnalibro venga salvato
  local function saveBookm ()
    local result = false
    local bookms = getBookLinesNum()
    local i = 0
    local valore
    local text = ""
    local maxt = false
    local fname = ""
    local key = ""
    local idf = 0
    
    if (bookms) then
      maxt = #bookms
      while (i <= maxt) do
        if (text == "") then
          text = tostring(bookms[i])
        else
          text = text..","..tostring(bookms[i])
        end
        result = true
        i = i + 1
      end
    end
    
    if (text ~= "") then  
      fname = rfx_UserFolderRSciTE().."\\"..GBOOKM_DB_FILE
      key = props["FilePath"]
      key = string.gsub(key, "=", "?") --sistema eventuale carattere =
      if rfx_setIniVal(fname, "General", key, text) then
        result = true
      end
    else
      --rwfx_MsgBox("Nessun segnalibro trovato","Attenzione",MB_OK)
      rwfx_MsgBox(_t(172),_t(9),MB_OK)
    end
    
    return result
  end
  
    --mostra tutte le linee con bookmark in modo che cliccandoci si vada alla
    -- linea relativa
    local function showBookm()
        local bookms = getBookLinesNum()
        local i = 0
        local text = ""
        local maxt = false

        print("")
        if (bookms) then
          maxt = #bookms
          while (i <= maxt) do
            text = ":"..tostring(bookms[i]+1)..": "..
                    rfx_RemoveReturnLine(rfx_Trim(editor:GetLine(bookms[i])))
            print(text)
            i = i + 1
          end
        end
    end
  
  --ottimizza database bookmarks eliminando i riferimenti
  --ai file non esistenti
  --ritorna true nel caso qualcosa sia stato ottimizzato
  local function optiDB ()
    local result = false
    local fname
    fname = rfx_UserFolderRSciTE().."\\"..GBOOKM_DB_FILE
    scite.Open(fname)
    return result
  end
  
  --consente la selezione, tramite finestra di dialogo, del file
  --dal quale caricare i bookmark
  local function loadOtherBookm ()
    local result = false
    local dati
    local fname
    local lista = ""
    local scelta
    
    fname = rfx_UserFolderRSciTE().."\\"..GBOOKM_DB_FILE
    dati = rfx_GetIniSec(fname, "General")
    for i,v in ipairs(dati) do
      if (lista == "") then
        lista = v
      else
        lista = lista.."|"..v
      end
    end
    
    --scelta = rwfx_ShowList(lista,"Seleziona segnalibri da ripristinare",false)
    scelta = rwfx_ShowList(lista,_t(173),false)
    if (scelta) then
      --print(dati[scelta+1])
      result = loadBookmFrom(dati[scelta+1])
    end
    
--  rwfx_MsgBox("This function is not implemented!","Alert!",MB_OK)
    return result
  end
  
  -- ritorna la scelta dell'utente :
  --  false = l'utente preme annulla
  local function questionFx()
    local lista = ""
    local id
    local scelta
    local tipo = false
    
--~     lista = lista.."Carica segnalibri per file corrente"
--~     lista = lista.."|Salva segnalibri correnti"
--~     lista = lista.."|Copia linee identificate da segnalibri in appunti"
--~     lista = lista.."|Carica segnalibri da altro file"
--~     lista = lista.."|Commuta segnlibro linea corrente"
--~     lista = lista.."|Elimina tutti i segnalibri dal file corrente"
--~     lista = lista.."|Elimina linee contrassegnate da segnalibri
--~     lista = lista.."|Svuota linee contrassegnate da segnalibri senza eliminarle
--~     lista = lista.."|Vai al segnalibro successivo"
--~     lista = lista.."|Vai al segnalibro precedente"
--~     lista = lista.."|Seleziona fino al prossimo segnalibro"
--~     lista = lista.."|Seleziona fino al precedente segnalibro"
--~     lista = lista.."|Apri base dati segnalibri"
    lista = _t(175)
    
    --scelta = rwfx_ShowList_presel(lista,"Gestione Segnalibri","gbookm",false)
    scelta = rwfx_ShowList_presel(lista,_t(174),"gbookm",false)
    if (scelta) then
      tipo = scelta 
    end
    
    return tipo
  end
  
  local function main()
    local scelta = questionFx()
    local msg = ""
    
    if (scelta) then
      if (scelta==0) then
        --carica segnalibri
        loadBookm()
      elseif (scelta==1) then
        --salva segnalibri
        saveBookm()
      elseif (scelta==2) then
        --mostra tutte le linee con bookmark
        showBookm()
      elseif (scelta==3) then
        --copia linee in clipboard
        copyBookLines()
      elseif (scelta==4) then
        --selezione segnalibri da ripristinare
        loadOtherBookm()
      elseif (scelta==5) then
        --commuta segnalibro
        scite.MenuCommand(IDM_BOOKMARK_TOGGLE)
      elseif (scelta==6) then
        ----elimina segnalibri
        scite.MenuCommand(IDM_BOOKMARK_CLEARALL)
      elseif (scelta==7) then
        --successivo
        scite.MenuCommand(IDM_BOOKMARK_NEXT)
      elseif (scelta==8) then
        --precedente
        scite.MenuCommand(IDM_BOOKMARK_PREV)
      elseif (scelta==9) then
        --seleziona filo al successivo
        scite.MenuCommand(IDM_BOOKMARK_NEXT_SELECT)
      elseif (scelta==10) then
        --seleziona fino al precedente
        scite.MenuCommand(IDM_BOOKMARK_PREV_SELECT)
      elseif (scelta==11) then
        --apri base dati
        optiDB()
      end --endif
    end 
  end--endfunction
  
  main()
end
