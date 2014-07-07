--[[
Version : 1.0.2
Web     : http://www.redchar.net

Questa procedura consente di utilizzare KDiff in congiunzione a RSciTE

------------ Versioni ------------

V.1.0.0
- Corretta selezione file non in lista quando il file corrente non è presente nell'elenco

V.1.0.0
- Release iniziale

Copyright (C) 2010-2013 Roberto Rossi 
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
    ultimo = table.getn(buffers)
    
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
    
    ultimo = table.getn(buffers2)
    
    -- 133=Altro...
    listafile = listafile.."|".._t(133)
    scelta = rwfx_ShowList(listafile,msg)
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
    
    --listaOperazioni = "Confronta corrente con altro file|".. --1
    --                  "Confronta corrente con altri due file|".. --2
    --                  "Confronta cartella corrente con altra cartella|".. --3
    --                  "Confronta cartella corrente con altre due cartella|".. --4
    --                  "Fondi corrente con altro file|".. --5
    --                  "Fondi corrente con altri due file|".. --6
    --                  "Fondi cartella corrente con altra cartella|".. --7
    --                  "Fondi cartella corrente con altre due cartelle" --8
    listaOperazioni = _t(180)
  
    scelta = rwfx_ShowList(listaOperazioni,_t(134))    
    if scelta then
      operazioneSelezionata = scelta + 1
    end
    
    return operazioneSelezionata
  end
  
  --questa funzione esegue la comparazione
  -- se compareFolder=true vengono confrontate cartelle, altrimenti file
  -- se compare3=true vengono confrontati 3 elementi e non 2
  -- se fusion=true vengono fusi gli elementi e ne viene prodotto uno nuovo
  local function ComparazioneCorrente (compareFolder, compare3, fusion)
    local kdiff = props["SciteDefaultHome"].."/tools/kdiff/kdiff3.exe"
    local fileBase = props["FileDir"].."\\"..props["FileNameExt"] --file corrente
    local file1 = "" --secondo file per confronto
    local file2 = "" --terzo file per confronto
    local fileFusion = "" --file risultante dalla fusione
    local folderBase = props["FileDir"] --cartella del file corrente, di base
    local folder1 = "" --seconda cartella per confronto
    local folder2 = "" --terza cartella per confronto
    local folderFusion = "" --cartella risultante da fusione
    local noStop = true
    local par = "" --parametri per kdiff
    
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
      
      if ((compare3) and (noStop)) then
        --file2 = SelezionaDocumento("Selezionare terza cartella per confronto...",true)
        file2 = SelezionaDocumento(_t(182),true)
        if file2 then
          par = par.."\""..file2.."\" "
        else
          noStop = false
        end
      end      
      
      if ((fusion) and (noStop)) then
        --folderFusion = SelezionaDocumento("Cartella destioazione per fusione...",true)
        folderFusion = SelezionaDocumento(_t(183),true)
        if folderFusion then
          par = par.."-o \""..folderFusion.."\" "
        end
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
      
      if ((compare3) and (noStop)) then
        --file2 = SelezionaDocumento("Selezionare terzo file per confronto...",false)
        file2 = SelezionaDocumento(_t(184),false)
        if file2 then
          par = par.."\""..file2.."\" "
        else
          noStop = false
        end
      end      
      
      if ((fusion) and (noStop)) then
        par = par.."-merge"
      end
    end --end compareFolder
    
    if (noStop) then
      --print(par)
      rwfx_ShellExecute(kdiff,par)
    end
  end --end function
  
  local function main ()
    local operazione =  getOperazione()
    
    if (operazione == 1) then -- selezione singolo file 
      ComparazioneCorrente(false, false, false)
    elseif (operazione == 2) then -- selezione due file
      ComparazioneCorrente(false, true, false)
    elseif (operazione == 3) then -- selezione singola cartella
      ComparazioneCorrente(true, false, false)
    elseif (operazione == 4) then -- selezione due cartelle
      ComparazioneCorrente(true, true, false)
    elseif (operazione == 5) then -- selezione singola file 
      ComparazioneCorrente(false, false, true)
    elseif (operazione == 6) then -- selezione due file
      ComparazioneCorrente(false, true, true)
    elseif (operazione == 7) then -- selezione singola cartella
      ComparazioneCorrente(true, false, true)
    elseif (operazione == 8) then -- selezione due cartelle
      ComparazioneCorrente(true, true, true)
    end --end if
    
    if (operazione > 0) then
      
    end --end if
  end --end main

main()


end

