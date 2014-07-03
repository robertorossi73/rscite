--[[
Version : 2.1.1
Web     : http://www.redchar.net

Questa procedura visualizza informazioni sulla distribuzione di SciTE

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
  
  local function visInfoDistribuzione ()
    local nDistribuzione -- nome distribuzione
    local vDistribuzione -- versione distribuzione
    local autore -- autore distribuzione
    local web -- sito web distribuzione
    local vScite -- versione scite
    local vWinMerge -- versione winmerge
    local vHExplorer -- versione hexplorer
    local vTidy -- versione tidy
    local vyuicompressor -- versione yuicompressor
    local idf
    local linea
    local pos
    local nome --nome impostazione
    local valore --valore impostazione
    local linguaCorrente --sigla lingua corrente RSciTE
    
    idf = io.open(props["SciteDefaultHome"].."/distro.ini")
    if idf then
      for linea in idf:lines() do
        pos = string.find(linea, "=")
        if pos then
          nome = string.lower(string.sub(linea, 1, (pos - 1)))
          valore = string.sub(linea, (pos + 1))
          if (nome == "ndistribuzione") then
            nDistribuzione = valore
          elseif (nome == "vdistribuzione") then
            vDistribuzione = valore
          elseif (nome == "autore") then
            autore = valore
          elseif (nome == "web") then
            web = valore
          elseif (nome == "scite") then
            vScite = valore
          elseif (nome == "winmerge") then
            vWinMerge = valore
          elseif (nome == "hexplorer") then
            vHExplorer = valore
          elseif (nome == "tidy") then
            vTidy = valore
          elseif (nome == "yuicompressor") then
            vyuicompressor = valore
          end          
        end
      end
      
      linguaCorrente = _t(0)
      -- 122=Dati Distribuzione
      -- 123=Nome
      -- 124=Versione
      -- 125=Autore
      -- 126=Sito Web
      -- 127=Dati Software Inclusi
      -- 128=Versione SciTE
      -- 129=Versione WinMerge
      -- 130=Versione HExplorer
      -- 131=Versione Tidy
      -- 132=Informazioni su
      -- 136=Lingua
      msg = "---- ".._t(122).." ---\n"
      msg = msg.._t(123).." : "..nDistribuzione.."\n"
      msg = msg.._t(136).." : "..linguaCorrente.."\n"
      msg = msg.._t(124).." : "..vScite.."-"..vDistribuzione
      msg = msg.."\n".._t(125).." : "..autore
      msg = msg.."\n".._t(126).." : "..web.."\n\n"
      msg = msg.."---- ".._t(127).." ---\n"
      msg = msg.._t(128).." : "..vScite
      msg = msg.."\n".._t(129).." : "..vWinMerge
      msg = msg.."\n".._t(130).." : "..vHExplorer
      msg = msg.."\n".._t(131).." : "..vTidy
      msg = msg.."\nYuiCompressor : "..vyuicompressor
      rwfx_MsgBox(msg,_t(132).." '"..nDistribuzione.."'")
    end --endif
    
  end --endfunction
  visInfoDistribuzione()
end
