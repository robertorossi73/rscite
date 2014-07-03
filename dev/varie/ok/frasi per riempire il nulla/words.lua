 --[[
Version : 0.0.1
Web     : http://www.redchar.net

Questo modulo consente di inserire del testo casuale, apparentemente
sensato ma, in realtà, senza alcun senso. (in lingua italiana)

Copyright (C) 2010 Roberto Rossi 
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

  local function main()
    local scelta
    local lista
    local i = 1
    local fnum
    local frase
    local cartellaScript = props["SciteDefaultHome"].."/luascr/"
    local nomefini = cartellaScript.."words.ini"
    local result = ""
    
    --lista = getDataList(nomefini,elementi)
    
    --scelta = rwfx_ShowList_presel(lista,_t(140),"searchw",false)
    scelta = true
    if scelta then
      math.randomseed(os.time())
      fnum = math.random(1, 8)
      while(i < 8) do
        fnum = math.random(1, 8)
        frase = rfx_GetIniVal(nomefini, "Column"..tostring(i), tostring(fnum))
        if (result == "") then
          result = frase
        else
          result = result.." "..frase
        end
        i = i + 1
      end
      editor:ReplaceSel(result)
      --print(result)
    end
  end
  
  main()
end
