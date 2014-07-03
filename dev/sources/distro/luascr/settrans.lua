--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura consente di regolare la trasparenza della finestra corrente
di SciTE

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
  
  local function mainProc ()
    local cartella
    local percent
    
    percent = rwfx_InputBox("0", _t(142), --Trasparenza SciTE
                                 _t(143), --Indica trasparenza finestra
                                 rfx_FN())
    if percent then
      percent = rfx_GF()
      percent = tonumber(percent)
      if percent then        
        percent = math.modf(percent)
        percent = 100 - percent
        if ((percent > 4) and (percent < 101)) then
          rwfx_SetTransparency(percent)
        end
        --print(percent)
      end
    end

  end
  
  mainProc()
end
