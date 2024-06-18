--[[ # -*- coding: utf-8 -*-
Version : 2.1.0
Web     : http://www.redchar.net

Questa procedura apre l'editor esadecimale con il file corrente

Copyright (C) 2011-2024 Roberto Rossi 
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

    --controlla la presenza del software, chiede dove si trova, suggerisce
    --  di scaricarti e riprovare
    --  ritorna il path completo del file eseguibile 
    local function getHexEditor(resetCfg)
        local result = ""
        local cfgfile = "hexpath.cfg"
        
        result = rfx_getApplicationPath(
                                    --"Attenzione: è necessario specificare quale applicazioni usare come editor esadecimale. Verrà ora chiesto di selezionare il file eseguibile(.exe)) dell'applicazione che si desidera utilizzare.",
                                    _t(494),
                                    --"Selezionare file exe dell'applicazione...",
                                    _t(495),
                                    --"Non è stata selezionata nessuna applicazione, impossibile continuare.",
                                    _t(496),
                                    --"Si desidere scaricare una applicazione dal web? Rispondendo 'Si' sarà possibile installare, gratuitamente, una delle applicazioni consigliate.",
                                    _t(497),
                                    "Frhed - binary file editor for Windows|ImHex - Hex Editor, tool to display, decode and analyze binary data|wxMEdit - A cross-platform Text/Hex Editor",
                                    { "https://github.com/WinMerge/frhed", 
                                      "https://imhex.werwolv.net/",
                                      "https://wxmedit.github.io/"},
                                    cfgfile,
                                    resetCfg
                                )
        
        return result
    end
    
  local function getOperazione ()
    local scelta = 0
    local listaOperazioni
    local operazioneSelezionata = 0
    
    listaOperazioni = --"Apri il file corrente nell'editor esadecimale".."|".. --1
                        _t(498).."|".. --1
                      --"Avvia l'editor esadecimale senza alcun file".."|".. --2
                        _t(499).."|".. --2
                      --"Seleziona nuovo editor esadecimale..." --3
                        _t(500) --3
                      
    scelta = rwfx_ShowList(listaOperazioni,_t(95))    
    if scelta then
      operazioneSelezionata = scelta + 1
    end
    
    return operazioneSelezionata
  end
  
  local function startHexEditor(openFile)
    local exe = getHexEditor(false)
    local last = string.sub(props["FilePath"], -1)
  
    if ((last == "\\") or (last == "/") or not(openFile)) then
      rwfx_ShellExecute(exe,"")
    else
      rwfx_ShellExecute(exe,"\""..props["FilePath"].."\"")
    end
  
  end
  
  local function main()
    local operazione
    
    -- verifica presenza software confronto
    if (getHexEditor(false) == "") then
        return false
    end
    
    operazione =  getOperazione()
    
    if (operazione == 1) then -- apri file
        startHexEditor(true)
    elseif (operazione == 2) then -- avvia editor
        startHexEditor(false)
    elseif (operazione == 3) then -- cambia software
        getHexEditor(true)
    end --end if    
  end

  main()
end

