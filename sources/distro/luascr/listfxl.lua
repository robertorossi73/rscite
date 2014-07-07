--[[
Version : 2.0.2
Web     : http://www.redchar.net

Questa procedura visualizza l'elenco delle function definite
nel file corrente

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

  --estrae il numero di riga da una linea con [nriga:altro...]
  local function EstraiNRiga ( linea )
    local pos
    local res = -1;
    
    pos = string.find(linea, ":")
    if pos then
      return (string.sub(linea, 1, pos - 1))
    end
  end
  
  local function ListFunctions ( ricerca )
    local ns = 0
    local pos = 0
    local linea = ""
    local linean = 0
    local listaFxStr = ""
    local listaFx = {}
    
    --output:remove(0,-1) --cancella output
    while (pos) do
      pos = editor:findtext(ricerca,SCFIND_WHOLEWORD,pos)
      if (pos) then
        pos = pos + 1
        linean = editor:LineFromPosition(pos)
        linea = editor:GetLine(linean)
        linea=string.sub(linea,0,string.len(linea)-1)
        linean= linean + 1
        listaFx[ns + 1] = linean..":"..linea
        if (listaFxStr == "") then
          listaFxStr = listaFx[ns + 1]
        else
          listaFxStr = listaFxStr.."|"..listaFx[ns + 1]
        end
        ns = ns + 1
      end
    end
    if not(listaFxStr == "") then
      scelta = rwfx_ShowList(listaFxStr,_t(105))
      if scelta then
        pos = EstraiNRiga(listaFx[scelta+1])
        if pos then
          --impostazione posizione cursore
          editor:GotoLine(tonumber(pos) - 1)
        end --if pos
      end
    end
  end
  
  ListFunctions("(defun")
end
