--[[
Author  : Roberto Rossi
Version : 1.1.0
Web     : http://www.redchar.net

Questa procedura consente la generazione delle statistiche relative a uno o più
file sorgenti.

Viene sfruttata l'utilità Cloc (Web : http://cloc.sourceforge.net/)

Copyright (C) 2012-2013 Roberto Rossi 
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
  function cloc_genBat(inPath)
    local batfile
    local idf
    local comando
    local exe = props["SciteDefaultHome"].."/tools/cloc/cloc-1.56.exe"
    
    batfile = os.getenv("TMP")
    batfile = batfile.."\\sciteCloc.bat"
    idf = io.open(batfile, "w")
    if (idf) then
      comando = "@\""..exe.."\" \""..inPath.."\""
      idf:write(comando)
      io.close(idf)
    end
    return batfile
  end
  
  function buttonHelp_click(control, change)
    --132=Informazioni su
    rwfx_MsgBox(_t(273), _t(132),MB_OK)
  end
  
  function buttonOk_click_f(control, change)
    local filename = wcl_strip:getValue("NOMEF")
    local batfile = ""
    
    output:ClearAll()
    batfile = cloc_genBat(filename)
    print(rfx_exeCapture("\""..batfile.."\""))
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
    local filename = wcl_strip:getValue("NOMED")
    local batfile = ""
    
    output:ClearAll()
    batfile = cloc_genBat(filename)
    print(rfx_exeCapture("\""..batfile.."\""))
  end
  
  function buttonOk_click_db(control, change)
    local folderName
    -- 85=Seleziona Cartella
    folderName = rwfx_BrowseForFolder(_t(85),rfx_FN())
    if (folderName) then
      wcl_strip:setValue("NOMED", rfx_GF())
    end
  end
  
  local function main()
  
    -- TODO : funzione da tradurre
    local nomef = props["FilePath"]
    local nomed = props["FileDir"]
    
    wcl_strip:init()

    wcl_strip:addButtonClose()
--~     wcl_strip:addLabel(nil, "File in analisi : ")
    wcl_strip:addLabel(nil, _t(274))
    wcl_strip:addText("NOMEF",nomef)
    wcl_strip:addButton("ESEGUIFB"," ... ", buttonOk_click_fb, false)
--~     wcl_strip:addButton("ESEGUIF"," Analizza &file ", buttonOk_click_f, true)
    wcl_strip:addButton("ESEGUIF"," ".._t(275).." ", buttonOk_click_f, true)
    wcl_strip:addNewLine()
--~     wcl_strip:addLabel(nil, "Cartella in esame : ")
    wcl_strip:addLabel(nil, _t(277))
    wcl_strip:addText("NOMED",nomed)
    wcl_strip:addButton("ESEGUIDB"," ... ", buttonOk_click_db, false)
--~     wcl_strip:addButton("ESEGUID"," Analizza &cartella ", buttonOk_click_d, false)
    wcl_strip:addButton("ESEGUID"," ".._t(276).." ", buttonOk_click_d, false)
    wcl_strip:addNewLine()
    wcl_strip:addSpace()
    wcl_strip:addSpace()
    wcl_strip:addSpace()
    wcl_strip:addButton("AIUTO",_t(242), buttonHelp_click)

    wcl_strip:show()
  end
  

  main()
end

