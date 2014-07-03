--[[
Version : 1.0.0
Web     : http://rsoftware.altervista.org

Questa procedura consente la ricerca e la sostituzione di un testo
all'interno di più file. Supporta le espressioni regolari ed utilizza,
per le operazioni, l'utilità SED.

Copyright (C) 2004,2005,2006,2007 Roberto Rossi 
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

  --legge o salva l'ultima ricerca effettuata
  local function last_command (save, comando)
    local fname
    local res = ""
    local idf
    
    fname = rfx_UserFolderRSciTE().."\\tmp\\findrep.txt"
    
    if (save) then --salvataggio
      idf = io.open(fname, "w")
      if (idf) then
        idf:write(comando)
        io.close(idf)
      end
    else --lettura
      idf = io.open(fname, "r")
      if (idf) then
        res = idf:read("*a")
        io.close(idf)
      end      
    end
    
    return res
  end
  
  --sostituisce nei file indicati, presenti in una cartella
  local function replace_files(cartella, filtro, 
                                trovaStr, sostituisciCon, 
                                backup, riutilizza)
    local comando = ""
    local res
    
    if (backup) then
      comando = " -i.bak "
    else
      comando = " -i "
    end
    
    comando = comando.."\"s/"..trovaStr.."/"..sostituisciCon.."/\" \""..
              cartella.."\\"..filtro.."\""
    
    if (riutilizza) then --riutilizza ultima esecuzione
      comando = last_command(false,"")
    end
    
    --conferma/inserimento opzioni SED
    res = rwfx_InputBox(comando, "Verifica parametri SED",
                        "In questa maschera è possibile verificare e modificare la correttezza dei parametri passati a SED :\r\n\r\n"..
                        "Per i dettagli si raccomanda di consultare la documentazione ufficiale (accessibile dalla lista opzioni di 'Trova/Sostituisci')",
                        rfx_FN());
    if (res) then
      comando = rfx_GF()
      if (comando ~= "") then
        rwfx_ShellExecute("\""..props["SciteDefaultHome"].."\\tools\\sed\\sed.exe\"",comando)
        last_command(true,comando)
      else
        rwfx_MsgBox("Impossibile eseguire SED senza specificare alcun parametro!",
                    "Attenzione!",MB_OK)
      end
    end
  end
  
  --funzione avvio macro
  local function main ()
    local cartella
    local filtro
    local trova
    local sostituzione
    local scelta
    local opzioni
    local backupOpz
    
    opzioni = "CON BACKUP dei file modificati|SENZA BACKUP dei file modificati|"..
              "Riutilizza ultima sostituzione|"..
              "Inserimento diretto parametri di SED|"..
              "Manuale di SED|FAQ di SED"
    scelta = rwfx_ShowList(opzioni,"Trova/Sostituisci...")
    if scelta then 
      backupOpz = false --senza backup
      if (scelta==0) then --con backup
        backupOpz = true
      end
      
      if (scelta==2) then--riutilizza ultimi parametri
        replace_files("c:\\temp","*.txt","Trova Questo Testo","Nuovo Testo",backupOpz,true)
      elseif (scelta==3) then --inserimento diretto parametri
        replace_files("c:\\temp","*.txt","Trova Questo Testo","Nuovo Testo",backupOpz,false)
      elseif (scelta==4) then--manuale
        rwfx_ShellExecute("\""..props["SciteDefaultHome"].."\\tools\\sed\\sed.html\"","")
      elseif (scelta==5) then--FAQ
        rwfx_ShellExecute("\""..props["SciteDefaultHome"].."\\tools\\sed\\sedfaq.txt\"","")
      else
        cartella = rwfx_BrowseForFolder("Selezionare Cartella nella quale effettuare le sostituzioni",rfx_FN())
        if cartella then
          cartella = rfx_GF() --ottiene nome cartella
          filtro = rwfx_InputBox("*.txt", "Filtro per selezione file",
                                  "Indicare filtro da applicare per selezionare i file da modificare (es.: *.*) :",
                                  rfx_FN())
          if filtro then
            filtro = rfx_GF()
            trova = rwfx_InputBox("cerca", "Testo da cercare",
                                    "Indicare il testo da sostituire (sono supportate le espressioni regolari) :",
                                    rfx_FN())
            if trova then
              trova = rfx_GF()
              sostituzione = rwfx_InputBox("sostituisci con", "Sostituisci con...",
                                      "Indicare il testo da inserire al posto di '"..trova.."' :",
                                      rfx_FN())
              if sostituzione then
                sostituzione = rfx_GF()
                replace_files(cartella,filtro,trova,sostituzione,backupOpz,false)
              end
            end
          end
        end --selezione cartella      
      end --endif scelta     

    end --endscelta
  end --endf
  main()  
  
end

