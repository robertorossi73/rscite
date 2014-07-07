--[[
Version : 3.0.0
Web     : http://www.redchar.net

Questa procedura permette l'inserimento dei numeri di linea nella
selezione o nel file corrente

Copyright (C) 2004-2013 Roberto Rossi 
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
  
  --local numlineeOpt = {"Numero cifre Fisso con 0 iniziali",
  --                      "Numero cifre Fisso con spazi iniziali",
  --                      "Numero cifre Variabile"}
  local numlineeOpt = {_t(106),
                       _t(107),
                       _t(108)
                      }
  
  local function FormattaTesto ( dimensione, linea, carattere )
    local lun
    local result
    
    lung = string.len(linea)
    if (dimensione > lung) then
      result = string.rep(carattere, (dimensione - lung))..linea     
    else
      result = linea
    end
    
    return result
  end

  --numera le linee selezionate o tutte
  --Riceve come parametri il numeroIniziale dal quale partire
  --per la numerazione e il tipo, che indica se numerare usando
  --il numero di linea fisico del file (true) o il numero partendo da 
  --numeroIniziale (false). Infine, riceve il parametro lunNumCostante che
  --indica se tutti i numeri inseriti devono avere lo stesso numero di
  --caratteri (true), oppure possono avere lunghezza variabile (false)
  local function NumeraLinee ( numeroIniziale, nLineaFisica, 
                               lunNumCostante, carNumCostante )
    local primaLinea
    local ultimaLinea
    local lineaCorrente
    local numLinee
    local i
    local testo
    local dimMax
    
    primaLinea = editor:LineFromPosition(editor.SelectionStart)
    ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
    
    numLinee = ultimaLinea - primaLinea
    
    if nLineaFisica then
      dimMax = primaLinea + numLinee
    else
      dimMax = numLinee + numeroIniziale      
    end
    dimMax = string.len(tostring(dimMax))
    
    lineaCorrente = primaLinea
    i = numeroIniziale
    -- scansione Linee
    while (lineaCorrente <= ultimaLinea) do
      editor:GotoLine(lineaCorrente)
      editor:Home()
      if nLineaFisica then
        testo = tostring(lineaCorrente + 1) --numero fisico
      else        
        testo = tostring(i) --rinumerazione
      end
      
      if lunNumCostante then
        testo = FormattaTesto(dimMax, testo, carNumCostante)
      end

      editor:ReplaceSel(testo.." ")
      
      lineaCorrente = lineaCorrente + 1
      i = i + 1
    end --endwhile
  end --endfunction  
  
  function buttonOk_click(control, change)
    local numinit = tonumber(wcl_strip:getValue("NVAL"))
    local tipo = wcl_strip:getValue("TVAL")
    
    if (numinit) then
      if (tipo == numlineeOpt[1]) then --0 iniziale
          NumeraLinee(numinit,false,true,"0")
      elseif (tipo == numlineeOpt[2]) then --spazi iniziali
          NumeraLinee(numinit,false,true," ")
      elseif (tipo == numlineeOpt[3]) then --senza nulla
          NumeraLinee(numinit,false,true,"")
      end
    else
        --print("->Numerazione Linee\nImpossibile continuare, Numero iniziale errato!")
        print(_t(109))
    end

  end

  local function main()
    local primaLinea
    
      primaLinea = editor:LineFromPosition(editor.SelectionStart) + 1
  
      wcl_strip:init()
      wcl_strip:addButtonClose()
      
      --wcl_strip:addLabel(nil, "Numerazione Linee :")
      wcl_strip:addLabel(nil, _t(110))
      wcl_strip:addCombo("TVAL")
      --wcl_strip:addLabel(nil, "Numero prima linea : ")
      wcl_strip:addLabel(nil, _t(111))
      wcl_strip:addText("NVAL", primaLinea)
      --wcl_strip:addButton("OK","&Esegui Numerazione Selezione",buttonOk_click, true)
      wcl_strip:addButton("OK",_t(112),buttonOk_click, true)
      
      wcl_strip:show()
      wcl_strip:setList("TVAL",numlineeOpt)
      wcl_strip:setValue("TVAL", numlineeOpt[1])
  end
  
  main()
  
end
