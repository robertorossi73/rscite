--[[
Autore  : Roberto Rossi
Version : 1.0.8
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
            --if (rwfx_MsgBox("Salvare il file decriptato in \n"..outFile,"Salva file in...",MB_YESNO ) == IDNO ) then
            if (rwfx_MsgBox(_t(344)..outFile,_t(345),MB_YESNO ) == IDNO ) then
                outFile = ""
            end
        end
        
        if (outFile == "") then
            --ok = rwfx_GetFileName("Selezionare File Decriptato",props["FileDir"], 
            --                        OFN_OVERWRITEPROMPT,rfx_FN(),"All Files (*.*)%c*.*")
            ok = rwfx_GetFileName(_t(346),props["FileDir"], 
                                    OFN_OVERWRITEPROMPT,rfx_FN(),_t(347))
            if ok then
              outFile = rfx_GF()
            end
        end
        
        if (outFile ~= "") then
            if (rfx_fileExist(outFile)) then
                ok = os.remove(outFile)
                if (not(ok)) then
                    --print("\nImpossibile sovrascrivere il file "..outFile)
                    print(_t(348).." "..outFile)
                end
            else
                ok = true
            end
            
            if (ok) then
                decrypt(password, outFile)                
                if (rfx_fileExist(outFile)) then
                    --if (rwfx_MsgBox("Si desidera aprire il file decriptato \n"..outFile,
                    --                "Apertura file",MB_YESNO ) == IDYES ) then
                    if (rwfx_MsgBox(_t(349)..outFile,
                                    _t(350),MB_YESNO ) == IDYES ) then
                        scite.Open(outFile)
                    end
                else
                    --print("\nImpossibile creare il file "..outFile)
                    print(_t(351).." "..outFile)
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
            --print("\nImpossibile continuare. Il file corrente non è salvato. Procedere al salvataggio e riprovare.")
            print(_t(352))
            result = false
        end        
        return result
    end
    
    local function checkPasswords(psw1, psw2)
        local result = true
        
        if (psw1 ~= psw2) then
            --print("Impossibile continuare, le password immesse sono differenti!")
            print(_t(353))
            result = false
        end
        
        if (psw1 == "")then
            --print("Impossibile continuare. E' necessario specificare una password!")
            print(_t(354))
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
            --if (rwfx_MsgBox("Sovrascrivere file \n"..fileName,"Sovrascrivere",MB_YESNO ) == IDYES ) then
            if (rwfx_MsgBox(_t(355)..fileName,_t(356),MB_YESNO ) == IDYES ) then
                result = os.remove(fileName)
                if (result) then
                    result = true
                else
                    --print("\nImpossibile eliminare il file!")
                    print(_t(357))
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
        --local gpg_fxs = "Decripta file corrente con password per sola lettura"..
        --                ";Decripta file corrente con password"..
        --                ";Cripta file corrente con password"
        local gpg_fxs = _t(358)..
                        _t(359)..
                        _t(360)
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
                        --if (rwfx_MsgBox("Si desidere eliminare il file corrente?"..
                        --                "\nFile criptato creato in : \n"..localFileASC..
                        --                "\n con password : "..password,
                        --                "Eliminazione File",MB_YESNO + MB_DEFBUTTON2) == IDYES ) then
                        if (rwfx_MsgBox(_t(361)..
                                        _t(362)..localFileASC..
                                        _t(363).." "..password,
                                        _t(364),MB_YESNO + MB_DEFBUTTON2) == IDYES ) then
                            os.remove(localFile)
                            scite.MenuCommand(IDM_CLOSE)
                        end
                        --if (rwfx_MsgBox("Si desidere aprire il file criptato \n"..localFileASC,
                        --                "Apertura file",MB_YESNO ) == IDYES ) then
                        if (rwfx_MsgBox(_t(365)..localFileASC,
                                        _t(366),MB_YESNO ) == IDYES ) then
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

        --lettura elementi da file di traduzione
        --local gpg_fxs = "Decripta file corrente con password per sola lettura"..
        --                ";Decripta file corrente con password"..
        --                ";Cripta file corrente con password"
        local gpg_fxs = _t(358)..
                        _t(359)..
                        _t(360)
                        
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
            
            --wcl_strip:addLabel(nil, "Password: ")
            wcl_strip:addLabel(nil, _t(367).." ")
            wcl_strip:addText("PASSW",old_pass, nil)
            --wcl_strip:addLabel(nil, "Funzione ")
            wcl_strip:addLabel(nil, _t(368).." ")
            wcl_strip:addCombo("VAL")
            wcl_strip:addSpace()
            wcl_strip:addNewLine()
            
            --wcl_strip:addLabel(nil, "Conferma Password: ")
            wcl_strip:addLabel(nil, _t(369).." ")
            wcl_strip:addText("PASSW1",old_pass, nil)
            wcl_strip:addSpace()
            --wcl_strip:addButton("OK","Esegui operazione",buttonOk_click, true)
            wcl_strip:addButton("OK",_t(370),buttonOk_click, true)
            
            wcl_strip:show()

            wcl_strip:setList("VAL", gpg_fxs)
            wcl_strip:setValue("VAL", gpg_fxs[1])
        end
    end
  
  main()
  
end
