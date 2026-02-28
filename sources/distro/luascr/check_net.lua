-- -*- coding: utf-8 -*- file readonly.lua
--[[
Author  : Roberto Rossi
Version : 2.0.1
Web     : http://www.redchar.net

Questa procedura verifica la versione di .net installata e consente di 
andare alla pagina del download sia dei Runtime, sia dell'sdk di microsoft

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
    
    --controlla la presenza di dotnet e verifica la versione
    local function check_net_checkDotNet(onlyVersion)
        local result
        local parts
        local ver = false
        local output = false
        local i = 1
        
        if (onlyVersion) then
            result = rfx_exeCapture("dotnet --version")
        else
            result = rfx_exeCapture("dotnet --info")
        end
        
        if (result ~= "") then
            if (onlyVersion) then
                result = string.gsub(result,"\n","")
                result = string.gsub(result,"\r","")
            end
            output = result            
        end
        return output
    end
    
    function buttonCancel_click(control, change)
        wcl_strip:close()
    end
    
    function buttonCheck_click(control, change)
        --local msg = "La versione .NET presente: {1}\n\nDesideri accedere alla pagina Microsoft per scaricare l'ultima versione di .NET? \n\nAttenzione:\n - Per poter sviluppare applicazioni con .NET è necessario installare la versione 'SDK'.\n - Le versioni identificate come 'Anteprima' sono consigliate a chi vuole sperimentare le future versioni di .NET e possono non essere completamente stabili e non sono pensate per gli ambienti di produzione."
        local msg = _t(528)
        --local title = "Informazioni: Microsoft .NET"
        local title = _t(526)
        local ver
        local ret = false
        
        ver = check_net_checkDotNet(true)
        if not(ver) then
            --ver = "[.NET non trovato!]"
            ver = _t(527)
        end
        msg = string.gsub(msg,"{1}",ver)
        
        ret = rwfx_MsgBox(msg,title,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2)
        if (ret == IDYES) then
            rwfx_ShellExecute("https://aka.ms/dotnet/download","")
        end
        wcl_strip:close()
    end
    
    function buttonInfo_click(control, change)
        local dataVer = check_net_checkDotNet(false)
        print(dataVer)
        wcl_strip:close()
    end
    
    local function main()
        wcl_strip:init()

        wcl_strip:addButtonClose()
        wcl_strip:addLabel(nil, "Verifica presenza Microsoft .NET")
        wcl_strip:addNewLine()
        
        wcl_strip:addButton("CHECK","Verifica .NET", buttonCheck_click, true)
        wcl_strip:addButton("CHECK2","Mostra informazini su .NET", buttonInfo_click)
        wcl_strip:addButton("ANNULLA",_t(239), buttonCancel_click)

        wcl_strip:show()
    end
    main()
    
end