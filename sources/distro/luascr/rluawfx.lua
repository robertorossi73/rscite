--[[
Version : 3.5.2
Web     : http://www.redchar.net

Funzioni di utilità per macro SciTE/Lua

Copyright (C) 2004-2020 Roberto Rossi 
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

if not(rwfx_info) then
    
    require("luascr/wcl_strip") --gestore interfaccia grafica SciTE

    --nome file traduzione
    PUBLIC_nomeFileTrad = ""

    --ritorna true se il file specificato esiste ed è leggibile
    function rfx_fileExist(nomef)
      local idf
      if (nomef) then      
        idf = io.open(nomef,"r")
        if (idf) then
          io.close(idf)
          return true
        end
      end
      return false
    end
    
    --ritorna true se il software è tradotto in inglese
    function rwfx_isEnglishLang()
      local nomeFileTradIt = "locale.properties" --lingua diversa da inglese
      if rfx_fileExist(props["SciteDefaultHome"].."/luascr/"..nomeFileTradIt) then
        return false --non inglese
      else
        return true  --inglese
      end
    end--endfunction

    --definizione costanti
      --maschera selezione file      
      OFN_CREATEPROMPT = 8192 --messaggio per creazione file
      OFN_FILEMUSTEXIST = 4096 --il file deve esistere
      
      --message box
      MB_OK = 0
      MB_OKCANCEL = 1
      MB_RETRYCANCEL = 5
      MB_YESNO = 4
      MB_YESNOCANCEL = 3
      MB_ABORTRETRYIGNORE = 2
      MB_DEFBUTTON2 = 256
      MB_DEFBUTTON3 = 512
      MB_DEFBUTTON4 = 768
      MB_ICONINFORMATION = 64
      MB_ICONEXCLAMATION = 48
      MB_ICONSTOP = 16
      MB_ICONQUESTION = 32      
      MB_CANCELTRYCONTINUE = 6
      --valori di ritorno per message box
      IDABORT = 3
      IDCANCEL = 2
      IDCONTINUE = 11
      IDIGNORE = 5
      IDNO = 7
      IDOK = 1
      IDRETRY = 4
      IDTRYAGAIN = 10
      IDYES = 6
      
      --costanti per funzione rwfx_fileOperation
      FOF_SILENT                 = 0x0004
      FOF_RENAMEONCOLLISION      = 0x0008
      FOF_NOCONFIRMATION         = 0x0010  
      FOF_WANTMAPPINGHANDLE      = 0x0020  
      FOF_ALLOWUNDO              = 0x0040
      FOF_FILESONLY              = 0x0080  
      FOF_SIMPLEPROGRESS         = 0x0100  
      FOF_NOCONFIRMMKDIR         = 0x0200  
      FOF_NOERRORUI              = 0x0400  
      FOF_NOCOPYSECURITYATTRIBS  = 0x0800  
      FOF_NORECURSION            = 0x1000  
      
      --costanti stringa per funzioni di interazione con registro
      --"HKCU"
      --"HKLM"
      

    if (rwfx_isEnglishLang()) then
      rwfx_NomeDLL = "rluawfx-en.dll"
    else
      rwfx_NomeDLL = "rluawfx.dll" --lingua diversa da inglese
    end
    
    --definizione funzioni generali
    
    --da usare previo settaggio della compatibilità
    --https://msdn.microsoft.com/en-us/library/ee330730%28v=vs.85%29.aspx#browser_emulation
    rwfx_ShowHTMLDialog = package.loadlib(rwfx_NomeDLL,"c_ShowHTMLDialog")
    
    rwfx_SetTransparency = package.loadlib(rwfx_NomeDLL,"c_SetTransparency")
    rwfx_c_ListBox = package.loadlib(rwfx_NomeDLL,"c_ListDlg")
    rwfx_GetFileName = package.loadlib(rwfx_NomeDLL,"c_GetFileName")
    rwfx_GetColorDlg = package.loadlib(rwfx_NomeDLL,"c_GetColorDlg")
    rwfx_MsgBox = package.loadlib(rwfx_NomeDLL,"c_MsgBox")
    rwfx_MsgBox_Btn = package.loadlib(rwfx_NomeDLL,"c_MsgBox_Customize_Btn")
    rwfx_InputBox = package.loadlib(rwfx_NomeDLL,"c_InputBox")
    rwfx_ExecuteCmd = package.loadlib(rwfx_NomeDLL,"c_SendCmdScite")
    rwfx_BrowseForFolder = package.loadlib(rwfx_NomeDLL,"c_BrowseForFolder")
    rwfx_PathIsDirectory = package.loadlib(rwfx_NomeDLL,"c_PathIsDirectory")
    rwfx_ShellExecute = package.loadlib(rwfx_NomeDLL,"c_shellExecute")
    rwfx_fileOperation = package.loadlib(rwfx_NomeDLL,"c_fileOperation")
    rwfx_createDirectory = package.loadlib(rwfx_NomeDLL,"c_createDirectory")
    rwfx_RegSetInteger = package.loadlib(rwfx_NomeDLL,"c_RegSetInteger")
    rwfx_RegGetInteger = package.loadlib(rwfx_NomeDLL,"c_RegGetInteger")
    rwfx_RegGetString = package.loadlib(rwfx_NomeDLL,"c_RegGetString")
    rwfx_Sleep = package.loadlib(rwfx_NomeDLL,"c_Sleep")
    rwfx_addToRecentDocs = package.loadlib(rwfx_NomeDLL,"c_addToRecentDocs")
    rwfx_SetWindowSize = package.loadlib(rwfx_NomeDLL,"c_SetWindowSize")    
    rfx_GetGUID = package.loadlib(rwfx_NomeDLL,"c_GetGUID")
    rfx_setIniVal = package.loadlib(rwfx_NomeDLL,"c_SetIniValue")
    rfx_shellAndWait = package.loadlib(rwfx_NomeDLL,"c_shellAndWait")
    rwfx_Test = package.loadlib(rwfx_NomeDLL,"c_Test")

    --elimina spazi e tabulazioni all'inizio e alla fine della linea passata
    function rfx_Trim( testo )
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
            if (not(pos1)) then
              pos1 = 0
            end
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
    end
    
    --ritorna una tabella con i dati sulla versione ricavati da version.txt
    -- i campi previsti :
    --  .FileMajorPart --parte 1 versione scite
    --  .FileMinorPart --parte 2 versione scite
    --  .FileBuildPart --parte 3 versione scite
    --  .FilePrivatePart --parte 4 versione scite
    --  .Distro --versione distro
    --  .AddPart --parte aggiuntiva libera (stringa)
    --  .Url --url sito distribuzione
    --  .Author --autore
    --  .NameDistro --nome distribuzione
    --  .UrlUpg --url ultima versione
    function rfx_GetVersionTable()
        return rfx_GetVerTblFromIniFile(props["SciteDefaultHome"].."\\version.txt")
    end
    
    --funzione complementare a rfx_GetVersionTable
    function rfx_GetVerTblFromIniFile(nomef)
      local resultTbl = {}
      local idf 
      local linea
      local lineaTbl
      
      resultTbl.Author = rfx_GetIniVal(nomef,"General","Author")
      resultTbl.NameDistro = rfx_GetIniVal(nomef,"General","Name")
      resultTbl.FileMajorPart = rfx_GetIniVal(nomef,"SciTE","MajorSciTE")
      resultTbl.FileMinorPart = rfx_GetIniVal(nomef,"SciTE","MinorSciTE")
      resultTbl.FileBuildPart = rfx_GetIniVal(nomef,"SciTE","BuildSciTE")
      resultTbl.FilePrivatePart = "" --non definito
      resultTbl.Distro = rfx_GetIniVal(nomef,"RSciTE","Major")
      resultTbl.AddPart = "" --non definito
      resultTbl.Url = rfx_GetIniVal(nomef,"RSciTE","WebRSciTE")
      resultTbl.UrlUpg = rfx_GetIniVal(nomef,"RSciTE","Download")
      resultTbl.AuthorUrl = rfx_GetIniVal(nomef,"General","Web")
      resultTbl.IniOnline = rfx_GetIniVal(nomef,"RSciTE","IniOnline")      
      resultTbl.DownloadFile = rfx_GetIniVal(nomef,"RSciTE","DownloadFile")
      
      return resultTbl 
    end
    
    --legge l'elenco dei valori contenuti in una sezione di un file INI
    function rfx_GetIniSec(nomeFile, sezione)
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
        for linea in idf:lines() do
          lineaCorrente = rfx_Trim(linea)
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
        idf:close()
      end --endif
      return inValore
    end --endf
 
     --legge un valore da un file INI
    function rfx_GetIniVal(nomeFile, sezione, valore)
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
        for linea in idf:lines() do
          lineaCorrente = rfx_Trim(linea)
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
    end --endf

    --Questa funzione accetta l'indice della frase da restituire,
    --presente nel file di traduzione
    function _t(indice)
      local result
      local nomeFileTradEn = "locale-en.properties" --inglese
      local nomeFileTradIt = "locale.properties" --non inglese

      if (PUBLIC_nomeFileTrad == "") then
        if rfx_fileExist(props["SciteDefaultHome"].."/luascr/"..nomeFileTradIt) then
          -- italiano
          PUBLIC_nomeFileTrad = props["SciteDefaultHome"].."/luascr/"..nomeFileTradIt
        else
          -- inglese
          PUBLIC_nomeFileTrad = props["SciteDefaultHome"].."/luascr/"..nomeFileTradEn
        end 
      end
      
      result = rfx_GetIniVal(PUBLIC_nomeFileTrad,"",tostring(indice))
      
      result = string.gsub(result,"\\n","\n")
      result = string.gsub(result,"\\r","\r")
      
      return result
    end
    
    --ritorna le chiavi del registro dedicate a contenere le
    --impostazioni del software
    --Il parametro, di tipo stringa, 
    --permette di ottenere una Chiave specifica :
    --"HOME" chiave principale
    --"DIALOGS" opzioni impostazione maschere
    --"TMP" opzioni di altro genere, temporanee e non rilevanti
    function rfx_Get_Registry_Key(chiaveRichiesta)
      local result = false
      local main = "software\\RSciTE"
      local datiVersione
      local versione = ""
      local richiesta = ""
      
      --versione distribuzione
      datiVersione = rfx_GetVersionTable()
      versione = tostring(datiVersione.Distro)
      --versione = rfx_GetIniVal(props["SciteDefaultHome"].."/distro.ini",
      --                         "Generale", "vDistribuzione")
      
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
    end
    
    --List Box standard.
    --Questa dialog sarà posizionata al centro dello schermo.
    --Viene mantenuto l'ultimo elemento eseguito, associato a nomeProcedura
    -- Se getLast è true, viene restituita l'ultima voce selezionata
    -- dall'utente, senza aprire la dialog
    function rwfx_ShowList_presel(lista,titolo,nomeProcedura,getLast)
      local i
      local sel
      local key = ""
            
      key = rfx_Get_Registry_Key("TMP")
      
      sel = rwfx_RegGetInteger(key, "showList."..nomeProcedura, "HKCU")
      if not(sel) then
        sel = 0
      end
      
      if (not(getLast)) then
        i = rwfx_c_ListBox(lista,titolo,false,-1,-1,0,0,true,"",sel)
        if i then
          rwfx_RegSetInteger(key, "showList."..nomeProcedura, i)
        end
      else
        i = sel
      end
      return i
    end

    --List Box standard.
    --Questa dialog sarà posizionata al centro dello schermo.
    function rwfx_ShowList(lista,titolo)
      return rwfx_c_ListBox(lista,titolo,false,-1,-1,0,0,true,"",0)
    end
    
    --List Box standard.
    --Questa dialog è come la precedente ma con posizionamento variabile
    --TODO : la finestra consente di essere posizionata fuori dal video!
    function rwfx_ShowList_Pos(lista,titolo,x,y)
      return rwfx_c_ListBox(lista,titolo,false,x,y,0,0,true,"",0)
    end
    
    --List Box standard.
    --Questa dialog sarà posizionata al centro dello schermo la prima volta
    --che viene visualizzata, per le volte seguenti verrà posizionata la 
    --dove è stata chiusa, mantenendo anche le dimensioni.
    --Al contrario della funzione standard è richiesto il nome univoco della
    --maschera che si apri.
    function rwfx_ShowList_Repos(lista,titolo,nomeProcedura, getLast)
      local i
      local sel
      local ListDimensionX
      local ListDimensionY
      local ListPositionX
      local ListPositionY
      local key = ""
      local maxValue = 60000
            
      key = rfx_Get_Registry_Key("TMP")
      
      sel = rwfx_RegGetInteger(key, "showList."..nomeProcedura, "HKCU")
      ListDimensionX = rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListDimensionX", "HKCU")
      if not(ListDimensionX) then 
        ListDimensionX = 400 
      end
      ListDimensionY = rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListDimensionY", "HKCU")
      if not(ListDimensionY) then 
        ListDimensionY = 400
      end
      ListPositionX = rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListPositionX", "HKCU")
      if (ListPositionX) then
        if (ListPositionX > maxValue) then ListPositionX = 0 end
      else
        ListPositionX = -1
      end
      ListPositionY = rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListPositionY", "HKCU")
      if (ListPositionY) then
        if (ListPositionY > maxValue) then ListPositionY = 0 end
      else
        ListPositionY = -1
      end
      if not(sel) then
        sel = 0
      end
      if (not(getLast)) then
        i = rwfx_c_ListBox(lista,titolo,
                           true,
                           ListPositionX,ListPositionY,
                           ListDimensionX,ListDimensionY,
                           false,
                           key.."\\showList."..nomeProcedura,
                           sel)
        if i then
          rwfx_RegSetInteger(key, "showList."..nomeProcedura, i)
        end
      else
        i = sel
      end
      --print("--")
      --print(rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListDimensionX", "HKCU"))
      --print(rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListDimensionY", "HKCU"))
      --print(rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListPositionX", "HKCU"))
      --print(rwfx_RegGetInteger(key.."\\showList."..nomeProcedura,"ListPositionY", "HKCU"))
      
      return i
      
      --return rwfx_c_ListBox(lista,titolo,true,-1,-1,0,0,false,dialogName,0)
    end

    --ritorna la traduzione della stringa data, estraendola dal file 
    --delle traduzioni delle macro
    --(props["SciteDefaultHome"].."/luascr/loclua.properties")
    --N.b.:nel caso non sia presente, il file delle traduzioni o la
    --stringa cercata, verrà restituita quest'ultima
    
    -- TODO : funzione da eliminare dopo la traduzione del software
    function rfx_GetStr(stringa)
      local nomeFile = props["SciteDefaultHome"].."/luascr/locluaen.properties"
      local inStringa = ""
      local inValore = ""
      local pos = nil
      local linea = ""
      local idf
      
      if (rwfx_isEnglishLang()) then --se è in inglese 
        idf = io.open(nomeFile, 'r')
        if idf then
          for linea in idf:lines() do
            pos = string.find(linea,"=")
            if pos then
              inStringa = string.sub(linea,1, pos -1)
              if (inStringa == stringa) then
                inValore = string.sub(linea,pos + 1)
                break
              end
            end
          end
          idf:close()
        end --if idf
      end --if traduzione
      
      if (inValore == "") then
        inValore = stringa
      end
      return inValore
    end --end rfx_GetStr

    --ritorna l'ultimo carattere della stringa data
    function rfx_LastCH (s)
      local i=string.len(s)
      return string.sub(s,i,i)
    end
    
    --rimuove l'eventuale ritorno a capo presente nella stringa data
    --e ritorna la stringa senza ritorni a capo
    function rfx_RemoveReturnLine(s)
      local a=""
      local lung=0
      
      lung = string.len(s)
      if rfx_LastCH(s)=="\r" then
        a = string.sub(s,1,lung-1)
        lung = string.len(a)
        if rfx_LastCH(a)=="\n" then
          a = string.sub(a,1,lung-1)
        end
      elseif rfx_LastCH(s)=="\n" then
        a = string.sub(s,1,lung-1)
        lung = string.len(a)
        if rfx_LastCH(a)=="\r" then
          a = string.sub(a,1,lung-1)
        end
      else
        a = s
      end  
    return a
    end

    -- splitta le linee che compongono il modello e ritorna una tabella
    function rfx_Split ( linea, separatore )
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
    function rfx_UserFolderRSciTE()
      local nomed
      --nomed = props["SciteUserHome"].."\\.rscite"
      nomed = os.getenv("APPDATA").."\\RScite"
      
      --controllo esistenza cartella temporanea programma ed eventuale creazione
      if (not(rwfx_PathIsDirectory(nomed.."\\tmp"))) then
        rwfx_createDirectory(nomed)
        rwfx_createDirectory(nomed.."\\tmp")
      end

      return nomed
    end
    
    -- ritorna il nome di un file temporaneo utilizzabile
    function rfx_getTmpFilePath()
      local filename = os.tmpname()
      filename = os.getenv("TMP")..filename
      return filename
    end

    --Ritorna la cartella in cui memorizzare i file relativi all'utente
    --corrente. es.:C:\Users\roberto\AppData\Local\Temp\.rscite
    --In aggiunta, controlla se la cartella non esiste, in tal caso 
    -- viene creata. 
    --Questa funzione controlla anche la presenza della sottocartella tmp
    function rfx_UserTmpFolderRSciTE()
      local nomed
      nomed = os.getenv("APPDATA").."\\RScite"
      
      --controllo esistenza cartella temporanea programma ed eventuale creazione
      if (not(rwfx_PathIsDirectory(nomed.."\\tmp"))) then
        rwfx_createDirectory(nomed)
        rwfx_createDirectory(nomed.."\\tmp")
        nomed = nomed.."\\tmp"
      end

      return nomed
    end
    
    --ritorna il nome del file standard di interscambio stringhe 'sciteStr.tmp'
    function rfx_FN()
      local nomef
      nomef = os.getenv("TMP")
      nomef = nomef.."\\sciteStr.tmp"
      return nomef
    end 

    --ritorna il contenuto del file temporaneo standard 'sciteStr.tmp'
    function rfx_GF()
      local nomef = rfx_FN()
      local result = ""
      local idf
      
      idf = io.open(nomef, "r")
      if (idf) then
        result = idf:read("*a")    
        io.close(idf)
      end

      return result
    end
    
    --scrive il testo specificato nel file temporaneo di scite, ritornando
    --true se l'operazione va a buon fine
    function rfx_WF(testo)
      local nomef = rfx_FN()
      local result = false
      local idf
      
      idf = io.open(nomef, "w")
      if (idf) then
        idf:write(testo)
        io.close(idf)
        result = true
      end

      return result
    end
    
    --rimuove il file temporaneo standard 'sciteStr.tmp'
    -- Specificando True sul parametro, si ottiene, dopo la cancellazione
    -- la generazione di un nuovo file vuoto
    function rfx_RF(overwrite)
      local result = os.remove(rfx_FN())
      
      if (overwrite) then
        rfx_WF("Null File")
      end
      
      return result
    end
    
    --legge il nome del progetto selezionato
    function rfx_readPathPrj()
      local nomef = rfx_FN()
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
    end
    
    --scrive il nome del progetto precedentemente salvato
    function rfx_savePathPrj(path)
      local nomef = rfx_FN()
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
    end

    --Ritorna il nome del file di abbreviazioni legato al tipo di file corrente.
    --Se non è stato trovato il file relativo al tipo di file corrente,
    --ritorna il file comune abbrev.properties
    --
    --I tipo supportati (per ora) sono :
    --  alisp
    --  lua
    --  php
    --  vb
    function rfx_getCurrent_abbrev_file()
      local result
      local patterns=""
      local variable
      local estensione    
      
      estensione = string.lower(props['FileExt'])
      
      estensione = '*.'..estensione
      
      if (estensione == '*.') then
        patterns = "default"
      elseif (string.find(props['file.patterns.markdown'],estensione,1,true)) then
        patterns = 'file.patterns.markdown'
      elseif (string.find(props['file.patterns.lisp'],estensione,1,true)) then
        patterns = 'file.patterns.lisp'
      elseif (string.find(props['file.patterns.alisp'],estensione,1,true)) then
        patterns = 'file.patterns.alisp'
      --elseif (string.find(props['file.patterns.dcl'],estensione,1,true)) then
      --  patterns = 'file.patterns.dcl'
      elseif (string.find(props['file.patterns.php'],estensione,1,true)) then
        patterns = 'file.patterns.php'
      elseif (string.find(props['file.patterns.vb'],estensione,1,true)) then
        patterns = 'file.patterns.vb'
      elseif (string.find(props['file.patterns.lua'],estensione,1,true)) then
        patterns = 'file.patterns.lua'
      elseif (string.find(props['file.patterns.css'],estensione,1,true)) then
        patterns = 'file.patterns.css'
      elseif (string.find(props['file.patterns.latex'],estensione,1,true)) then
        patterns = 'file.patterns.latex'
      elseif (string.find(props['file.patterns.sql'],estensione,1,true)) then
        patterns = 'file.patterns.sql'
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
    end

    --esegue un quansiasi programma e ritorna il suo output
    function rfx_exeCapture(cmd)
        local fin = assert(io.popen(cmd, 'r'))
        local content = assert(fin:read('*a'))
        fin:close()
      return content
    end

    --ritorna true se è presente un runtime di Java
    function rfx_javaExist ()
      local java

      java = rfx_exeCapture("reg query \"HKLM\\Software\\JavaSoft\\Java Runtime Environment\"")
      
      if (java == "") then
        return false;
      else
        return true;
      end
    end

  --ritorna una tabella contenente lo stato delle versioni di .net installate, es :
  -- {
  -- v11 = true,
  -- v2 = true,
  -- v3 = true,
  -- v35 = true,
  -- v4 = true
  -- }
  function rfx_dotNetExist()
    local v11 = nil
    local v20 = nil
    local v30 = nil
    local v35 = nil
    local v40 = nil
    local result = {}
    
    v11 = rwfx_RegGetInteger("software\\microsoft\\net framework setup\\ndp\\v1.1.4322","Install","HKLM")
    v20 = rwfx_RegGetInteger("software\\microsoft\\net framework setup\\ndp\\v2.0.50727","Install","HKLM")
    v30 = rwfx_RegGetInteger("software\\microsoft\\net framework setup\\ndp\\v3.0","Install","HKLM")
    v35 = rwfx_RegGetInteger("software\\microsoft\\net framework setup\\ndp\\v3.5","Install","HKLM")
    v40 = rwfx_RegGetInteger("software\\microsoft\\net framework setup\\ndp\\v4\\Client","Install","HKLM")
    
    if (v11) then
      result.v11 = true
    else
      result.v11 = false
    end
    if (v20) then
      result.v2 = true
    else
      result.v2 = false
    end
    if (v30) then
      result.v3 = true
    else
      result.v3 = false
    end
    if (v35) then
      result.v35 = true
    else
      result.v35 = false
    end
    if (v40) then
      result.v4 = true
    else
      result.v4 = false
    end
    
    return result
  end --end exist .net
    
  --dato un percorso, restituisce una tabella contenente le cartelle 
  --presenti nel percorso stesso. Es.  C:\a\b\c\d\
  --  dovrebbe generare la tabella contenente :
  --      c:\a\b\c\d\
  --      c:\a\b\c\
  --      c:\a\b\
  --      c:\a\
  -- Se il percorso specificato non è un percorso valito, ritorna false
  function rfx_explodePath(path)
    local result = false
    local dati
    local i
    local id = 0
    local v
    local linea = ""
    
    if (rwfx_PathIsDirectory(path)) then
    --if (true) then
      --normalizzazione path
      path = string.gsub(path, "/", "\\")
      if (rfx_LastCH(path) ~= "\\") then
        path = path.."\\"
      end
      
      dati = rfx_Split(path,"\\")
      
      for i,v in ipairs(dati) do
        if (v ~= "") then
          if (linea == "") then
            linea = v
          else
            linea = linea.."\\"..v
          end
          
          --inserimento in tabella
          if (not(result)) then
            result = {}
          end
          if (string.sub(path,0,2) == "\\\\") then
            result[id] = "\\\\"..linea.."\\"
          else
            if (string.sub(path,1,2) == ":") then 
              result[id] = linea.."\\" --percorso standard con nome disco
            elseif (string.sub(path,0,1) == "\\") then --percorso assoluto senza disco
              result[id] = "\\"..linea.."\\"
            else --altro percorso
              result[id] = linea.."\\"
            end
          end
          id = id + 1
          
        end
      end
      
    end
    return result
  end --endfunction

  --Questa funzione concatena due tabelle restituendone
  --una che rappresenta la somma delle due passate come
  --parametro. Entrambe le tabelle hanno indice da 1 a n.
  --Altri tipi di tabella non sono supportati. Nel caso in cui
  --i dati passati non siano tabelle, questi verranno ignorati
  --TODO : utilizzare eventuali dati non di tipo tabella
  --       concatenandoli ugualmente e generando una tabella
  --       risultante
  function rfx_concatTables(table1, table2)
  local i = 0

    -- preparazione dati in ingresso
    if (type(table1) ~= "table") then
      table1 = {}
    end
    if (type(table2) ~= "table") then
      table2 = {}
    end

    i = #table1
    for k,v in pairs(table2) do 
      table1[i+1] = v
      i = i + 1
    end
    return table1
  end --endfunction

  --semplice funzione per la copia di un piccolo file di testo
  -- ritorna true nel caso la copia sia riuscita, false in caso contrario
  function rfx_fileCopy(source, destination)
    local result = false
    local idf
    local text = ""
    
    if (rfx_fileExist(source)) then
      idf = io.open(source, "r")
      if (idf) then
        text = idf:read("*a") --lettura sorgente
        io.close(idf)
        
        idf = io.open(destination, "w")--scrittura destination
        if (idf) then
          result = idf:write(text)
          io.close(idf)
          result = true
        end        
      end
    end
    
    return result
  end

  --cerca il file specificato in tutte le cartelle elencate dalla variabile di
  --sistema PATH. Non considera la cartella corrente
  --Ritorna il percorso completo del file oppure 
  function rfx_findFileInPath(fileName)
    local globalPath = os.getenv("PATH")
    local tblPaths = rfx_Split(globalPath, ";")
    local i
    local v
    local part
    local result = nil
    
    for i,v in ipairs(tblPaths) do
      part = string.sub(v,-1)      
      if ((part=="\\") or (part=="/")) then
        v = v..fileName
      else
        v = v.."\\"..fileName
      end
      
      if rfx_fileExist(v) then
        result = v
      end
    end
    return result
  end
  
end --end if modulo
