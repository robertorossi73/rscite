--[[
Author  : Roberto Rossi
Version : 1.4.1
Web     : http://www.redchar.net

Editor di configurazione per le proprietà di SciTE

Copyright (C) 2017-2018 Roberto Rossi 
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
    
    if (rwfx_isEnglishLang()) then
        require("luascr/cfgEditor-en")
    else
        require("luascr/cfgEditor-it")
    end
    
    local cfgEditor_CurrentCfgId = 0
    
    local function cfgEditor_TableToString(tbl, separator)
        local strPrefixCfg = "    "
        local i
        local v
        local result = ""
        local item
        
        for i, v in ipairs(tbl) do
            if (type(v) == "table") then
                item = strPrefixCfg..v[1]
                if ((v[3] ~= "") and 
                    ( v[2] ~= "cmd")) then -- aggiunge variabile quando necessario
                    item = item.."  ("..v[3].. ")"
                end
            else
                item = v
            end
            if (result == "") then
                result = item
            else
                result = result..separator..item
            end
        end
        return result
    end

    local function cfgEditor_writeConfig(filePath, setting, value)
        local result = false
        local idf
        local line
        local tmpLine
        local tblData = {}
        local txtSearch = setting.."="
        local i
        local v
        local setOk = false
        local removeLine = false
        
        i = 1
        idf = io.open(filePath, "r")
        if (idf) then
            for line in idf:lines() do
                removeLine = false
                tmpLine = rfx_Trim(line)
                tmpLine = string.gsub(tmpLine, " ", "")
                tmpLine = string.gsub(tmpLine, "\t", "")
                if (string.sub(tmpLine, 1, string.len(txtSearch)) == txtSearch ) then
                    line = txtSearch..value
                    setOk = true
                    if (value == "*REMOVE*") then
                        removeLine = true
                    end
                end

                if (removeLine) then
                    --elimina la configurazione
                    i = i - 1
                else
                    tblData[i] = line
                end
                i = i + 1
            end
            io.close(idf)
        end
        
        if (setOk == false) then
            if (value ~= "*REMOVE*") then --solo se il valore è diverso da REMOVE
                tblData[i] = txtSearch..value
            end
        end
        
        idf = io.open(filePath, "w")
        if (idf) then
            for i, v in ipairs(tblData) do
                idf:write(v.."\n")
            end          
            io.close(idf)
            result = true
        end
        
        return result
    end
  
    local function cfgEditor_SetCfg()
        local result = false
        local i
        local valTxt = wcl_strip:getValue("ITEMVALUES")
        local item = cfgEditor_tblItems[cfgEditor_CurrentCfgId]
        local nameCfg = item[3]
        local newValue = ""
        local max
        local options
        local filePath = props["SciteUserHome"].."\\SciTEUser.properties"
        
        options = item[4]
        if (options == false) then
            newValue = valTxt
        else
            max = #options
            i = 1
            while (i <= max) do
                if (options[i] == valTxt) then
                    newValue = options[i+1]
                end
                i = i + 2
            end
        end

        --TODO : verifica coerenza nuovo valore
        if (newValue == "") then
            --print("\n--- Editor di configurazione di RSciTE ---")
            print(_t(444))
            --print("> Valore specificato NON VALIDO!")
            print(_t(445))
        else
            cfgEditor_writeConfig(filePath, nameCfg, newValue)
            --messaggio che dice all'utente di chiudere e riaprire il programma
            output:ClearAll()
            --print("\n--- Editor di configurazione di RSciTE ---")
            print(_t(444))
            --print("Configurazione impostata:")
            print(_t(446))
            print(nameCfg.." -> "..newValue)
            --print("> Attenzione! Per rendere attive alcune impostazione è necessario chiudere e riaprire SciTE. <")
            print(_t(447))
        end
        
    end
  
    function buttonOk_click(control, change)
        output:ClearAll()
        cfgEditor_SetCfg()
        wcl_strip:close()
        cfgEditor_main()
    end
    
    function buttonCancel_click(control, change)
        output:ClearAll()
        wcl_strip:close()
        cfgEditor_main()
    end

    function buttonHelp_click(control, change)
        local item = cfgEditor_tblItems[cfgEditor_CurrentCfgId]
        if (item ~= nil) then
            if (type(item[5]) == "number") then
                --print("Configurazione : "..item[3].."\n\n".._t(item[5]))
                print(_t(448).." "..item[3].."\n\n".._t(item[5]))
            elseif (type(item[5]) == "string") then
                print(_t(448).." "..item[3].."\n\n"..item[5])
            end
        end
    end
    
    local function cfgEditor_edit(idCfg)
        local item = cfgEditor_tblItems[idCfg]
        local title = item[1]
        local opts = {}
        local i
        local max
        local options
        local currentI
        local currentV
        
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        --wcl_strip:addLabel(nil, "Nome configurazione : ")
        wcl_strip:addLabel(nil, _t(449))
        wcl_strip:addLabel(nil, item[3].."   ")
        wcl_strip:addNewLine()
        wcl_strip:addLabel(nil, "  "..title.." : ")
        wcl_strip:addCombo("ITEMVALUES")

        --wcl_strip:addButton("SAVE","&Salva configurazione", buttonOk_click)
        wcl_strip:addButton("SAVE",_t(450), buttonOk_click)
        --wcl_strip:addButton("CANCEL","&Annulla", buttonCancel_click)
        wcl_strip:addButton("CANCEL",_t(451), buttonCancel_click)
        wcl_strip:show()
        
        if (item[4] ~= false) then
            currentI = props[item[3]]
            currentV = ""
            options = item[4]
            
            max = #options
            i = 1
            while (i <= max) do
                opts[i] = options[i]
                if (options[i+1] == currentI) then
                    currentV = options[i]
                end
                i = i + 2
            end
            wcl_strip:setList("ITEMVALUES", opts)
            wcl_strip:setValue("ITEMVALUES", currentV)
        else
            wcl_strip:setValue("ITEMVALUES", props[item[3]])
        end
        
        cfgEditor_CurrentCfgId = idCfg
        buttonHelp_click(nil,nil)        
    end

    function cfgEditor_main()
        local lista
        local scelta
        local item
        local firstCh
        local nextSelection = true
        local typeCfg = ""
        local cmd = ""
        
        lista = cfgEditor_TableToString(cfgEditor_tblItems, "|")
        while (nextSelection) do
            --scelta = rwfx_ShowList_Repos(lista,"Editor Configurazioni", "configuration_editor", false)
            scelta = rwfx_ShowList_Repos(lista,_t(452), "configuration_editor", false)
            if scelta then
                output:ClearAll()
                item = cfgEditor_tblItems[scelta+1]
                typeCfg = item[2] --str, int, cmd, etc...
                print(item[3])
                if (type(item) == "table") then
                    
                    if (typeCfg == "cmd") then  
                        cmd = item[3]
                        --comandi singoli
                        if (cmd == "RSCITE_GUIDE") then
                            require("luascr/gohelp") -- guida a RSciTE
                        elseif (cmd == "IDM_HELP_SCITE") then
                            scite.MenuCommand(IDM_HELP_SCITE) -- help
                        elseif (cmd == "IDM_OPENUSERPROPERTIES") then                        
                            scite.MenuCommand(IDM_OPENUSERPROPERTIES) -- proprietà utente
                        elseif (cmd == "IDM_OPENGLOBALPROPERTIES") then                        
                            scite.MenuCommand(IDM_OPENGLOBALPROPERTIES) -- proprietà globali
                        end
                    else
                        cfgEditor_edit(scelta+1)
                    end 
                    nextSelection = false
                else
                    nextSelection = true
                end
            else
                nextSelection = false
                output:ClearAll()
            end
        end
    end

cfgEditor_main()

end
