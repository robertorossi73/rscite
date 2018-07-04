--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura inserisce un numero incrementale sostituendo un testo fisso
presente piu volte nel file corrente

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

    function buttonOk_click(control, change)
        --local tmpVars = rfx_GF()
        --local vars = rfx_Split(tmpVars, ",")
        local i = tonumber(wcl_strip:getValue("TNUM"))
        local v = wcl_strip:getValue("TVAL")
        
        if (v ~= "") then
            inscounter_replace(v, i)
            print(_t(198))
        end
        wcl_strip:close()
    end

    local function main()
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        wcl_strip:addLabel(nil, _t(410))
        wcl_strip:addText("TVAL",editor:GetSelText(), nil)
        wcl_strip:addLabel(nil, _t(412))
        wcl_strip:addText("TNUM", "1", nil)
        wcl_strip:addButton("OKBTN",_t(411),buttonOk_click, true)
        wcl_strip:show()
    end
    
    function inscounter_replace(txt, starti)
        local ns = starti
        local posStart = 0
        local posEnd = 0

        while (posStart) do  
            posStart, posEnd = editor:findtext(txt,SCFIND_MATCHCASE,posEnd)
            if (posStart) then
                editor.SelectionStart = posStart
                editor.SelectionEnd = posEnd
                editor:ReplaceSel(tostring(ns))
                print(_t(414).." '"..tostring(ns).."' "..
                        _t(415).." "..tostring(editor:LineFromPosition(posStart)+1))
                ns = ns + 1
            end
        end
    end
  
    main()
end

