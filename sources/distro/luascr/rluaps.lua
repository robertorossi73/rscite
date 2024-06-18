--[[ # -*- coding: utf-8 -*-
Version : 1.0.3
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

--esegue script powershell
--  scriptTxt = testo script powershell
--  captureNoStop = cattura l'output ma non può ricevere imput utente
--  outFileName = salva l'output nel file specificato
function rfx_powerShell(scriptTxt, captureNoStop, outFileName)
  local psf
  local loc_rfx_execPowerShell
  local loc_rfx_genPowerShell
  
  function loc_rfx_genPowerShell(txtScript, utf8bom)
    local psfile
    local idf
    local command
    local exe = props["SciteDefaultHome"].."/tools/curl/curl.exe"
    local outFolder = os.getenv("TMP")
    
    psfile = outFolder.."\\rscite ps.ps1"
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
  
  -- powershell -ExecutionPolicy Bypass -File "$(FilePath)"
  function loc_rfx_execPowerShell(psfile, captureNoStop, outFileName)
    local cmd = "powershell -ExecutionPolicy Bypass -WindowStyle Normal -Sta -OutputFormat TEXT -File \""..psfile.."\""
    
    if (outFileName) then
      cmd = cmd.." >\""..outFileName.."\""
    end
    
    if (captureNoStop) then
      -- ritorna risultato
      return rfx_exeCapture(cmd)
    else
      -- ritorna true se il comando termina correttamente
      return os.execute(cmd)
    end  
  end
  
  psf = loc_rfx_genPowerShell(scriptTxt, true)
  return loc_rfx_execPowerShell(psf, captureNoStop, outFileName)
end

--print( rfx_powerShell("dir c:\\temp\\unicode\\ci*.*\n[System.Console]::ReadKey()", true))
--print( rfx_powerShell("write-host \"Hello`nHello`ci®Ωo.txt\"\n[System.Console]::ReadKey()"))
--print( rfx_powerShell("write-host \"Hello`nHello`ci®Ωo.txt\""))
--hell("write-host \"Hello`nHello`ci®Ωo.txt\"\n[System.Console]::ReadKey()")

-- scr = "$H = Get-Host\n$Win = $H.UI.RawUI.WindowSize\n$Win.Height = 10\n$Win.Width  = 10\n$H.UI.RawUI.Set_WindowSize($Win)"
-- res = rfx_powerShell(scr.."\n[System.Console]::ReadKey()")
-- if (res) then
--   print("ok")
-- else
--   print("error")
-- end
-- print("end")




