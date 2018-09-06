--[[
Version : 2.0.0
Web     : http://www.redchar.net

Questa procedura unisce le linee selezionate a formare una linea singola.

Copyright (C) 2018 Roberto Rossi 
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
  
    --unisce il testo selezionato portandolo su una sola linea
    local function main()
        local txt = editor:GetSelText()
        
        txt = string.gsub(txt, "\r\n", " ")
        txt = string.gsub(txt, "\n\r", " ")
        txt = string.gsub(txt, "\n", " ")
        txt = string.gsub(txt, "\r", " ")
        
        editor:ReplaceSel(txt)
    end
  
  
    main()
end --modulo
