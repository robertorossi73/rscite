--[[# -*- coding: utf-8 -*-
Version : 1.0.0
Author  : Roberto Rossi
Web     : http://www.redchar.net

Apre la selezione usando l'applicazione predefinita del Sistema Operativo

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
    require("luascr/rluawfx")
  
    --dato il percorso di un file ritorna l'elenco di tutte le cartelle accessibili
    --partendo da quella del file specificato
    local function externalOpen_splitPath(completePath)
        local ch 
        local path
        local parPath
        local chList = {}
        local i = 1
        local v
        local seps = {}
        local result = {}
        
        path = string.gsub(completePath,"/", "\\") --normalize path
        for i = 1, #path do
            chList[i] = path:sub(i, i)
        end

        for i,v in ipairs(chList) do 
            if (v == "\\") then
                table.insert(seps, i)
            end
        end

        for i,v in ipairs(seps) do 
            parPath = string.sub(path, 0, v)
            if (parPath == "\\") then
                parPath = "\\\\"
            elseif (string.sub(path, 0, 1) == "\\") then
                parPath = "\\"..parPath
            end
            table.insert(result, parPath)
        end
        
       return result
    end
  
    local function main()
        local selText = editor:GetSelText()
        local selPath = ""
        local tmpPath = ""
        local v
        local i
        
        selText = rfx_Trim(selText)
        
        if (selText ~= "") then
            if rfx_fileExist(selText) then
                selPath = selText
            else
                tmpPath = props["FileDir"].."\\"..selText
                if rfx_fileExist(tmpPath) then
                    selPath = tmpPath
                else
                    paths = externalOpen_splitPath(tmpPath)
                    for i,v in ipairs(paths) do 
                        --print(i)
                        --print(v)
                        tmpPath = v..selText
                        if rfx_fileExist(tmpPath) then
                            selPath = tmpPath
                            break
                        end
                    end
                end
            end
            
            if (selPath == "") then
                --if (rwfx_MsgBox("Non è stato trovato un file corrispondente al testo selezionato. Vuoi comunque tentare di aprire la selezione usando il programma predefinito del sistema operativo?", "Nessun file trovato...",MB_YESNO) == IDYES) then
                if (rwfx_MsgBox(_t(529), _t(530),MB_YESNO) == IDYES) then
                    selPath = selText --apro cos'i com'è la selezione
                end
            end
            
            --print(tmpPath)
            if (selPath ~= "") then
                --print("Open File: "..selPath)
                print(_t(531)..selPath)
                rwfx_ShellExecute(selPath, "")
            else
                --print("Nessun file valido selezionato.\nSelezione errata: "..selText)
                print(_t(532)..selText)
            end
        else
            --print("Nessun file valido selezionato.")
            print(_t(533))
        end
    end
    
    main()
end --fine dello script
