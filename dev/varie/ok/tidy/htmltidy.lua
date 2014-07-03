--[[
Version : 1.0.2
Web     : http://rsoftware.altervista.org

Questa procedura consente l'utilizzo dell'utilità HtmlTidy in modo dinamico

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
  
  local function main()
    local scelta
    local lst
    local res
    local fbak
    local comando = "\""..props["SciteDefaultHome"].."/tools/tidy/tidy.exe".."\" "
    local parametri = ""
    local nomef
    
    fbak = props["FileNameExt"]..".tidybak"
    --rfx_FN()--file di output temporaneo
    lst = "Controllo errori in file corrente"..         --0
          "|Controllo accessibilità su file corrente".. --1
          "|Riformatta file corrente (formato XML)"..             --2
          "|Riformatta file corrente (formato HTML)"..            --3
          "|Converti file HTML corrente in XHTML"..     --4
          "|Converti file XHTML corrente in HTML"..     --5
          "|Riformatta file usando configurazione personalizzata"..     --6
          "|Ripristina backup del file corrente"..      --7
          "|--"..                                       --8
          "|Apri Manuale HTML Tidy"..                   --9
          "|Apri Domande Frequenti su HTML Tidy"..      --10
          "|Apri 'Riferimento alle Opzioni"             --11
          
    scelta = rwfx_ShowList(lst,"HTML Tidy")
    if scelta then
      
      -- TODO : se il file corrente non è salvato richiedere all'utente il
      -- salvataggio (controllo avviene con editor.Modify)
      
      -- TODO : se necessario richiedi file di configurazione 
      
      --richiesta backup per funzioni che modificano il file corrente
      if (
          (scelta == 2) or
          (scelta == 3) or
          (scelta == 4) or
          (scelta == 5) or
          (scelta == 6)
         )
      then
        res = rwfx_MsgBox("Si desidera effettuare una copia del file corrente in '"..fbak.."',"..
                          " prima di procedere all'elaborazione del testo?",
                          "Backup", MB_YESNO)
        if (res == IDYES) then
          --creazione backup
          rwfx_fileOperation(props["FilePath"],props["FilePath"]..".tidybak","copy",0x10)
        end      
      end 
      
      if (scelta==0) then --controllo errori
        --tidy -e -f risultato.txt test2.html
        parametri = "-e -f \""..rfx_FN().."\" \"".. 
                            props["FilePath"].."\""
        os.execute("\""..comando..parametri.."\"")
        res = rfx_GF()
        print("\n--------- HTML Tidy ---------")
        print(res)
      elseif (scelta==1) then
      -- verifica accessibilità per l'utilizzo su browser non grafici
      -- tidy -e -access [n] test2.html
      -- n può essere 1,2 o 3
        parametri = "-e -access 3 -f \""..rfx_FN().."\" \""..
                            props["FilePath"].."\""
        os.execute("\""..comando..parametri.."\"")
        res = rfx_GF()
        print("\n--------- HTML Tidy ---------")
        print(res)      
      elseif (scelta==2) then
        --formatta XML
        parametri = "-xml -indent -modify -f \""..rfx_FN().."\" \""..
                    props["FilePath"].."\""
        print("\""..comando..parametri.."\"")
        os.execute("\""..comando..parametri.."\"")
        res = rfx_GF()
        print("\n--------- HTML Tidy Formattazione XML ---------")
        print(res)
      elseif (scelta==3) then
        -- formatta HTML
        parametri = "-indent -modify -f \""..rfx_FN().."\" \""..props["FilePath"].."\""
        os.execute("\""..comando..parametri.."\"")
        res = rfx_GF()
        print("\n--------- HTML Tidy Formattazione HTML ---------")
        print(res)
      elseif (scelta==4) then
      -- converti file corrente da HTML a XHML
        parametri = "-indent -asxhtml -modify \""..props["FilePath"].."\""
        os.execute("\""..comando..parametri.."\"")      
      elseif (scelta==5) then
      -- converti file corrente da XHML a HTML
        parametri = "-indent -ashtml -modify \""..props["FilePath"].."\""
        os.execute("\""..comando..parametri.."\"")      
      elseif (scelta==6) then
        -- TODO : Riformatta file usando configurazione personalizzata
        --tidy -modify -config file.cfg test2.html
         
        nomef = rwfx_GetFileName("Seleziona file di configurazione"
                                    ,"",OFN_FILEMUSTEXIST,rfx_FN(),"File di Configurazione (*.cfg)%c*.cfg")
        if nomef then
          nomef = rfx_GF()
          parametri = "-indent -modify"..
                      " -config \""..nomef.."\""..
                      " -f \""..rfx_FN().."\" \""..props["FilePath"].."\""
          os.execute("\""..comando..parametri.."\"")
          res = rfx_GF()
          print("\n--------- HTML Tidy Formattazione HTML ---------")
          print(res)
        end --endnomefile
      elseif (scelta==7) then
      -- Ripristina Backup
        if (rfx_fileExist(props["FilePath"]..".tidybak")) then
          os.execute("copy /Y \""..props["FilePath"]..".tidybak\" \""..
                     props["FilePath"])
          scite.MenuCommand(104) --IDM_REVERT, aggiornamento video corrente
        else
          rwfx_MsgBox("Il backup per il file corrente NON esiste. Impossibile ripristinarlo!",
                      "Ripristino Backup")
        end
      elseif (scelta==9) then
      -- Manuale
        rwfx_ShellExecute("\""..props["SciteDefaultHome"].."/tools/tidy/doc/tidy_man.html\"","")
      elseif (scelta==10) then
      -- FAQ
        rwfx_ShellExecute("\""..props["SciteDefaultHome"].."/tools/tidy/doc/faq.html\"","")
      elseif (scelta==11) then
      -- References
        rwfx_ShellExecute("\""..props["SciteDefaultHome"].."/tools/tidy/doc/quickref.html\"","")
      end
      
    end --endscelta
  end --endmain
  
  main() 
end

