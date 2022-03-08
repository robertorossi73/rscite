--[[Trasforma selezione in immagine(tramite carbon.now.sh)
# -*- coding: utf-8 -*-
Version : 1.0.1
Web     : http://www.redchar.net

Questa procedura consente di utilizzare il servizio fornito da https://carbon.now.sh/
per trasformare il testo selezionato in una immagine

Copyright (C) 2021 Roberto Rossi 
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
  
    local function EncodeString(s)
        local result = ""
        local t = {}
        local i
        local v
        local preV
        local ch
        local natural = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"

        for i=1, string.len(s) do
          t[i]= (string.sub(s,i,i))
        end

        for i,v in ipairs(t) do
            if ((v == "\n") or (v == "\r")) then
                if ((v == "\n") and (preV == "\r")) then
                    ch = ""
                else
                    ch = "%250A"
                end
            else
                if (string.find(natural, v, 0, true)) then
                    ch = v
                else
                    ch = "%25"..string.format('%02X',string.byte(v))
                end
            end    
            result = result..ch
            preV = v
        end

        return result
    end
    
    local function GetUrl(str)
        --t=verminal -- combinazione colori
        local base = "https://carbon.now.sh/?l=auto&code="
        local code
        
        code = EncodeString(str)
        
        return base..code
    end

    local function main()
        local str = editor:GetSelText()
        local url
        
        if (rfx_Trim(str) ~= "") then
            url = GetUrl(str)
            rwfx_ShellExecute(url,"")
        else
            --24=Impossibile procedere, non hai selezionato il testo da convertire!
            --9=attenzione
            rwfx_MsgBox(_t(24),_t(9),MB_OK)
        end
    end
    
    main()
    
end





