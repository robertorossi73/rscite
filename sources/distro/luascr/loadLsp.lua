--[[
Version : 1.2.2
Web     : http://www.redchar.net

Questa procedura permette il caricamente del file lisp corrente in un CAD supprotato

Copyright (C) 2015 Roberto Rossi 
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
    local function Main ()
        local tbl =  {}
        
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
        --wcl_strip:addLabel(nil, "CAD : ")
        wcl_strip:addLabel(nil, _t(335))
        wcl_strip:addCombo("CAD")
        --wcl_strip:addButton("ESEGUI","Carica File Corrente", buttonOk_click, true)
        wcl_strip:addButton("ESEGUI",_t(334), buttonOk_click, true)
        wcl_strip:addNewLine()
        wcl_strip:addSpace()
        --wcl_strip:addLabel(nil, "N.B. : questo procedura richiede che il CAD selezionato sia aperto")
        wcl_strip:addLabel(nil, _t(336))

        wcl_strip:show()
        
        --ripristinare ultima selezione
        wcl_strip:setList("CAD", tbl)
        wcl_strip:setValue("CAD", tbl[loadCADLsp_presel(nil)])
    end

    Main()
end

