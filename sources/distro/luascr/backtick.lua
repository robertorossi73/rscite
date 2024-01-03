--[[# -*- coding: utf-8 -*-
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura gestisce l'inserimento degli apici inclinati/backtick

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

  function main_backtick (onlyInsert)
    local testo
    local result = ""
    local i=1
    local len
    local lettera
    
    if (onlyInsert) then
        editor:ReplaceSel("`")
    else
        testo = editor:GetSelText()
        len = string.len(testo)
        
        while (i <= len) do
          lettera = string.sub(testo,i,i)
          if (lettera == "'") then
            lettera = "`"
          end      
          result = result..lettera
          
          i = i + 1
        end
        
        if not(result == "") then
          editor:ReplaceSel(result)
        end
        return result
    end --endif
    
  end 
end


