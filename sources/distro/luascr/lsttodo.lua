--[[
Version : 1.1.0
Web     : http://www.redchar.net

Elenca tutte le linee contenenti tag TODO :

"HACK", "TODO", "UNDONE"

Copyright (C) 2004-2021 Roberto Rossi 
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

  local listaTAG = {
                    "HACK ",
                    "TODO ", 
                    "UNDONE ", 
                    "HACK:", 
                    "TODO:", 
                    "UNDONE:",
                    "HACK :", 
                    "TODO :", 
                    "UNDONE :"
                   }
  
  local function main()
    local i, linea, lineaTmp
    local id, value
    local flagok
    
    output:ClearAll()    
    i = 0
    linea = editor:GetLine(i)
    while linea do
      flagok = true
      lineaTmp = string.upper(linea)
      for id,value in ipairs(listaTAG) do
        if (string.find(lineaTmp, value, 1, true) and flagok) then          
          print(":"..(i + 1)..": "..rfx_RemoveReturnLine(linea))
          flagok = not(flagok)
        end
      end      
      i = i + 1;
      linea = editor:GetLine(i);
        if (i > editor.LineCount) then
            linea = false
        end
    end
    
  end--endfunction
  
  main()
end
