--[[Riapri file corrente. Chiure e riapre il file attivo.
# -*- coding: utf-8 -*-

Version : 1.0.1
Web     : http://www.redchar.net

Questo modulo consente di chiudere e riaprire il file corrente.

Copyright (C) 2023 Roberto Rossi 
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

do --inizio script. Utile per isolare le variabili presenti nello script
   --dal resto dell'ambiente LUA e dalle funzioni di RSciTE

    --carica le funzioni speciali di RSciTE
    require("luascr/rluawfx")
  
    local function main()
        local nomef = props["FilePath"]
    
        if (props["FileNameExt"] ~= "") then
            scite.MenuCommand(IDM_CLOSE)
            scite.Open(nomef)
        else
            --print("Attenzione: Il file corrente deve essere salvato per poter essere riaperto!")
            print(_t(485))
        end
    end  

  main() 
end --fine dello script
