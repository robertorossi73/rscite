--[[    
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura, attraverso l'uso di un servizio web, mostra le statistiche
di download relative alla versione "release" di un progetto pubblico ospitato
su GitHub.

Copyright (C) 2019-2020 Roberto Rossi 
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

    if not(G_GITHUBSTATS) then
        G_GITHUBSTATS = {"", ""}
    end
    
    --button ok
    function buttonOk_click(control, change)
        local val = wcl_strip:getValue("VAL")
        local val2 = wcl_strip:getValue("VAL2")
        local engine = "https://somsubhra.com/github-release-stats/?username=xxxxxx1&repository=xxxxxx2"
        local url = ""
        
        if ((val ~= "") and (val2 ~= "")) then
            url = string.gsub(engine, "xxxxxx1", val)
            url = string.gsub(url, "xxxxxx2", val2)
            rwfx_ShellExecute(url,"")
            G_GITHUBSTATS[1] = val
            G_GITHUBSTATS[2] = val2
            wcl_strip:close()
        else
            --print("\nInvalid Data!")
            print(_t(474))
        end
    end
  
    --main function
    local function main()
        wcl_strip:init()
          
        wcl_strip:addButtonClose()
                
        --wcl_strip:addLabel(nil, "Github username :")
        wcl_strip:addLabel(nil, _t(471))
        wcl_strip:addText("VAL",G_GITHUBSTATS[1],nil)
        --wcl_strip:addButton("OK"," Mostra Statistiche ",buttonOk_click, true)
        wcl_strip:addButton("OK"," ".._t(472).." ",buttonOk_click, true)
        wcl_strip:addNewLine()
        --wcl_strip:addLabel(nil, "Repository name :")
        wcl_strip:addLabel(nil, _t(473))
        wcl_strip:addText("VAL2",G_GITHUBSTATS[2],nil)
        
        wcl_strip:show()
    end

    main()
end 
