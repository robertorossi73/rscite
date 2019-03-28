--[[
Version : 1.0.1
Web     : http://www.redchar.net

Questa procedura mostra una finestra per aprire un file qualsiasi nella
cartella del file corrente

Copyright (C) 2019 Roberto Rossi 
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
        local cf = props["FileDir"]
        local fileName
        
        fileName = rwfx_GetFileName(_t(463),cf, OFN_FILEMUSTEXIST,rfx_FN())
        if (fileName) then
          scite.Open(rfx_GF())
        end
    end
    main()
end
