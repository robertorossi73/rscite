--[[
Version : 2.0.5
Web     : http://www.redchar.net

Questa procedura elimina il file corrente

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
  
  local function DelCurrentFile ()
    local flagOk = nil
    local nomeFile = props["FilePath"]
    local res
   
    -- 39=Attenzione : Il file corrente sta per essere eliminato dal disco!\nSi desidera procedere?
    -- 40=Eliminazione file
    -- 41=Non è stato possibile eliminare '
    -- 42=Eliminazione file
    if (rwfx_MsgBox(_t(39),_t(40),MB_YESNO + MB_DEFBUTTON2) == IDYES) then
      flagOk = true
    end
    
    if ((flagOk) and (nomeFile ~= '')) then
      res = os.remove(nomeFile)
      if not(res) then
        require(props["SciteDefaultHome"].."/luascr/rluawfx.lua")
        rwfx_MsgBox(_t(41)..nomeFile.."' !",_t(42), MB_OK)
      else
        rwfx_ExecuteCmd("close:")
      end
    end --if flagOk 
  end
  
  DelCurrentFile()
end
