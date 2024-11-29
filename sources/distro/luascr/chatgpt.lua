--[[Invia il testo selezionato a ChatGpt
Version : 1.0.0
Author  : Roberto Rossi
Web     : http://www.redchar.net

Invia una domanda(il testo selezionato) a chatgpt

Copyright (C) 2024-2025 Roberto Rossi 
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

V.1.0.0
- release iniziale

]]

do
  require("luascr/rluawfx")
  
  --converti spazi e ritorni a capo
  local function convertCR(text)
    local result    
    --result = string.gsub(text, "\n", "%%0A")
    result = string.gsub(text, "\n", " ")
    --result = string.gsub(result, "\r", "%%0A")
    result = string.gsub(result, "\r", " ")
    result = string.gsub(result, " ", "%%20")
    result = string.gsub(result, "/", "%%2F")
    
    return result
  end
  
  --verifica la presenza di un dato elemento all'interno di una tabella
  --ritorna false nel caso l'elemento non sia presente
  --altrimenti torna il suo indice
  local function table_exist(tbl, el)
    local i
    local v
    
    for i, v in pairs(tbl) do
      if v == el then
        return i
      end
    end
    return false
  end

  --salva la tabella delle ultime espressioni eseguite
  local function save_expressions(values)
    local nomef = rfx_UserFolderRSciTE()..'/tmp/exeChatGpt.ini'
    local v
    local count = 1
    
    while (count < 26) do
      v = values[count]
      if (v) then
        rfx_setIniVal(nomef, "General", "chatgpt"..tostring(count) , v)
      end
      count = count + 1
    end
  end

  --ritorna la tabella delle ultime 100 espressioni eseguite
  local function get_expressions()
    local nomef = rfx_UserFolderRSciTE()..'/tmp/exeChatGpt.ini'
    local result = {}
    local i = 1
    local v
    
    while(i < 26) do
      v = rfx_GetIniVal(nomef, "General", "chatgpt"..tostring(i))
      if (v ~= "") then
        result[i] = v
      else
        break
      end
      i = i + 1
    end    
    
    return result
  end
  
  function buttonOk_click(control, change)
    local values
    local text = ""
    local service = "https://chat.openai.com/?q="
    local command = ""
    
    text = wcl_strip:getValue("REQUEST")
    
    if (text ~= "") then
      values = get_expressions()
      if (not(table_exist(values, text))) then
        table.insert(values,1,text)
        save_expressions(values)
        wcl_strip:setList("REQUEST", values)
      end
      
        if (text ~= "") then    
          command = service..convertCR(text)
          rwfx_ShellExecute(command,"")
        else
          --159=Nessun testo selezionato. Impossibile continuare!
          print("-> ChatGpt\n".._t(159))
        end
      
      wcl_strip:close()
    end
  end
  
  local function main()
    local testo = ""
    local tbl = get_expressions()
    
    testo = editor:GetSelText()
    
    testo = string.gsub(testo, "\n", " ")
    testo = string.gsub(testo, "\r", " ")
    testo = string.gsub(testo, "\t", " ")
    
    wcl_strip:init()

    wcl_strip:addButtonClose()
    --wcl_strip:addLabel(nil, "Richiesta per ChatGpt :")
    wcl_strip:addLabel(nil, _t(522))
    wcl_strip:addCombo("REQUEST")

    wcl_strip:addButton("ESEGUI",_t(57), buttonOk_click, true)
    --wcl_strip:addButton("ANNULLA","&Annulla", buttonCanc_click)

    wcl_strip:show()
    
    wcl_strip:setList("REQUEST", tbl)
    
    if (testo == "") then
        if (#tbl > 0) then
            testo = tbl[1]
        end
    end
    wcl_strip:setValue("REQUEST", testo)

  end
  
  main()
  
end
