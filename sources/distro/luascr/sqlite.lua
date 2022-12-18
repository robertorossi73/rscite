--# -*- coding: utf-8 -*-
--SQLite Module
--
-- Questo modulo consente l'uso di script sqlite

--[[
Version : 1.3.2
Web     : http://www.redchar.net

Questo modulo consente l'utilizzo con sqlite in versione a linea di comando

Copyright (C) 2020 Roberto Rossi 
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
    -- variabile globale contenente il percorso dell'ultimo db utilizzato
    -- G_sqlite_db_path

    --carica le funzioni speciali di RSciTE
    require("luascr/rluawfx")

    --variabile globale con ultimo database specificato
    --G_recent_sqlite_db
    
    function buttonMan_click(control, change)
       rwfx_ShellExecute("https://devdocs.io/sqlite/","") 
    end
    
    function buttonSel_click(control, change)
        local destfile
        local fileName = false
        
        destfile = rwfx_GetFileName( _t(206)
                                   ,"", 0,rfx_FN(),
                                   _t(195))
                                   --"All Files (*.*)%c*.*")
        if (destfile) then
            fileName = rfx_GF()
            wcl_strip:setValue("TVAL", fileName)
            G_recent_sqlite_db = fileName
        end
    end
     
    function sqlite_execute_script(dbpath)
        local result
        local sqlpath
        local sqlfolder
        
        sqlpath = props["FilePath"]
        sqlfolder = props["FileDir"]
        
        G_recent_sqlite_db = dbpath
        
        if (rfx_fileExist(dbpath) or dbpath == "")then
            executeSqlOnDb(dbpath, sqlpath, sqlfolder)
        else
            if not(dbpath) then
                dbpath = "???"
            end
            --print("Impossibile trovare il file "..dbpath)
            print(_t(466).." "..dbpath)
        end
    end
    
    function buttonOk_click(control, change)
        sqlite_execute_script(wcl_strip:getValue("TVAL"))
        wcl_strip:close()
    end
    
    function buttonCancel_click(control, change)
        wcl_strip:close()
    end
    
    --mostra la maschera dove poter speficiare il db su cui
    --  agire e le relative opzioni
    local function startGui()
        local result = false
        
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        --TODO: da tradurre
        --wcl_strip:addLabel(nil, "File di Database (opzionale): ")
        wcl_strip:addLabel(nil, _t(467).." ")
        wcl_strip:addText("TVAL","")
        --wcl_strip:addButton("SELBTN","Seleziona file",buttonSel_click, false)
        wcl_strip:addButton("SELBTN",_t(468),buttonSel_click, false)
        --wcl_strip:addButton("OKBTN","Esegui SQL",buttonOk_click, true)
        wcl_strip:addButton("OKBTN",_t(469),buttonOk_click, true)
        --wcl_strip:addButton("CLOSEBTN","Chiudi",buttonCancel_click, false)
        wcl_strip:addButton("CLOSEBTN",_t(200),buttonCancel_click, false)
        wcl_strip:addNewLine()
        wcl_strip:addSpace()
        --wcl_strip:addLabel(nil, "Se il database non è specificato verrà eseguito solamente lo script corrente.")
        wcl_strip:addLabel(nil, _t(465))
        --Manuale SQLite
        wcl_strip:addButton("MANBTN",_t(470),buttonMan_click, false)
        wcl_strip:show()
        if (G_recent_sqlite_db) then
            wcl_strip:setValue("TVAL", G_recent_sqlite_db)
        end
    end
  
    local function getSqliteExtPath ()
        return props["SciteDefaultHome"].."\\tools\\sqlite\\sqlite3.exe"
    end
  
    --crea file bat con stringa per esecuzione sqlite su script corrente
    --  ritorna path completo file bat
    local function createBat(dbpath, sqlpath, sqlfolder)
        local exe = getSqliteExtPath()
        local tmpbat = os.tmpname()..".bat"
        local idf
        
        --esecuzione: sqlite.exe "db.name" < "path\script.sql"
        idf = io.open(tmpbat, "w")
        if (idf) then
            idf:write("echo off\n")
            --idf:write("cd /D \"%~dp0\"\n")
            idf:write("cd /D \""..sqlfolder.."\"\n")
            idf:write("echo database: "..dbpath.."\n")
            idf:write("echo sql file: "..sqlpath.."\n")
            idf:write("echo -------- ---------\n")
            idf:write("\""..exe.."\" \""..dbpath.."\" < \""..sqlpath.."\"\n")
            io.close(idf)
        end
        return tmpbat
    end
    
    --esegue il file sql specificato sul db indicato
    function executeSqlOnDb(dbpath, sqlpath, sqlfolder)
        local bat
        
        bat = createBat(dbpath, sqlpath, sqlfolder)
        
        print(rfx_exeCapture("cmd /c \""..bat.."\""))
        
        os.remove(bat)
        print(_t(464))
        --print("\n-------- ---------\nProcedura conclusa.")
        
        return result
    end
  
    function sqlite_run(value)
        if (value == 7) then
            startGui()
        else
            sqlite_execute_script("")
        end
    end
  
    --main()
end
