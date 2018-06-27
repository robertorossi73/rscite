--[[
Version : 1.1.3
Web     : http://www.redchar.net

Questa procedura Consente l'apertura di uno degli ultimi file modificati.

Copyright (C) 2004-2015 Roberto Rossi 
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
    local nomef = ""
    local scelta
    local buffers = PUBLIC_get_bufferList() --lista file
    local lista
    local i
    local file
    local corrente
    
    if (buffers and (#buffers > 0)) then
      corrente = props["FilePath"]
      for i,file in ipairs(buffers) do
        if (lista) then
          lista = lista.."|"..file
        else
          lista = file
        end
      end
      
      --scelta = rwfx_ShowList(lista,"Ultimi file Aperti...")
      --scelta = rwfx_ShowList(lista,_t(141))
      scelta = rwfx_ShowList_Repos(lista,_t(141),"openLast")
      if scelta then
        if (rfx_fileExist(buffers[scelta + 1])) then
          scite.Open(buffers[scelta + 1])        
        else
          --il file xxxx non esiste, attenzione
          rwfx_MsgBox(_t(68)..buffers[scelta + 1].._t(69),_t(9),MB_ICONSTOP + MB_OK)
        end
      end
    end
    
  end
  
  main()

end
  
