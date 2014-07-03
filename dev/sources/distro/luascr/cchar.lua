--[[
Version : 2.0.5
Web     : http://www.redchar.net

Questa procedura mostra le caratteristiche del carrattere corrente

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
  
  local function GetStatCh ()
    local chInteger;
    local ch;
    local chHex;
    local pos;
    local msg;
    
    pos = editor.CurrentPos;
    chInteger = editor.CharAt[pos];
    ch = string.char(chInteger);
    chHex = string.format("%X",chInteger)
    
    -- 16- Carattere
    -- 17- Codice Ascii
    -- 18- Codice Esadecimale
    -- 19- Offset (Decimale)
    -- 20- Offset (Esadecimale)
    -- 21- Dati su Carattere Corrente
    msg = _t(16).." : \t\t\t"..ch.."\n";
    msg = msg.._t(17).." : \t\t\t"..chInteger.."\n";
    msg = msg.._t(18).." : \t\tH"..chHex.."\n\n";    
    msg = msg.._t(19).." : \t\t\t"..pos.."\n";
    msg = msg.._t(20).." : \t\tH"..string.format("%X",pos);
    rwfx_MsgBox(msg,_t(21));
  end
  GetStatCh();
end
