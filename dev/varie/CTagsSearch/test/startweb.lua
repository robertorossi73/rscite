--[[
Version : 2.0.2
Web     : http://www.redchar.net

Questa procedura avvia il file corrente su un web server locale

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
  
  -- indirizzo web del server web locale
  local webserver="http://localhost:8080"
  -- cartella contenente sito web
  local webfolder="d:\\web\\mirror"
  
  local function mainStart()
    local folder
    local pos
    local strtemp
    local comando = false
    
    folder = props["FilePath"]
    pos = string.find(folder,webfolder)
    strtemp = string.upper(string.sub(folder,1,string.len(webfolder)))
    if (strtemp == string.upper(webfolder)) then
      comando = webserver..string.sub(folder,string.len(webfolder)+1)
      comando = string.gsub(comando,"\\","/") --inversione barre per percorso web
      print(comando)
      rwfx_ShellExecute(comando,"")
    else
      -- 121=file non riconosciuto
      print(_t(121))
    end    
  end --endf
  

  mainStart()
end 
