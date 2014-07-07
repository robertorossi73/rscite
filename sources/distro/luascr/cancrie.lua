--[[
Version : 2.0.7
Web     : http://www.redchar.net

Questa procedura permette di eliminare i rientri (spazi o tabulazioni) 
all'inizio delle linee selezionate

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

  --toglie n spazi o tabulazioni (nRientri) dall'inizio della linea
  local function CancSTLinea( testo, nRientri)
    local result = ""
    local pos1 = 0
    
    if (testo ~= "") then
      --trova il primo carattere NON spazio e NON tabulazione
      pos1 = string.find(testo, "[^ \t]")
      if ((nRientri ~= 0) and (pos1 > nRientri)) then
        result = string.sub(testo, (nRientri + 1))
      else
        result = string.sub(testo, pos1) 
      end
    else
      result = testo
    end
    
    return result
  end

  --gestione dialog per inserimento rientro
  local function StartCancRientro ( )
  local lung
  local testo
  local inizioPos
  local finePos
  local lineaCorrente
  local primaLinea
  local ultimaLinea
  local posizioneIniziale
  local lungTab
    lungTab = props["tabsize"] --impostazione tabulazione attuale
    
    -- 13- Rimozione Rientri
    -- 14- Specifica il numero di spazi/tabulazioni da rimuovere dall'inizio delle righe selezionate :
    -- 15- specificare 0 per eliminare qualsiasi spazio/tabulazione presente
    lung = rwfx_InputBox(lungTab, _t(13),_t(14).."\r\n\r\n (".._t(15)..")",rfx_FN())
    if lung then
      lung = rfx_GF()
      lung = tonumber(lung)
      if (lung > -1) then
        posizioneIniziale = editor.CurrentPos
        primaLinea = editor:LineFromPosition(editor.SelectionStart)
        ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
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
          testo = CancSTLinea(testo, lung)
          print(testo)
          editor:ReplaceSel(testo)
          lineaCorrente = lineaCorrente + 1
        end --endwhile
      end
    end
  end
  StartCancRientro()
end
