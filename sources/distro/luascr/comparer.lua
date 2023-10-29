--[[ # -*- coding: utf-8 -*-
Version : 1.1.5
Web     : http://www.redchar.net

Questa procedura consente di utilizzare i software di comparazione
in congiunzione a RSciTE

Copyright (C) 2022-2023 Roberto Rossi 
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
    local function getComparer(resetCfg)
        local result = ""
        local cfgfile = "comppath.cfg"
        
        result = rfx_getApplicationPath(
                                    --"Attenzione: è necessario specificare quale applicazioni usare per il confronto dei file. Verrà ora chiesto di selezionare il file eseguibile(.exe)) dell'applicazione di confronto che si desidera utilizzare.",
                                    _t(486),
                                    --"Selezionare file exe dell'applicazione...",
                                    _t(487),
                                    --"Non è stata selezionata nessuna applicazione, impossibile continuare.",
                                    _t(488),
                                    --"Si desidere scaricare una applicazione dal web? Rispondendo 'Si' sarà possibile installare, gratuitamente, l'applicazione WinMerge.",
                                    _t(489),
                                    "WinMerge - Differencing and merging tool for Windows|KDiff - Diff Tools & File Comparison Tools|Meld - Visual diff and merge tool",
                                    {"https://www.winmerge.org", "https://download.kde.org/stable/kdiff3/", "https://meldmerge.org/"},
                                    cfgfile,
                                    resetCfg
                                )
        
        return result
    end
    
  --dato un percorso, rimuove l'ultimo carattere \ o /, se presente
  local function removeLastSlash(path)
    local result = path
    
    if ((string.sub(path,-1) == "\\") or
        (string.sub(path,-1) == "/")) then
      result = string.sub(path,1, string.len(path)-1)
    end
      
    return result
  end
  
  --ritorna una parte del percorso passato come parametro
  -- parte = 0 ritorna solo nome+estensione file
  -- parte = 1 ritorna solo percorso
  -- parte = 2 solo estensione
  local function getPartPath(linea, parte)
    local i
    local pos
    local ch
    local result
    local nomefileExt
    local path
    local carattere="\\"
    local carattere2="/"
    local trovato = false
    
    if (parte==2) then --solo estensione
      carattere = "."
    end
    
    i = string.len(linea)
    nomefileExt = linea
    path = ""
    while (i > 0) do
      ch = string.sub(linea,i,i)
      if ((ch == carattere) or (ch == carattere2)) then
        nomefileExt = string.sub(linea,i+1)
        path = string.sub(linea,1,i)
        i = 0
      end
      i = i - 1
    end
    
    if (parte==0) then
      result = nomefileExt
    elseif (parte==1) then
      result = removeLastSlash(path)
    elseif (parte==2) then
      result = nomefileExt
    else
      result = nil
    end
    
    return result
  end
  
  --ritorna true se il file specificato esiste
  local function file_exist(nomef)
    local idf
    
    idf = io.open(nomef,"r")
    if (idf) then
      io.close(idf)
      return true
    else
      return false
    end
  end
  
  --consente la selezione di un file o di una cartella
  local function SelezionaFF (selectFolder)
    local nomeFile
    local testo
    local idf
      
    if (selectFolder) then
      -- 85=Seleziona Cartella
      nomeFile = rwfx_BrowseForFolder(_t(85),rfx_FN())    
    else
      -- 84=Seleziona file da inserire
      nomeFile = rwfx_GetFileName(_t(84)
                                  ,"", OFN_FILEMUSTEXIST,rfx_FN())
    end
    
    if nomeFile then
      nomeFile = rfx_GF()      
    end
    return nomeFile
  end
  
  --mostra la lista degli ultimi file/cartelle utilizzati e consente selezione
  -- se selectFolder=true visualizza cartelle, atrimenti file
  local function SelezionaDocumento (msg, selectFolder)
    local listafile = ""
    local i = 1 --primo elemento della lista
    local i2 = 0
    local ultimo
    local scelta
    local fileselezionato = false
    local buffers
    local buffers2 = {}
    local line = ""
    
    buffers = PUBLIC_get_bufferList()
    ultimo = #buffers
    
    while (i <= ultimo) do
      --esclude file corrente
      if (props["FilePath"] ~=  buffers[i]) then
        line = buffers[i]
        if (selectFolder) then
          line = getPartPath(line,1)
        end
        if (listafile == "") then
          listafile = line
          buffers2[i2] = line
        else
          listafile = listafile.."|"..line
          buffers2[i2] = line
        end      
        i2 = i2 + 1
      --else
        --ultimo = ultimo - 1
      end
      i = i + 1
    end
    
    ultimo = #buffers2
    
    -- 133=Altro...
    listafile = listafile.."|".._t(133)
    --scelta = rwfx_ShowList(listafile,msg)
    scelta = rwfx_ShowList_Repos(listafile,msg,"winmerge2",false)
    if scelta then
      --if ((scelta + 1) == ultimo) then
      if ((scelta - 1) == ultimo) then
        fileselezionato = "" -- è stato scelta la voce Altro...
      else
        fileselezionato = buffers2[scelta]
        if (selectFolder) then
          fileselezionato = removeLastSlash(fileselezionato)
        end
      end
    end
    
    if (fileselezionato == "") then
      fileselezionato = SelezionaFF(selectFolder)
    end
    
    return fileselezionato
  end
  
  --ritorna l'operazione selezionata:
  --  
  -- 0 = Annulla
  -- 1...X = funzioni
  local function getOperazione ()
    local scelta = 0
    local listaOperazioni
    local operazioneSelezionata = 0
    
    listaOperazioni = --"Confronta corrente con altro file|".. --1
                      _t(490).."|"..
                      --"Confronta cartella corrente con altra cartella|".. --2
                      _t(491).."|"..
                      --"Avvia applicazione per confronti senza file/cartelle|".. --3
                      _t(493).."|"..
                      --"Seleziona nuovo software per confronti..." --3
                      _t(492)
                      
    scelta = rwfx_ShowList(listaOperazioni,_t(134))    
    if scelta then
      operazioneSelezionata = scelta + 1
    end
    
    return operazioneSelezionata
  end
  
  --questa funzione esegue la comparazione
  -- se compareFolder=true vengono confrontate cartelle, altrimenti file
  local function ComparazioneCorrente (compareFolder, onlyOpen)
    local comparer = ""
    local fileBase = props["FileDir"].."\\"..props["FileNameExt"] --file corrente
    local file1 = "" --secondo file per confronto
    local file2 = "" --terzo file per confronto
    local fileFusion = "" --file risultante dalla fusione
    local folderBase = props["FileDir"] --cartella del file corrente, di base
    local folder1 = "" --seconda cartella per confronto
    local folder2 = "" --terza cartella per confronto
    local folderFusion = "" --cartella risultante da fusione
    local noStop = true
    local par = "" --parametri
    
    -- verifica presenza software per confronto
    comparer = getComparer(false)
    
    if (not(onlyOpen)) then
        if (compareFolder) then
          --gestione cartelle
          par = "\""..folderBase.."\" "
          
          --folder1 = SelezionaDocumento("Confronta cartella corrente con...",true)
          folder1 = SelezionaDocumento(_t(181),true)
          if folder1 then
            par = par.."\""..folder1.."\" "
          else
            noStop = false
          end
          
        else --gestione files
          par = "\""..fileBase.."\" "
          
          -- 134=Confronta file corrente con...
          file1 = SelezionaDocumento(_t(134),false)

          if file1 then
            par = par.."\""..file1.."\" "
          else
            noStop = false
          end
          
        end --end compareFolder
    end --onlyOpen
    
    if (noStop) then
      --print(par)
      rwfx_ShellExecute(comparer,par)
    end
  end --end function
  
  local function main ()
    local operazione = -1
    
    -- verifica presenza software confronto
    if (getComparer(false) == "") then
        return false
    end

    operazione =  getOperazione()
    
    if (operazione == 1) then -- selezione singolo file 
        ComparazioneCorrente(false, false)
    elseif (operazione == 2) then -- selezione singola cartella
        ComparazioneCorrente(true, false)
    elseif (operazione == 3) then -- avvia applicazione senza parametri
        ComparazioneCorrente(false, true)
    elseif (operazione == 4) then -- cambia software per confronto
        getComparer(true)
    end --end if
    
    return true
  end --end main

main()


end

