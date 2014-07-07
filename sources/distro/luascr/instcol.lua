--[[
Version : 2.1.1
Web     : http://www.redchar.net

Questa procedura inserisce il testo specificato alla colonna indicata,
compreso inizio e fine linea

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

  local function InsTextInCol (testoAdd, lung)
  local lineaTxt
  local lineaCorrente
  local primaLinea
  local ultimaLinea
  local posizioneIniziale
  local pos
  local lungLinea = 0
  local lungAdd = 0
  local parte1 = ""
  local parte2 = ""
  
  if (testoAdd) then
    if lung then
      if (lung > -1) then
        posizioneIniziale = editor.CurrentPos
        primaLinea = editor:LineFromPosition(editor.SelectionStart)
        ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
        --gestione singola linea
        lineaCorrente = primaLinea
        while (lineaCorrente <= ultimaLinea) do
          lineaTxt = editor:GetLine(lineaCorrente)
          lineaTxt = rfx_RemoveReturnLine(lineaTxt)
          lungLinea = string.len(lineaTxt)
          lungAdd = 0
          if (lung > 0) then
            if (lung > lungLinea) then
              lungAdd = lung - lungLinea
              lineaTxt = lineaTxt..string.rep(" ", lungAdd-1)
              lineaTxt = lineaTxt..testoAdd
            else
              parte1 = string.sub(lineaTxt,1, lung -1)
              parte2 = string.sub(lineaTxt,lung)
              lineaTxt = parte1..testoAdd..parte2
            end
          else --fine linea
            lineaTxt = lineaTxt..testoAdd
          end
          editor:GotoLine(lineaCorrente)
          editor:Home()
          editor:LineEndExtend()
          editor:ReplaceSel(lineaTxt)
          lineaCorrente = lineaCorrente + 1
        end --endwhile
        editor.CurrentPos = posizioneIniziale + lung
        editor.SelectionStart = editor.CurrentPos
        editor.SelectionEnd = editor.CurrentPos
      end --endif
    end --endif
  end --endif
  end --endfunction

--InsTextInCol()
  
  --button ok
  function buttonOk_click(control, change)
    
    local val = wcl_strip:getValue("VAL")
    local ncol = wcl_strip:getValue("NCOL")
    if ( tonumber(ncol) and (tonumber(ncol) > -1)) then
      InsTextInCol(val, tonumber(ncol))
    end
    
  end
  
  --main function
  local function main()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    wcl_strip:addLabel(nil, _t(102))
    wcl_strip:addText("VAL", "")
    wcl_strip:addNewLine()
    wcl_strip:addLabel(nil, _t(104))
    wcl_strip:addText("NCOL", "1")
    --wcl_strip:addButton("OK","&Esegui",buttonOk_click, true)
    wcl_strip:addButton("OK",_t(66),buttonOk_click, true)
    
    wcl_strip:show()
  end
  
  main()

end --endmodulo
