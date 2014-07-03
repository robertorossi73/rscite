--[[
Version : 2.0.5
Web     : http://www.redchar.net

Questa procedura permette l'inserimento dei numeri di linea nella
selezione o nel file corrente

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

do
  require("luascr/rluawfx")
  
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
  
  local function EseguiNumeraLinee ()
    local scelta
    local iniziale = 0
    
    -- 106=Iniziando da N.(n.cifre Fisso con 0)
    -- 107=Iniziando da N.(n.cifre Fisso)
    -- 108=Iniziando da N.(n.cifre Variabile)
    -- 109=Con posizione fisica(n.cifre Fisso con 0)
    -- 110=Con posizione fisica(n.cifre Fisso)
    -- 111=Con posizione fisica(n.cifre Variabile)
    -- 112=Numerazione Linee
    -- 113=Numero Iniziale
    -- 114=Indica il Valore dal quale iniziare la Numerazione delle linee :
    local opzioni = _t(106).."|"..
                    _t(107).."|"..
                    _t(108).."|"..
                    _t(109).."|"..
                    _t(110).."|"..
                    _t(111)
    
      scelta = rwfx_ShowList(opzioni,_t(112))
      if scelta then
        if ((scelta == 0) or (scelta == 1) or (scelta == 2)) then
          iniziale = rwfx_InputBox("1", _t(113),_t(114),rfx_FN())
          iniziale = rfx_GF()
          iniziale = tonumber(iniziale)
        end
        if (scelta == 0) then
          NumeraLinee(iniziale,false,true,"0")
        elseif (scelta == 1) then
          NumeraLinee(iniziale,false,true," ")
        elseif (scelta == 2) then          
          NumeraLinee(iniziale,false,false,"")
        elseif (scelta == 3) then
          NumeraLinee(iniziale,true,true,"0")
        elseif (scelta == 4) then
          NumeraLinee(iniziale,true,true," ")
        elseif (scelta == 5) then          
          NumeraLinee(iniziale,true,false,"")
        end
      end
  end --endfunction
  
  EseguiNumeraLinee()
  
end
