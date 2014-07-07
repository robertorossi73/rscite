--[[
Version : 2.0.8
Web     : http://www.redchar.net

Questa procedura richiede il nome del file da confrontare con quello corrente
attraverso l'uso di WinMerge

------------ Versioni ------------

V.2.0.7
- corretta confronto con primo o ultimo elemento della lista file

V.2.0.6
- Eliminato file corrente dalla lista dei file con cui
  confrontarlo
- supporto esclusivo per versione unicode di winmerge

V.2
- Nuova Licenza

V.1.1.1
- porting su SciTE 1.34

V.1.1.0
- Aggiunta possibilità di utilizzare winmerge esterno alla cartella di Lua

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
  
  --ritorna true se il file specificato esiste
  local function file_exist(nomef)
    local idf
    
    idf = io.open(nomef,"r")
    if (idf) then
      io.close(idf)
      return true
    else
      return false
    end
  end
  
  local function SelezionaFile ()
    local nomeFile
    local testo
    local idf
      
    -- 84=Seleziona file da inserire
    nomeFile = rwfx_GetFileName(_t(84)
                                ,"", OFN_FILEMUSTEXIST,rfx_FN())
    
    if nomeFile then
      nomeFile = rfx_GF()      
    end
    return nomeFile
  end

  
  local function SelezionaDocumento ()
    local listafile = ""
    local i = 1 --primo elemento della lista
    local i2 = 0
    local ultimo
    local scelta
    local fileselezionato = false
    local buffers
    local buffers2 = {}
    
    buffers = PUBLIC_get_bufferList()
    ultimo = table.getn(buffers)
    
    while (i <= ultimo) do
      --esclude file corrente
      if (props["FilePath"] ~=  buffers[i]) then
        if (listafile == "") then
          listafile = buffers[i]
          buffers2[i2] = buffers[i]
        else
          listafile = listafile.."|"..buffers[i]
          buffers2[i2] = buffers[i]
        end      
        i2 = i2 + 1
      end
      i = i + 1
    end
    
    -- 133=Altro...
    -- 134=Confronta file corrente con...
    listafile = listafile.."|".._t(133)
    scelta = rwfx_ShowList(listafile,_t(134))
    if (ultimo == 0) then
      ultimo = 2
    end
    if scelta then
      --print(scelta)
      --print(ultimo)
      if ((scelta + 1) == ultimo) then
        fileselezionato = "" -- è stato scelta la voce Altro...
      else
        fileselezionato = buffers2[scelta]
      end
    end
    
    if (fileselezionato == "") then
      fileselezionato = SelezionaFile()
    end
    
    return fileselezionato
  end
  
  local function ComparazioneFileCorrente ()
    local SecondoFile
    local PrimoFile = props["FileDir"].."\\"..props["FileNameExt"]
    local winmerge = props["SciteDefaultHome"].."/tools/winmerge/WinMergeU.exe"
    
    if (not(file_exist(winmerge))) then
      winmerge = props["SciteDefaultHome"].."/../winmerge/WinMergeU.exe"
    end
    
    
    --print(winmerge)
    SecondoFile = SelezionaDocumento()
    --print(PrimoFile)
    --print(SecondoFile)
    if SecondoFile then
      if not(PrimoFile == SecondoFile) then
        if not(SecondoFile == "") then
          SecondoFile = ' "'..SecondoFile..'"'
        end
        PrimoFile = '"'..PrimoFile..'"'
        --print(PrimoFile..SecondoFile)
        rwfx_ShellExecute(winmerge,PrimoFile..SecondoFile)
      end
    end
  end
  
  ComparazioneFileCorrente();
end

