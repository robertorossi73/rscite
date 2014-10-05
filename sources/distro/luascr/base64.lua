--[[ # -*- coding: utf-8 -*-
Version : 0.1.0
Web     : http://www.redchar.net

Questo script consente la codifica e la decodifica del testo in formato base64

Copyright (C) 2011-2014 Roberto Rossi 
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

------------------ base64 encoding/decoding (by Alex Kloss) -------------
    -- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
    -- licensed under the terms of the LGPL2
------------------ base64 encoding/decoding (by Alex Kloss) -------------   

--]]

do
  require("luascr/rluawfx")

------------------ Start base64 encoding/decoding (by Alex Kloss) -------------
    -- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
    -- licensed under the terms of the LGPL2
------------------ Start base64 encoding/decoding (by Alex Kloss) -------------   
    
    -- character table string
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    -- encoding
    local function enc(data)
        return ((data:gsub('.', function(x) 
            local r,b='',x:byte()
            for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
            return r;
        end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
            return b:sub(c+1,c+1)
        end)..({ '', '==', '=' })[#data%3+1])
    end

    -- decoding
    local function dec(data)
        data = string.gsub(data, '[^'..b..'=]', '')
        return (data:gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end))
    end

  --codifica o decodifica un testo usando l'algoritmo base64.
  --operation può essere "e" oppure "d", nel primo caso codifica, nel secondo
  --  decodifica
  -- se textIsFile=true allora il valore di text è interpretato come file e il 
  --    se poi è specificato outputFile, il risultato viene salvato nel file indicato
  local function exec_base64(operation, text, textIsFile, outputFile)
    local func = 'enc'
    local result = "!-error-!";
    local data = ""
    local idf = false
    local loadFromFile = false
    local savedToFile = false
    
    if ((textIsFile) and (textIsFile ~= "")) then
        idf = io.open(text, "r")
        if (idf) then
            data = idf:read("*a")            
            io.close(idf)
            loadFromFile = true
        end
    else
        data = text
    end
    
    if (operation == "e") then
      result = enc(data)
    elseif (operation == "d") then
      result = dec(data)
    end
    
    if ((outputFile) and (outputFile ~= "")) then
        idf = io.open(outputFile, "w")
        if (idf) then            
            idf:write(result)
            io.close(idf)
            savedToFile = true
        end
    end
    
    if (loadFromFile and savedToFile) then
        result = "Input : "..text.."\nOutput : "..outputFile
    end
    
    return result
  end --end function
------------------ End base64 encoding/decoding (by Alex Kloss) ---------------

  function buttonOk_click(control, change)
    local inFile = ""
    local outFile = ""
    local text = ""
    local operation = false
    local operationId = false
    local operations = rfx_Split(_t(191), "|")
    local readFile = false
    
    inFile = wcl_strip:getValue("INVAL")
    outFile = wcl_strip:getValue("OUTVAL")
    text = wcl_strip:getValue("QVAL")
    
    operationId = wcl_strip:getValue("TVAL")
    
    if (operationId == operations[1]) then
        operationId = 1 --encode base64
    elseif (operationId == operations[2]) then
        operationId = 2 --decode base64
    end

    if (text ~= "") then
        operation = true
    end
    
    if (inFile ~= "") and (outFile ~= "") then
        readFile = true
        text = inFile
        operation = true
    end
    
    if (operation) then
        if (operationId == 1) then --codifica
            text = exec_base64("e",text, readFile, outFile)
            print("---- start base64 ----")
            print(text)
            print("---- end base64 ----")
        elseif (operationId == 2) then --decodifica
            text = exec_base64("d",text, readFile, outFile)
            print("---- decoded from base64 : start ----")
            print(text)
            print("---- decoded from base64 : end ----")
        end
    end
  end
  
  --selezione file di input
  function buttonSelectIn_click(control, change)
    local destfile
    local fileName = false
    
    destfile = rwfx_GetFileName( _t(206)
                               ,"", 0,rfx_FN(),
                               "All Files (*.*)%c*.*")
    if (destfile) then
        fileName = rfx_GF()
        wcl_strip:setValue("INVAL", fileName)
    end

  end
  
  --selezione file di output
  function buttonSelectOut_click(control, change)
    local destfile
    local fileName = false
    local result
    
    destfile = rwfx_GetFileName( _t(206)
                               ,"", 0,rfx_FN(),
                               "All Files (*.*)%c*.*")
    if (destfile) then
        fileName = rfx_GF()
        if (rfx_fileExist(fileName)) then
            if (rwfx_MsgBox(_t(190),_t(9),MB_YESNO ) == IDYES ) then
                wcl_strip:setValue("OUTVAL", fileName)
            end
        else
            wcl_strip:setValue("OUTVAL", fileName)
        end
        
    end
    
  end

    --codifica/decodifica il testo selezionato o inserito da maschera di dialogo
    local function main()
        local operations = rfx_Split(_t(191), "|")
    
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        wcl_strip:addLabel(nil, _t(189))
        wcl_strip:addText("QVAL",editor:GetSelText(), nil)
        wcl_strip:addNewLine()
        wcl_strip:addLabel(nil, _t(330))
        wcl_strip:addText("INVAL","", nil)
        wcl_strip:addButton("FILEIN",_t(332),buttonSelectIn_click, false)
        wcl_strip:addNewLine()
        wcl_strip:addLabel(nil, _t(331))
        wcl_strip:addText("OUTVAL","", nil)
        wcl_strip:addButton("FILEOUT",_t(332),buttonSelectOut_click, false)
        wcl_strip:addNewLine()
        wcl_strip:addLabel(nil, _t(333))
        wcl_strip:addCombo("TVAL")
        
        wcl_strip:addButton("OK",_t(66),buttonOk_click, true)
        
        wcl_strip:show()
        wcl_strip:setList("TVAL",operations)
        wcl_strip:setValue("TVAL", operations[1])
    end
    
  main()
end
