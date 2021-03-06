--[[
Version : 1.1.0
Web     : http://www.redchar.net

Questa procedura Consente la gestione dell'affiancamento delle finestre,
in modo da poter visualizzare contemporaneamente pi� file.

Copyright (C) 2004-2011 Roberto Rossi 
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

Comandi per attivazione procedura
command.name.2.*=Affianca &Finestre
command.subsystem.2.*=3
command.2.*=dofile $(SciteDefaultHome)/luascr/tilewin.lua
]]

do
  
  require("luascr/rluawfx")

  --Suesta funzione controlla l'avvenuta apertura di una nuova istanza di SciTE
  --Se resetFlag = true, si limita a resettare il file che segnala l'apertura
  --di SciTE
  local function attendiAperturaSciTE(resetFlag)
    local nomef = ""
    local idf
    local res = false
    local i = 0
    
    nomef = os.getenv("TMP")
    nomef = nomef.."\\scitePrj.tmp"
    
    if (resetFlag) then      
      os.remove(nomef)
      --print("\nCancellato file temporaneo")
    else --attende apertura programma
      while (i < 500) do 
        rwfx_Sleep(200)
        if (rfx_fileExist(nomef)) then
          res = true
          --print("\nTrovato file temporaneo")
          break
        end
        i = i + 1
      end
    end
    
    return res
  end
  
  --controlla la presenza di almeno due file aperti,
  --ritorna false se � aperto un solo file
  local function controlloFileAperti()
    local res = true
    local buffers
    
    buffers = PUBLIC_get_bufferList()
    if (table.getn(buffers) < 2) then
      rwfx_MsgBox("Impossibile eseguire il comando. Attualmente � presente un solo file, risulta quindi inutile riaprirlo in una nuova finestra.","Attenzione")
      res = false
    end
    
    return res
  end
  
  --controlla la corretta impostazione della variabile relativa alle finestre
  --multiple e, se � il caso, avvisa l'utente delle modifiche necessarie.
  --Ritorna true se � tutto ok
  local function controlloStato()
    local res = true
    local edit
    local pos
    local linean
    local idm_bookmark_toggle = 222
    
    if (props["check.if.already.open"] == "1") then
      edit = rwfx_MsgBox("Impossibile continuare! \n\r\n\r"..
                  "Questa funzione necessit� che SciTE lavori in modalit� multi-finestra. \n\r"..
                  "Attualmente il programma funziona in modalit� a finestra singola, � quindi necessario "..
                  "modificare l'opzione 'check.if.already.open'. \n\r\n\r"..
                  "Per fare ci� aprire il file 'SciTEGlobal.properties' e impostare "..
                  "la variabile 'check.if.already.open' a 1 (attualmente � impostata a 0).\n\r\n\r"..  
                  --"Dopo aver effettuato la modifica, prima di continuare, riavviare SciTE.\n\r\n\r"..
                  "Si desidera aprire automaticamente il file per la modifica?",
                  "Attenzione.",MB_ICONSTOP + MB_YESNO)
      if (edit == IDYES) then --procedere all'editazione
        scite.Open(props["SciteDefaultHome"].."/SciTEGlobal.properties")
        pos = editor:findtext("check.if.already.open",SCFIND_WHOLEWORD,0)
        if (pos) then --apertura file e selezione voce
          editor:GotoPos(pos)
          scite.MenuCommand(idm_bookmark_toggle) --evidenzia valore
        end
      end
      res = false
    end
    
    
    return res
  end

  --funzione principale
  local function main()
    local scelta
    local listaFxStr
    local nomef
    local comando
    local comandoSciTE
    local ultimo
    local i
    
    if (controlloStato()) then
      comando = props["SciteDefaultHome"].."/tilewin.exe"
      comandoSciTE = props["SciteDefaultHome"].."/SciTE.exe"
      listaFxStr = "Apri nuova finestra|"..          --0
                   "Apri file corrente in nuova finestra|"..            --1
                   "Affianca orizzontalmente le finestre di SciTE|"..   --2
                   "Affianca verticalmente le finestre di SciTE"        --3
      scelta = rwfx_ShowList(listaFxStr,"Affiancamento SciTE...")
      if scelta then
        nomef = props["FilePath"] --file corrente
        if (scelta==1) then
          if (controlloFileAperti()) then
            attendiAperturaSciTE(true)
            rwfx_ShellExecute(comandoSciTE,"\""..nomef.."\"")
            attendiAperturaSciTE(false)
            rwfx_ShellExecute(comando,"") --affiancamento orizzontale
          end
        elseif (scelta==0) then
          if (controlloFileAperti()) then
            attendiAperturaSciTE(true)
            rwfx_ShellExecute(comandoSciTE,"\""..nomef.."\"")
            attendiAperturaSciTE(false)
            rwfx_ShellExecute(comando,"") --affiancamento orizzontale
            rwfx_ExecuteCmd("close:")
          end
        elseif (scelta==2) then
          rwfx_ShellExecute(comando,"") --affiancamento orizzontale
        elseif (scelta==3) then
          rwfx_ShellExecute(comando,"-v") --affiancamento verticale
        --elseif (scelta==4) then --apri tutti i file correnti
        --  --TODO : implementare affiancamento verticale
        --    for i,nomef in ipairs(buffers) do
        --      attendiAperturaSciTE(true)
        --      rwfx_ShellExecute(comandoSciTE,nomef)
        --      attendiAperturaSciTE(false)
        --    end
        --   rwfx_ShellExecute(comando,"") --affiancamento orizzontale
        --    rwfx_ExecuteCmd("quit:")
        end
      end
    end -- end controllo stato
  end --end function
  
  main()
end
