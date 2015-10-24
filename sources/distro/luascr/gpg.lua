--[[
Autore  : Roberto Rossi
Version : 1.0.0
Web     : http://www.redchar.net

Modulo per criptazione/deccriptazione file

Questo modulo consente la criptazione e la decriptazione dei file.

Il software basa il suo funzionamento sull'utilità libera GnuPG

Funzioni da implementare
- criptazione file con password
- decriptazione file con password
- decriptazione per sola consultazione

Copyright (C) 2015 Roberto Rossi 
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

-- props["rscite.gpg.tmppass"] variabile globale adibita alla memorizzazione 
-- dell'ultima password utilizzata

do
    require("luascr/rluawfx")

    local function decrypt(pass, outputFile)
        local testo = ""
        local exePath = "\""..props["SciteDefaultHome"].."\\tools\\gpg\\GPG.exe\""
        local localFile = props["FilePath"]
        local commandLine = exePath.." --cipher-algo AES -d --output \""..
                            outputFile.."\" --passphrase \""..pass.."\" \""..localFile.."\""

        testo = rfx_exeCapture("cmd /C \""..commandLine.."\"")
    end
    
    local function decryptReadOnly(pass)
        local testo = ""
        local exePath = "\""..props["SciteDefaultHome"].."\\tools\\gpg\\GPG.exe\""
        local localFile = props["FilePath"]
        local commandLine = exePath.." --cipher-algo AES -d --passphrase \""..pass.."\" \""..localFile.."\""

        testo = rfx_exeCapture("cmd /C \""..commandLine.."\"")
        scite.Open("")
        editor:AddText(testo)
        scite.MenuCommand(IDM_READONLY)
    end
    
    local function cryptASCFile(pass)
        local exePath = props["SciteDefaultHome"].."\\tools\\gpg\\GPG.exe"
        local localFile = props["FilePath"]
        local commandLine = "--cipher-algo AES -c --armor --passphrase \""..pass.."\" \""..localFile.."\""

        rfx_exeCapture("cmd /C \"\""..exePath.."\" "..commandLine.."\"")        
    end

    --chiede il nome del file di destionazione decriptato ed effettua la decriptazione
    local function saveAsDecrypt (password)
        local startDecrypt = false
        local outFile = ""
        local ok
        local OFN_OVERWRITEPROMPT = 2
        local localFile = props["FilePath"]
        local ext = string.upper(string.sub(localFile,-4))
        
        if (ext == ".ASC") then
            outFile = props["FileDir"].."\\"..props["FileName"]
            --TODO : da tradurre
            if (rwfx_MsgBox("Salvare il file decriptato in \n"..outFile,"Salva file in...",MB_YESNO ) == IDNO ) then
                outFile = ""
            end
        end
        
        if (outFile == "") then
            --TODO : da tradurre
            ok = rwfx_GetFileName("Selezionare File Decriptato",props["FileDir"], 
                                    OFN_OVERWRITEPROMPT,rfx_FN(),"All Files (*.*)%c*.*")
            if ok then
              outFile = rfx_GF()
            end
        end
        
        if (outFile ~= "") then
            if (rfx_fileExist(outFile)) then
                ok = os.remove(outFile)
                if (not(ok)) then
                    --TODO : traduzione
                    print("\nImpossibile sovrascrivere il file "..outFile)
                end
            end
            
            if (ok) then
                decrypt(password, outFile)                
                if (rfx_fileExist(outFile)) then
                --TODO : da tradurre
                    if (rwfx_MsgBox("Si desidera aprire il file decriptato \n"..outFile,
                                    "Apertura file",MB_YESNO ) == IDYES ) then
                        scite.Open(outFile)
                    end
                else
                    --TODO : da tradurre
                    print("\nImpossibile creare il file "..outFile)
                end--exist
            end --ok
        end
        
    end
    
    --verifica se il file corrente è salvato, avvisa l'utente e salva
    --ritorna true se il file è stato salvato, false in caso contrario
    local function checkSavedFile()
        local result = true
        
        --file modificato
        if (editor.Modify) then
            output:ClearAll()
            --TODO : da tradurre
            print("\nImpossibile continuare. Il file corrente non è salvato. Procedere al salvataggio e riprovare.")
            result = false
        end        
        return result
    end
    
    local function checkPasswords(psw1, psw2)
        local result = true
        
        if (psw1 ~= psw2) then
            --TODO : da tradurre
            print("Impossibile continuare, le password immesse sono differenti!")
            result = false
        end
        
        if (psw1 == "")then
            --TODO : traduzione
            print("Impossibile continuare. E' necessario specificare una password!")
            result = false
        end 
        
        return result
    end
    
    --verifica la presenza e la scrivibilità del file specificato e chiede all'utente se
    --  vuole sovrascriverlo, ritornando il risultato
    -- nel caso l'utente voglia sovrascriverlo, il file viene cancellato
    local function checkDestination(fileName)
        local result = false        
        if (rfx_fileExist(fileName)) then
            --TODO : traduzione
            if (rwfx_MsgBox("Sovrascrivere file \n"..fileName,"Sovrascrivere",MB_YESNO ) == IDYES ) then
                result = os.remove(fileName)
                if (result) then
                    result = true
                else
                    --TODO : traduzione
                    print("\nImpossibile eliminare il file!")
                    result = false
                end
            end
        else
            result = true
        end
        
        return result
    end
    
    --button ok
    function buttonOk_click(control, change)
        --TODO : lettura elementi da file di traduzione
        local gpg_fxs = "Decripta file corrente con password per sola lettura"..
                        ";Decripta file corrente con password"..
                        ";Cripta file corrente con password"
        local val = wcl_strip:getValue("VAL")
        local password = wcl_strip:getValue("PASSW")
        local password1 = wcl_strip:getValue("PASSW1")
        local localFile = props["FilePath"]
        local localFileASC = props["FilePath"]..".asc"
        
        wcl_strip:close()

        if (not(props["rscite.gpg.tmppass"] == "") and 
            string.find(password,  "********", 1 , true) and
            string.find(password1, "********", 1 , true)
            ) then
            password = props["rscite.gpg.tmppass"]
            password1 = props["rscite.gpg.tmppass"]
        end
        
        gpg_fxs = rfx_Split(gpg_fxs,";")
        if (val == gpg_fxs[1]) then --decriptazione temporanea
            --print("0 -- "..val)
            if (checkPasswords(password, password)) then
                decryptReadOnly(password)
                props["rscite.gpg.tmppass"] = password
            end
        elseif (val == gpg_fxs[2]) then
            --print("- 1 -- "..val)
            if (checkPasswords(password, password1)) then
                saveAsDecrypt(password)
            end
        elseif (val == gpg_fxs[3]) then --criptazione file corrente
            if (checkPasswords(password, password1)) then
                if (checkDestination(localFileASC)) then
                    if (checkSavedFile()) then
                        cryptASCFile(password)
                        props["rscite.gpg.tmppass"] = password
                        --TODO : da tradurre
                        if (rwfx_MsgBox("Si desidere eliminare il file corrente?"..
                                        "\nFile criptato creato in : \n"..localFileASC..
                                        "\n con password : "..password,
                                        "Eliminazione File",MB_YESNO + MB_DEFBUTTON2) == IDYES ) then
                            os.remove(localFile)
                            scite.MenuCommand(IDM_CLOSE)
                        end
                        --TODO : da tradurre
                        if (rwfx_MsgBox("Si desidere aprire il file criptato \n"..localFileASC,
                                        "Apertura file",MB_YESNO ) == IDYES ) then
                            scite.Open(localFileASC)
                        end
                    end --end checkSavedFile
                end  --end checkDestination
            end --end checkPasswords
        end

    end
  
    local function main()
        local nguid
        local opzioni
        local testo
        local dest    
        local old_pass

        --TODO : lettura elementi da file di traduzione
        local gpg_fxs = "Decripta file corrente con password per sola lettura"..
                        ";Decripta file corrente con password"..
                        ";Cripta file corrente con password"
                        
        if (not(props["rscite.gpg.tmppass"] == "")) then
            old_pass = "********"
        else
            old_pass = ""
        end

        gpg_fxs = rfx_Split(gpg_fxs,";")
        
        dest = rfx_FN()

        if (rfx_GetGUID(dest)) then
            testo = string.lower(rfx_GF())

            wcl_strip:init()      
            wcl_strip:addButtonClose()
            
            --TODO : traduzione
            wcl_strip:addLabel(nil, "Password: ")
            wcl_strip:addText("PASSW",old_pass, nil)
            --TODO : traduzione
            wcl_strip:addLabel(nil, "Funzione ")
            wcl_strip:addCombo("VAL")
            wcl_strip:addSpace()
            wcl_strip:addNewLine()
            
            --TODO : traduzione
            wcl_strip:addLabel(nil, "Conferma Password: ")
            wcl_strip:addText("PASSW1",old_pass, nil)
            wcl_strip:addSpace()
            --TODO : traduzione
            wcl_strip:addButton("OK","Esegui operazione",buttonOk_click, true)
            
            wcl_strip:show()

            wcl_strip:setList("VAL", gpg_fxs)
            wcl_strip:setValue("VAL", gpg_fxs[1])
        end
    end
  
  main()
  
end
