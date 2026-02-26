-- -*- coding: utf-8 -*- file readonly.lua
--[[
Author  : Roberto Rossi
Version : 1.0.0
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
    local function checkDotNet()
        local result = rfx_exeCapture("dotnet --version")
        local parts
        local ver = false
        local output = false
        local i = 1
        
        if (result ~= "") then
            result = string.gsub(result,"\n","")
            result = string.gsub(result,"\r","")
            output = result
        end
        return output
    end
    
    -- https://aka.ms/dotnet/download
    -- https://aka.ms/dotnet/sdk-not-found
    local function main()
        --local msg = "La versione .NET presente: {1}\n\nDesideri accedere alla pagina Microsoft per scaricare l'ultima versione di .NET? \n\nAttenzione:\n - Per poter sviluppare applicazioni con .NET è necessario installare la versione 'SDK'.\n - Le versioni identificate come 'Anteprima' sono consigliate a chi vuole sperimentare le future versioni di .NET e possono non essere completamente stabili e non sono pensate per gli ambienti di produzione."
        local msg = _t(528)
        --local title = "Informazioni: Microsoft .NET"
        local title = _t(526)
        local ver = checkDotNet()
        local ret = false
        
        if not(ver) then
            --ver = "[.NET non trovato!]"
            ver = _t(527)
        end
        msg = string.gsub(msg,"{1}",ver)
        
        ret = rwfx_MsgBox(msg,title,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2)
        if (ret == IDYES) then
            rwfx_ShellExecute("https://aka.ms/dotnet/download","")
        end
    end
    main()
    
end