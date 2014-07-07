--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura elimina i ritorni a capo nell'intero file corrente

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

  function buttonCancel_click(control, change)
    wcl_strip:close()
  end
  
  function buttonOk_click(control, change)
    local all
    
    wcl_strip:close()
    
    all = editor:GetText()
    
    all = string.gsub(all,"\n","")
    all = string.gsub(all,"\r","")
    editor:SetText(all)
    
    -- 198=\nProcedura conclusa con successo.
    print(_t(198))
  end
  
  local function main()
    wcl_strip:init()

    wcl_strip:addButtonClose()
    wcl_strip:addLabel(nil, _t(278))
    wcl_strip:addLabel(nil, "        ")
    wcl_strip:addButton("ANNULLA",_t(279), buttonCancel_click,true)
    wcl_strip:addButton("ESEGUI",_t(280), buttonOk_click)

    wcl_strip:show()
  end
  
  main()
end
