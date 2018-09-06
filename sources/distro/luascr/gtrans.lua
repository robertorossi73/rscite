--[[Traduci testo selezionato in...
Version : 1.0.2
Author  : Roberto Rossi
Web     : http://www.redchar.net

Traduzione testo selezionato utilizzando Google Translator

Copyright (C) 2011-2015 Roberto Rossi 
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

V.1.0.2
- inserita conversione carattere /

V.1.0.1
- corretto link per accesso a sito. Attualmente la lingua di destinazione è
sempre italiano

V.1.0.0
- rimossa selezione lingua destinazione, ora è sufficiente lanciare la funzione
  dopo aver selezionato un testo
- eliminati ritorni a capo prima di traduzione

V.0.0.1
- release iniziale con richiesta lingua destinazione

]]

do
  require("luascr/rluawfx")
  
  --converti spazi e ritorni a capo
  local function convertCR(text)
    local result
    
    --result = string.gsub(text, "\n", "%%0A")
    result = string.gsub(text, "\n", " ")
    --result = string.gsub(result, "\r", "%%0A")
    result = string.gsub(result, "\r", " ")
    result = string.gsub(result, " ", "%%20")
    result = string.gsub(result, "/", "%%2F")
    
    return result
  end
  
  local function main()
    local text = editor:GetSelText()
    local service = "http://translate.google.com/#auto/it/"
    local command = ""
    local lang 
        
    if (text ~= "") then    
      --service = service.."#auto|"
      command = service..convertCR(text)
      rwfx_ShellExecute(command,"")
    else
      --159=Nessun testo selezionato. Impossibile continuare!
      print("-> Google Translator\n".._t(159))
    end
  end
  
  main() --esecuzione procedura principale
  
end
