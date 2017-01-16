--[[
Author  : Roberto Rossi
          Riccardo
Version : 1.1.1
Web     : http://www.redchar.net

Questa procedura consente una selezione rettangolare specifiando i due angoli
opposti della selezione

Copyright (C) 2017 Roberto Rossi e Riccardo
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

--[[
*******************************************************************************
modifiche 4 gennaio 2017
1) fix: FindColumn(endrow-1,endcol-1) --> FindColumn(endrow-1,endcol)
2) add: l'editor va alla prima linea/colonna
3) add: memoria dell'ultima selezione
4) add: print della selezione effettuata
5) mod: cambiato l'ordine delle etichette nella maschera di input
*******************************************************************************
]]

do
    require("luascr/rluawfx")

    function buttonOk_click_fb(control, change)        
        local initcol = tonumber(wcl_strip:getValue("INITCOL"))
        local initrow = tonumber(wcl_strip:getValue("INITROW"))
        local endcol = tonumber(wcl_strip:getValue("ENDCOL"))
        local endrow = tonumber(wcl_strip:getValue("ENDROW"))
        
        if (initcol and initrow and endcol and endrow) then
            -- inizio inserimento #1 (4 gen 2017)
            editor:GotoLine(initrow-1)
            editor:GotoPos(editor.CurrentPos+initcol)
            Glo_inicol = initcol
            Glo_inirow = initrow
            Glo_endcol = endcol
            Glo_endrow = endrow
            -- fine inserimento #1
            editor.RectangularSelectionCaret = editor:FindColumn(initrow - 1, initcol - 1)
            editor.RectangularSelectionAnchor = editor:FindColumn(endrow - 1 , endcol) -- mod 4 gen 2017
            -- inizio inserimento #2 (4 gen 2017)
            --print("\n=> Selezione:")
            ;print(_t(386))
            --print("Li I: " .. initrow .. " - Co I: " .. initcol)
            print(_t(387).." "..initrow.." ".._t(388).." "..initcol)
            --print("Li F: " .. endrow  .. " - Co F: " .. endcol )
            print(_t(389).." "..endrow.." ".._t(390).." "..endcol)
            print("\n")
            -- fine inserimento #2
        else
            --print("\n=> Selezione rettangolare : Dati inseriti non validi!")
            print(_t(380))
        end
    
        wcl_strip:close()
    end
    
    
    local function main()
        -- inizio inserimento #3 (4 gen 2017)
        if Glo_inicol then 
            Loc_inicol = Glo_inicol 
        else 
            Loc_inicol = 1 
        end
        if Glo_inirow then 
            Loc_inirow = Glo_inirow 
        else 
            Loc_inirow = 1
        end
        if Glo_endcol then 
            Loc_endcol = Glo_endcol 
        else 
            Loc_endcol = 2 
        end
        if Glo_endrow then 
            Loc_endrow = Glo_endrow 
        else 
            Loc_endrow = 2
        end
        -- fine inserimento #3
        wcl_strip:init()

        wcl_strip:addButtonClose()
        
        --wcl_strip:addLabel(nil, "Colonna iniziale")
        wcl_strip:addLabel(nil, _t(381))
        wcl_strip:addText("INITCOL",Loc_inicol) -- mod 4 gen 2017
        --wcl_strip:addLabel(nil, "Riga iniziale")
        wcl_strip:addLabel(nil, _t(382))
        wcl_strip:addText("INITROW",Loc_inirow) -- mod 4 gen 2017
        wcl_strip:addSpace()
        wcl_strip:addNewLine()
        --wcl_strip:addLabel(nil, "Colonna finale")
        wcl_strip:addLabel(nil, _t(383))
        wcl_strip:addText("ENDCOL",Loc_endcol) -- mod 4 gen 2017
        --wcl_strip:addLabel(nil, "Riga finale")
        wcl_strip:addLabel(nil, _t(384))
        wcl_strip:addText("ENDROW",Loc_endrow) -- mod 4 gen 2017
        --wcl_strip:addButton("ESEGUID"," Seleziona ", buttonOk_click_fb, true)
        wcl_strip:addButton("ESEGUID",_t(385), buttonOk_click_fb, true)        
        
        wcl_strip:show()
    end


    main()
    
end