--[[
Version : 1.0.1
Web     : http://www.redchar.net

Estrae codici colori esadecimali da file corrente

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

    local function decodeHexVal(txt)
        local result = ""
        local len
        local ch
        local i = 0
        
        txt = string.lower(txt)
        len = string.len(txt)
    
        while (i <= len) do
            ch = string.sub(txt,i,i)
            if ((ch == "#") or
                (ch == "0") or
                (ch == "1") or
                (ch == "2") or
                (ch == "3") or
                (ch == "4") or
                (ch == "5") or
                (ch == "6") or
                (ch == "7") or
                (ch == "8") or
                (ch == "9") or
                (ch == "a") or
                (ch == "b") or
                (ch == "c") or
                (ch == "d") or
                (ch == "e") or
                (ch == "f")) then
                
                if (string.len(result) < 7) then
                    result = result..ch
                else
                    break;
                end                
            end
            i = i + 1
        end
        
        --supportati i formati #xxx oppure #xxxxxx
        if ((string.len(result) ~= 4) and (string.len(result) ~= 7)) then
            result = ""
        end
        
        return result
    end
    
    --ritorna true se l'elento non esiste nella tabella
    local function NotExistInTable(tbl, value)
        local i
        local v
        local result = true
        
        for i, v in ipairs(tbl) do
            if (v == value) then
                result = false
                break
            end
        end
        
        return result
    end
    
    local function CompareItems (elemento1, elemento2)
        if (elemento1 < elemento2) then
            return true
        else
            return false
        end
    end
    
    local function DumpTable(tbl)
        local i
        local v
        
        --TODO : da tradurre
        
        print("File : "..props["FilePath"])
        print("Colors found : "..tostring(#tbl))
        print("Hexadecimal Colors : ")
        for i, v in ipairs(tbl) do
            print(v)
        end
        print("")
    end

    local function getColorsList()
        local result = {}
        local pos1
        local pos2
        local hexVal
        local initPos = editor.CurrentPos
        
        if not(pos1) then
            pos1 = -1
        end
        
        while (pos1 ~= nil) do
            pos1, pos2 = editor:findtext("#[0-F0-f][0-F0-f][0-F0-f].*", SCFIND_REGEXP, pos1 + 1)
            if (pos1) then
                editor:SetSel(pos1, pos2)
                hexVal = editor:GetSelText()
                hexVal = string.sub(hexVal,0, 7)
                hexVal = decodeHexVal(hexVal)
                if (hexVal ~= "") then
                    if (NotExistInTable(result, hexVal)) then
                        table.insert(result, hexVal)                    
                    end
                end
            end
        end
        editor:GotoPos(initPos)
        
        table.sort(result, CompareItems)
        return result
    end
    
    local function main()
        local colors = getColorsList()
        
        DumpTable(colors)
    end
    
    main()
end

