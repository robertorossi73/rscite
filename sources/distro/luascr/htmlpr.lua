--[[
Version : 3.0.6
Web     : http://www.redchar.net

Gestione Attributi TAG HTML e classi PHP

Questa funzionalità prende i dati dalla lista delle proprietà presente nella
sottocartella luascr\html.
All'inizio della lista proprietà, sarà sempre disponibile 
una voce per la chiusura del tag

Se il carattere precedente alla posizione del cursode è un >, allora
viene avviato l'assistente per le classi predefinite di PHP, se così
non è viene avviata la procedura di completamento TAG HTML

Copyright (C) 2004-2018 Roberto Rossi 
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

  --ritorna l'ultimo carattere della stringa data
  local function LastCH (s)
    local i=string.len(s)
    return string.sub(s,i,i)
  end  
  
  --rimuove l'eventuale ritorno a capo presente nella stringa data
  --e ritorna la stringa senza ritorni a capo
  local function RemoveReturnLine(s)
    local a=""
    local lung=0
    
    if (s) then
      lung = string.len(s)
      if LastCH(s)=="\r" then
        a = string.sub(s,1,lung-1)
        lung = string.len(a)
        if LastCH(a)=="\n" then
          a = string.sub(a,1,lung-1)
        end
      elseif LastCH(s)=="\n" then
        a = string.sub(s,1,lung-1)
        lung = string.len(a)
        if LastCH(a)=="\r" then
          a = string.sub(a,1,lung-1)
        end
      else
        a = s
      end 
    end --endif
  return a
  end
  
  --elimina spazi/tabulazioni e barre /
  local function trimStringa( testo )
    local result = ""
    local pos1 = 0
    local pos2 = 0
    
    --trova il primo carattere NON spazio, NON tabulazione, NON /
    pos1 = string.find(testo, "[^ \t/]")
    --trova l'ultimo carattere NON spazio e NON tabulazione
    pos2 = string.find(testo, "[ \t]+$")
    
    if pos1 or pos2 then
      if pos2 then
        if (pos2 > pos1) then
          pos2 = pos2 - 1
        end
        result = string.sub(testo, pos1 , pos2)
      else
        result = string.sub(testo, pos1)
      end
      result=string.lower(result)
    else
      result = nil
    end
    return result
  end
  
  --caricamento file con proprieta TAG
  local function listaPropTag(nomeFile)
    local lstFormat={}
    local idf
    local i
    local line
    local ch

    idf = io.open(nomeFile, "r")
    if (idf) then
      
      i = 1
      for line in idf:lines() do
        ch = string.sub(line,1,1)
        if ((ch ~= "#") and --elimina commenti, sezioni e linee vuote
            (ch ~= "[") and
            (ch ~= ";") and
            (line ~= "")) then
          lstFormat[i] = line;
          i = i + 1;
        end
      end
      io.close(idf)
    end
    return lstFormat
  end

  --ritorna il tag html precedente, rispetto alla posizione del cursore
  local function LeggiTAGPrecedente( ricerca )
    local tagHtml
    local pos
    local currentPos
    
    currentPos = editor.CurrentPos
    editor:SearchAnchor()
    pos = editor:SearchPrev(0,ricerca)
    tagHtml = ""
    if (pos > -1) then
      editor:WordRightExtend()
      editor:WordRightEndExtend()
      tagHtml = editor:GetSelText()
    end
    editor.CurrentPos = currentPos
    editor.SelectionStart = currentPos
    if tagHtml then
      tagHtml = trimStringa(tagHtml)
      if (tagHtml == "") then
        tagHtml = nil
      end
    end
    
    return trimStringa(RemoveReturnLine(tagHtml))
  end
  
  --visualizza la lista degli attributi
  local function VisListaAttributi( tagHtml )
    local cartella = props["SciteDefaultHome"].."/luascr/html/"
    local lstProp={}
    local strLst = ""
    local idv
    local valore
    local tagChiusura = ""
    
    if tagHtml then
      lstProp = listaPropTag(cartella..tagHtml..".lst")
      if (#lstProp > 0) then
        tagChiusura = '</'..tagHtml..'>'
        strLst = tagChiusura
        for idv, valore in pairs(lstProp) do
          if (strLst == '') then
            strLst = valore
          else
            strLst = strLst..'|'..valore
          end
        end
    
        if (strLst) and (strLst~="") then
          idv = rwfx_ShowList(strLst,tagHtml)
          if (idv) then
            if (idv == 0) then
              valore = tagChiusura
            else
              valore = lstProp[idv]
            end
            editor:ReplaceSel(valore)
          end
        end
      end --end check count
    end --if not(nil)
  end

--visualizza la lista degli attributi
  local function VisListaAttClassPHP()
    local cartella = props["SciteDefaultHome"].."/luascr/php/"
    local lstProp={}
    local strLst = ""
    local idv
    local valore
    local tagChiusura = ""
    local classe = ""
    
    lstProp=listaPropTag(cartella.."phpclass.lst")
    for idv, valore in pairs(lstProp) do
        if (strLst == '') then
          strLst = valore
        else
          strLst = strLst..'|'..valore
        end
    end
    
    -- 78=Classe da Utilizzare
    idv = rwfx_ShowList(strLst,_t(78))
    if (idv) then
      classe = lstProp[idv+1]
      --print(classe)
      lstProp = listaPropTag(cartella..string.lower(classe)..".lst")
      if (#lstProp > 0) then
        strLst = ""
        for idv, valore in pairs(lstProp) do
          if (strLst == '') then
            strLst = valore
          else
            strLst = strLst..'|'..valore
          end
        end
    
        if (strLst) and (strLst~="") then
          idv = rwfx_ShowList(strLst,classe.."->...")
          if (idv) then
            valore = lstProp[idv+1]
            editor:ReplaceSel(valore)
          end
        end
      end --end check count
    end --end selezione classe
  end --endfunction
  
  --funzione principale
  local function main()
    local curpos
    
      curpos = editor.CurrentPos
      if (string.byte(">") == editor.CharAt[curpos-1]) then
        --gestione classi PHP
        VisListaAttClassPHP()
      else
        --gestione HTML
        VisListaAttributi(LeggiTAGPrecedente("<"))
      end    
  end
  
  main()
end

