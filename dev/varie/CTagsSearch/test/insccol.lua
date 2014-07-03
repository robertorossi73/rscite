--[[
Version : 2.1.7
Web     : http://www.redchar.net

Questa procedura inserisce il codice colore scelto tramite
maschera

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
  
  local function InsCodColor ()
    local code
    local r,g,b
    local scelta
    code,r,g,b = rwfx_GetColorDlg()
    
    -- 79=Inserisci valore RGB Esadecimale
    -- 80=Inserisci valore RGB Decimale
    -- 81=Inserimento Colore
    if code then
      r = string.format("%X",r)
      g = string.format("%X",g)
      b = string.format("%X",b)
      if (string.len(r) == 1) then r = "0"..r end
      if (string.len(g) == 1) then g = "0"..g end
      if (string.len(b) == 1) then b = "0"..b end
      scelta = rwfx_ShowList(_t(79).."|".._t(80),_t(81))      
      if (scelta == 0) then
        editor:ReplaceSel(r..g..b)
      elseif (scelta == 1) then
        editor:ReplaceSel(code)
      end
    end
  end
  InsCodColor()
end
