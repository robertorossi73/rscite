--[[# -*- coding: utf-8 -*-
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura consente lo scaricamente e l'aggiornamento di RSciTE

Copyright (C) 2021-2022 Roberto Rossi 
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

    local function StartUpdate()
        local outFolder = rfx_UserTmpFolderRSciTE()
        local outIniFile = outFolder.."\\online_version.txt"
        local exe = props["SciteDefaultHome"].."/tools/curl/curl.exe"
        local iniTbl = rfx_GetVersionTable()
        local par = iniTbl.IniOnline
        local versionTbl = rfx_GetVersionTable()
        local OnlineVersionTbl = false
        local OnlineFile = false
        local iniVal = false
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
                            --TODO: messaggio che spiega come procedere
                            print("\n> Attenzione:")
                            print("Verrà ora scaricata la nuova versione di RScitE. Al termine dell'operazione aprire il file ZIP e lanciare, con un doppio clic, il file eseguibile presente al suo interno.\nE' indispensabile chiudere RSciTE prima di procedere con l'aggiornamento.")
                            --TODO: traduzione
                            --TODO: messaggio che chiede se visualizzare la pagina con le novità
                            --      pagina che sarà le note della versione che si sta scaricando
                            rwfx_ShellExecute(OnlineFile, "open")
                        else
                            --TODO: messaggio che spiega perchè non è possibile eseguire l'update
                            --TODO: traduzione
                            print("\nLa versione corrente è già aggiornata!")
                        end
                    end
                end
            else
                --TODO: traduzione
                print("Impossibile verificare la versione online! Controllare la connessione e riprovare.")
            end
        end
    end

    StartUpdate()
end
  
  
  