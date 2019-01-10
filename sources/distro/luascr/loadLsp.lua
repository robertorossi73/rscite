--[[
Version : 2.1.0
Web     : http://www.redchar.net

Questa procedura permette il caricamente del file lisp corrente in un CAD supprotato

Copyright (C) 2015-2018 Roberto Rossi 
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

    function inverterSlash(testo)
        local result = ""
        local i=1
        local len
        local lettera

        len = string.len(testo)

        while (i <= len) do
          lettera = string.sub(testo,i,i)
          if (lettera == "\\") then
            lettera = "/"
          end      
          result = result..lettera
          
          i = i + 1
        end
        return result
    end 

    
    function buttonOk_click(control, change)
        local exe = "wscript"
        local cad = ""
        local cadselected = ""
        local par = ""
        
        cadselected = wcl_strip:getValue("CAD")        
        cadselected = string.lower(cadselected)
        
        if (string.find(cadselected, "*", 1, true)) then
            cad = "\"all\""
            loadCADLsp_presel(1)
        elseif (string.find(cadselected, "progecad", 1, true)) then
            cad = "\"icad\""
            loadCADLsp_presel(2)
        elseif (string.find(cadselected, "autocad", 1, true)) then
            cad = "\"acad\""
            loadCADLsp_presel(3)
        elseif (string.find(cadselected, "bricscad", 1, true)) then
            cad = "\"bcad\""
            loadCADLsp_presel(4)
        elseif (string.find(cadselected, "zwcad", 1, true)) then
            cad = "\"zcad\""
            loadCADLsp_presel(5)
        end

        wcl_strip:close()

        par = "\""..props["SciteDefaultHome"].."/luascr/loadCADLsp.vbs\" " ..
                cad..
                " \""..inverterSlash(props["FilePath"]).."\""

        rwfx_ShellExecute(exe,par)
    end

    function buttonOkDcl_click(control, change)
        local exe = "wscript"
        local cad = ""
        local cadselected = ""
        local idf
        local par = ""
        local nomef
        local newNomef
        local result = ""
        local dialogName = ""

        dialogName = wcl_strip:getValue("DCL")
        
        cadselected = wcl_strip:getValue("CAD")
        cadselected = string.lower(cadselected)
        
        if (string.find(cadselected, "*", 1, true)) then
            cad = "\"all\""
            loadCADLsp_presel(1)
        elseif (string.find(cadselected, "progecad", 1, true)) then
            cad = "\"icad\""
            loadCADLsp_presel(2)
        elseif (string.find(cadselected, "autocad", 1, true)) then
            cad = "\"acad\""
            loadCADLsp_presel(3)
        elseif (string.find(cadselected, "bricscad", 1, true)) then
            cad = "\"bcad\""
            loadCADLsp_presel(4)
        elseif (string.find(cadselected, "zwcad", 1, true)) then
            cad = "\"zcad\""
            loadCADLsp_presel(5)
        end

        wcl_strip:close()
        
        --implementare scrittura file lsp per test dcl
        nomef = props["SciteDefaultHome"].."\\luascr\\tst_dcl_tpl.lsp"
        newNomef = os.getenv("TMP").."\\tst_dcl_tpl.lsp"
        idf = io.open(nomef, "r")
        if (idf) then
          result = idf:read("*a")
          io.close(idf)
        end
        
        result = string.gsub(result, "dclFileNamePosition", inverterSlash(props["FilePath"]))
        result = string.gsub(result, "dialogNamePosition", dialogName)

        idf = io.open(newNomef, "w")
        if (idf) then
          result = idf:write(result)
          io.close(idf)
        end
        
        par = "\""..props["SciteDefaultHome"].."/luascr/loadCADLsp.vbs\" " ..
                cad..
                " \""..inverterSlash(newNomef).."\""

        rwfx_ShellExecute(exe,par)
        --print(par)
    end
    
---------------------------- Procedure di utilità ---------------------------- 
    --legge/scrive l'ultimo cad seleziolnato
    -- se value = nil la funzione ritorna il valore precedentemente salvato
    -- se value != nil e > 0, la funzione scrive il valore nel registro
    function loadCADLsp_presel(value)
        local sel = nil
        local key = ""
        
        key = rfx_Get_Registry_Key("TMP")
        if (value) then
            rwfx_RegSetInteger(key, "loadCADLsp.CADName", value)
        else
            sel = rwfx_RegGetInteger(key, "loadCADLsp.CADName", "HKCU")        
            if not(sel) then
                sel = 1
            end
        end
        
        return sel
    end
    
---------------------------- Procedure principale ---------------------------- 
    function MainLoadLsp ()
        local tbl =  {}
        local isDCL = false --lisp == true, dcl == false
        
        if (props["Language"] == "lisp") then
            isDCL = false;
        else
            isDCL = true;
        end
        
        tbl = { --"Ricerca automatica, progeCAD/AutoCAD/BricsCAD/ZwCAD/*",
                _t(337),
                "progeCAD",
                "AutoCAD",
                "BricsCAD",
                "ZwCAD"
                }

        local nomef = props["FileNameExt"]

        wcl_strip:init()

        wcl_strip:addButtonClose()
        if (isDCL) then
            wcl_strip:addLabel(nil, "Dialog : ")
            wcl_strip:addText("DCL", rfx_Trim(editor:GetSelText()))
        end
        
        --wcl_strip:addLabel(nil, "CAD : ")
        wcl_strip:addLabel(nil, _t(335))
        wcl_strip:addCombo("CAD")
        if (isDCL) then
            wcl_strip:addButton("ESEGUI",_t(334), buttonOkDcl_click, true)
        else
            wcl_strip:addButton("ESEGUI",_t(334), buttonOk_click, true)
        end
        wcl_strip:addNewLine()
        if (isDCL) then
            wcl_strip:addSpace()
            wcl_strip:addSpace()
        end
        wcl_strip:addSpace()
        --wcl_strip:addLabel(nil, "N.B. : questo procedura richiede che il CAD selezionato sia aperto")
        wcl_strip:addLabel(nil, _t(336))

        wcl_strip:show()
        
        --ripristinare ultima selezione
        wcl_strip:setList("CAD", tbl)
        wcl_strip:setValue("CAD", tbl[loadCADLsp_presel(nil)])
    end

    MainLoadLsp()
end

