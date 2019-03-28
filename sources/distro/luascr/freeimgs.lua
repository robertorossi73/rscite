--[[Traduci testo selezionato in...
Version : 1.0.0
Author  : Roberto Rossi
Web     : http://www.redchar.net

Questo modulo, dato un testo, cerca su alcuni siti web delle immagini
con licenza completamente libera

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
  
    function buttonHelp_click(control, change)
        local msg = ""
        
        --msg = "Questo comando utilizza, contemporanemante,i seguenti servizi:\n\n"
        msg = _t(437)
        msg = msg.."http://www.pixabay.com\n"
        msg = msg.."http://www.pexels.com\n"
        rwfx_MsgBox(msg,_t(438),MB_OK)
    end
    
    function buttonOk_click(control, change)
  --converti spazi e ritorni a capo
        local function sanitize(text, spaceTo)
            local result
            
            --result = string.gsub(text, "\n", "%%0A")
            result = string.gsub(text, "\n", " ")
            --result = string.gsub(result, "\r", "%%0A")
            result = string.gsub(result, "\r", " ")
            result = string.gsub(result, " ", "%%20")
            result = string.gsub(result, "/", "%%2F")
            result = string.gsub(result, " ", spaceTo)
            
            return result
        end
        
        local function openServices(text)
            local service = "https://pixabay.com/it/images/search/"
            local service2 = "https://www.pexels.com/search/"
            local command = ""
            local lang 
                
            if (text ~= "") then    
              command = service..sanitize(text,"+")
              rwfx_ShellExecute(command,"")
              command = service2..sanitize(text,"%20")
              rwfx_ShellExecute(command,"")
              wcl_strip:close()
            end
        end
        txt = wcl_strip:getValue("QVAL")
        
        openServices(txt)
    end
    
    local function main()
        wcl_strip:init()
        wcl_strip:addButtonClose()
       
        --wcl_strip:addLabel(nil, "Parole chiave: ")
        wcl_strip:addLabel(nil, _t(439).." ")
        wcl_strip:addText("QVAL",editor:GetSelText(), nil)
        --wcl_strip:addButton("OK","&Cerca immagini",buttonOk_click, true)
        wcl_strip:addButton("OK",_t(440),buttonOk_click, true)
        --wcl_strip:addButton("HELP","I&nfo",buttonHelp_click, false)
        wcl_strip:addButton("HELP",_t(441),buttonHelp_click, false)
        
        wcl_strip:show()
    end
  
  main() --esecuzione procedura principale
  
end
