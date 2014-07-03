--[[
Author  : Roberto Rossi
Version : 2.1.3
Web     : http://www.redchar.net

Questa procedura rinomina il file corrente

Copyright (C) 2004-2009 Roberto Rossi 
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
  
  local function RenCurrentFile ()
    local nomeSorg
    local nomeDest
    local ret,msg
    local flagOk = nil
    
    -- 115=Attenzione : Il file corrente non è stato salvato!\nSe si rinomina il file prima di salvarlo verranno perse le modifiche!\n\nSi desidera procedere ugualmente?
    -- 116=Salvataggio file
    -- 117=Nome File
    -- 118=Indica il nuovo nome per il file corrente. \r\n\r\nE' possibile usare le seguenti abbreviazione nel nome file :\r\n[#ts#] = Inserisce il TimeStamp (es: [#ts#].txt) corrente
    
    if (editor.Modify) then
      if (rwfx_MsgBox(
          _t(115),
          _t(116),
          MB_YESNO + MB_DEFBUTTON2) == IDYES) then
        flagOk = true
      end
    else
      flagOk = true
    end
    
    if (flagOk) then
      nomeDest = nil
      nomeSorg = props["FileNameExt"]
      nomeDest = rwfx_InputBox(nomeSorg, _t(117), _t(118), rfx_FN())
      if nomeDest then
        nomeDest = rfx_GF()
        if (nomeDest ~= "") then
          nomeDest = string.gsub(nomeDest, '%[%#ts%#%]', os.time())
          nomeDest = props["FileDir"].."\\"..nomeDest
          ret = os.rename(props["FilePath"],nomeDest)
          if ret then
            rwfx_ExecuteCmd("close:")
            scite.Open(nomeDest)
          end
        end
      end
    end --if flagOk 
  end
  RenCurrentFile()
end

