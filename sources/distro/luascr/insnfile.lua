--[[
Version : 2.0.6
Web     : http://www.redchar.net

Questa procedura inserisce il nome del file selezionato, tramite la
maschera standard, nella posizione corrente del cursore

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
  
  local function InsertNomeFile ()
    local nomeFile
    
    -- 92=Seleziona file da inserire
    nomeFile = rwfx_GetFileName(_t(92),"", OFN_FILEMUSTEXIST,rfx_FN())
    
    if nomeFile then
      nomeFile = rfx_GF()
      editor:ReplaceSel(nomeFile)
    end
  end
  InsertNomeFile()
end

