--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura permette di lanciare la calcolatrice del sistema operativo

Copyright (C) 2004-2021 Roberto Rossi 
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
  --carica le funzioni speciali di RSciTE
  require("luascr/rluawfx")
  
  function main()
    
    rwfx_ShellExecute("calc.exe","")
  end
  
  main()
end --fine dello script
