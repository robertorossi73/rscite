--[[
Version : 0.0.1
Web     : http://www.redchar.net

Questa procedura permette l'uso dell'utilità fciv.exe prodotta da microsoft
per il calcolo di md5 e sha1

TODO : Questo modulo consentirà di :
- Ottenere l'md5 di un file selezionato;
- Ottenere l'sha1 di un file selezionato;
- Ottenere l'md5 di una stringa selezionata nel testo;
- Ottenere l'sha1 di una stringa selezionata nel testo;
- Ottenere l'md5 di un gruppo di file;
- Ottenere l'md5 di una cartella (i file contenuti), 
  eventualmente comprese le sottocartelle;
- Creare file xml con valori md5 e sha1 calcolati.
- interrogazione di un database xml precedentemente creato

Copyright (C) 2010 Roberto Rossi 
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

  local function main()
    local fnfciv = props["SciteDefaultHome"].."\\fciv.exe"
    local cmd = "cmd /C \"\""..fnfciv.."\""
  
    cmd = cmd.." \"C:\\d\\temp\" -both"
    cmd = cmd.."\""
    print(cmd)
    print(rfx_exeCapture(cmd))
  end
  
  
  main()
end
