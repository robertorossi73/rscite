--[[
Version : 1.2.0
Web     : http://www.redchar.net

Questa procedura Consente la gestione dell'affiancamento delle finestre,
in modo da poter visualizzare contemporaneamente più file.

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

  --Questa funzione controlla l'avvenuta apertura di una nuova istanza di SciTE
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
  --ritorna false se è aperto un solo file
  local function controlloFileAperti()
    local res = true
    local buffers
    
    buffers = PUBLIC_get_bufferList()
    if (table.getn(buffers) < 2) then
      rwfx_MsgBox("Impossibile eseguire il comando. Attualmente è presente un solo file, risulta quindi inutile riaprirlo in una nuova finestra.","Attenzione")
      res = false
    end
    
    return res
  end
  
  --controlla la corretta impostazione della variabile relativa alle finestre
  --multiple e, se è il caso, avvisa l'utente delle modifiche necessarie.
  --Ritorna true se è tutto ok
  local function controlloStato()
    local res = true
    local edit
    local pos
    local linean
    local idm_bookmark_toggle = 222
    
    if (props["check.if.already.open"] == "1") then    
      --[[edit = rwfx_MsgBox("Impossibile continuare! \n\r\n\r"..
                  "Questa funzione necessità che SciTE lavori in modalità multi-finestra. \n\r"..
                  "Attualmente il programma funziona in modalità a finestra singola, è quindi necessario "..
                  "modificare l'opzione 'check.if.already.open'. \n\r\n\r"..
                  "Per fare ciò aprire il file 'SciTEGlobal.properties' e impostare "..
                  "la variabile 'check.if.already.open' a 0 (attualmente è impostata a 1).\n\r\n\r"..  
                  "Si desidera aprire automaticamente il file per la modifica?",
                  "Attenzione.",MB_ICONSTOP + MB_YESNO)
        ]]
      edit = rwfx_MsgBox(_t(138),_t(9),MB_ICONSTOP + MB_YESNO)
      if (edit == IDYES) then --procedere all'editazione
        --scite.Open(props["SciteDefaultHome"].."/SciTEGlobal.properties")
        scite.Open(props["SciteUserHome"].."/SciTEUser.properties")
        pos = editor:findtext("check.if.already.open",SCFIND_WHOLEWORD,0)
        if (pos) then --apertura file e selezione voce
          editor:GotoPos(pos)
          scite.MenuCommand(idm_bookmark_toggle) --evidenzia valore
        else
          --[[ 1 = permetti una sola finestra di SciTE
               0 = consenti la presenza di pià finestre di SciTE
               check.if.already.open=0
            ]]
          editor:AddText(_t(188))
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
      
      --[[listaFxStr = 
                   "Affianca orizzontalmente le finestre di SciTE|"..   --0
                   "Affianca verticalmente le finestre di SciTE"        --1
                   "Apri nuova finestra|"..          --2
                   "Sposta file corrente in nuova finestra|"..            --3
                   "Apri file corrente in nuova finestra|"..            --4
        ]]
      listaFxStr = _t(137)
      
      scelta = rwfx_ShowList(listaFxStr,"Affiancamento SciTE...")
      if scelta then
        nomef = props["FilePath"] --file corrente
        if (scelta==3) then --Sposta file corrente in nuova finestra
          if (controlloFileAperti()) then
            attendiAperturaSciTE(true)
            rwfx_ShellExecute(comandoSciTE,"\""..nomef.."\"")
            attendiAperturaSciTE(false)
            rwfx_ExecuteCmd("close:")
          end
        elseif (scelta==2) then --Apri nuova finestra
          if (controlloFileAperti()) then
            rwfx_ShellExecute(comandoSciTE,"")
          end
        elseif (scelta==4) then --Apri file corrente in nuova finestra
          if (controlloFileAperti()) then
            rwfx_ShellExecute(comandoSciTE,"\""..nomef.."\"")
          end
        elseif (scelta==0) then --affiancamento orizzontale
          rwfx_ShellExecute(comando,"-o") --affiancamento orizzontale
        elseif (scelta==1) then --affiancamento verticale
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
