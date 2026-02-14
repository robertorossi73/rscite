-- -*- coding: utf-8 -*- file readonly.lua
--[[
Author  : Roberto Rossi
Version : 1.0.1
Web     : http://www.redchar.net

Questa procedura consente di rendere tutti i file in sola lettura o di annullare
    questo stato

Copyright (C) 2026 Roberto Rossi 
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
  
    local function setAllReadOnly (state)
        local startIndex = tostring(os.clock())
        local gotonext = true
        local maxi = tonumber(props["buffers"])
        local i = 1
        buffer["rscite.buffer.id"] = startIndex
        
        while ((i <= maxi) and gotonext) do
            scite.MenuCommand(IDM_NEXTFILE)
            if (editor.ReadOnly == not(state)) then
                scite.MenuCommand(IDM_READONLY)
            end
            if (buffer["rscite.buffer.id"] == startIndex) then
                gotonext = false
            end        
            i = i + 1
        end
    end
    
    function buttonReadOnly_click(control, change)
        setAllReadOnly(true)
        wcl_strip:close()
    end
    function buttonCancel_click(control, change)
        wcl_strip:close()
    end
    function buttonNotReadOnly_click(control, change)
        setAllReadOnly(false)
        wcl_strip:close()
    end
    
    local function main ()
        wcl_strip:init()

        wcl_strip:addButtonClose()
        wcl_strip:addLabel(nil, _t(525))
        wcl_strip:addNewLine()    
        
        wcl_strip:addButton("READONLY",_t(523), buttonReadOnly_click, true)
        wcl_strip:addButton("NOTREADONLY",_t(524), buttonNotReadOnly_click)
        wcl_strip:addButton("ANNULLA",_t(239), buttonCancel_click)

        wcl_strip:show()
    end
    main()
end --fine dello script
