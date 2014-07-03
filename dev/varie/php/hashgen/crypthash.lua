 --[[
Author  : Roberto Rossi
Version : 0.0.2
Web     : http://www.redchar.net

Questa procedura consente la criptazione/decriptazione del testo e la 
generazione di stringhe di hash

Consente di operare testo selezionato, in 
quest'ultimo caso l'operazione è limitata dall'impossibilità  di utilizzare
una selezione contenente ritorni a capo lunga al massimo circa 2000 caratteri,
limitazione imposta dalla massima lunghezza del comando utilizzabile da cmd.exe,
come spiegato nell'articolo microsoft 
"Command prompt (Cmd. exe) command-line string limitation"

Nota : Durante le operazioni di criptazione, non vengono effettuate copie 
temporanee dei dati originali, la procedura lavora direttamente sul testo/file 
indicato.

TODO : Nelle prossime release sono da implementtare :
  - Traduzione frasi (attualmente solo in italiano)
  - supporto ad algoritmi di criptazione simmetrica
  - capacità  di operare su interi file, selezionabili o file corrente
  - capacità  di criptare/decriptare file con chiave simmetrica
  

Copyright (C) 2010 Roberto Rossi 
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

  --chiede all'utente quale algoritmo utilizzare per il calcolo
  local function getAlgo ()
    local algoList --lista algoritmi supportati
    local scelta
    local result = ""
    
    algoList = "md5|sha1|crc32|Tutti"
    
    scelta = rwfx_ShowList(algoList,"Metodo di calcolo")
    
    if (scelta) then
      if (scelta==0) then
        result = "md5"
      elseif (scelta==1) then
        result = "sha1"
      elseif (scelta==2) then
        result = "crc32"
      elseif (scelta==3) then
        result = "all"
      end
    end
    
    return result
  end
  
  --chiede all'utente la fonte per l'elaborazione
  --utilizzare la selezione corrente oppure seleziona un file
  --TODO : da terminare
  local function getSource ()
    local optList --lista opzioni
    local scelta = 1 --selezione file
    local result = "" --annullato
    local flagOk
    local nomeFile
     
    optList = "Testo Selezionato|File Corrente|Altro File..."
    
    scelta = rwfx_ShowList(optList,"Effettua Calcolo su...")
    
    if (scelta) then
      if (scelta==0) then --calcolo su selezione
        result = "s"
      elseif (scelta==1) then --calcolo su file corrente
        
        -- 116=Salvataggio file
        if (editor.Modify) then
          if (rwfx_MsgBox(
              "Il file corrente non è stato salvato, si desidera continuare ugualmente?",
              _t(116),
              MB_YESNO + MB_DEFBUTTON2) == IDYES) then
            flagOk = true
          end
        else
          flagOk = true
        end
        
        if (flagOk) then
          result = props["FilePath"]
        end
        
      elseif (scelta==2) then --calcolo su file selezionato
      
        nomeFile = rwfx_GetFileName("Selezionare file da elaborare"
                                    ,"", OFN_FILEMUSTEXIST,rfx_FN())
        
        if nomeFile then
          result = rfx_GF()
        end
      end
    end    
    
    return result
  end
  
  --verifica la presenza dell'interprete php e dello script da eseguire
  --se sutto è ok la funzione ritorna 1, se non viene trovato php ritorna 2
  --se non viene trovato lo script 3
  local function checkPHPScript(script)
    local result = 1 --tutto ok
    local phpInterp = props["SciteDefaultHome"].."\\tools\\php\\php.exe"
    
    if (not(rfx_fileExist(phpInterp))) then
      result = 2
    end
    
    if (not(rfx_fileExist(script))) then
      result = 3
    end
    
    return result
  end
  
  local function execCalc(fonte)
    local scriptName = props["SciteDefaultHome"].."\\luascr\\hashgen.php"
    local cmd = "cmd /C \"\""..props["SciteDefaultHome"].."\\tools\\php\\php.exe\" -f \""..scriptName.."\""
    local cmdsel = ""
    local cmdtmp = ""
    local content = ""
    local fin
    local errnum = 0 -- nessun errore
    local algo = ""
    local seltext = editor:GetSelText()

    
    if ((seltext ~= "") or not(fonte == "")) then
      algo = getAlgo()
    end
    
    if (fonte == "") then
      --calcolo su selezione
      cmd = cmd.." string "..algo
      
      if (seltext ~= "") then
        if (not(string.find(seltext, "\n")) and not(string.find(seltext, "\r"))) then
          seltext = string.gsub(seltext, "\"", "\\\"") --sistemazione doppi apici "
          cmdtmp = cmd.." \""..seltext.."\""
          if (string.len(cmdtmp) < 2047) then --verifica lunghezza massima
            cmdsel = cmdtmp
          end        
        else
          seltext = ""
          errnum = 1 --ritorni a capo individuati
        end
      else
        errnum = 2 --nessuna selezione
      end
    else
      --calcolo sul file selezionato
      --TODO : elaborazione file selezionato
      
    end
    
    if (algo == "") then
      cmdsel = ""
    end
    
    if (cmdsel=="") then
      if (errnum == 1) then
        print("\nImpossibile effettuare la conversione! Non è possibile includere ritorni a capo nel testo selezionato.")
      elseif (errnum == 2) then
        print("\nNon è stato selezionato alcun testo! Effettuare le selezione e riprovare.")
      elseif (errnum == 3) then
      elseif (errnum == 4) then
      end
    else
      cmdsel = cmdsel.."\"" --chiusura comando    
      if (checkPHPScript(scriptName) == 1) then
        content = rfx_exeCapture(cmdsel)
      else
        print("\nImpossibile trovare l'interprete PHP o lo script da eseguire!")
      end
    end
    print("\n->"..content)
    
  end --endfx

  local function main()
    local fonte
    
    
    fonte = getSource()
    
    if (not(fonte == "")) then
      if (fonte == "s") then
        execCalc("");
      else
        execCalc(fonte);
      end
    end
  end
  
  main()
  
end
