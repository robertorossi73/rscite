--[[Apri file da cartella...
Version : 1.0.3
Web     : http://www.redchar.net

Questa procedura mostra la finestra di apertura file partendo da una cartella
già utilizzata, e preventivamente selezionata

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

    local function getPath(str)
        return str:match("(.*[/\\])")
    end

  local function main()
    local nomef = ""
    local scelta
    local buffers = PUBLIC_get_bufferList() --lista file
    local lista
    local i
    local file
    local corrente
    local cf = props["FileDir"]
    local fileName
    
    if (buffers and (#buffers > 0)) then
      corrente = props["FilePath"]
      for i,file in ipairs(buffers) do
        file = getPath(file)
        if (lista) then
          lista = lista.."|"..file
        else
          lista = file
        end
      end
      
      --scelta = rwfx_ShowList(lista,"Ultimi file Aperti...")
      --scelta = rwfx_ShowList(lista,_t(141))
      scelta = rwfx_ShowList_Repos(lista, --lista files
                                    --titolo con numero file elencati
                                    "("..tostring(#buffers + 1)..") ".._t(141),
                                    "openLast")
      if scelta then
        cf = getPath(buffers[scelta + 1])        
        fileName = rwfx_GetFileName(_t(463),cf, OFN_FILEMUSTEXIST,rfx_FN())
        if (fileName) then
          scite.Open(rfx_GF())
        end
      end
    end
    
  end
  
   
  main()

end
  
