--[[Autostart File
Autore : Roberto Rossi
Web    : http://www.redchar.net
Versione : 1.9.0

Copyright (C) 2004-2013 Roberto Rossi 
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

require("luascr/rluawfx") --funzioni di utilità
require("luascr/wcl_strip") --gestore interfaccia grafica SciTE

--ritorna una tabella con l'elenco degli ultimi 50 file aperti
function PUBLIC_get_bufferList(nomef)
  local idf
  local linea = ""
  local buffers = {}
  local folderSciTE = ""
  
  if (not(nomef)) then
    folderSciTE = rfx_UserTmpFolderRSciTE().."\\tmp"
    nomef = folderSciTE.."\\lastFiles.txt"
  end
  
  idf = io.open(nomef,"r")
  if (idf) then
    linea = idf:read("*l")--legge linea
    io.close(idf)
  end
  
  if (linea and (linea ~= "")) then  
    buffers = rfx_Split(linea,"*")
  end
  
  return buffers
end

--aggiunge il file f all'elenco degli ultimi 50 file aperti
function PUBLIC_add_bufferList(f)
  local nomef
  local idf
  local i
  local idx
  local file
  local linea = "" --linea con nomi file
  local buffers = {} --lista file
  local folderSciTE
  local max_files = 100 --numero massimo di file memorizzati
  
  --cartella temporanea scite
  folderSciTE = rfx_UserTmpFolderRSciTE().."\\tmp"
  nomef = folderSciTE.."\\lastFiles.txt"
  
  buffers = PUBLIC_get_bufferList(nomef)

  if (#buffers > 0) then  
    for i,file in ipairs(buffers) do
       if file == f then  idx = i; break end
    end
    
    if idx then
      table.remove(buffers,idx)
    end  
    table.insert(buffers,1,f)

    linea = ""
    for i,file in ipairs(buffers) do
      if (i < max_files) then --limita file inseribili
        if (linea == "") then
          linea = file
        else
          linea = linea.."*"..file
        end
      end
    end
  else
    linea = f
  end

  idf = io.open(nomef,"w")
  if (idf) then
    linea = idf:write(linea)--scrive dati
    io.close(idf)
  end
end

---------------------------- Gestione Eventi SciTE ----------------------------

function OnSwitchFile(f)
  wcl_strip:close() --chiusura eventuale interfaccia Stripe
end

function OnOpen(f)
  wcl_strip:close() --chiusura eventuale interfaccia Stripe
  PUBLIC_add_bufferList(f)
end

function OnChar(c)  
  if (props['rscite.braces.autoclose'] == '1') then
    local modal
    local pos
    local nextChar
    local nextCharEx
    local okSubst = false
    
    modal = editor.Lexer

    -- 4=html
    -- 21=lisp
    -- 15=lua
    if ((modal==4) or (modal==21) or (modal==15)) then
      pos = editor.CurrentPos
      nextChar = editor:textrange(pos,pos+1)
      nextCharEx = string.byte(nextChar)
      if ((nextCharEx == 13) or --ritorno a capo
          (nextCharEx == 10) or --ritorno a capo
          (nextCharEx == 32) or --spazio
          (nextCharEx == 9)  or --tabulazione
          (nextCharEx == 41) or --parentesi )
          (nextCharEx == 93)   --parentesi ]        
         ) then 
        okSubst = true
      end
    end
    
    if (okSubst) then
      if (c=="(") then
        editor:ReplaceSel(")")
        --if (modal==21) then --solo con Lisp mette il cursore tra le parentesi
          editor:CharLeft()
        --end
      elseif (c=="[") then
        editor:ReplaceSel("]")
        editor:CharLeft() --posiziona il cursore tra le parentesi
      end
    end --end okSubst
  end --if 
end --end OnChar


------------------------ procedure eseguite all'avvio -------------------------

--scrive il nome del progetto precedentemente salvato
function rfx_savePathPrj(path)
  local nomef = ""
  local idf
  
  nomef = os.getenv("TMP")
  nomef = nomef.."\\scitePrj.tmp"
  
  idf = io.open(nomef, "w")
  if (idf) then
    result = idf:write(path)
    io.close(idf)
    return true
  else
    return false
  end
end

--reset ultimo progetto aperto
rfx_savePathPrj("")

