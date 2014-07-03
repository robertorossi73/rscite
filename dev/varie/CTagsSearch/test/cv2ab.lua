--[[
Version : 1.0.3
Web     : http://www.redchar.net

Questa procedura converte il testo in modo da poter essere utilizzato
all'interno delle proceduredi gestione Template/Abbreviazioni

Queste macro consentono la conversione sia del testo selezionato, sia del
testo contenuto nella clipboard.

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
  
  --ritorna il testo contenuto negli appunti
  local function getTextFromClipBoard()
    local result
    local inizio
    local fine
    
    inizio = editor.SelectionStart
    editor:Paste()
    fine = editor.SelectionStart
    editor.SelectionStart = inizio
    editor.SelectionEnd = fine
    result = editor:GetSelText()
    editor:ReplaceSel("")
    return result
  end
  
  --elimina i ritorni a capo, sostituendoli con gli appositi segnaposto \n
  local function replace_crlf(testo)
    if not(testo == "") then
      testo = string.gsub(testo,"\r\n","\\n")
      testo = string.gsub(testo,"\r","\\n")
      testo = string.gsub(testo,"\n","\\n")
    end
    return testo
  end

  local function main()
    local testo
    local scelta
    
    -- 22- Converti e Inserisci contenuto Appunti/Clipboard|Converti selezione
    -- 135- Abbreviazioni/Snippet/Template
    -- 23- Impossibile procedere, gli Appunti non contengono del testo!
    -- 9- Attenzione!
    -- 24- Impossibile procedere, non hai selezionato il testo da convertire!
    scelta = rwfx_ShowList(_t(22),_t(135))
    if scelta then
      if (scelta==0) then --inserimento Appunti
        testo = getTextFromClipBoard()
        testo = replace_crlf(testo)
        if not(testo=="") then
          editor:ReplaceSel(testo);--sostituisce la selezione corrente
        else
        rwfx_MsgBox(_t(23), _t(9),MB_OK)
        end
      elseif (scelta==1) then --conversione selezione
        testo = editor:GetSelText()
        testo = replace_crlf(testo)
        if not(testo=="") then
          editor:ReplaceSel(testo);--sostituisce la selezione corrente
        else
        rwfx_MsgBox(_t(24),_t(9),MB_OK)
        end
      end--endif
    end--endscelta
  end--end main

  main()
end
