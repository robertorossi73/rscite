--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura effettua il caricamento di un file LUA

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
  
  local function LoadLuaFile ()
    local nomeFile
    local testo
    local idf
      
    -- 160=Seleziona file LUA da caricare
    nomeFile = rwfx_GetFileName(_t(160)
                                ,"", OFN_FILEMUSTEXIST,rfx_FN())
    
    if nomeFile then
      nomeFile = rfx_GF()
      dofile(nomeFile)
    end
  end
  LoadLuaFile()
end

