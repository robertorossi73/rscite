--[[
Version : 2.1.5
Web     : http://www.redchar.net

Questa procedura consente l'eliminazione di tutte le righe
vuote presenti. Vengono considerate vuote anche le linee contenenti
solamente spazi.

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
  local function EliminaLineeVuote ()
    local linea
    local x
    local i, pos
    
    i = 0
    linea = editor:GetLine(i)
    while linea do
      x = string.gsub(linea,"%s*","") --eliminazione spazi
      if ((x == "\n\r") or (x == "\r\n") or 
          (x == "\n") or (x == "\r") or (x == "")) then
        
        pos = editor:PositionFromLine(i)
        editor.CurrentPos = pos
        editor:LineDelete()
        i = i - 1
      end
      i = i + 1
      linea = editor:GetLine(i)
    end
    editor.CurrentPos = 0
    editor.SelectionStart = 0
    editor.SelectionEnd = 0
    
    -- 43=Eliminazione linee vuote, terminata con successo!
    -- 44=Eliminazione Linee!
    rwfx_MsgBox(_t(43),_t(44),MB_OK)
  end
  
  EliminaLineeVuote()
end
