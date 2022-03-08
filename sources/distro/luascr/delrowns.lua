--[[
Version : 2.0.9
Web     : http://www.redchar.net

Questa procedura consente l'eliminazione di tutte le righe
che NON contengono il testo specificato. E' possibile utilizzare tutte le espressioni
previste per la funzione find di LUA.

Copyright (C) 2004-2022 Roberto Rossi 
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
  local function EliminaLinee ()
    local linea
    local x
    local i, pos
    local lineeEliminate = 0
    local strDaCercare
    
    -- 45=Eliminazione Linee
    -- 46=Elimina le linee che NON contengono :
    -- 47=Eliminazione linee, terminata con successo!\n\n
    -- 48=Sono state eliminate
    -- 49=linee.
    -- 50=Eliminazione Linee
    strDaCercare = rwfx_InputBox("", _t(45),_t(46), rfx_FN());
    
    if (strDaCercare) then
      strDaCercare=rfx_GF()
      i = 0
      linea = editor:GetLine(i)
      while i < editor.LineCount do
        x = string.find(linea, strDaCercare, 1, true)
        if not(x) then
          pos = editor:PositionFromLine(i)
          editor.CurrentPos = pos
          editor:LineDelete()
          lineeEliminate = lineeEliminate + 1
          if i < (editor.LineCount - 1) then
            i = i - 1
          end
        end
        i = i + 1
        linea = editor:GetLine(i)
      end
      editor.CurrentPos = 0
      editor.SelectionStart = 0
      editor.SelectionEnd = 0
      rwfx_MsgBox(_t(47).._t(48).." "..lineeEliminate.." ".._t(49),_t(50),MB_OK)
    end--endif
  end --endfunction
  
  EliminaLinee()
end
