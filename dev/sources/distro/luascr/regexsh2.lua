--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura consente l'apertura della documentazione generica relativa alle espressioni regolari.

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
    local exeApp = props["SciteDefaultHome"].."/tools/dngrep/doc/regular-expressions-cheat-sheet-v2.pdf"
    local par = ""
      rwfx_ShellExecute(exeApp,"")
  end --end main

main()


end

