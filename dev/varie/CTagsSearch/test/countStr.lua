--[[
Version : 1.0.0
Web     : http://www.redchar.net

Visualizza statistiche su stringa indicata.

Copyright (C) 2010 Roberto Rossi 
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

  --dato il numero di una linea, ritorna il numero di volte che
  --  la stringa specificata si ripete
  local function countInLine(lineNum, findStr, ignoreCase)
    local num = 0
    local line = editor:GetLine(lineNum)
    
    if (line) then
      if (ignoreCase) then
        line = string.lower(line)
        findStr = string.lower(findStr)
      end
      for w in string.gmatch(line, findStr) do
         num = num + 1
       end
    end
    return num
  end
  
  -- questa funzione effettua il conteggio ritornando il numero delle occorrenze
  local function startCount (typeCount, findStr)
    local i = 0
    local numo = 0
    local msg = ""
    local conteggioGenerale = 0
    local conteggioLinee = 0
    local posCorrente = false
    local ignoreCase = false
    
    if (typeCount > 1) then
      posCorrente = editor.CurrentPos
    end
    
    if (typeCount > 1) then
      --eliminazione bookmarks
      scite.MenuCommand(IDM_BOOKMARK_CLEARALL)
    end
    
    if ((typeCount == 0) or(typeCount == 2)) then
      ignoreCase = true --ignora maiusc/minusc
    end
    
    while (i < editor.LineCount) do
      numo = countInLine(i,findStr, ignoreCase)
      if (numo > 0) then
        conteggioGenerale = conteggioGenerale + numo
        conteggioLinee = conteggioLinee + 1
        
        if (typeCount > 1) then
          editor:GotoLine(i)
          scite.MenuCommand(IDM_BOOKMARK_TOGGLE)
        end
      end
      i = i + 1
    end

    if (conteggioGenerale > 0) then
      --msg = "Stringa cercata : "..findStr.."\n\n"..
      --      "Occorrenze individuate : "..conteggioGenerale.."\n"..
      --      "Linee trovate : "..conteggioLinee
      msg = _t(166).." "..findStr.."\n\n"..
            _t(167).." "..conteggioGenerale.."\n"..
            _t(168).." "..conteggioLinee
    end
    
    if (posCorrente) then
      editor:GotoPos(posCorrente)
    end
    
    return msg
  end
  
  -- ritorna la scelta dell'utente :
  --  false = l'utente preme annulla
  --  0 = conta le occorrenze (ignora maiusc/minusc)
  --  1 = conta le occorrenze (considera maiusc/minusc)
  --  2 = imposta bookmarks eliminando gli attuali
  local function questionFx()
    local lista
    local id
    local scelta
    local tipo = false
    
    --lista="Statistiche ricerca|Statistiche ricerca|Imposta Segnalibri eliminando"
    lista=_t(169)
    
    --scelta = rwfx_ShowList(lista,"Conteggia Testo")
    scelta = rwfx_ShowList(lista,_t(170))
    if (scelta) then
      tipo = scelta 
    end
    
    return tipo
  end
  
  --chiede all'utente la stringa da cercare
  local function questionStr()
    local result = false
    local res
    
    --specifica il testo da carcare
    res = rwfx_InputBox("", _t(170),_t(171),rfx_FN())
    if res then
      result = rfx_GF()
    end
    
    return result
  end
  
  local function main()
    local findstr = questionStr()
    local scelta = false
    local msg = ""
    
    if (findstr) then
      scelta = questionFx()
      if (scelta) then
        msg = startCount(scelta, findstr)
        if (msg ~= "") then
          rwfx_MsgBox(msg,_t(170),MB_OK)
        else
          rwfx_MsgBox("Non è stato trovato nulla",_t(170),MB_OK)
        end
      end
    end 
  end--endfunction
  
  main()
end
