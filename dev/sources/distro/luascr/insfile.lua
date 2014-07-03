--[[
Version : 2.1.5
Web     : http://www.redchar.net

Questa procedura inserisce il contenuto di un file nella posizione
corrente del cursore

Copyright (C) 2004-2009 Roberto Rossi 
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
  
  local function InsertFile ()
    local nomeFile
    local testo
    local idf
      
    -- 84=Seleziona file da inserire
    nomeFile = rwfx_GetFileName(_t(84)
                                ,"", OFN_FILEMUSTEXIST,rfx_FN())
    
    if nomeFile then
      nomeFile = rfx_GF()
      idf = io.open(nomeFile, "r")
      testo = idf:read("*a")
      io.close(idf)
      if (testo ~= "") then
        editor:ReplaceSel(testo)
      end
    end
  end
  InsertFile()
end

