--[[
Author  : Roberto Rossi
Version : 2.1.1
Web     : http://www.redchar.net

Questa procedura consente l'esecuzione di HTML Tidy (tidy.exe)

Copyright (C) 2012-2018 Roberto Rossi 
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
  
  --genera file bat con comando completo, ritorna il path del bat
  function tidy_genBat(options, inPath)
    local batfile
    local idf
    local comando
    local exe = props["SciteDefaultHome"].."/tools/tidy/tidy.exe"
    local txtLog = rfx_FN()
    
    batfile = os.getenv("TMP")
    batfile = batfile.."\\sciteTidy.bat"
    idf = io.open(batfile, "w")
    if (idf) then
      comando = "@\""..exe.."\" ".. options.." -indent -modify ".."\""..inPath.."\" -f "..txtLog
      idf:write(comando)
      io.close(idf)
    end
    return batfile
  end
  
  function buttonOk_click_fb(control, change)
    local fileName
    -- 84=Seleziona file da inserire
    fileName = rwfx_GetFileName(_t(84)
                                ,"", OFN_FILEMUSTEXIST,rfx_FN())
    if (fileName) then
      wcl_strip:setValue("NOMEF", rfx_GF())
    end
  end
  
  function buttonOk_click_d(control, change)
    local filename = wcl_strip:getValue("NOMEF")
    local tpfile = wcl_strip:getValue("TPFILE")
    local cmdline = ""
    local options = ""
    
    if (tpfile == "XML") then
        options = "-xml"
    end
    
    cmdline = tidy_genBat(options, filename)

    if (editor.Modify) then
        --"Il file corrente non è stato salvato. Procedere al salvataggio prima di continuare?"
        if (rwfx_MsgBox(_t(202),
            _t(241), MB_YESNO + MB_DEFBUTTON2) == IDYES) then
          scite.MenuCommand(IDM_SAVE)
        end
    end
    
    --407=Attenzione: Questa procedura potrebbe modificare l'interno file corrente!\n\n 
    --      Si desidera procedere?
    if (rwfx_MsgBox(_t(407), _t(408), MB_YESNO) == IDYES) then
        output:ClearAll()
        rfx_exeCapture("\""..cmdline.."\"")
        print(rfx_GF())
        scite.MenuCommand(IDM_REVERT)
    end
    
    wcl_strip:close();
  end
  
  local function main()
    local nomef = props["FilePath"]
    local nomed = props["FileDir"]
    local types = {"HTML", "XML"}
    
    wcl_strip:init()

    wcl_strip:addButtonClose()
--~     wcl_strip:addLabel(nil, "File da elaborare: ")
    wcl_strip:addLabel(nil, _t(405))
    --tipo file
    --XML
    --HTML
    wcl_strip:addText("NOMEF",nomef)
    wcl_strip:addLabel(nil, _t(406))
    wcl_strip:addCombo("TPFILE")
    wcl_strip:addButton("ESEGUIFB"," ... ", buttonOk_click_fb, false)
    --Esegui
    wcl_strip:addButton("ESEGUID"," ".._t(66).." HTML Tidy", buttonOk_click_d, true)
    
    wcl_strip:show()
    
    wcl_strip:setList("TPFILE", types)
    wcl_strip:setValue("TPFILE", "HTML")
  end

  main()
end

