--[[
Version : 1.2.0
Web     : http://www.redchar.net

Questa procedura verifica che quella corrente sia l'ultima release disponibile,
in caso contrario permette lo scaricamento e l'installaizone di quest'ultima

Copyright (C) 2013-2014 Roberto Rossi 
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
  
  --ritorna una tabella nella quale il primo elemento (true/false) indica se
  --esiste un aggiornamento, mentre il secondo è il numero di versione online
  local function updater_existUpg()
    local result = false
    local versionTbl
    local webUpg = ""    
    local source = {}
    local cmd = "\""..props["SciteDefaultHome"].."\\tools\\wget\\wget\" -qO- "
    local webData = ""
    local verWebFileMajorPart
    local verWebFileMinorPart
    local verWebFileBuildPart
    local verWebDistro
    local remoteVerStr = ""
    local localVerStr = ""
    
    versionTbl = rfx_GetVersionTable()
  
    source = rfx_Split(versionTbl.Source, "\t")    
    webUpg = source[11] --indirizzo dal quale scaricare i dati sulla nuova release
    
    cmd = cmd..webUpg
    
    webData = rfx_exeCapture(cmd)
    
    webData = rfx_Split(webData, "\t")
    
    verWebFileMajorPart = tonumber(webData[3]) --versione SciTE
    verWebFileMinorPart = tonumber(webData[4]) --versione SciTE
    verWebFileBuildPart = tonumber(webData[5]) --versione SciTE
    verWebDistro = tonumber(webData[7]) --versione distribuzione
    
    if (verWebFileMajorPart) then
        remoteVerStr =  tostring(verWebFileMajorPart).."."..
                        tostring(verWebFileMinorPart).."."..
                        tostring(verWebFileBuildPart).."-"..
                        tostring(verWebDistro)
    else 
        remoteVerStr = nil
    end
    localVerStr =   versionTbl.FileMajorPart.."."..
                    versionTbl.FileMinorPart.."."..
                    versionTbl.FileBuildPart.."-"..
                    versionTbl.Distro
    
    if (verWebDistro) then
        if (verWebDistro > versionTbl.Distro) then
          result = true
        elseif (verWebDistro == versionTbl.Distro) then
          if (verWebFileMajorPart > versionTbl.FileMajorPart) then
            result = true
          elseif (verWebFileMajorPart == versionTbl.FileMajorPart) then
            if (verWebFileMinorPart > versionTbl.FileMinorPart) then
              result = true
            elseif (verWebFileMinorPart == versionTbl.FileMinorPart) then
              if (verWebFileBuildPart > versionTbl.FileBuildPart) then
                result = true
              end
            end
          end
        end    
    end
    
    return {result, remoteVerStr, localVerStr}
  end
  
  --chiudi
  function buttonClose_click(control, change)
    wcl_strip:close()
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
  
  --apri la pagina per scaricare la nuova release
  function buttonGoToWeb_click(control, change)
    local versionTbl
    
    versionTbl = rfx_GetVersionTable()
    
    rwfx_ShellExecute(versionTbl.UrlUpg,"")
    wcl_strip:close()
  end
  
  --verifica aggiornamenti
  function buttonOk_click(control, change)
    local remoteVer = ""
    
    --verifica versione e mostra maschera adeguata
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    remoteVer = updater_existUpg()
    
    --wcl_strip:addLabel("L2", "Versione corrente di RSciTE : "..remoteVer[3])
    wcl_strip:addLabel("L2", _t(290)..remoteVer[3])
    wcl_strip:addNewLine()
    
    if (remoteVer[1]) then --software da aggiornare
      --wcl_strip:addLabel("L3", "Versione online di RSciTE : "..remoteVer[2])
        if (remoteVer[2]) then
            wcl_strip:addLabel("L3", _t(291)..remoteVer[2])
        else
            wcl_strip:addLabel("L3", _t(291).._t(327)) --impossibile verificare la versione
        end
      wcl_strip:addNewLine()
      
      --wcl_strip:addLabel(false, "Esiste una nuova versione, desideri scaricarla ?")
        if (remoteVer[2]) then
            wcl_strip:addLabel("L1", _t(281))
        end
      wcl_strip:addNewLine()
      --wcl_strip:addButton("OK","&Si, scarica ora",buttonGoToWeb_click, true)
      wcl_strip:addButton("OK",_t(282),buttonGoToWeb_click, true)
      --wcl_strip:addButton("CLOSE","&No",buttonClose_click, false)
      wcl_strip:addButton("CLOSE",_t(283),buttonClose_click, false)
    else --software gia aggiornato
        if (remoteVer[2]) then
            wcl_strip:addLabel("L3", _t(291)..remoteVer[2])
        else
            wcl_strip:addLabel("L3", _t(291).._t(327)) --impossibile verificare la versione
        end
      wcl_strip:addNewLine()
     
      --wcl_strip:addLabel(false, "La versione attuale non richiede aggiornamenti.")
        if (remoteVer[2]) then
            wcl_strip:addLabel(false, _t(284))
        end
      wcl_strip:addNewLine()
      --wcl_strip:addButton("CLOSE","&Chiudi",buttonClose_click, true)
      wcl_strip:addButton("CLOSE",_t(285),buttonClose_click, true)
    end   
    
    wcl_strip:show()    
  end
  
  --main function
  local function main(autoStart)
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    wcl_strip:addLabel(nil, _t(307))
    wcl_strip:addNewLine()
    --wcl_strip:addLabel(false, "Desideri verificare se esiste una nuova release di RSciTE?")
    wcl_strip:addLabel(nil, _t(286))
    wcl_strip:addNewLine()
    --wcl_strip:addButton("OK","&Verifica Aggiornamenti Adesso",buttonOk_click, true)
    wcl_strip:addButton("OK",_t(287),buttonOk_click, true)
    if (autoStart) then
      --wcl_strip:addButton("CLOSE","&Non verificare Ora",buttonClose_click, false)
      wcl_strip:addButton("CLOSE",_t(288),buttonClose_click, false)
      --wcl_strip:addButton("CLOSE2","Non &Controllare piu\' ",buttonClose2_click, false)
      wcl_strip:addButton("CLOSE2",_t(289),buttonClose2_click, false)
    end    
    
    wcl_strip:show()
  end
  
  --esegui se la procedura è lanciata manualmente
  if (PUBLIC_optionScript == "EXECUTE") then
    main(false)
    PUBLIC_optionScript = ""
  elseif (PUBLIC_optionScript == "AUTOEXECUTE") then
    main(true)
    PUBLIC_optionScript = ""
  end
  
    main(false)
end
