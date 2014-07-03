--[[
Author  : Roberto Rossi
Version : 1.0.3
Web     : http://www.redchar.net

Questa funzione consente l'inserimento di un BOM all'interno del file
corrente.

Copyright (C) 2012-2013 Roberto Rossi 
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

  local function execute(scelta)
    local elementi = rfx_Split(_t(224), "|")    

    if (scelta == elementi[1]) then --UTF-16 Little Endian 
      editor:InsertText(0,string.char(254))
      editor:InsertText(0,string.char(255))
      print(_t(198))
    elseif (scelta == elementi[2]) then --BOM  per Codifica UTF-16 Big Endian (FE FF)
      editor:InsertText(0,string.char(255))
      editor:InsertText(0,string.char(254))
      print(_t(198))
    elseif (scelta == elementi[3]) then --BOM  per Codifica UTF-8 (EF BB BF)
      editor:InsertText(0,string.char(191))
      editor:InsertText(0,string.char(187))
      editor:InsertText(0,string.char(239))
      print(_t(198))
    end
  end
  
  --button ok
  function buttonOk_click(control, change)
    execute(wcl_strip:getValue("VAL"))
  end
  
  --main function
  --TODO : da fare
  local function main()
    local elementi = rfx_Split(_t(224), "|")    
    
      wcl_strip:init()      
      wcl_strip:addButtonClose()
      
      wcl_strip:addLabel(nil, _t(225))
      wcl_strip:addCombo("VAL")
      wcl_strip:addButton("OK",_t(251),buttonOk_click, true)
      
      wcl_strip:show()
      
      wcl_strip:setList("VAL", elementi)
      wcl_strip:setValue("VAL", elementi[1])
  end
  
  main()

end
