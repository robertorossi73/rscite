--[[
Version : 2.0.1
Web     : http://www.redchar.net

Questa procedura verifica che quella corrente sia l'ultima release disponibile,
in caso contrario permette lo scaricamento e l'installaizone di quest'ultima

Copyright (C) 2013-2016 Roberto Rossi 
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
    function buttonOk_click(control, change)
        local versionTbl
        versionTbl = rfx_GetVersionTable()
        rwfx_ShellExecute(versionTbl.Url,"")
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
    wcl_strip:addButton("OK",_t(287),buttonOk_click, true)
    
    wcl_strip:addNewLine()
    --wcl_strip:addButton("OK","&Ricordamelo il prossimo mese",buttonOk_click, true)
    wcl_strip:addButton("OK2",_t(374),buttonClose_click, false)
    
    --wcl_strip:addButton("CLOSE2","Non &Controllare piu\' ",buttonClose2_click, false)
    wcl_strip:addButton("CLOSE2",_t(289),buttonClose2_click, false)

    wcl_strip:show()
  end
  
  
    mainV2()
  
end
