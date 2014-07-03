--[[
Version : 1.0.0
Web     : http://rsoftware.altervista.org

Questa procedura Consente la gestione della lista dei file preferiti.

Copyright (C) 2004,2005,2006,2007 Roberto Rossi 
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
  
  --ritorna il nome del file dell'elenco preferiti.
  --TODO :Questo file viene cercato nella cartella del programma, se non viene
  --trovato viene inserito nella cartella dell'utente corrente
  local function get_name_preferiti()
    local nomef
    
    nomef = rfx_UserFolderRSciTE().."\\preferiti.txt"
    return nomef
  end
  
  --ritorna una tabella con l'elenco dei file preferiti
  local function PUBLIC_get_bufferList()
    local nomef
    local idf
    local linea = ""
    local buffers = {}
    local folderSciTE = ""
    local i = 0
    
    nomef = get_name_preferiti()
    print(nomef)
    idf = io.open(nomef,"r")
    if idf then
      if (idf) then
        linea = idf:read("*l")--legge linea
        buffers[i]=linea
        i = i + 1
      end
      io.close(idf)
    end
    
    return buffers
  end

  local function main()
    --TODO : tutto da fare
    local nomef = ""
    local scelta
    local buffers = PUBLIC_get_bufferList() --lista file
    local lista = ""
    local i
    local dati = {}
    local desc = ""
    
    if (buffers) then
      for i,nomef in ipairs(buffers) do
        dati = rfx_split(nomef,"=")
        nomef = dati[0]
        if (table.getn(dati) == 2) then
          desc = dati[1]
        end
        
        if (lista ~= "") then
          lista = lista.."|"..nomef
        else
          lista = nomef
        end
      end
      
      scelta = rwfx_ShowList(lista,"File Preferiti...")
      if scelta then
        --scite.Open(buffers[scelta + 1])
      end
    end
    
  end
  
  main()

end
  