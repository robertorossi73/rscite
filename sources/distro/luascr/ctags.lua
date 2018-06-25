--[[
Author  : Roberto Rossi
Version : 1.1.7
Web     : http://www.redchar.net

Questa procedura fornisce all'utente l'elenco di funzioni, variabili e classi
presenti in un file, usando le funzioni di CTAGS
]]

do
  require("luascr/rluawfx")

  --data una lista di estensioni separata da ; (es.: *.vb;*.bas;*.frm;*.dob)
  --e un'estensione (es.: *.bas), ritorna true se questa è presente nell'elenco
  local function inExtentions (listExt, findExt)
    local result
    
    result = false
    
    listExt = string.lower(listExt)
    findExt = string.lower(findExt)
    if (listExt ~= "") then
      --cerca "*.xxx;"
      if (string.find(listExt,findExt..";",1,true)) then
        result = true --trovato
      else
        --cerca "*.xxx" come ultimo elemento della lista
        if (string.sub(listExt,-(string.len(findExt))) == findExt) then
          result = true --trovato
        end      
      end
    end
    
    return result
  end
  
  --permette all'operatore di selezionare il tipo di elemento da visualizzare
  -- nil = annulla
  -- "" = tutto
  -- "f" = solo funzioni
  -- "c" = solo classi
  -- "v" = solo variabili
  -- "save" = Salva file CTAG su disco
  local function getTipoRichiesta ()
    local lista
    local id
    local scelta
    local tipo = false
    
    --lista="Visualizza Tutti gli Elementi|Visualizza solo le Funzioni|Visualizza solo le Classi|Visualizza solo le Variabili|Salva file completo CTAGS"
    lista=_t(144)
    
    --scelta = rwfx_ShowList(lista,"CTAGS - Elementi da Elencare")
    scelta = rwfx_ShowList(lista,_t(145))
    
    if (scelta) then
      if (scelta==1) then
        tipo = "f"
      elseif (scelta==2) then
        tipo = "c"
      elseif (scelta==3) then
        tipo = "v"
      elseif (scelta==4) then
        tipo = "save"
      else
        tipo = ""
      end
    end
    
    return tipo
  end

  -- Ritorna il nome del linguaggio usato nel file corrente, da passare a CTAGS
  -- I linguaggi supportati da CTAGS sono :
  -- (ok)Asm, (ok)Asp, (ok)Awk, (ok)Basic, BETA, (ok)C, (ok)C++, (ok)C#
  -- (ok)Cobol, (ok)Eiffel, (ok)Erlang, (ok)Fortran,
  -- (ok)HTML, (ok)Java, (ok)JavaScript, (ok)Lisp, (ok)Lua, (ok)Make, 
  -- (ok)Pascal, (ok)Perl, (ok)PHP, (ok)Python
  -- REXX, (ok)Ruby, (ok)Scheme, (ok)Sh, SLang, SML, SQL, (ok)Tcl, Vera,
  -- (ok)Verilog, Vim, YACC
  -- Attenzione : solo quelli identificati con (ok) sono supportati
  local function getNomeLinguaggioCorrente()
    local result = ""
    local estensione
    
    estensione = string.lower(props['FileExt'])
    
    estensione = '*.'..estensione
    
    if (inExtentions(props['file.patterns.alisp'],estensione)) then
      result = 'Lisp'
    elseif (inExtentions(props['file.patterns.lisp'],estensione)) then
      result = 'Lisp'
    elseif (inExtentions(props['file.patterns.verilog'],estensione)) then
      result = 'Verilog'
    elseif (inExtentions(props['file.patterns.tcl.like'],estensione)) then
      result = 'Tcl'
    elseif (inExtentions(props['file.patterns.sql'],estensione)) then
      result = 'SQL'
    elseif (inExtentions(props['file.patterns.bash'],estensione)) then
      result = 'Sh'
    elseif (inExtentions(props['file.patterns.scheme'],estensione)) then
      result = 'Scheme'
    elseif (inExtentions(props['file.patterns.rb'],estensione)) then
      result = 'Ruby'
    elseif (inExtentions(props['file.patterns.py'],estensione)) then
      result = 'Python'
    elseif (inExtentions(props['file.patterns.perl'],estensione)) then
      result = 'Perl'
    elseif (inExtentions(props['file.patterns.pascal'],estensione)) then
      result = 'Pascal'
    elseif (inExtentions(props['file.patterns.php'],estensione)) then
      result = 'PHP'
    elseif (inExtentions(props['file.patterns.vb'],estensione)) then
      result = 'Basic'
    elseif (inExtentions(props['file.patterns.lua'],estensione)) then
      result = 'Lua'
    elseif (inExtentions(props['file.patterns.cplusplus'],estensione)) then
      result = 'C++'
    elseif (inExtentions(props['file.patterns.cpp'],estensione)) then
      result = 'C'
    elseif (inExtentions(props['file.patterns.cs'],estensione)) then
      result = 'C#'
    elseif (inExtentions(props['file.patterns.c.like'],estensione)) then
      result = 'Java'
    elseif (inExtentions("*.js",estensione)) then
      result = 'JavaScript'
    elseif (inExtentions(props['file.patterns.asm'],estensione)) then
      result = 'Asm'
    elseif (inExtentions(props['file.patterns.web'],estensione)) then
      result = 'Asp'
    elseif (inExtentions(props['file.patterns.html'],estensione)) then
      result = 'HTML'
    elseif (inExtentions(props['file.patterns.awk'],estensione)) then
      result = 'Awk'
    elseif (inExtentions(props['file.patterns.cobol'],estensione)) then
      result = 'Cobol'
    elseif (inExtentions(props['file.patterns.eiffel'],estensione)) then
      result = 'Eiffel'
    elseif (inExtentions(props['file.patterns.erlang'],estensione)) then
      result = 'Erlang'
    elseif (inExtentions(props['file.patterns.fortran'],estensione)) then
      result = 'Fortran'
    elseif (inExtentions(props['file.patterns.make'],estensione)) then
      result = 'Make'
    end
    
    return result
  end
  
  local function execCTAGS (tipo)
    local ch = ""
    local nomeFout = "" --file temporaneo di output dati
    local nomeFsource = props["FilePath"] --file sorgente da analizzare
    local linea = ""
    local linguaggio = ""
    local datiLinea = {}
    local i
    local n
    local tmpVar
    local tmpPath
    local tmpBat
    local pos1
    local pos2
    local sorgente
    local ctags_version = ""
    local ctags_url = ""
    local ctags_author = ""
    local ctags_name
    local tipoCorrente
    
    tmpPath = rfx_UserFolderRSciTE().."\\tmp"
    
    if (tipo=="save") then
       --nomeFout = rwfx_GetFileName("Seleziona File CTAGS da Salvare"
                              --,"", OFN_CREATEPROMPT,rfx_FN(),"CTAGS File (*.*)%c*.*")
       nomeFout = rwfx_GetFileName(_t(146)
                              ,"", OFN_CREATEPROMPT,rfx_FN(),"CTAGS Files (*.*)%c*.*")
      if nomeFout then
        nomeFout = rfx_GF()
      end
    else
      nomeFout = tmpPath.."\\ctags.txt"
    end
    
    if (nomeFout) then
      linguaggio = getNomeLinguaggioCorrente()
      
      linea = "\""..props["SciteDefaultHome"].."\\ctags.exe\" "..
              "--fields=+n --language-force="..linguaggio..
              " -f \""..nomeFout.."\" \""..nomeFsource.."\""
      tmpBat = tmpPath.."\\tmpscript.bat"
      i = io.open(tmpBat,"w")
        i:write("del \""..nomeFout.."\"\n")
        i:write(linea)
--        i:write("pause\n") --per debug
      io.close(i)
      
      os.execute("cmd /c \""..tmpBat.."\"")
      --rfx_exeCapture(tmpBat)
    end
    
    if (tipo == "save") then
      --salvataggio file, messaggi conclusivi
      if (nomeFout) then
        --if (rwfx_MsgBox("Si desidera Aprire il file '"..nomeFout.."' ?",
          --"Apertura file CTAGS", MB_YESNO) == IDYES) then
        
        if (rwfx_MsgBox(_t(147).." '"..nomeFout.."' ?",
          _t(148), MB_YESNO) == IDYES) then
          scite.Open(nomeFout)
        end
      end
    else --lista elementi standard in pannello di output
      --scite.MenuCommand(420)--IDM_CLEAROUTPUT
      scite.MenuCommand(IDM_CLEAROUTPUT)
      
      i = io.open(nomeFout)
      if (i) then
        io.close(i)
        i=1
        for linea in io.lines(nomeFout) do 
          if (linea ~= "") then
            ch = string.sub(linea,1,1)
            if (ch ~= "!") then
              pos1 = string.find(linea,"/^")
              if (pos1) then
                pos2 = string.find(linea,"$/;")
                sorgente = string.sub(linea,pos1,pos2+2)
                linea=string.sub(linea,1,pos1)..string.sub(linea,pos2)
              else
                pos1 = string.find(linea,";\"")
                pos2 = string.find(linea,"\t")
                sorgente = string.sub(linea,1,pos2)
              end
              datiLinea[i]=rfx_Split(linea,"\t")
              datiLinea[i][3]=sorgente
              --print(datiLinea[i][1]) --nome tag
              --print(datiLinea[i][2]) --file
              --print(datiLinea[i][3]) --linea
              --print(datiLinea[i][4]) --tipo tab (f=funzione, v=variabili, c=classi)
              --print(datiLinea[i][5]) --linea (es.: line:15)        
              i = i + 1
            else
              --visualizzazione informazioni            
              if (string.sub(linea,1,20) == "!_TAG_PROGRAM_AUTHOR") then
                ctags_author = string.sub(linea,21)
              elseif (string.sub(linea,1,21) == "!_TAG_PROGRAM_VERSION") then
                ctags_version = string.sub(linea,22)
              elseif (string.sub(linea,1,18) == "!_TAG_PROGRAM_NAME") then
                ctags_name = string.sub(linea,19)
              elseif (string.sub(linea,1,17) == "!_TAG_PROGRAM_URL") then
                ctags_url = string.sub(linea,18)
              end            
            end
          end
        end
        
        print("-- ".. string.gsub(ctags_name, "//", "")..
              " V."..string.gsub(ctags_version, "//", "")..
              "\n--- "..string.gsub(ctags_author, "/", "-")..
              "\n--- "..ctags_url
              )
        print(" Language : "..linguaggio);
        
        if (tipo=="") then
          --print("------------ Elenco Classi,Funzioni,Variabili in file Corrente ------------")
          print("------------ ".._t(149).." ------------")
        elseif (tipo=="c") then
          --print("------------ Elenco Classi in file Corrente ------------")
          print("------------ ".._t(150).." ------------")
        elseif (tipo=="f") then
          --print("------------ Elenco Funzioni in file Corrente ------------")
          print("------------ ".._t(151).." ------------")
        elseif (tipo=="v") then
          --print("------------ Elenco Variabili in file Corrente ------------")
          print("------------ ".._t(152).." ------------")
        end
        --print("-- Numero Elementi trovati : "..#datiLinea)
        print("-- ".._t(153).." : "..#datiLinea)
        for i=1, #datiLinea, 1 do
          tmpVar = rfx_Split(datiLinea[i][5],":")
          n = tmpVar[2] --numero linea
          linea = datiLinea[i][3]
          linea = string.gsub(linea,"/^","")
          linea = string.gsub(linea,"$/;","")
          linea = rfx_Trim(linea)
          if not(n) then
            n = ""
          end
          
          tipoCorrente = datiLinea[i][4]
          if ((tipo == "") or (tipoCorrente == tipo)) then
            if (tipoCorrente == "f") then
              tipoCorrente = "F" --funzione
            elseif (tipoCorrente == "c") then
              tipoCorrente = "C" --class
            elseif (tipoCorrente == "d") then
              tipoCorrente = "D" --define
            elseif (tipoCorrente == "v") then
              tipoCorrente = "V" --variabili
            else
              tipoCorrente = "\t"
            end
            --print(":"..n..": ".._t(154).."="..tipoCorrente.." : "..linea)
            print(":"..n..":"..tipoCorrente.."-"..linea)
          end
        end      
      end --endif
    end --endif save, standard 
    
    if (linguaggio=="") then
      print("Language Not supported")
    end
  end --endfunction
  
  local function main()
    local tipo
    local flagOk
    
    tipo = getTipoRichiesta()
    
    if (tipo) then
      execCTAGS(tipo)
    end
  end

  
  main()
  
  
end 
