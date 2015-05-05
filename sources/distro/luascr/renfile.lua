--[[
Author  : Roberto Rossi
Version : 3.1.2
Web     : http://www.redchar.net

Questa procedura rinomina il file corrente

Copyright (C) 2004-2015 Roberto Rossi 
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
  
  function buttonOk_click(control, change)
    local nomeDest = wcl_strip:getValue("NOME")
    local flagOk = false
    
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
      nomeDest = props["FileDir"].."\\"..nomeDest
      ret = os.rename(props["FilePath"],nomeDest)
      if ret then
        wcl_strip:close()
        scite.MenuCommand(IDM_CLOSE)
        scite.Open(nomeDest)
        wcl_strip:close()
      else
        --print("Impossibile rinominare il file. Controllare che il nuovo file non sia gia presente e che si abbiano i permessi di effettuare l'operazione!")
        print(_t(271))
      end
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

