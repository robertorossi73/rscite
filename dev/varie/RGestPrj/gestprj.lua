--[[
Version : 3.0.0
Web     : http://www.redchar.net

Questo file implementa un rudimentale gestore progetti. 

Copyright (C) 2004-2010 Roberto Rossi 
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
    local trovato = false
    
    if (parte==2) then --solo estensione
      carattere = "."
    end
    
    i = string.len(linea)
    nomefileExt = linea
    path = ""
    while (i > 0) do
      ch = string.sub(linea,i,i)
      if (ch == carattere) then
        nomefileExt = string.sub(linea,i+1)
        path = string.sub(linea,1,i)
        i = 0
      end
      i = i - 1
    end
    
    if (parte==0) then
      result = nomefileExt
    elseif (parte==1) then
      result = path
    elseif (parte==2) then
      result = nomefileExt
    else
      result = nil
    end
    
    return result
  end

  --dato un file di progetto, ritorna il suo nome letto dal suo interno
  local function getPrjName(nomefile)
    --TODO : da implementare
  end
  
  --data una cartella di partenza e un'elenco di estensioni di file,
  --genera l'elenco di tutti i file presenti partendo dalla cartella indicata
  --procedendo in modo ricorsivo all'interno di tutte le sue sottodirectory
  local function getFilesInProject(cartella, estensioni)
    --TODO : da implementare
  end
  
  --dato il nome di un simbolo (parola), la cartella di partenza e l'elenco
  --delle estensioni dei file facenti parte del progetto, tenta di trovarne
  --la definizione. Usando CTAGS tenta di trovare funzioni, classi, variabili
  -- ecc...
  local function getSimbolDef(simbolo, cartella, estensioni)
    --TODO : da implementares
  end

  --partendo dal file corrente, cerca nella sua cartella e in tutte le cartelle
  --superiori un file di progetto, restituisce il percorso di tale file, compreso
  --il nome
  local function findProjectFile ()
    --TODO : da implementare
  end
  
  --apre un file, utilizzando anche i percorsi relativi rispetto alla cartella
  --del progetto
  --TODO : non so se serve
  local function openDocument (linea)
    local nome --nome file linea
    local path --cartella linea
    local pathProject --cartella progetto
    local fileName="" --file da aprire
    
    pathProject = getPartPath(rfx_readPathPrj(),1)
    if (string.sub(linea,1,1) == ".") then --controlla percorso relativo
      fileName = pathProject..linea
    else --file con percorso assoluto
      fileName = linea
    end
    
    -- 68=\nIl file selezionato(
    -- 69=) non esiste!
    if (not(rfx_fileExist(fileName))) then
      print(_t(68)..fileName.._t(69))
    else
      scite.Open(fileName)
    end
    
  end
  
  --apre il progetto relativo al file corrente
  --TODO : da implementare
  local function openProject()
    local nomeFile
    local ok
   
    -- 70=Seleziona Progetto da aprire
    -- 71=Progetto%c*.spj
    -- 72=\nFile progetto non valido! Deve avere estensione '.spj'!
    ok = rwfx_GetFileName(_t(70),"", OFN_FILEMUSTEXIST,rfx_FN(),_t(71))
    if ok then
      nomeFile = rfx_GF()
      if (string.lower(getPartPath(nomeFile,2))=="spj") then
        rfx_savePathPrj(nomeFile)
      else
        print(_t(72))
      end
    end
  end

  --ritorna il contenuto di un intero file
  --TODO : non so se serve
  local function readFile(nomef)
    local result = ""
    local idf
    
    idf = io.open(nomef, "r")
    if (idf) then
      result = idf:read("*a")    
      io.close(idf)
    end

    return result
  end

  --apre un nuovo documento 
  --TODO : non so se serve
  local function newProject()
    -- 73=\nAttenzione : \nUna volta completato il file, salvarlo assegnandogli estensione '.SPJ'.
    local testo = readFile(props["SciteDefaultHome"].."/luascr/template.spj")
    scite.Open("")
    editor:ReplaceSel(testo)
    print(_t(73))
  end
  
  --visualizza la maschera di gestione progetto con i file indicato
  --TODO : da implementare correttamente, modifcando le voci proposte
  --funzione principale da cui parte il programma
  local function main()
    local strmenu = ""
    local scelta
    local i=1
    local nomef
    local nomePerFile
    local flagContinua --indica se riaprire la maschera di selezione
    local elencoFile = {}
    local tit = ""
    local currentprj = ""
    
    -- 74=\nImpossibile determinare il nome del progetto! Formato file non valido.
    -- 75=Gestisci Progetto Corrente
    -- 76=Apri Progetto
    -- 77=Nuovo Progetto
    flagContinua = true
    while flagContinua do
      currentprj = rfx_readPathPrj()
      if not(currentprj=="") then
        tit = rfx_GetIniVal(currentprj,"General","Name")
        if (tit=="") then
          print(_t(74))
        end
        elencoFile = rfx_GetIniSec(currentprj,"Files")
      end
      if elencoFile then
        i = 1
        while (i <= table.getn(elencoFile)) do
          nomePerFile = rfx_GetIniVal(currentprj,"Files",elencoFile[i])
          if (string.sub(elencoFile[i],1,1) == "*") then
            nomef = "-->    "..string.sub(elencoFile[i],2)
          else
            if not(nomePerFile=="") then
              nomef = "    "..nomePerFile
            else
              nomef = "    "..getPartPath(elencoFile[i],0)
            end
          end
          strmenu = strmenu..nomef.."|"
          i = i + 1;
        end
        strmenu = strmenu.."...|"
      end      
      strmenu = strmenu..
                _t(75).."|"..
                _t(76).."|"..
                _t(77)
      scelta = rwfx_ShowList(strmenu,rfx_GetStr("Prj : ")..tit)
      if scelta then
        if (scelta > (table.getn(elencoFile) - 1)) then --menu scelta file
          scelta = scelta - table.getn(elencoFile)
          if (scelta == 1) then --gestione progetto corrente
            openDocument(currentprj)
            flagContinua = false
          elseif (scelta == 2) then --apri progetto
            openProject()
            flagContinua = true
          elseif (scelta == 3) then --nuovo progetto
            newProject()
            flagContinua = false
          end
        else
          --elimina nome sezioni e considera solo nomi file
          if (not(string.sub(elencoFile[scelta+1],1,1) == "*")) then
            openDocument(elencoFile[scelta+1])
          end          
          flagContinua = false
        end
      else
        flagContinua = false
      end
      strmenu = ""
    end --endwhile
    
    return scelta
  end

  main()
  
end
 