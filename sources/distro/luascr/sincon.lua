--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura permette, fruttando servizi internet di ottenere i 
sinonimi e i contrari di una parola

Copyright (C) 2013 Roberto Rossi 
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
  --carica le funzioni speciali di RSciTE
  require("luascr/rluawfx")
  
  function buttonOk_click(control, change)
    local val = wcl_strip:getValue("VAL")
    
    if (val ~= "") then
      rwfx_ShellExecute("http://www.sinonimi-contrari.it/"..val.."/","")
      wcl_strip:close()
    end
  end
  
  local function main()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    --wcl_strip:addLabel("Trova Sinonimo/Contrario per :")
    wcl_strip:addLabel(_t(309))
    wcl_strip:addText("VAL", editor:GetSelText(), false)
    --wcl_strip:addButton("OK","Cerca", buttonOk_click, true)
    wcl_strip:addButton("OK",_t(310), buttonOk_click, true)
    wcl_strip:show()
  end
  
  main()
end --fine dello script
