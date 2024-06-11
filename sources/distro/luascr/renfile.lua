-- -*- coding: utf-8 -*-
--[[
Author  : Roberto Rossi
Version : 4.0.0
Web     : http://www.redchar.net

Questa procedura rinomina il file corrente

Copyright (C) 2004-2024 Roberto Rossi 
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

---------------------------------- Versioni -----------------------------------
V.4.0.0
- aggiunto supporto per caratteri unicode

V.3.1.0
- eliminato tasto chiudi
- aggiunta chiusura finestra dopo esecuzioen

V.3.0.0
- Aggiunta interfaccia Stripe

]]

do
  require("luascr/rluawfx")
  
  function buttonHelp_click(control, change)
    rwfx_MsgBox(_t(118), _t(117),MB_OK)
  end
  
  --genera file bat con comando completo, ritorna il path del bat
  function renfile_genBat(comando)
    local batfile
    local idf
    
    batfile = os.getenv("TMP")
    batfile = batfile.."\\sciteRenFile.bat"
    idf = io.open(batfile, "w")
    if (idf) then
      idf:write(comando)
      io.close(idf)
    end
    return batfile
  end
  
  function buttonOk_click(control, change)
    local nomeDest = wcl_strip:getValue("NOME")
    local flagOk = false
    local cmd
    local batfile = ""
    
    if (nomeDest ~= "") then
      --file modificato
      if (editor.Modify) then
        --"Il file corrente non è stato salvato. Procedere al salvataggio prima di continuare?"
        if (rwfx_MsgBox(_t(202),
            _t(241), MB_YESNO + MB_DEFBUTTON2) == IDYES) then
          scite.MenuCommand(IDM_SAVE)
          flagOk = true
        end
      else
        flagOk = true 
      end    
      nomeDest = string.gsub(nomeDest, '%[%#ts%#%]', os.time())
      
      -- test: ©®Ω
      cmd = "chcp 65001"
      cmd = cmd.."\ncls"
      
      cmd = cmd.."\nrename \"".. props["FilePath"] .."\" \"".. nomeDest .."\""

      cmd = cmd.."\n@echo off\n"

      cmd = cmd.."\n@IF %ERRORLEVEL% NEQ 0 ("
      cmd = cmd.."\n  pause"
      cmd = cmd.."\n  goto:eof"
      cmd = cmd.."\n)"
      
      cmd = cmd.."\n@IF NOT EXIST "
      cmd = cmd.."\""..props["FileDir"].."\\"..nomeDest.."\" ("
        --print("Impossibile rinominare il file. Controllare che il nuovo file non sia gia presente e che si abbiano i permessi di effettuare l'operazione!")
      cmd = cmd.."\n  cls"
      cmd = cmd.."\n  echo ".._t(271)
      cmd = cmd.."\n  pause"
      cmd = cmd.."\n)"
      
      batfile = renfile_genBat(cmd)
      --rwfx_ShellExecute(batfile,"")
      os.execute("\""..batfile.."\"")
      
      nomeDest = props["FileDir"].."\\"..nomeDest
      if rfx_fileExist(nomeDest) then
        wcl_strip:close()
        scite.MenuCommand(IDM_CLOSE)
        scite.Open(nomeDest)
      end
      wcl_strip:close()
      --scite.MenuCommand(IDM_CLOSE)
      --scite.Open(nomeDest)
    end
  end
  
  local function main()
    local nomef = props["FileNameExt"]
    
    wcl_strip:init()

    wcl_strip:addButtonClose()
    wcl_strip:addLabel(nil, _t(117))
    wcl_strip:addText("NOME",nomef)
    wcl_strip:addButton("AIUTO",_t(242), buttonHelp_click)
    wcl_strip:addButton("ESEGUI",_t(243), buttonOk_click, true)

    wcl_strip:show()
  end
  

  main()
end

