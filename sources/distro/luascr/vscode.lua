--[[ # -*- coding: utf-8 -*-
Version : 1.2.0
Web     : http://www.redchar.net

Questa procedura permette di lanciare una versione di Visual Studio Code, scelta
tra quelle configurabili

Copyright (C) 2023 Roberto Rossi 
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
    
    local function selectVSCExe()
        local result = ""
        local fileName
        
        -- 84=Seleziona file da inserire
        --fileName = rwfx_GetFileName("Seleziona Eseguibile 'Code.exe'..."
        fileName = rwfx_GetFileName(_t(510)
                                    ,"", OFN_FILEMUSTEXIST,rfx_FN())
        if (fileName) then
            result = rfx_GF()
        end

        return result
    end
    
    local function setVSCConfig(    name1, path1,
                                    name2, path2,
                                    name3, path3,
                                    name4, path4,
                                    name5, path5
                                )
        local str = ""
        
        if (rfx_Trim(name1) == "") then name1 = "Visual Studio Code 1" end
        if (rfx_Trim(name2) == "") then name2 = "Visual Studio Code 2" end
        if (rfx_Trim(name3) == "") then name3 = "Visual Studio Code 3" end
        if (rfx_Trim(name4) == "") then name4 = "Visual Studio Code 4" end
        if (rfx_Trim(name5) == "") then name5 = "Visual Studio Code 5" end
        
        str =   rfx_Trim(name1).."|"..rfx_Trim(path1).."|"..
                rfx_Trim(name2).."|"..rfx_Trim(path2).."|"..
                rfx_Trim(name3).."|"..rfx_Trim(path3).."|"..
                rfx_Trim(name4).."|"..rfx_Trim(path4).."|"..
                rfx_Trim(name5).."|"..rfx_Trim(path5)
        
        rfx_setCfgFile("VSCPaths.cfg", str)
    end
    
    local function getVSCConfig()
        local str = rfx_getCfgFile("VSCPaths.cfg")
        local result = {
                        "Visual Studio Code 1", "",
                        "Visual Studio Code 2", "",
                        "Visual Studio Code 3", "",
                        "Visual Studio Code 4", "",
                        "Visual Studio Code 5", ""
                        }
        if (str ~= "") then
            result = rfx_Split(str, "|")
        end
        
        return result
    end
    
    ---------------------------- Procedure di utilità ---------------------------- 
    --legge/scrive l'ultimo cad seleziolnato
    -- se value = nil la funzione ritorna il valore precedentemente salvato
    -- se value != nil e > 0, la funzione scrive il valore nel registro
    local function loadVScode_presel(value)
        local sel = nil
        local key = ""
        
        key = rfx_Get_Registry_Key("TMP")
        if (value) then
            rwfx_RegSetInteger(key, "VSCode.ExeIndex", value)
        else
            sel = rwfx_RegGetInteger(key, "VSCode.ExeIndex", "HKCU")        
            if not(sel) then
                sel = 1
            end
        end
        
        return sel
    end
    
    function buttonSelect1_click(control, change)
        local path = selectVSCExe()
        wcl_strip:setValue("VSC1", path)
    end
    function buttonSelect2_click(control, change)
        local path = selectVSCExe()
        wcl_strip:setValue("VSC2", path)
    end
    function buttonSelect3_click(control, change)
        local path = selectVSCExe()
        wcl_strip:setValue("VSC3", path)
    end
    function buttonSelect4_click(control, change)
        local path = selectVSCExe()
        wcl_strip:setValue("VSC4", path)
    end
    function buttonSelect5_click(control, change)
        local path = selectVSCExe()
        wcl_strip:setValue("VSC5", path)
    end
    
    function buttonClose_click(control, change)
        wcl_strip:close()
    end

    function buttonCfg_click(control, change)
        wcl_strip:close()
        mainCfg()
    end
    
    function buttonSave_click(control, change)
        setVSCConfig(
                        wcl_strip:getValue("VSCN1"), wcl_strip:getValue("VSC1"),
                        wcl_strip:getValue("VSCN2"), wcl_strip:getValue("VSC2"),
                        wcl_strip:getValue("VSCN3"), wcl_strip:getValue("VSC3"),
                        wcl_strip:getValue("VSCN4"), wcl_strip:getValue("VSC4"),
                        wcl_strip:getValue("VSCN5"), wcl_strip:getValue("VSC5")
                    )
        wcl_strip:close()
    end
    
    --elimina file di configurazione
    function buttonReset_click(control, change)
        -- Desideri ripristinare la configurazione di base?
        if (rwfx_MsgBox(_t(511),_t(9),MB_YESNO) == IDYES) then
            rfx_setCfgFile("VSCPaths.cfg", false)
        end
        wcl_strip:close()
    end
    
    local function openVSCode(onlyOpen)
        local result = 0
        local i
        local item
        local tp
        local isOk = false
        local exeName
        local url = ""    
        local values = getVSCConfig()
        local index_names = {1, 3, 5, 7, 9}
        local names = { values[index_names[1]], 
                        values[index_names[2]], 
                        values[index_names[3]], 
                        values[index_names[4]], 
                        values[index_names[5]]}

        
        tp = wcl_strip:getValue("QVSC")
        
        for i,item in ipairs(names) do
            if (item == tp) then
                exeName = values[index_names[i] + 1]
                if rfx_fileExist(exeName) then
                    if (onlyOpen) then
                        rwfx_ShellExecute(exeName,"")
                    else
                        rwfx_ShellExecute(exeName," \""..props["FilePath"].."\"")
                    end
                    loadVScode_presel(i)
                else
                    print("Missing File \""..exeName.."\". Check Configuration!")
                    result = 1
                end
                isOk = true
            end
        end
      
        if not(isOk) then
            print("Invalid Selection!")
        end
    
        return result
    end
    
    function buttonOkFile_click(control, change)
        if (openVSCode(false) > 0) then
            buttonCfg_click(control, change)
        else
            wcl_strip:close()
        end
    end
    
    function buttonOkOpen_click(control, change)
        if (openVSCode(true) > 0) then
            buttonCfg_click(control, change)
        else
            wcl_strip:close()
        end
    end
    
    function mainCfg()

        local values = {}
        
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        values = getVSCConfig()
        
        -- wcl_strip:addLabel(nil, "Nome: ")
        wcl_strip:addLabel(nil, _t(512))
        wcl_strip:addText("VSCN1", values[1], false)
        -- wcl_strip:addLabel(nil, "  Eseguibile: ")
        wcl_strip:addLabel(nil, _t(513))
        wcl_strip:addText("VSC1", values[2], false)
        wcl_strip:addButton("EXEVSC1"," ... ",buttonSelect1_click, false)
        wcl_strip:addNewLine()
        
        wcl_strip:addLabel(nil, _t(512))
        wcl_strip:addText("VSCN2", values[3], false)
        wcl_strip:addLabel(nil, _t(513))
        wcl_strip:addText("VSC2", values[4], false)
        wcl_strip:addButton("EXEVSC2"," ... ",buttonSelect2_click, false)
        wcl_strip:addNewLine()
        
        wcl_strip:addLabel(nil, _t(512))
        wcl_strip:addText("VSCN3", values[5], false)
        wcl_strip:addLabel(nil, _t(513))
        wcl_strip:addText("VSC3", values[6], false)
        wcl_strip:addButton("EXEVSC3"," ... ",buttonSelect3_click, false)
        wcl_strip:addNewLine()
        
        wcl_strip:addLabel(nil, _t(512))
        wcl_strip:addText("VSCN4", values[7], false)
        wcl_strip:addLabel(nil, _t(513))
        wcl_strip:addText("VSC4", values[8], false)
        wcl_strip:addButton("EXEVSC4"," ... ",buttonSelect4_click, false)
        wcl_strip:addNewLine()
        
        wcl_strip:addLabel(nil, _t(512))
        wcl_strip:addText("VSCN5", values[9], false)
        wcl_strip:addLabel(nil, _t(513))
        wcl_strip:addText("VSC5", values[10], false)
        wcl_strip:addButton("EXEVSC5"," ... ",buttonSelect5_click, false)
        wcl_strip:addNewLine()
        
        wcl_strip:addSpace()
        --wcl_strip:addButton("RESET"," &Resetta configurazione ",buttonReset_click, false)
        wcl_strip:addButton("RESET",_t(514),buttonReset_click, false)
        wcl_strip:addSpace()
        --wcl_strip:addButton("SAVE"," &Salva configurazione ",buttonSave_click, false)
        wcl_strip:addButton("SAVE",_t(515),buttonSave_click, false)
        --wcl_strip:addButton("CLOSE"," &Annulla ",buttonClose_click, true)
        wcl_strip:addButton("CLOSE",_t(516),buttonClose_click, true)
        
        wcl_strip:show()
--         wcl_strip:setList("TVAL",{"WolframAlpha", "Google"})
--         wcl_strip:setList("QVAL",samples)
--         wcl_strip:setValue("TVAL", "Google")
--         wcl_strip:setValue("QVAL", editor:GetSelText())  
    end
    
    local function main()

        local values = getVSCConfig()
        local names = {values[1], values[3], values[5], values[7], values[9] }
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        --wcl_strip:addLabel(nil, "  Applicazione : ")--funzione
        wcl_strip:addLabel(nil, _t(521))--funzione
        wcl_strip:addCombo("QVSC")
        
        --wcl_strip:addButton("OPENF"," Apri file corrente... ",buttonOkFile_click, true)
        wcl_strip:addButton("OPENF",_t(517),buttonOkFile_click, true)
        --wcl_strip:addButton("OPEN"," Apri... ",buttonOkOpen_click, false)
        wcl_strip:addButton("OPEN",_t(518),buttonOkOpen_click, false)
        wcl_strip:addNewLine()
        wcl_strip:addSpace()
        wcl_strip:addSpace()
        --wcl_strip:addButton("CFG"," Configura... ",buttonCfg_click, false)
        wcl_strip:addButton("CFG",_t(519),buttonCfg_click, false)
        --wcl_strip:addButton("CLOSE","Chiudi",buttonClose_click, false)
        wcl_strip:addButton("CLOSE",_t(520),buttonClose_click, false)
        
        wcl_strip:show()
        wcl_strip:setList("QVSC", names)
        wcl_strip:setValue("QVSC", names[loadVScode_presel(false)])
    end
    
    main()

end --fine dello script
