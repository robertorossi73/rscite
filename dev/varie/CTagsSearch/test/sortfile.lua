--[[
Version : 2.0.3
Web     : http://www.redchar.net

Questa procedura ordina il file corrente

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

-----------------------------------Versioni------------------------------------
2.0
  - nuova licenza
1.3.1 :
  - porting a SciTE 1.34
  
1.3.0 :
  - aggiunto ordinamento selezione

1.2.0 :
  - aggiunta modalità ordinamento ascendente/discendente
  - corretto ordinamento file, dove la prima riga veniva sempre inserita
    come ultimo elemento
  - corretto ordinamento file che non hanno l'ultima riga vuota
]]

do
  require("luascr/rluawfx")
  
  --inserisce una linea in fondo al file
  local function insertLinea( idx, linea )
    editor:AddText(linea)
  end
  
  local function ConfrontoElementiAsc (elemento1, elemento2)
    if (elemento1 < elemento2) then
      return true
    else
      return false
    end
  end

  local function ConfrontoElementiDsc (elemento1, elemento2)
    if (elemento1 > elemento2) then
      return true
    else
      return false
    end
  end
  
  --ordina file corrente, oppure solo la selezione
  local function OrderCurrentBuffer(tipo,sortAll)
    local linea,pos
    local i=0
    local tbLinee = {} --tabella file
    local lineaCorrente
    local ultimaLinea
    local primaLinea
    local inizioSel
    local fineSel
    local i
    local v
    
    if (sortAll) then
      editor:DocumentEnd()
      linea = editor:GetCurLine()
      if (linea ~= "") then
        editor:NewLine()
      end
      --lettura tutto file
      i = 1
      linea = editor:GetLine(i-1)
      while linea do --lettura linee
        tbLinee[i] = linea
        i = i + 1
        linea = editor:GetLine(i-1)
      end
    else
      --lettura selezione
      i = 1
      inizioSel = editor.SelectionStart
      fineSel = editor.SelectionEnd
      primaLinea = editor:LineFromPosition(inizioSel)
      ultimaLinea = editor:LineFromPosition(fineSel)
      lineaCorrente = primaLinea
      while (lineaCorrente <= ultimaLinea) do
        editor:GotoLine(lineaCorrente)
        editor:Home()
        editor:LineEndExtend()
        linea = editor:GetSelText()
        tbLinee[i] = linea
        i = i + 1
        lineaCorrente = lineaCorrente + 1
      end --endwhile      
    end
    
    if (tipo==0) then --ordinamento ascendente
      table.sort(tbLinee,ConfrontoElementiAsc)
    elseif (tipo==1) then --ordinamento discendente
      table.sort(tbLinee,ConfrontoElementiDsc)
    end
    
    if (sortAll) then
      editor:ClearAll()      
      for i,v in pairs(tbLinee) do
        insertLinea(i,v)
      end      
    else
      i = 1
      lineaCorrente = primaLinea
      while (lineaCorrente <= ultimaLinea) do
        editor:GotoLine(lineaCorrente)
        editor:Home()
        editor:LineEndExtend()
        editor:ReplaceSel(tbLinee[i])
        i = i + 1
        lineaCorrente = lineaCorrente + 1
      end
    end
    
    
  end
  
  local function SceltaOrdinamento()
    local scelta = 0 --ordinamento standard, ascendente
    local allBuffer = true
    
    -- 119=Ascendente|Discendente
    -- 120=Ordinamento
    scelta = rwfx_ShowList(_t(119),_t(120))
    if (scelta) then
      if (editor.SelectionEnd ~= editor.SelectionStart) then
        allBuffer = false
      end
      OrderCurrentBuffer(scelta, allBuffer)
    end
  end
  
  SceltaOrdinamento()
end

