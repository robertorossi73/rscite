--[[
Version : 3.0.0
Web     : http://www.redchar.net

Questa procedura verifica che quella corrente sia l'ultima release disponibile,
in caso contrario permette lo scaricamento e l'installaizone di quest'ultima

Copyright (C) 2013-2023 Roberto Rossi 
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

    --genera file bat con comando completo
    function upd_genBat(OnlineFile)
        local batfile
        local idf
        local command
        local exe = props["SciteDefaultHome"].."/tools/curl/curl.exe"
        local outOnlineFile = "\\NewRSciTE.zip"
        local outFolder = os.getenv("TMP")
        
        outOnlineFile = outFolder..outOnlineFile
        batfile = outFolder.."\\rsciteUpd.bat"
        os.remove(outOnlineFile)
        idf = io.open(batfile, "w")
        if (idf) then            
            command = "@\""..exe.."\" -f -L -o \""..outOnlineFile.."\" "..OnlineFile
            idf:write("@chcp 65001")            
            idf:write("\n@echo off")
            idf:write("\n@cls")
            idf:write("\n@echo.")
            idf:write("\n@echo Download new file...")
            idf:write("\n@echo.")
            idf:write("\n"..command)            
            idf:write("\nif exist \""..outOnlineFile.."\" (")
            idf:write("\n@explorer \""..outOnlineFile.."\"")
            idf:write("\n) else (")
            idf:write("\n@echo.")
            idf:write("\n@echo Unable download file!")
            idf:write("\n@echo.")
            idf:write("\n@pause")
            idf:write("\n)")
            io.close(idf)
        else
            batfile = ""
        end
        return batfile
    end

    --avvio download nuovo aggiornamento
    local function StartUpdate()
        local outFolder = rfx_UserTmpFolderRSciTE()
        local outIniFile = outFolder.."\\online_version.txt"
        local outOnlineFile = "\\NewRSciTE.zip"
        local exe = props["SciteDefaultHome"].."/tools/curl/curl.exe"
        local iniTbl = rfx_GetVersionTable()
        local par = iniTbl.IniOnline
        local versionTbl = rfx_GetVersionTable()
        local OnlineVersionTbl = false
        local OnlineFile = false
        local iniVal = false
        local retVal = false
        local outVal = false
        local idf
        
        if (par) then
            iniVal =  rfx_exeCapture("\""..exe.."\" "..par)
            if (iniVal ~= "") then
                idf = io.open(outIniFile, "w")
                idf:write(iniVal)
                io.close(idf)
                OnlineVersionTbl = rfx_GetVerTblFromIniFile(outIniFile)
                if (OnlineVersionTbl.DownloadFile ~= "") then
                    if (versionTbl.Distro and OnlineVersionTbl.Distro) then
                        if (tonumber(versionTbl.Distro) < 
                            tonumber(OnlineVersionTbl.Distro) + 1) then
                            OnlineFile = OnlineVersionTbl.DownloadFile
                            
                            retVal = upd_genBat(OnlineFile)
                            if (retVal ~= "") then
                                --print("\n> Attenzione:")    
                                --print("Verrà ora scaricata la nuova versione di RSciTE. Al termine dell'operazione verrà aperto un file ZIP, per avviare l'aggiornamento fare doppio clic sul file eseguibile presente al suo interno.\nE' indispensabile chiudere RSciTE prima di procedere con l'aggiornamento.")
                                if (rwfx_MsgBox(_t(479),_t(9),MB_YESNO ) == IDYES ) then
                                        rwfx_ShellExecute(retVal,"")
                                end
                            else
                                --print("\nImpossibile scaricare la nuova versione di RSciTE! Controlla la connessione e riprova.")
                                rwfx_MsgBox(_t(480),_t(9),MB_OK)
                            end
                        else
                            --print("\nLa versione corrente è già aggiornata!")
                            rwfx_MsgBox(_t(481),_t(9),MB_OK)
                        end
                    end
                end
            else
                --TODO: traduzione
                --print("Impossibile verificare la versione online! Controllare la connessione e riprovare.")
                rwfx_MsgBox(_t(482),_t(9),MB_OK)
            end
        end
    end

  --chiudi e disattiva updater
  function buttonClose2_click(control, change)
    local noUpdater = rfx_UserTmpFolderRSciTE().."\\no_updater.txt"
    idf = io.open(noUpdater, "w")
    if (idf) then
      idf:write("This file disable updater function. Delete this file to enable function.\n")
      io.close(idf)
    end
    wcl_strip:close()
  end
  
    --chiudi
    function buttonClose_click(control, change)
        wcl_strip:close()
    end
    
    --cerca aggiornamento su sito web
    function buttonDown_click(control, change)
        StartUpdate()
        wcl_strip:close()
    end
  
    --cerca aggiornamento su sito web
    function buttonOk_click(control, change)
        local versionTbl
        versionTbl = rfx_GetVersionTable()
        rwfx_ShellExecute(versionTbl.Url,"")
        wcl_strip:close()
    end
  
    --ritorna la stringa con la versione corrente del programma
    local function getCurrentVersionStr()
    local localVerStr = ""
    local versionTbl
        versionTbl = rfx_GetVersionTable()
        localVerStr =   --versionTbl.FileMajorPart.."."..
                        --versionTbl.FileMinorPart.."."..
                        --versionTbl.FileBuildPart.."-"..
                        versionTbl.Distro
        return localVerStr
    end
  
  --main function
  local function mainV2()
    local versionTbl

    versionTbl = rfx_GetVersionTable()

    wcl_strip:init()
    wcl_strip:addButtonClose()

    wcl_strip:addLabel(nil, _t(307))
    wcl_strip:addSpace()
    wcl_strip:addNewLine()

    wcl_strip:addLabel(nil, _t(290)..getCurrentVersionStr())
    wcl_strip:addSpace()
    wcl_strip:addNewLine()

    --wcl_strip:addLabel(false, "Desideri verificare se esiste una nuova release di RSciTE?")
    wcl_strip:addLabel(nil, _t(286))
    wcl_strip:addNewLine()    
    --wcl_strip:addButton("OK","&Verifica Aggiornamenti Adesso",buttonOk_click, true)
    wcl_strip:addButton("OK",_t(287),buttonDown_click, true)

    wcl_strip:addNewLine()    
    --wcl_strip:addButton("OK","Scarica aggiornamento manualmente",buttonOk_click, true)
    wcl_strip:addButton("OK3",_t(478),buttonOk_click, false)
    
    wcl_strip:addNewLine()
    --wcl_strip:addButton("OK","&Ricordamelo il prossimo mese",buttonOk_click, true)
    wcl_strip:addButton("OK2",_t(374),buttonClose_click, false)

    --wcl_strip:addButton("CLOSE2","Non &Controllare piu\' ",buttonClose2_click, false)
    wcl_strip:addButton("CLOSE2",_t(289),buttonClose2_click, false)

    wcl_strip:show()
  end

  mainV2()
end
