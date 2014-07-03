--[[
Version : 2.0.5
Web     : http://www.redchar.net

Questa procedura Esegue l'espressione Lua selezionata

Esempio :
  print("testo") --stampa un testo generico
  print(props["menu.language"]) --stampa il contenuto del menu Linguaggio

Copyright (C) 2004-2010 Roberto Rossi 
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
  
  local function EseguiLua ()
    local testo
    local res
    
    -- 57=print(\"esempio\")
    -- 58=Espressione Lua
    -- 59=Non è stata selezionata nessuna espressione!\r\n\r\nInserisci qui sotto l'espressione, in linguaggio Lua, da interpretare
    
    testo = editor:GetSelText()
    if (testo == "") then
      res = rwfx_InputBox(_t(57), _t(58),_t(59),rfx_FN())
      if res then
        testo = rfx_GF()
      else
        testo = ""
      end

    end
    
    if not(testo=="") then
      dostring(testo)
    end
  end
  
  EseguiLua()
end


