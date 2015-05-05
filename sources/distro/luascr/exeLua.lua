--[[
Version : 3.1.1
Web     : http://www.redchar.net

Questa procedura Esegue l'espressione Lua selezionata

Esempio :
  print("testo") --stampa un testo generico
  print(props["menu.language"]) --stampa il contenuto del menu Linguaggio

Copyright (C) 2004-2015 Roberto Rossi 
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

---------------------------------- Versioni -----------------------------------

V.3.1.0
- aggiunta chiusura dopo esecuzione
- eliminato tasto annulla
- aggiunte traduzione

V.3.0.1
- Aggiunta interfaccia Stripe
- Aggiunta lista ultime istruzioni eseguite (25)

]]

do 
  require("luascr/rluawfx")
  
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
    local nomef = rfx_UserFolderRSciTE()..'/tmp/exeLua.ini'
    local v
    local count = 1
    
    while (count < 26) do
      v = values[count]
      if (v) then
        rfx_setIniVal(nomef, "General", "lua"..tostring(count) , v)
      end
      count = count + 1
    end
  end

  --ritorna la tabella delle ultime 100 espressioni eseguite
  local function get_expressions()
    local nomef = rfx_UserFolderRSciTE()..'/tmp/exeLua.ini'
    local result = {}
    local i = 1
    local v
    
    tbl = rfx_GetIniSec
    
    while(i < 26) do
      v = rfx_GetIniVal(nomef, "General", "lua"..tostring(i))
      if (v ~= "") then
        result[i] = v
      else
        break
      end
      i = i + 1
    end    
    
    return result
  end
  
--~   function buttonCanc_click(control, change)
--~     wcl_strip:close()
--~   end

  function buttonOk_click(control, change)
    local values
    local luaStr = ""
    
    luaStr = wcl_strip:getValue("LUA")
    
    if (luaStr ~= "") then
      values = get_expressions()
      if (not(table_exist(values, luaStr))) then
        table.insert(values,1,luaStr)
        save_expressions(values)
        wcl_strip:setList("LUA", values)
      end
      dostring(luaStr)
      wcl_strip:close()
    end
  end
  
  local function main()
    local testo = ""
    
    testo = editor:GetSelText()
    
    testo = string.gsub(testo, "\n", " ")
    testo = string.gsub(testo, "\r", " ")
    testo = string.gsub(testo, "\t", " ")
    
    wcl_strip:init()

    wcl_strip:addButtonClose()
    --wcl_strip:addLabel(nil, "Espressione Lua:")
    wcl_strip:addLabel(nil, _t(58).." :")
    wcl_strip:addCombo("LUA")

    wcl_strip:addButton("ESEGUI",_t(57), buttonOk_click, true)
    --wcl_strip:addButton("ANNULLA","&Annulla", buttonCanc_click)

    wcl_strip:show()
    
    wcl_strip:setList("LUA", get_expressions())
    wcl_strip:setValue("LUA", testo)

  end
  
  main()
end


