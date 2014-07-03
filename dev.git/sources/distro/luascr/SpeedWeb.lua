--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura verifica le prestazioni di una pagina web 
(selezionata o indicata manualmente)

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
  require("luascr/rluawfx")

  --button ok
  function buttonOk_click(control, change)
    local val = wcl_strip:getValue("VAL")
    local searchEngine = {"Web Page Analyzer Standard","Web Page Analyzer - 1.00 BETA"}
    local engine = wcl_strip:getValue("ENGINE")

    if (engine == searchEngine[1]) then
      engine = "http://analyze.websiteoptimization.com/authenticate.php?url=$value&"
    elseif (engine == searchEngine[2]) then
      engine = "http://analyze.websiteoptimization.com/2013/_process.php?url=$value"
    else
      engine = ""
      val = ""
    end
    
    if (val ~= "") then
      val = string.gsub(engine,"$value", val)
      rwfx_ShellExecute(val,"")
    else
      if (engine == "") then
        --print("\nTester NON valido!")
        print(_t(292))
      else
        --print("\nIndirizzo NON valido!")
        print(_t(293))
      end
    end
    wcl_strip:close()
  end
  
  --main function
  local function main()
      local searchEngine = {"Web Page Analyzer Standard","Web Page Analyzer - 1.00 BETA"}
      wcl_strip:init()
      
      wcl_strip:addButtonClose()
            
      wcl_strip:addLabel(nil, _t(294))
      wcl_strip:addText("VAL",editor:GetSelText(),nil)
      wcl_strip:addButton("OK",_t(295),buttonOk_click, true)
      wcl_strip:addNewLine()
      wcl_strip:addLabel(nil, _t(296))
      wcl_strip:addCombo("ENGINE", nil)
      
      wcl_strip:show()
      
      wcl_strip:setList("ENGINE", searchEngine)
      wcl_strip:setValue("ENGINE", searchEngine[1])
  end

  main()
end 
