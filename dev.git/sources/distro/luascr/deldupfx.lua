--[[
Version : 2.2.1
Web     : http://www.redchar.net

Questa procedura consente l'eliminazione dei doppioni presenti
nel file vorrente.
In questo file sono definite solamente le funzioni, che NON vengono
eseguite atuomaticamente al suo caricamento.

Copyright (C) 2004-2009 Roberto Rossi 
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

local tbLinee = {} --tabella file
local searchString = "" --stringa da cercare in tabella

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
return a
end

--callback per foreach su tabella linee
local function DataCompare (i, linea)
  if (linea == searchString) then
    return 1
  else
    return nil
  end
end

--controllo presenza di searchString nella tabella linee (tbLinee)
local function IsTbPresent()
  local result = false
  local tmpres = false
  local i
  local v
  
  for i,v in pairs(tbLinee) do
    tmpres = DataCompare(i,v)
    if (tmpres) then
      result = tmpres
    end
  end

  return(result)
end

--eliminazione linee doppie
function EliminaLineeDoppie()
  local linea,pos
  local i=0
  
  i = 0
  linea = editor:GetLine(i)
  while linea do 
    searchString = RemoveReturnLine(linea)
    if IsTbPresent() then
      pos = editor:PositionFromLine(i)
      editor.CurrentPos = pos
      editor:LineDelete()
      i = i - 1
    else
      tbLinee[i] = RemoveReturnLine(linea)
    end
    i = i + 1
    linea = editor:GetLine(i)
  end
  editor.CurrentPos = 0
  editor.SelectionStart = 0
  editor.SelectionEnd = 0  
end
