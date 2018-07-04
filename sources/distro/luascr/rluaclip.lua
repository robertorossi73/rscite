--[[
Version : 1.3.4
Web     : http://www.redchar.net

Questa procedura implementa la copia dei dati in slot fissi. Nella pratica
implementa un gestore appunti avanzati.

Nel caso in cui non ci sia una selezione viene copiata o tagliata la linea
corrente, però senza che intervenga il gestore degli appunti.

Copyright (C) 2010-2018 Roberto Rossi 
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
]]

do
  require("luascr/rluawfx")
   
  local MAX_NUM_SLOT = 100
  local SLOT_FILE_NAME = "\\slot"
  local SLOT_FILE_EXT = ".dat"
  local SLOT_FILE_FOLDER = "slots"
  local SLOT_PATH_FOLDER = ""
  local SLOT_DATA_SEP = "-"
  
  --elimina gli spazi, le tabulazioni e i ritorni a capo presenti all'inizio
  --della stringa indicata
  --TODO : purtroppo la semplice eliminazione di questi caratteri elimina
  --       la corretta indentazione della prima linea della selezione
  local function trimTextForSlot(text)
       local result = ""
      local pos1 = 0
      
      if ( text ) then
        --trova il primo carattere NON spazio, NON tabulazione
        --e NON ritorno a capo
        --pos1 = string.find(text, "[^ \t\n\r]")
        
        --if (pos1) then
        --  if pos1 then
        --    result = string.sub(text, pos1)
        --  else
            result = text
        --  end
        --end
      end --controllo esistenza testo
      return result
  end
  
  
  --converte una tabella in una stringa da passare alle funzioni di 
  --visualizzazione list rwfx...
  local function tableToStringList(tbl)
    local i
    local v
    local result = ""
    
    for i,v in pairs(tbl) do
      if (result == "") then
        result = rfx_Trim(v)
      else
        result = result.."|"..rfx_Trim(v)
      end
    end    
    return result
  end
  
  --ritorna il path della cartella contenente i file degli slot
  local function getSlotPath()
    local userpath
    
    userpath = rfx_UserFolderRSciTE().."\\"..SLOT_FILE_FOLDER
    
    if (not(rwfx_PathIsDirectory(userpath))) then
      rwfx_createDirectory(userpath)
    end
    return userpath
  end
  
  --ritorna la prima linea dello slot indicato (da 1 a MAX_NUM_SLOT)
  local function getSlotTitle(slotn)
    local result = ""
    local idf
    local nomef
    local exist = false
    
    nomef = SLOT_PATH_FOLDER..SLOT_FILE_NAME..tostring(slotn)..SLOT_FILE_EXT
    idf = io.open(nomef, "r")
    if (idf) then
      result = idf:read() --lettura prima linea
      if (string.len(result) > 250) then
        result = string.sub(result, 1, 250).."..."
      end
      io.close(idf)
      exist = true
    end
    
    if ((rfx_Trim(result) == "") and exist) then
      result = _t(158) --"Prima linea Vuota!"
    end
    
    return result
  end
  
  --ritorna il contenuto dello slot n (da 1 a MAX_NUM_SLOT)
  local function getSlot(slotn)
    local result = ""
    local idf
    local nomef
    
    nomef = SLOT_PATH_FOLDER..SLOT_FILE_NAME..tostring(slotn)..SLOT_FILE_EXT
    idf = io.open(nomef, "r")
    if (idf) then
      result = idf:read("*a")
      io.close(idf)
    end
    
    --TIPS per windows
    --Questa linea trasforma il fine linea in [CR][LF]. Senza questo intervento
    --il file verrà inserito solamente con il terminatore di linea [LF]
    result = string.gsub(result,"\n","\r\n")
    
    return result
  end
  
  --ritorna l'elenco degli slot presenti, compreso il contenuto della prima
  --linea
  local function getListSlots ()
    local i = 1
    local result = {}
    local title
    
    while (i <= MAX_NUM_SLOT) do
      title = getSlotTitle(i)
      result[i] = tostring(i)..SLOT_DATA_SEP..title
      
      i = i + 1
    end
    
    return result
  end
  
  --salva il testo selezionato nell'editor, all'interno dello slot indicato
  -- da 1 a MAX_NUM_SLOT
  local function setSlot(slotn, text)
    local nomef = ""
    local result = false
    local idf
    
    if ( text == "") then
      --nessun salvataggio
      result = false
    else
      text = trimTextForSlot(text)
      nomef = SLOT_PATH_FOLDER..SLOT_FILE_NAME..tostring(slotn)..SLOT_FILE_EXT
      idf = io.open(nomef, "w")
      if (idf) then
        
        --TIPS per Windows
        --questa sostituzione impedisce l'insrimento ERRATO dei ritorni a capo.
        --Senza questa linea, ogni linea della selezione verrebbe terminata
        --con [CR][CR][LF]
        text = string.gsub(text,"\r","")
        
        idf:write(text)
        io.close(idf)
        result = true
      end
    end
    
    return result
  end
  
  
  --verifica la selezione corrente ed avvisa l'utente se questa è vuota
  local function checkSelection ()
  local result = true
  
    if (editor:GetSelText() == "") then
      --attenzione seleziona mancante
      --rwfx_MsgBox("Selezione Mancante","Attenzione",MB_OK)
      --rwfx_MsgBox(_t(159),_t(9),MB_OK)
      result = false
    end
  return result
  end
  
  --funziont globale
  --esegue una delle seguenti operazioni
  -- operation = 1 : copia testo selezionato in uno slot
  -- operation = 2 : taglia il testo selezionato e lo inserisce in uno slot
  -- operation = 3 : incolla il testo presente in uno slot
  --
  function rluaclip_main(operation)
    local lista
    local scelta
    local text
    local nslot
    local pos
    local cutcopyOk = false
    
    SLOT_PATH_FOLDER = getSlotPath()
    lista = getListSlots()

    
    if ((operation == 1) or (operation == 2)) then --copia
        if (checkSelection()) then
            scelta = rwfx_ShowList(tableToStringList(lista),"Salvare testo in...")
            if (scelta) then
                text = lista[scelta+1]
                pos = string.find(text, SLOT_DATA_SEP)
                nslot = string.sub(text,1,pos-1)
                setSlot(nslot,editor:GetSelText())
                editor:CopyText(editor:GetSelText()); --copia nella clipboard
                cutcopyOk = true
            end
        else
            --copia/taglia linea corrente
            editor:CopyText(editor:GetCurLine()); --copia nella clipboard
            cutcopyOk = true
        end
    elseif (operation == 3) then --incolla
      --scelta = rwfx_ShowList(tableToStringList(lista),"Selezionare elemento da inserire...")
      scelta = rwfx_ShowList_presel(tableToStringList(lista),_t(101),"rluaclip",false)
      if (scelta) then
        text = lista[scelta+1]
        pos = string.find(text, SLOT_DATA_SEP)
        nslot = string.sub(text,1,pos-1)
        text = getSlot(tonumber(nslot))      
        if (text ~= "") then
          editor:CopyText(text); --copia nella clipboard
          editor:ReplaceSel(text)
        end
      end
    end
    
    if ((operation == 2) and cutcopyOk) then --taglia
        if (checkSelection()) then --elimina selezione
            editor:ReplaceSel("")
        else
            editor:LineDelete()
        end
    end
    
  end --endmain
  
end