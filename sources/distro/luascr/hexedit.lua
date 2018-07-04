--[[
Version : 1.1.1
Web     : http://www.redchar.net

Questa procedura apre l'editor esadecimale con il file corrente

Copyright (C) 2011-2015 Roberto Rossi 
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
    local exe = props["SciteDefaultHome"].."/tools/WinMerge/frhed/frhed.exe" 
    local last = string.sub(props["FilePath"], -1)
    if ((last == "\\") or (last == "/")) then
      rwfx_ShellExecute(exe,"");
    else
      rwfx_ShellExecute(exe,"\""..props["FilePath"].."\"");
    end
  end

  main()
end

