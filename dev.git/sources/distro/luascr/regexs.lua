--[[
Version : 1.0.2
Web     : http://www.redchar.net

Questa procedura consente l'esecuzione di dnGREP.

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
    
  local function main ()
    local exeApp = props["SciteDefaultHome"].."/tools/dngrep/dnGREP.exe"
    local par = ""
    local netVer = rfx_dotNetExist()
    if ( netVer["v4"] ) then
      rwfx_ShellExecute(exeApp,props["FileDir"])
    else
      print(_t(272))
      --print("\nAttenzione : Per eseguire questa procedura è necessario la presenza di .NET V.4!\n\nE' possibile scaricarne una copia da \n https://www.microsoft.com/it-it/download/details.aspx?id=17718")
    end
  end --end main

main()


end

