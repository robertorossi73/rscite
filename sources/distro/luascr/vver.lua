--[[
Version : 3.3.0
Web     : http://www.redchar.net

Questa procedura visualizza informazioni sulla distribuzione di SciTE, inoltre
consente l'avvio della provedura di aggiornamento

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

---------------------------------- Versioni -----------------------------------

V.3.1.0
- Aggiunte informazioni sulla versione di SciTE

V.3.1.0
- Eliminato tasto chiudi

V.3.0.0
- Aggiunta interfaccia Stripe

]]

do
  require("luascr/rluawfx")
  
  local function execUpg()
    local nomef = props["SciteDefaultHome"].."\\RUpdtr.exe"
    if (rfx_fileExist(nomef)) then
        rwfx_ShellExecute(nomef,"")
    else
      print("\nError : Missing file 'RUpdtr.exe'!!")
    end
  end
  
  --function buttonCanc_click(control, change)
    --wcl_strip:close()
  --end
  
  function buttonUpg_click(control, change)
    wcl_strip:close()
    execUpg()
  end

  local function visInfoDistribuzioneStripe ()
    local nDistribuzione -- nome distribuzione
    local autore -- autore distribuzione
    local web -- sito web distribuzione
    local linea
    local pos
    local nome --nome impostazione
    local valore --valore impostazione
    local linguaCorrente --sigla lingua corrente RSciTE
    local versionTbl --tabella con dati versione
    local vDistribuzione -- versione distribuzione
    local vScite -- versione scite
    local result
    
    versionTbl = rfx_GetVersionTable()

    vScite = versionTbl.FileMajorPart.."."..
                   versionTbl.FileMinorPart.."."..versionTbl.FileBuildPart
    vDistribuzione = versionTbl.Distro
    web = versionTbl.Url
    nDistribuzione = versionTbl.NameDistro
    autore = versionTbl.Author

    linguaCorrente = _t(0)
    -- 122=Dati Distribuzione
    -- 123=Nome
    -- 124=Versione
    -- 125=Autore
    -- 126=Sito Web
    -- 127=Dati Software Inclusi
    -- 128=Versione SciTE
    -- 129=Versione KDiff
    -- 130=Versione HExplorer
    -- 131=Versione Tidy
    -- 132=Informazioni su
    -- 136=Lingua
    wcl_strip:init()
    wcl_strip:addButtonClose()

    wcl_strip:addLabel(nil, "----> ".._t(122)) --Dati Distribuzione
    wcl_strip:addSpace()
    wcl_strip:addNewLine()

    wcl_strip:addLabel(nil, _t(123).." : ")
    wcl_strip:addLabel(nil,nDistribuzione)
    wcl_strip:addNewLine()

    wcl_strip:addLabel(nil, _t(136).." : ")
    wcl_strip:addLabel(nil,linguaCorrente)
    wcl_strip:addNewLine()

    wcl_strip:addLabel(nil, _t(124).." : ")
    --wcl_strip:addLabel(nil,vScite.."-"..vDistribuzione.." "..versionTbl.AddPart)
    wcl_strip:addLabel(nil, vDistribuzione.." "..versionTbl.AddPart)
    wcl_strip:addNewLine()

    wcl_strip:addLabel(nil, _t(128).." : ")
    wcl_strip:addLabel(nil,vScite)
    wcl_strip:addNewLine()

    wcl_strip:addLabel(nil, _t(126).." : ")
    --wcl_strip:addLabel(nil,web)
    wcl_strip:addButton("OK",web, buttonGoToWeb_click, true)
    wcl_strip:addNewLine()

    wcl_strip:show()
  end --endfunction
  
  --apri la pagina per scaricare la nuova release
  function buttonGoToWeb_click(control, change)
    local versionTbl
    
    versionTbl = rfx_GetVersionTable()
    
    rwfx_ShellExecute(versionTbl.Url,"")
    wcl_strip:close()
  end


  visInfoDistribuzioneStripe()
end
