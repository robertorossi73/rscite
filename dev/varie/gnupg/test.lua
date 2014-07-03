--[[
Author  : Roberto Rossi
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura, utilizzando OpenPGP consente la criptazione/decriptazione
dei file, utilizzando svariati algoritmi.

Attualmente consete :

- cripta/decripta con gli algoritmi 
  3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH

TODO :

- implementare criptazione/decripazione con chiave pubblica
- implementare criptazione/decripazione su più file
]]

do

  require("luascr/rluawfx")

  
  --ritorna il contenuto di un file e lo elimina dal disco
  function getAllFile(nomef)
    local result = ""
    local idf
    
    idf = io.open(nomef, "r")
    if (idf) then
      result = idf:read("*a")    
      io.close(idf)
      
      os.remove(nomef)
    end

    return result
  end

  --scrive un file batch temporaneo e ritorna il suo nome
  local function write_batTmpBatch(commandLine)
    local fname = rfx_getTmpFilePath()
    
    fname = fname..".bat"
    
    i = io.open(fname,"w")
        i:write(commandLine.."\n")
    io.close(i)
    
    return fname
  end
  
  --Esegue pgp usando parametri personalizzati.
  --In ogni caso redirige l'output su un file temporaneo.
  --Ritorna true se il processo ha avuto successo e il file temporaneo esiste
  --Se il comando fallisce, nessun file temporaneo verrà creato e la
  --  funzione ritornarà false
  local function exec_pgp(param, filein, fileout)
    local result = false
    local pgpexe = props["SciteDefaultHome"].."\\tools\\gpg\\gpg.exe"
    local batchName
    local parEncrypt = param.." -o \""..fileout.."\" \""..filein.."\""
    local cmdLine = "\""..pgpexe.."\" "..parEncrypt
    
    cmdLine = "echo off\ncls\n"
    cmdLine = cmdLine.."\""..pgpexe.."\" "..parEncrypt
    
    batchName = write_batTmpBatch(cmdLine)    
    
    --print(batchName)
    os.execute("\""..batchName.."\"")
    
    if (rfx_fileExist(fileout)) then      
      --TODO : eliminare file creato?
      --os.remove(fname)
      result = true
    else
      result = false
    end
    os.remove(batchName)
    
    return result
  end
  
  
  --permette all'operatore di selezionare il tipo di algoritmo da usare
  -- ritorna
  -- nil quando l'utente preme annulla, oppure uno di questo valori
  -- 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH
  local function getTipoAlgo ()
    local lista
    local id
    local scelta
    local tipo = false
    
    lista="3DES|CAST5|BLOWFISH|AES|AES192|AES256|TWOFISH"
    
    --TODO : da tradurre
    scelta = rwfx_ShowList(lista,"Algoritmo di Criptazione")
    
    if (scelta) then
      if (scelta==0) then
        tipo = "3DES"
      elseif (scelta==1) then
        tipo = "CAST5"
      elseif (scelta==2) then
        tipo = "BLOWFISH"
      elseif (scelta==3) then
        tipo = "AES"
      elseif (scelta==4) then
        tipo = "AES192"
      elseif (scelta==5) then
        tipo = "AES256"
      elseif (scelta==6) then
        tipo = "TWOFISH"
      end
    end
    
    return tipo
  end

  --cripta file corrente o altro file con chiave simmetrica  
  local function encrypt_c(cryptCurrentFile)
    local algo
    local password
    local filein
    local param = ""
    local fileout --= rfx_getTmpFilePath()
    local result = ""
    
    if (cryptCurrentFile) then
      filein = props["FilePath"]
    else
      -- TODO : tradurre
      filein = rwfx_GetFileName("Selezionare file da criptare/origine"
                                ,"", 0,rfx_FN())
    end
    

    if (filein) then
      filein = rfx_GF()
      -- TODO : tradurre
      fileout = rwfx_GetFileName("Selezionare nome file criptato/destinazione"
                                  ,"", 0,rfx_FN())
      if (fileout) then
        fileout = rfx_GF()
        
        --TODO : tradurre
        password = rwfx_InputBox("ParolaChiave", "Parola Chiave",
                                 "Inserire la parola chiave con la quale verrà criptato il file :",
                                 rfx_FN());
        if (password) then
          password = rfx_GF()        
          algo = getTipoAlgo()
          if (algo) then
            --param = "--cipher-algo "..algo.." -c --passphrase \""..password.."\""
            param = "--cipher-algo "..algo.." -c "
            result = exec_pgp(param, filein, fileout)
          end
        end --password
      end --fileout
    end --filein
    
    return result
  end

  --decripta file selezionato con chiave simmetrica e salva contenuto in nuovo
  --file che l'utente indicherà
  local function decrypt_c(noSaveDecrypted)
    local algo
    --local password
    local filein
    local param = ""
    local fileout --= rfx_getTmpFilePath()
    local result = ""
    local testo = ""
    
    --filein = props["FilePath"]
    -- TODO : tradurre
    filein = rwfx_GetFileName("Selezionare file criptato/origine"
                                ,"", 0,rfx_FN())
    if (filein) then
      filein = rfx_GF()
      
      if (noSaveDecrypted) then
        fileout = rfx_getTmpFilePath() --file temporaneo
      else
        -- TODO : tradurre
        fileout = rwfx_GetFileName("Selezionare nome file decriptato/destinazione"
                                    ,"", 0,rfx_FN())
      end
      
      if (fileout) then
        if not(noSaveDecrypted) then
          fileout = rfx_GF()
        end
        
        --TODO : tradurre
        --password = rwfx_InputBox("ParolaChiave", "Parola Chiave",
        --                         "Inserire la parola chiave con la quale verrà criptato il file :",
        --                         rfx_FN());
        --if (password) then
         -- password = rfx_GF()
          --algo = getTipoAlgo()
          --if (algo) then
            --param = "--cipher-algo "..algo.." -d --passphrase \""..password.."\""
            param = " -d "
            result = exec_pgp(param, filein, fileout)
            
            if (result and noSaveDecrypted) then
              testo = getAllFile(fileout)
              scite.MenuCommand(IDM_NEW)
              editor:ReplaceSel(testo)
            end
          --end
        --end --password
        
      end --fileout
    end --filein
    
    return result
  end
  
  local function main()
    
    --encrypt_c(false)
    print(decrypt_c(true))
  end
  
  

  main()
end
 