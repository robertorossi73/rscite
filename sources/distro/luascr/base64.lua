--[[ # -*- coding: utf-8 -*-
Version : 0.0.3
Web     : http://www.redchar.net

Questo script consente la codifica e la decodifica del testo in formato base64

Copyright (C) 2011-2013 Roberto Rossi 
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
  local function exec_base64(operation, text)
    local func = 'enc'
    local arg = {operation, text};
    local result = "!-error-!";
    
    if (operation == "e") then
      result = enc(text)
    elseif (operation == "d") then
      result = dec(text)
    end
    return result
  end --end function
------------------ End base64 encoding/decoding (by Alex Kloss) ---------------
  

  
  --codifica/decodifica il testo selezionato o inserito da maschera di dialogo
  local function main()
    local testo
    local result
    local listaopt
    local selezione
    
    testo = editor:GetSelText()
    if (testo == "") then
      rwfx_MsgBox(_t(190), _t(189),MB_OK)
    else
      listaopt = _t(191)      
      selezione = rwfx_ShowList(listaopt,_t(189))
      
      if (selezione) then
        if (selezione == 0) then --codifica
          testo = exec_base64("e",testo)
          editor:ReplaceSel(testo)
        elseif (selezione == 1) then --codifica
          testo = exec_base64("e",testo)
          editor:CopyText(testo);
        elseif (selezione == 2) then --decodifica
          testo = exec_base64("d",testo)
          editor:ReplaceSel(testo)
        elseif (selezione == 3) then --decodifica
          testo = exec_base64("d",testo)
          editor:CopyText(testo);
        end
      end
    end
  end -- end function
  
  main()
end
