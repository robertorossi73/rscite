--[[
Version : 2.2.2
Web     : http://www.redchar.net

Questa procedura permette l'allineamento della selezione
a sinistra/destra/centro
E' inoltre possibile utilizzare un riempimento che inserisce caratteri
speciali prima e/o dopo il testo allineato

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
  
  local function trimStringa( testo )
    local result = ""
    local pos1 = 0
    local pos2 = 0
    
    --trova il primo carattere NON spazio e NON tabulazione
    pos1 = string.find(testo, "[^ \t]")
    --trova l'ultimo carattere NON spazio e NON tabulazione
    pos2 = string.find(testo, "[ \t]+$")
    
    if pos2 then
      if (pos2 > pos1) then
        pos2 = pos2 - 1
      end
      result = string.sub(testo, pos1 , pos2)
    else
      result = string.sub(testo, pos1)
    end
    return result
  end
  -- tipoAllineamento = 1 -> sinistra
  -- tipoAllineamento = 2 -> centro
  -- tipoAllineamento = 3 -> destra
  local function AllineaSelezione ( tipoAllineamento, riempimento, prosecuzione )
    local testo
    local primaLinea
    local inizioPos
    local ultimaLinea
    local finePos
    local pos
    local numLinee
    local lineaCorrente
    local lunghezza
    local nspaziPrima
    local spazi
    local lungTotaleLinea = 0
    
    lungTotaleLinea = tonumber(props["edge.column"])
    
    primaLinea = editor:LineFromPosition(editor.SelectionStart)
    ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
    if (primaLinea == ultimaLinea) then
      numLinee = 1
    else
      numLinee = ultimaLinea - primaLinea
    end

    --gestione singola linea
    lineaCorrente = primaLinea
    while (lineaCorrente <= ultimaLinea) do
      editor:GotoLine(lineaCorrente)
      editor:LineEnd()
      finePos = editor.CurrentPos
      inizioPos = editor:PositionFromLine(lineaCorrente)
      editor.SelectionStart = inizioPos
      editor.SelectionEnd = finePos
      testo = editor:GetSelText()
      testo = trimStringa(testo)
      if (tipoAllineamento == 1) then --sinistra
        if (riempimento ~= " ") then
          testo = testo.." " --inserimento distanziatori da separatire
        end
        if prosecuzione then --riempimento attivo
          if ((lungTotaleLinea - string.len(testo)) > 0) then
            testo = testo..string.rep(riempimento,lungTotaleLinea - string.len(testo))
          end
        end
        editor:ReplaceSel(trimStringa(testo))
      elseif (tipoAllineamento == 2) then  --centro        
        if (riempimento ~= " ") then
          testo = " "..testo.." " --inserimento distanziatori da separatire
        end
        lunghezza = string.len(testo)
        nspaziPrima = lungTotaleLinea - lunghezza
        if (nspaziPrima > 0) then
          nspaziPrima = nspaziPrima / 2
          spazi = string.rep(riempimento, math.floor(nspaziPrima))
          if prosecuzione then --riempimento attivo
            if ((lungTotaleLinea - (string.len(spazi) + string.len(testo))) > 0) then
              testo = testo..string.rep(riempimento,
                      lungTotaleLinea - (string.len(spazi) + string.len(testo)))
            end
          end          
          --editor:ReplaceSel(spazi..trimStringa(testo))
          editor:ReplaceSel(spazi..testo)
        end
      else --destra
        if (riempimento ~= " ") then
          testo = " "..testo --inserimento distanziatori da separatire
        end
        lunghezza = string.len(testo)
        nspaziPrima = lungTotaleLinea - lunghezza
        if (nspaziPrima > 0) then
          spazi = string.rep(riempimento, nspaziPrima)
          --editor:ReplaceSel(spazi..trimStringa(testo))
          editor:ReplaceSel(spazi..testo)
        end
      end      
      lineaCorrente = lineaCorrente + 1
    end --endwhile
    --fine gestione singola linea
  end --endfunction
  
  
  local function EseguiAllineaSelezione ()
    local scelta
    local tipoAll
    local riempimento
    local prosecuzione
    
    -- 12- Sinistra|Centro|Destra|Sinistra con Riempimento|Centro con Riempimento|Destra con Riempimento
      tipoAll = rwfx_ShowList(_t(12),"")
      
      riempimento =  " "
      prosecuzione = nil
      if tipoAll then
        if (tipoAll > 2) then
          scelta = rwfx_ShowList("'''''|/////|-----|+++++|*****|~~~~~|^^^^^","")
          if scelta then
            tipoAll = tipoAll - 3
            if (scelta == 0) then
              riempimento = "'"
            elseif (scelta == 1) then
              riempimento = "/"
            elseif (scelta == 2) then
              riempimento = "-"
            elseif (scelta == 3) then
              riempimento = "+"
            elseif (scelta == 4) then
              riempimento = "*"
            elseif (scelta == 5) then
              riempimento = "~"
            elseif (scelta == 6) then
              riempimento = "^"
            end
            prosecuzione = true
          else
            tipoAll = nil
          end
        end
        if (tipoAll == 0) then
          AllineaSelezione(1,riempimento,prosecuzione)
        elseif (tipoAll == 1) then
          AllineaSelezione(2,riempimento,prosecuzione)
        elseif (tipoAll == 2) then
          AllineaSelezione(3,riempimento,prosecuzione)
        end
      end --tipoAll
  end --endfunction
  
  EseguiAllineaSelezione()
  
end

