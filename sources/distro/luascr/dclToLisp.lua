
--[[
Author  : Roberto Rossi
Version : 1.1.2
Web     : http://www.redchar.net

Questo modulo consente di trasformare un file .dcl in una stringa di lisp

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
    require("luascr/rluawfx")
    
    --Carica un file e restituisce una tabella di stringhe, un elemento per linea
    local function dclToLisp_fileToTable (filename)
        local result = {}
        local line = ""
        local idf
        local i = 1
        
        idf = io.open(filename, 'r')
        if idf then
            for line in idf:lines() do
                --lineaCorrente = rfx_Trim(linea)
                result[i] = line
                i = i + 1
            end --endfor
            idf:close()
        end --endif
        
    return result
    end

    local function dclToLisp_cvDclToLisp (tableLines)
    local result = ""
    local k
    local v
    local i = 1

        result = "(setq myDcl (strcat ".."\r\n"
        for k,v in pairs(tableLines) do 
            v = string.gsub(v, "\\", "\\\\")
            v = string.gsub(v, "\"", "\\\"")
            result = result.."    \""..v.."\\n\"\r\n"
        end
        result = result.."    )".."\r\n)"
    return result
    end

    local function getDclFileName()
        local destfile
        local fileName = ""
        
        destfile = rwfx_GetFileName( 
                                   --"Seleziona file .DCL da convertire"
                                   _t(506)
                                   ,"", 0,rfx_FN(),
                                   --"File Dcl(*.dcl)%c*.dcl")
                                   _t(507))
        if (destfile) then
            fileName = rfx_GF()
        end
        
    return fileName
    end
        
    local function main()
        local filename = ""
        local result

        filename = getDclFileName()
        if not(filename == "") then
            result = dclToLisp_fileToTable(filename)
            if (#result > 0) then
                editor:CopyText(dclToLisp_cvDclToLisp(result))
                --print("\nLa Dcl convertita è stata copiata negli appunti del sistema operativo. Il testo può essere incollato all'interno di qualsiasi file (Ctrl+V).")
                print(_t(508))
            end
        end
    end

    main()
    
end


