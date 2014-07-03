--[[
TODO : Questo file rappresenta il framework principale per lo sviluppo con
       RSciTE, nel quale saranno incluse tutte le funzioni necessarie per
       la realizzazione di nuove procedure e per fornire agli utenti un
       metodo semplificato per lo sviluppo in RSciTE

Autore  : Roberto Rossi
Web     : http://rsoftware.altervista.org

Framework per lo sviluppo di applicazioni in RSciTE/Lua

Copyright (C) 2004,2005,2006,2007 Roberto Rossi 
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

--[[
Regole Generali

* Tutte le funzioni sono precedure dal prefisso :
  "rscite:"
* Tutte le variabili globali e costanti, sono precedute da :
  "rscite."
 
* Tutte le funzioni iniziano con una lettera maiuscola, inoltre se sono presenti
  più parole, ognuna avrà la prima lettera maiuscola.
* Tutte le costanti sono scritte in lettere maiuscole

]]

--[[
Note di sviluppo :

- Eliminata funzione rfx_GetStr
- Eliminata funzione rwfx_isEnglishLang
- A Tutte le funzioni, il prefisso rwfx_ è stato sostituito con rscite:
- A Tutte le funzioni, il prefisso rfx_ è stato sostituito con rscite:
- Rinominata fileOperation in FileOperation
- Rinominata createDirectory in CreateDirectory
- Rinominata fileExist in FileExist
- Rinominata readPathPrj in ReadPathPrj
- Rinominata getCurrent_abbrev_file in GetCurrent_abbrev_file
- Rinominata readPathPrj in ReadPathPrj
- Rinominata savePathPrj in SavePathPrj
- Rinominata ShowList_presel in ShowList_Presel
- 

]]

if not(rscite) then --se non è ancora caricato il framework, attiva il caricamento
  
  rscite = {} --inizializzazione framework
  
  rscite.FRAMEWORK_VERSION = "1.0.0"  --versione

  --questa funzione visualizzata la versione del framework in output
  function rscite:ShowFrameworkInfo()
    local result
    
    result = "RSciTE Lua Framework\n"..
             "Author  : Roberto Rossi\n"..
             "Web     : http://rsoftware.altervista.org\n"..
             "Version : "..rscite.FRAMEWORK_VERSION
             
    print(result)
    
    return result
  end
    
  --                    definizione costanti
  --maschera selezione file      
  rscite.OFN_CREATEPROMPT = 8192 --messaggio per creazione file
  rscite.OFN_FILEMUSTEXIST = 4096 --il file deve esistere
      
  --message box
  rscite.MB_OK = 0
  rscite.MB_OKCANCEL = 1
  rscite.MB_RETRYCANCEL = 5
  rscite.MB_YESNO = 4
  rscite.MB_YESNOCANCEL = 3
  rscite.MB_ABORTRETRYIGNORE = 2
  rscite.MB_DEFBUTTON2 = 256
  rscite.MB_DEFBUTTON3 = 512
  rscite.MB_DEFBUTTON4 = 768
  rscite.MB_ICONINFORMATION = 64
  rscite.MB_ICONEXCLAMATION = 48
  rscite.MB_ICONSTOP = 16
  rscite.MB_ICONQUESTION = 32      
  rscite.MB_CANCELTRYCONTINUE = 6
  --valori di ritorno per message box
  rscite.IDABORT = 3
  rscite.IDCANCEL = 2
  rscite.IDCONTINUE = 11
  rscite.IDIGNORE = 5
  rscite.IDNO = 7
  rscite.IDOK = 1
  rscite.IDRETRY = 4
  rscite.IDTRYAGAIN = 10
  rscite.IDYES = 6
      
  --costanti per funzione fileOperation
  rscite.FOF_SILENT                 = 0x0004
  rscite.FOF_RENAMEONCOLLISION      = 0x0008
  rscite.FOF_NOCONFIRMATION         = 0x0010  
  rscite.FOF_WANTMAPPINGHANDLE      = 0x0020  
  rscite.FOF_ALLOWUNDO              = 0x0040
  rscite.FOF_FILESONLY              = 0x0080  
  rscite.FOF_SIMPLEPROGRESS         = 0x0100  
  rscite.FOF_NOCONFIRMMKDIR         = 0x0200  
  rscite.FOF_NOERRORUI              = 0x0400  
  rscite.FOF_NOCOPYSECURITYATTRIBS  = 0x0800  
  rscite.FOF_NORECURSION            = 0x1000  

  rscite.DLLNAME = "rluawfx.dll"
    
  --definizione funzioni    
  rscite["c_ListBox"] = package.loadlib(rscite.DLLNAME,"c_ListDlg")
  rscite["GetFileName"] = package.loadlib(rscite.DLLNAME,"c_GetFileName")
  rscite["GetColorDlg"] = package.loadlib(rscite.DLLNAME,"c_GetColorDlg")
  rscite["MsgBox"] = package.loadlib(rscite.DLLNAME,"c_MsgBox")
  rscite["InputBox"] = package.loadlib(rscite.DLLNAME,"c_InputBox")
  rscite["ExecuteCmd"] = package.loadlib(rscite.DLLNAME,"c_SendCmdScite")
  rscite["BrowseForFolder"] = package.loadlib(rscite.DLLNAME,"c_BrowseForFolder")
  rscite["PathIsDirectory"] = package.loadlib(rscite.DLLNAME,"c_PathIsDirectory")
  rscite["ShellExecute"] = package.loadlib(rscite.DLLNAME,"c_shellExecute")
  rscite["FileOperation"] = package.loadlib(rscite.DLLNAME,"c_fileOperation")
  rscite["CreateDirectory"] = package.loadlib(rscite.DLLNAME,"c_createDirectory")
  rscite["RegSetInteger"] = package.loadlib(rscite.DLLNAME,"c_RegSetInteger")
  rscite["RegGetInteger"] = package.loadlib(rscite.DLLNAME,"c_RegGetInteger")
  rscite["Sleep"] = package.loadlib(rscite.DLLNAME,"c_Sleep")
  rscite["Test"] = package.loadlib(rscite.DLLNAME,"c_Test")
    
  --ritorna le chiavi del registro dedicate a contenere le
  --impostazioni del software
  --Il parametro, di tipo stringa, 
  --permette di ottenere una Chiave specifica :
  --"HOME" chiave principale
  --"DIALOGS" opzioni impostazione maschere
  --"TMP" opzioni di altro genere, temporanee e non rilevanti
  function rscite:Get_Registry_Key(chiaveRichiesta)
    --TODO : funzione da terminare
    local result = false
    local main = "software\\RSciTE"
    local versione = ""
    local richiesta = ""
    
    --versione distribuzione
    versione = rscite:GetIniVal(props["SciteDefaultHome"].."/distro.ini",
                             "Generale", "vDistribuzione")
    
    richiesta = string.upper(chiaveRichiesta)
    main = main.."\\v"..versione --divisione software per versione
    if (richiesta == "HOME") then --chiave principale
      result = main
    elseif (richiesta == "DIALOGS") then --chiave per valori di impostazione delle dialog
      result = main.."\\dialogs"
    elseif (richiesta == "TMP") then --chiave per valori temporanei di altor genere
      result = main.."\\tmp"
    end
    return result
  end --endfunction
    
  --List Box standard.
  --Questa dialog sarà posizionata al centro dello schermo.
  --Viene mantenuto l'ultimo elemento eseguito, associato a nomeProcedura
  -- Se getLast è true, viene restituita l'ultima voce selezionata
  -- dall'utente, senza aprire la dialog
  function rscite:ShowList_Presel(lista,titolo,nomeProcedura,getLast)
    local i
    local sel
    local key = ""
          
    key = rscite:Get_Registry_Key("TMP")
    
    sel = rscite:RegGetInteger(key, "showList."..nomeProcedura)
    if not(sel) then
      sel = 0
    end
    
    if (not(getLast)) then
      i = rscite:c_ListBox(lista,titolo,false,-1,-1,0,0,true,"",sel)
      if i then
        rscite:RegSetInteger(key, "showList."..nomeProcedura, i)
      end
    else
      i = sel
    end
    return i
  end --endfunction

  --List Box standard.
  --Questa dialog sarà posizionata al centro dello schermo.
  function rscite:ShowList(lista,titolo)
    return rscite:c_ListBox(lista,titolo,false,-1,-1,0,0,true,"",0)
  end --endfunction
  
  --List Box standard.
  --Questa dialog è come la precedente ma con posizionamento variabile
  function rscite:ShowList_Pos(lista,titolo,x,y)
    return rscite:c_ListBox(lista,titolo,false,x,y,0,0,true,"",0)
  end --endfunction
    
  --List Box standard.
  --Questa dialog sarà posizionata al centro dello schermo la prima volta
  --che viene visualizzata, per le volte seguenti verrà posizionata la 
  --dove è stata chiusa, mantenendo anche le dimensioni.
  --Al contrario della funzione standard è richiesto il nome univoco della
  --maschera che si apri.
  local function rscite:ShowList_Repos(lista,titolo,dialogName)
    --TODO : funzione da terminare
    
    return rscite:c_ListBox(lista,titolo,true,-1,-1,0,0,false,dialogName,0)
  end --endfunction

  --elimina spazi e tabulazioni all'inizio e alla fine della linea passata
  function rscite:Trim( testo )
    local result = ""
    local pos1 = 0
    local pos2 = 0
    
    if ( testo ) then
      --trova il primo carattere NON spazio e NON tabulazione
      pos1 = string.find(testo, "[^ \t]")
      --trova l'ultimo carattere NON spazio e NON tabulazione
      pos2 = string.find(testo, "[ \t]+$")
      
      if (pos2 or pos1) then
        if pos2 then
          if (pos2 > pos1) then
            pos2 = pos2 - 1
          end
          result = string.sub(testo, pos1 , pos2)
        else
          if pos1 then
            result = string.sub(testo, pos1)
          else
            result = testo
          end
        end
      end
    end --controllo esistenza testo
    return result
  end --endfunction

  --legge l'elenco dei valori contenuti in una sezione di un file INI
  function rscite:GetIniSec(nomeFile, sezione)
    local inStringa = ""
    local inValore = {}
    local pos = nil
    local linea = ""
    local lineaCorrente = ""
    local idf
    local sezioneCor = ""
    local flagOk = nil
    local i = 1
    
    idf = io.open(nomeFile, 'r')
    if idf then
      for linea in idf:lines(nomeFile) do
        lineaCorrente = rscite:Trim(linea)
        if ((lineaCorrente~="") and (string.sub(lineaCorrente,1,1)~=";")) then
          if ((string.sub(lineaCorrente,1,1)) == "[") then --sezione
            sezioneCor = string.sub(lineaCorrente, 2, string.len(lineaCorrente) - 1)
            if (string.lower(sezioneCor) == string.lower(sezione)) then
              flagOk = true
            else
              if flagOk then
                break
              end
              flagOk = false
            end
          else
            if flagOk then
              pos = string.find(linea,"=")
              if pos then
                inValore[i] = string.sub(linea,1,pos-1)
                i = i + 1
              else --se non esiste = ritorna l'intera linea
                inValore[i] = linea
                i = i + 1
              end --endif pos
            end --endif flagok
          end --endif
        end --end vuoto-commento
      end --endfor        
    end --endif
    idf:close()
    return inValore
  end --endfunction
 
   --legge un valore da un file INI
  function rscite:GetIniVal(nomeFile, sezione, valore)
    local inStringa = ""
    local inValore = ""
    local pos = nil
    local linea = ""
    local lineaCorrente = ""
    local idf
    local sezioneCor = ""
    local flagOk = nil
    
    idf = io.open(nomeFile, 'r')
    if idf then
      for linea in idf:lines(nomeFile) do
        lineaCorrente = rscite:Trim(linea)
        if ((lineaCorrente~="") and (string.sub(lineaCorrente,1,1)~=";")) then
          if ((string.sub(lineaCorrente,1,1)) == "[") then --sezione
            sezioneCor = string.sub(lineaCorrente, 2, string.len(lineaCorrente) - 1)
            if (string.lower(sezioneCor) == string.lower(sezione)) then
              flagOk = true
            else
              if flagOk then
                break
              end
              flagOk = false
            end
          else
            if (flagOk or ((sezioneCor == "") and (sezione == ""))) then
              pos = string.find(linea,"=")
              if pos then
                inStringa = string.sub(linea,1, pos -1)
                if (string.lower(inStringa) == string.lower(valore)) then
                  inValore = string.sub(linea,pos + 1)
                  break
                end
              end
            end --endif flagok
          end --endif
        end --end vuoto-commento
      end --endfor        
      idf:close()
    end --endif      
    return inValore
  end --endfunction

    
  --ritorna l'ultimo carattere della stringa data
  function rscite:LastCH (s)
    local i=string.len(s)
    return string.sub(s,i,i)
  end
  
  --rimuove l'eventuale ritorno a capo presente nella stringa data
  --e ritorna la stringa senza ritorni a capo
  function rscite:RemoveReturnLine(s)
    local a=""
    local lung=0
    
    lung = string.len(s)
    if rscite:LastCH(s)=="\r" then
      a = string.sub(s,1,lung-1)
      lung = string.len(a)
      if rscite:LastCH(a)=="\n" then
        a = string.sub(a,1,lung-1)
      end
    elseif rscite:LastCH(s)=="\n" then
      a = string.sub(s,1,lung-1)
      lung = string.len(a)
      if rscite:LastCH(a)=="\r" then
        a = string.sub(a,1,lung-1)
      end
    else
      a = s
    end  
  return a
  end --endfunction

  -- splitta le linee che compongono il modello e ritorna una tabella
  function rscite:Split ( linea, separatore )
    local parola = ""
    local result = {}
    local pos = 0
    local i = 1

    pos = string.find(linea, separatore)
    while pos do
      parola = string.sub(linea, 1, (pos - 1))
      result[i] = parola
      i = i + 1
      linea = string.sub(linea, (pos + string.len(separatore)))
      pos = string.find(linea, separatore)
    end --endwhile
    result[i] = linea
    return result
  end --endfunction

    
  --Ritorna la cartella in cui memorizzare i file relativi all'utente
  --corrente. es.:c:\user\roberto\.rscite
  --In aggiunta, controlla se la cartella non esiste, in tal caso 
  -- viene creata. 
  --Questa funzione controlla anche la presenza della sottocartella tmp
  function rscite:UserFolderRSciTE()
    local nomed
    nomed = props["SciteUserHome"].."\\.rscite"
    
    --controllo esistenza cartella temporanea programma ed eventuale creazione
    if (not(rscite:PathIsDirectory(nomed.."\\tmp"))) then
      rscite:createDirectory(nomed)
      rscite:createDirectory(nomed.."\\tmp")
    end

    return nomed
  end --endfunction
  
  --ritorna il nome del file standard di interscambio stringhe 'sciteStr.tmp'
  function rscite:FN()
    local nomef
    nomef = os.getenv("TMP")
    nomef = nomef.."\\sciteStr.tmp"
    return nomef
  end  --endfunction

  --ritorna il contenuto del file temporaneo standard 'sciteStr.tmp'
  function rscite:GF()
    local nomef = rscite:FN()
    local result = ""
    local idf
    
    idf = io.open(nomef, "r")
    if (idf) then
      result = idf:read("*a")    
      io.close(idf)
    end
    return result
  end --endfunction
    
  --ritorna true se il file specificato esiste
  function rscite:FileExist(nomef)
    local idf      
    idf = io.open(nomef,"r")
    if (idf) then
      io.close(idf)
      return true
    else
      return false
    end
  end --endfunction
    
  --legge il nome del progetto selezionato
  function rscite:ReadPathPrj()
    local nomef = rscite:FN()
    local result = ""
    local idf
    
    nomef = os.getenv("TMP")
    nomef = nomef.."\\scitePrj.tmp"
    
    idf = io.open(nomef, "r")
    if (idf) then
      result = idf:read("*a")    
      io.close(idf)
    end

    return result
  end --endfunction
    
  --scrive il nome del progetto precedentemente salvato
  function rscite:SavePathPrj(path)
    local nomef = rscite:FN()
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
  end --endfunction

  --Ritorna il nome del file di abbreviazioni legato al tipo di file corrente.
  --Se non è stato trovato il file relativo al tipo di file corrente,
  --ritorna il file comune abbrev.properties
  --
  --I tipo supportati (per ora) sono :
  --  alisp
  --  lua
  --  php
  --  vb
  function rscite:GetCurrent_abbrev_file()
    local result
    local patterns=""
    local variable
    local estensione    
    
    estensione = string.lower(props['FileExt'])
    
    estensione = '*.'..estensione
    
    if (estensione == '*.') then
      patterns = "default"
    elseif (string.find(props['file.patterns.alisp'],estensione,1,true)) then
      patterns = 'file.patterns.alisp'
    elseif (string.find(props['file.patterns.php'],estensione,1,true)) then
      patterns = 'file.patterns.php'
    elseif (string.find(props['file.patterns.vb'],estensione,1,true)) then
      patterns = 'file.patterns.vb'
    elseif (string.find(props['file.patterns.lua'],estensione,1,true)) then
      patterns = 'file.patterns.lua'
    elseif (string.find(props['file.patterns.css'],estensione,1,true)) then
      patterns = 'file.patterns.css'
    else
      patterns = 'default'
    end
    
    if (patterns~='') then
      if (patterns == 'default') then
        result = props["SciteDefaultHome"]..'/abbrev/abbrev.properties'
      else
        variable = 'abbreviations.$('..patterns..')'
        result = props[variable]
      end
    end
    
    return result
  end --endfunction
    
end --end if modulo framework
