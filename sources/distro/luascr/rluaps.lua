--[[ # -*- coding: utf-8 -*-
Version : 1.3.4
Web     : http://www.redchar.net

Funzioni di utilità per macro SciTE/Lua. Funzioni per la gestione di script
powershell.

Copyright (C) 2024 Roberto Rossi 
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

require("luascr/rluawfx")

  -- powershell -ExecutionPolicy Bypass -File "$(FilePath)"
  function rfx_execPowerShell(psfile, captureNoStop, outFileName, hideWindow, parms)
    --genera file bat con comando completo, ritorna il path del bat
    function genBat(comando)
      local batfile
      local idf
      
      batfile = os.getenv("TMP")
      batfile = batfile.."\\rscitePS.bat"
      idf = io.open(batfile, "w")
      if (idf) then
        idf:write(comando)
        io.close(idf)
      end
      return batfile
    end
    
    local winState = "Normal"
    local cmd     
    local res = ""
    local ch
    
    if (hideWindow) then
      winState = "hidden"
    end
    cmd = "powershell -ExecutionPolicy Bypass -WindowStyle "..winState.." -Sta -OutputFormat TEXT -File \""..psfile.."\""
    
    if (parms) then
      cmd = cmd.." "..parms
    end
    
    if (outFileName) then
      cmd = cmd.." >\""..outFileName.."\""
    end
    
    if (captureNoStop) then
      -- ritorna risultato
      res = rfx_exeCapture(cmd)
      --rimuove ultimo ritorno a capo
      res = rfx_RemoveReturnLine(res)
      return res
    else
      -- ritorna true se il comando termina correttamente
      res = genBat("chcp 65001\nmode 80,15\ncolor 17\ncls\n"..cmd)
      --return os.execute("\""..res.."\"")
      rwfx_ShellExecute(res,"")
      return true
    end  
  end

  --esegue script powershell
  --  scriptTxt = testo script powershell
  --  captureNoStop = cattura l'output ma non può ricevere input utente
  --  outFileName = salva l'output nel file specificato
  function rfx_powerShell(scriptTxt, captureNoStop, outFileName)
    local psf
    local loc_rfx_genPowerShell
    
    function loc_rfx_genPowerShell(txtScript, utf8bom)
      local psfile
      local idf
      local command
      local outFolder = os.getenv("TMP")
      
      psfile = outFolder.."\\rscite.ps1"
      idf = io.open(psfile, "w")
      if (idf) then            
        command = txtScript
        if utf8bom then
          idf:write("\xEF") -- tre caratteri per BOM utf-8
          idf:write("\xBB")
          idf:write("\xBF")
          idf:write("chcp 65001")
        end
        --idf:write("\necho off")
        idf:write("\ncls")
        idf:write("\n"..command)            
        io.close(idf)
      else
        psfile = ""
      end
      
      return psfile
    end
    
    psf = loc_rfx_genPowerShell(scriptTxt, true)
    return rfx_execPowerShell(psf, captureNoStop, outFileName)
  end
  
  
-- TEST

-- ret = rfx_execPowerShell("c:\\Temp\\scite\\genguid.ps1", true, false, true)
-- editor:ReplaceSel(ret)

--rfx_execPowerShell("c:\\Temp\\scite\\loadCAD.ps1", false, false, false, "icad \"".. "c:\\Temp\\ci®Ωo.lsp" .."\"")

-- END TEST

