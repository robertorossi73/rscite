--[[
Version : 2.1.4
Web     : http://www.redchar.net

Questa procedura elimina tutte le lettere accentata da un file
HTML sostituendole con i corrispondenti simboli

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
  
  AccArray = {"è","é","à","ì","ò","ù"};
  HtmlArray = {"&egrave;","&eacute;","&agrave;","&igrave;","&ograve;","&ugrave;"};
  
  ns = 0;
  
  function SubstAcc2Htm (id, val)
    local pos = true;
    while (pos) do
      pos = editor:findtext(val)
      if (pos) then
        editor:remove(pos, pos + 1);
        editor:insert(pos, HtmlArray[id]);
        ns = ns + 1;
      end
    end
  end
  
  local i
  local v
  
  for i,v in pairs(AccArray) do
    SubstAcc2Htm(i,v)
  end
  
  --frase : 1- Procedura Conclusa con successo.\n\n Sostituiti
  --        2- elementi
  --        3- Conversione Caratteri!
  rwfx_MsgBox(_t(1).." "..ns.." ".._t(2)..".",_t(3),MB_OK)
end
