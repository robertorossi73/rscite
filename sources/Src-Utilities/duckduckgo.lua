--[[
Version : 1.0.0
Web     : http://www.redchar.net

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


  Questo script permette di inserire i nomi dei servizi partendo
  dalle linee preformattate inserite nel file searchw.ini
  
  ---- Come Funziona ----
  Nel file .ini saranno presenti, prima le linee preformattate con
  i tag dei servizi, e successivamente le destrizioni commentate :

  ...
  Online Services Sports ()=!cbssports
  Google ()=!google
  Google ()=!gau
  ...
  ;~ CBS Sports (!cbssports)
  ;~ CBSNews (!cbsnews)
  ;~ CEAN (!cean)
  ;~ CheatCC (!gamecheats)
  ...
  
  Posizionando il puntatore su una linea modello (le prime tre)
  e quindi avviando lo script, il programma cercherà il tag nelle
  descrizioni e lo andrà ad inserire nella linea modello tra le
  parentesi tonde, ad esempio :
  
  ...
  Online Services Sports (CBS Sports)=!cbssports
  ...
  
  Attenzione : la sintassi delle linee è fissa
  
  Elenco completo BANG di DuckDuckGO:
  https://duckduckgo.com/bang_lite.html
]]


do

  require("luascr/rluawfx")
  
  local function main()
    local linea
    local linea2
    local linean
    local posSign
    local pos
    local sign = "="
    local tag = ""
    local part1 = ""
    local part2 = ""
    local lineanSearch
    local search
    
    linean = editor:LineFromPosition(editor.CurrentPos)
    linea = editor:GetLine(linean)
    
    posSign = string.find(linea, sign)
    
    if (posSign) then
      part1 = string.sub(linea,1,posSign-1)
      part2 = string.sub(linea,posSign+1)
      part2 = rfx_RemoveReturnLine(part2)
      
      search = "("..part2..")"
      pos = editor:findtext(search)
      lineanSearch = editor:LineFromPosition(pos)
      linea2 = editor:GetLine(lineanSearch)
      
      linea2 = string.sub(linea2,3)
      pos = string.find(linea2, search)
      linea2 = string.sub(linea2,1, pos-2)
      linea2 = rfx_Trim(linea2) --nome servizio
      --print(pos)
      --print(part1)
      --print(part2)
      --print(linea2)
      pos = string.find(linea,"()=",0,true)
      --print(pos)
      if (pos) then
        linea2 = string.sub(linea,1, pos-1).."("..linea2..")"..
                 string.sub(linea,pos+2)
        editor:SearchNext(1,linea)
        editor:ReplaceSel(linea2)
      else
        print("Non è stato trovato nulla, cambiare linea!")
      end
      --print(linea2)
    end
  end

main()

end
