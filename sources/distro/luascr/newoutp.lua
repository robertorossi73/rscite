--[[
Version : 1.0.0
Web     : http://www.redchar.net

Copia il contenuto del pannello di output all'interno di un nuovo file senza
nome

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

  local function main()
    local testo    
    
    testo = output:GetText()
    
    if (testo ~= "") then 
      --nuovo file
      scite.Open("");
      editor:AddText(testo)
    end
    
  end--endfunction
  
  main()
end
