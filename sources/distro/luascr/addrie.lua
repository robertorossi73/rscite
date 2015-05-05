--[[
Version : 2.1.1
Web     : http://www.redchar.net

Questa procedura permette di aggiungere i rientri all'inizio delle linee
selezionate (il rientro viene generato utilizzando degli spazi)

Copyright (C) 2004-2015 Roberto Rossi 
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

  --gestione dialog per inserimento rientro
  local function StartInsRientro ( lung )
  local strAggiunta
  local lineaCorrente
  local primaLinea
  local ultimaLinea
  local posizioneIniziale
  
    if lung then
      if (lung > 0) then
        strAggiunta = string.rep(" ", lung)
        posizioneIniziale = editor.CurrentPos
        primaLinea = editor:LineFromPosition(editor.SelectionStart)
        ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
        --gestione singola linea
        lineaCorrente = primaLinea
        while (lineaCorrente <= ultimaLinea) do
          editor:GotoLine(lineaCorrente)
          editor:Home()
          editor:ReplaceSel(strAggiunta)
          lineaCorrente = lineaCorrente + 1
        end --endwhile
        editor.CurrentPos = posizioneIniziale + lung
        editor.SelectionStart = editor.CurrentPos
        editor.SelectionEnd = editor.CurrentPos
      end
    end
  end

  --button ok
  function buttonOk_click(control, change)
    
    local val = wcl_strip:getValue("VAL")
    if ( tonumber(val) and (tonumber(val) > 0)) then
      StartInsRientro(tonumber(val))
    end
  end
  
  --main function
  local function main()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    -- 4- Aggiunta Rientri
    -- 5- 'Specifica il numero di spazi di cui far rientrare ogni riga selezionata : '
    wcl_strip:addLabel(nil, _t(5))
    wcl_strip:addText("VAL", "2")
    --wcl_strip:addButton("OK","&Esegui",buttonOk_click, true)
    wcl_strip:addButton("OK",_t(66),buttonOk_click, true)
    
    wcl_strip:show()
  end
  
  main()

end
