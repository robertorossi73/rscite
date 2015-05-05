--[[
Version : 4.2.1
Web     : http://www.redchar.net

Copyright (C) 2004-2015 Roberto Rossi 
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
V.4.1.0
-- la finestra principale rimane posizionata dove è stata usata l'ultima volta

V.4.0.0
-- introdotto terzo parametro nei file ini di dichiarazione script. Questo
    consente di impostare la variabile globale PUBLIC_optionScript che 
    viene usata dagli script per ricevere un qualsiasi dato 
    (solotamente un'opzione)

V.3.1.0
-- Aggiunto sistema di gestione estensioni ("Extensions"). Il sistema di estensioni prevede, oltre ai normali script modificabili dall'utente, anche un sistema per il caricamento di script/estensioni alternativo. Questo sistema prevede che sia possibile inserire sottocartelle nella directory 'extensions', sottocartelle che per essere viste come estensioni dovranno contenere un file chiamato 'scite.lua' identico, nella struttura, ai normali script di estensioni (utente). Inoltre, sempre nella cartella 'extensions' sarà presente un file di indice che elenca in quali cartelle ricercare lo script 'scite.lua'. Infine, nel caso in cui il file indice non sia presente, all'apertura di F12 questo verrà creato. Questo meccanismo consente l'installazione di nuove 'estensioni' e la loro inclusione in F12 indipendentemente dalle estensioni utente, identificate dagli script 'scriptX.lua'. Un'ipotetica installazione di estensioni, si limiterà a creare la sottocartella (assegnandogli ad esempio un guid come nome) e a eliminare il file indice, cosa che determinerà poi la sua automatica rigenerazione alla successiva apertura di F12. In assenza della cartella "Extensions", il software si comporterà normalente senza alcun degrado delle prestazioni.

V.3.0.0
-- Aggiunta lista script utente. Nella lista aggiungere funzioni utente. Invece di costringere l'utente a modificare il file di configurazione, nella cartella dell'utente relativa a scite, verrà inserita la sottocartella "extensions" la quale potrà contenere n. file script numerati da script1.lua a script50.lua che, se esistenti, verranno letti e inseriti nella lista, quindi eseguiti. Ogni file, sulla prima linea, all'interno di un commento, conterrà la dicitura da visualizzare nella lista fi F12.

]]

--Variabile pubblica che consente il passaggio di un parametro agli script eseguiti
PUBLIC_optionScript = nil
  
do
  require("luascr/rluawfx")

  --data un path di una cartella ritorna, sottoforma di tabella, l'elenco
  -- delle sottodirectory presenti
  local function GetSubFoldersList(folder)
    local result = {}
    local subfolders = ""
    
    subfolders=rfx_exeCapture("cmd /c dir /AD /b \""..folder.."\"")
    result = rfx_Split(subfolders,"\n")

    --rimuove ultimo elemento, normalmente vuoto
    table.remove(result,table.getn(result))
    
    return result
  end
  
  --ritorna il percorso della cartella relativa ai file script delle estensioni
  local function GetExtensionScriptPath()
    return rfx_UserFolderRSciTE().."\\Extensions\\"
  end

  -- ricrea, se necessario, il file di indice relativo alle estensioni
  -- alternative, nel caso questo venga creato/ricreato la funzione ritorna
  -- true.
  -- il formato del file prodotto è il classico .ini
  local function CheckAltExtensionsIndex ()
    local result = false
    local folder = GetExtensionScriptPath()
    --file indice per le estensioni alternative
    local nomef = folder.."extensions.lst"
    local makeIndex = false
    local idf
    local testo
    local k
    local v
    local i = 1
    local foldersList = {}
    local nomefscript = "" --nome file script
    
    --se la cartella delle estensioni non esiste salta la verifica
    if (rwfx_PathIsDirectory(folder)) then
      if (not(rfx_fileExist(nomef))) then
        makeIndex = true --se l'indice non esiste lo crea
      end
    end
    
    if (makeIndex) then
      --rfx_exeCapture("cmd /c dir /s /b \""..folder.."scite.lua\" > \""..nomef.."\"")
      foldersList = GetSubFoldersList(folder)
      
      idf = io.open(nomef, "w")
      if (idf) then
        idf:write("[Extensions]\n")
        for k,v in pairs(foldersList) do 
          nomefscript = folder..v.."\\scite.lua"
          if (rfx_fileExist(nomefscript)) then
            idf:write("extension"..tostring(i).."="..nomefscript.."\n")
            i = i + 1
          end
        end
        io.close(idf)
        result = true
      end
    end
    return result
  end
  
  -- ritorna il titolo di uno script
  -- la prima linea del file determina il titolo dello script, 
  --    ovviamente questa sarà commentata
  -- in assenza della prima linea verrà usata la seconda
  local function GetExtensionScriptTitle(nomef)
    local result = ""
    local idf
    local linea1 = ""
    local linea2 = ""
    
    idf = io.open(nomef, "r")
    if (idf) then
      linea1 = idf:read("*l")
      linea2 = idf:read("*l")
      io.close(idf)
      
      if (linea2 and (rfx_Trim(linea2) ~= "")) then
        result = linea2
      end
      
      linea1 = rfx_Trim(linea1)
      if (linea1 and 
                (linea1 ~= "--") and
                (linea1 ~= "--[[") and
                (linea1 ~= "")) then
        result = linea1
      end
    end

    result = rfx_Trim(result)
    if (string.sub(result,1,4)=="--[[") then
      result = string.sub(result,5) --elimina commento multilinea
    else
      if (string.sub(result,1,2)=="--") then
        result = string.sub(result,3) --elimina commento
      end
    end
    result = rfx_Trim(result)
    return result
  end

  -- carica la lista delle estensioni alternative
  -- questa funzione restituisce la lista (come tabella) degli script,
  -- sottoforma di elenco titoli, oppure di elenco file
  local function GetAltExtensionScriptFiles(getTitles)
    --file indice per le estensioni alternative
    local nomef = GetExtensionScriptPath().."extensions.lst"
    local result = {}
    local scriptsID
    local scriptFile = ""
    local k
    local v
    nomescr = ""
    local i = 1
    
    scriptsID = rfx_GetIniSec(nomef, "Extensions")
    for k,v in pairs(scriptsID) do       
      scriptFile = rfx_GetIniVal(nomef, "Extensions", v) 
      if (getTitles) then
        result[i] = GetExtensionScriptTitle(scriptFile)
      else
        result[i] = scriptFile
      end
      i = i + 1
    end

    return result
  end
  
  -- questa funzione restituisce la lista (come tabella) degli script,
  -- sottoforma di elenco titoli, oppure di elenco file
  local function GetExtensionScriptFiles(getTitles)
    local idxMin = 1 --indice primo file di script 
    local idxMax = 50 --indice ultimo file di script 
    --nome base per file script xxx.lua
    local stdFileName = GetExtensionScriptPath().."script"
    local stdFileExtension = ".lua"
    local i = idxMin
    local idx = 1
    local result = {}
    local nomef = ""
    local listAlt = {}
    local k
    local v
    
    while (i <= idxMax) do
      nomef = stdFileName..tostring(i)..stdFileExtension
      if (rfx_fileExist(nomef)) then
        if (getTitles) then
          result[idx] = GetExtensionScriptTitle(nomef) --lista titoli
        else
          result[idx] = nomef --lista file
        end
        idx = idx + 1
      end
      i = i + 1
    end
    
    --aggiungere elenco estensioni alternative
    listAlt = GetAltExtensionScriptFiles(getTitles)
    for k,v in pairs(listAlt) do 
      result[idx] = v
      idx = idx + 1
    end
    
    return result
  end

  -- apre la cartella degli script. Nel caso questa non esiste viene
  -- automaticamente creata, inoltre, nel caso sia vuota comparirà un
  -- avviso che chiederà se creare un file di esempio
  local function OpenExtensionScriptFolder ()
    local nomed = GetExtensionScriptPath()
    local firstExec = false
    local source = ""
    local destination = ""
    
    if (not(rwfx_PathIsDirectory(nomed))) then
      firstExec = true
      rwfx_createDirectory(nomed) --cartella mancante
    end
    
    if (table.maxn(GetExtensionScriptFiles(false)) < 1) then
      firstExec = true --cartella vuota
    end
    
    if (firstExec) then 
      --avviso e creazione script di esempio
      
      --"Questa è la prima volta che si accede alla cartella delle Estensioni, si desiderà che RSciTE crei un semplice script di esempio?",
      --"Estensioni", 
      if (rwfx_MsgBox( _t(176), _t(177),MB_YESNO) == IDYES) then
        -- effettuare copia
        source =  props["SciteDefaultHome"].."/luascr/ExtensionSample.lua"
        destination = nomed.."script1.lua"
        if (not(rfx_fileCopy(source, destination))) then
          print("\nError : in 'rfx_fileCopy' from 'addtools.lua'")
        end
      end
    end
    
    rwfx_ShellExecute("explorer.exe","\""..string.gsub(GetExtensionScriptPath(), "/", "\\").."\"")    
  end
  
  local function StartAddedTools(exeLast)
    local sottoCartella = "/luascr/"
    local cartellaScript = props["SciteDefaultHome"]..sottoCartella
    local fileIni
    
    if (rwfx_isEnglishLang()) then --inglese
      fileIni = cartellaScript.."tools-en.ini"
    else --non inglese
      fileIni = cartellaScript.."tools.ini"
    end

    local nomeSezione 
    nomeSezione = "Tools"
    
    local scelta
    local i, valore
    local listaFxStr = ""
    local listaExtensionFiles = {}
    local flag
    -- frasi : 6- Attenzione : Questa procedura potrebbe modificare l'interno file corrente!\n\n Si desidera procedere?
    --         7- Personalizza Elenco Funzioni
    --         8- Comandi Aggiuntivi by R.R.
    --         9- Attenzione!
    local msg1 = _t(6)
    local dimLista
    local dimStandardList

    --generazione lista script alternativi (non utente)
    CheckAltExtensionsIndex()
    -- elenco script standard
    local listaFx = rfx_GetIniSec(fileIni, nomeSezione)
    dimStandardList = table.getn(listaFx) --dimensione lista script standard
    -- aggiunta lista estensioni
    listaFx = rfx_concatTables(listaFx, GetExtensionScriptFiles(true))
    
    -- lista file per script
    listaExtensionFiles = GetExtensionScriptFiles(false)
    local script = ""
    local dati = {}
    local datistr = ""
    
    listaFxStr = table.concat(listaFx,"|")
    --aggiunta funzione per personalizzazione funzioni
    if (listaFxStr ~= '') then
      listaFxStr = listaFxStr..'|'..
               "....|".._t(7)
    end

    --scelta =  rwfx_ShowList_presel(listaFxStr,_t(8),"addtools",exeLast)
    scelta =  rwfx_ShowList_Repos(listaFxStr,_t(8),"addtools", exeLast)
    if (scelta) then
      dimLista = table.getn(listaFx)
      if (scelta < dimLista) then
        scelta = scelta + 1
        datistr = rfx_GetIniVal(fileIni, nomeSezione, listaFx[scelta])
        if (datistr == "") then --se è vuoto cerco estensione
          --nome script più avviso per elaborazione intero file disattivato
          datistr = listaExtensionFiles[scelta - dimStandardList]..",0"
        end
        dati = rfx_Split(datistr,",")
        script = dati[1] --nome file script
        flag = dati[2] --flag script
        PUBLIC_optionScript = dati[3] --opzioni da passare a script
        --print(PUBLIC_optionScript)

        if (string.find(script,"\\",1,true) or
            string.find(script,"/",1,true)) then
          --script con percorso impostato e sostituzioni percorsi standard
          script = string.gsub(script,"\${SciteDefaultHome}",props["SciteDefaultHome"])
          script = string.gsub(script,"\${SciteUserHome}",props["SciteUserHome"])
        else
          script = cartellaScript..script --script con percorso standard
        end
        
        if (flag == "0") then
          dofile(script)
        elseif (flag == "1") then
          if (rwfx_MsgBox(msg1,_t(9),MB_YESNO + MB_DEFBUTTON2) == IDYES) then
            dofile(script) 
          end
        end
      elseif ((scelta - 1) == dimLista) then --selezione ultima voce lista
        --scite.Open(fileIni); --apertura file delle funzioni
        OpenExtensionScriptFolder()        
      end--verifica dimensione lista
    end
  end --endf
  
  --verifica se è necessario eseguire la procedura di verifica aggiornamenti,
  --il controllo avviene una volta al mese
  local function updater_main()
    local month = tonumber(os.date("%m"))
    local noUpdater = rfx_UserTmpFolderRSciTE().."\\no_updater.txt"
    local monthFile = rfx_UserTmpFolderRSciTE().."\\updater.txt"
    local lastMonthCheck = 0
    local idf
    local updateOk = true
    local result = false
    local noEmpty = false
      
    idf = io.open(noUpdater, "r")
    if (idf) then
      updateOk = false
      io.close(idf)
    end
    
    if (updateOk) then
      idf = io.open(monthFile, "r")
      if (idf) then
        lastMonthCheck = tonumber(idf:read("*a"))
        io.close(idf)
        noEmpty = true
      end

      if (month ~= lastMonthCheck) then
        idf = io.open(monthFile, "w")
        if (idf) then
          result = idf:write(tostring(month))
          io.close(idf)
        end
        if (noEmpty) then
          PUBLIC_optionScript = "AUTOEXECUTE"
          dofile(props["SciteDefaultHome"].."\\luascr\\updater.lua")
          result = true
        else
          result = false
        end
        
      end
    end -- updateOk    
    return result
  end -- end updater_main

  local function main()    
     --verifica aggiornamenti
    
    if not(updater_main()) then
      if (PUBLIC_command) then
        StartAddedTools(true)
      else
        StartAddedTools(false)
      end
    end
    PUBLIC_command = nil
  end
  
  main()
end
