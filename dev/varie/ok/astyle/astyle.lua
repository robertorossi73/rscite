--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura Utilizza il software AStyle per formattare il codice
sorgente

Copyright (C) 2004-2010 Roberto Rossi 
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

  --elimina i ritorni a capo, sostituendoli con gli appositi segnaposto \n
  local function replace_crlf(testo)
    if not(testo == "") then
      testo = string.gsub(testo,"\r\n"," ")
      testo = string.gsub(testo,"\r"," ")
      testo = string.gsub(testo,"\n"," ")
    end
    return testo
  end
  
  local function main ()
    local testo = ""
    local nomef = ""
    local comando = ""
    local batfile = ""
    local idf
    
    --TODO : verificare presenza dell'eseguibile di astyle.exe
    batfile = os.getenv("TMP")
    batfile = batfile.."\\sciteStr.bat"        
    
    testo = editor:GetSelText()
    if (testo ~= "") then
      testo = replace_crlf(testo)
      idf = io.open(batfile, "w")
      if (idf) then
        nomef = rfx_FN()
        comando = "\""..props["SciteDefaultHome"].."\\AStyle.exe\" "
        comando = comando.."\""..nomef.."\""
        idf:write(comando)
        io.close(idf)
        
        rfx_WF(testo.."\n\n")
        os.execute("\""..batfile.."\"")
        testo = rfx_GF()
        editor:ReplaceSel(testo)
        --adatta il file corrente alla modalità corrente di fine linea
        editor:ConvertEOLs(editor.EOLMode)
      end --endif batfile
    else
      rwfx_MsgBox("E' necessario Selezionare del testo prima di eseguire questa procedura.",
              "Impossibile procedere!",MB_OK)
    end
  end -- endfx
  
  main()
end
