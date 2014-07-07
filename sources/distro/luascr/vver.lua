--[[
Version : 3.1.3
Web     : http://www.redchar.net

Questa procedura visualizza informazioni sulla distribuzione di SciTE, inoltre
consente l'avvio della provedura di aggiornamento

Copyright (C) 2004-2013 Roberto Rossi 
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
  
  local function visInfoDistribuzione ()
    local nDistribuzione -- nome distribuzione
    local autore -- autore distribuzione
    local web -- sito web distribuzione
    local vKDiff -- versione kdiff
    local vHExplorer -- versione hexplorer
    local vTidy -- versione tidy
    local vyuicompressor -- versione yuicompressor
    local idf
    local linea
    local pos
    local nome --nome impostazione
    local valore --valore impostazione
    local linguaCorrente --sigla lingua corrente RSciTE
    local versionTbl --tabella con dati versione
    local vDistribuzione -- versione distribuzione
    local vScite -- versione scite
    local vFar --versione far
    local vRegex --versione Regexerator
    local result
    
    idf = io.open(props["SciteDefaultHome"].."/distro.ini")
    if idf then
      for linea in idf:lines() do
        pos = string.find(linea, "=")
        if pos then
          nome = string.lower(string.sub(linea, 1, (pos - 1)))
          valore = string.sub(linea, (pos + 1))
          if (nome == "kdiff") then
            vKDiff = valore
          elseif (nome == "hexplorer") then
            vHExplorer = valore
          elseif (nome == "tidy") then
            vTidy = valore
          elseif (nome == "yuicompressor") then
            vyuicompressor = valore
          elseif (nome == "far") then
            vFar = valore
          elseif (nome == "regexerator") then
            vRegex= valore
          end          
        end
      end
      io.close(idf)

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
      msg = "---- ".._t(122).." ---\n"
      msg = msg.._t(123).." : "..nDistribuzione.."\n"
      msg = msg.._t(136).." : "..linguaCorrente.."\n"
      msg = msg.._t(124).." : "..vScite.."-"..vDistribuzione.." "..versionTbl.AddPart
      msg = msg.."\n".._t(125).." : "..autore
      msg = msg.."\n".._t(126).." : "..web.."\n\n"
      msg = msg.."---- ".._t(127).." ---\n"
      msg = msg.._t(128).." : "..vScite
      msg = msg.."\n".._t(129).." : "..vKDiff
      msg = msg.."\n".._t(130).." : "..vHExplorer
      msg = msg.."\n".._t(131).." : "..vTidy
      msg = msg.."\nYuiCompressor : v. "..vyuicompressor
      msg = msg.."\nRegexSearch : v. "..vFar
      msg = msg.."\nRegexerator : v. "..vRegex
      
      --rwfx_MsgBox_Btn(IDNO, "&Aggiorna")
      rwfx_MsgBox_Btn(IDOK, _t(199))
      --rwfx_MsgBox_Btn(IDYES, "&Chiudi")
      rwfx_MsgBox_Btn(IDCANCEL, _t(200))
      
      --msg = msg.."\n\n Se si desidera verificare la presenza di eventuali aggiornamenti, premere 'Aggiorna'."
      msg = msg.._t(201)
      result = rwfx_MsgBox(msg,_t(132).." '"..nDistribuzione.."'",MB_OKCANCEL + MB_DEFBUTTON2)
      if (result == IDOK) then
        --upgrade
        execUpg()
      end
    end --endif
    
  end --endfunction

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
    local vKDiff -- versione kdiff
    local vHExplorer -- versione hexplorer
    local vTidy -- versione tidy
    local vyuicompressor -- versione yuicompressor
    local idf
    local linea
    local pos
    local nome --nome impostazione
    local valore --valore impostazione
    local linguaCorrente --sigla lingua corrente RSciTE
    local versionTbl --tabella con dati versione
    local vDistribuzione -- versione distribuzione
    local vScite -- versione scite
    local vFar --versione far
    local vRegex --versione Regexerator
    local result
    
    idf = io.open(props["SciteDefaultHome"].."/distro.ini")
    if idf then
      for linea in idf:lines() do
        pos = string.find(linea, "=")
        if pos then
          nome = string.lower(string.sub(linea, 1, (pos - 1)))
          valore = string.sub(linea, (pos + 1))
          if (nome == "kdiff") then
            vKDiff = valore
          elseif (nome == "hexplorer") then
            vHExplorer = valore
          elseif (nome == "tidy") then
            vTidy = valore
          elseif (nome == "yuicompressor") then
            vyuicompressor = valore
          elseif (nome == "far") then
            vFar = valore
          elseif (nome == "regexerator") then
            vRegex= valore
          end          
        end
      end
      io.close(idf)

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
      wcl_strip:addLabel(nil, "     ----> ".._t(127)) --Dati Software Aggiuntivo
      wcl_strip:addNewLine()
      
      wcl_strip:addLabel(nil, _t(123).." : ")
      wcl_strip:addLabel(nil,nDistribuzione)
      wcl_strip:addLabel(nil, _t(128).." : ")
      wcl_strip:addLabel(nil,vScite)      
      wcl_strip:addNewLine()
      
      wcl_strip:addLabel(nil, _t(136).." : ")
      wcl_strip:addLabel(nil,linguaCorrente)
      wcl_strip:addLabel(nil, _t(129).." : ")
      wcl_strip:addLabel(nil,vKDiff)
      wcl_strip:addNewLine()
      
      wcl_strip:addLabel(nil, _t(124).." : ")
      wcl_strip:addLabel(nil,vScite.."-"..vDistribuzione.." "..versionTbl.AddPart)
      wcl_strip:addLabel(nil, _t(130).." : ")
      wcl_strip:addLabel(nil,vHExplorer)
      wcl_strip:addNewLine()
      
      wcl_strip:addLabel(nil, _t(125).." : ")
      wcl_strip:addLabel(nil,autore)
      wcl_strip:addLabel(nil, _t(131).." : ")
      wcl_strip:addLabel(nil,vTidy)
      wcl_strip:addNewLine()
      
      wcl_strip:addLabel(nil, _t(126).." : ")
      wcl_strip:addLabel(nil,web)
      wcl_strip:addLabel(nil, "YuiCompressor : v. ")
      wcl_strip:addLabel(nil,vyuicompressor)
      wcl_strip:addNewLine()
      
      wcl_strip:addSpace()
      wcl_strip:addSpace()
      wcl_strip:addLabel(nil, "dnGREP : v. ")
      wcl_strip:addLabel(nil,vFar)
      wcl_strip:addNewLine()
      
      wcl_strip:addSpace()
      wcl_strip:addSpace()
      wcl_strip:addLabel(nil, "Regexerator : v. ")
      wcl_strip:addLabel(nil,vRegex)
      wcl_strip:addNewLine()
      
      --wcl_strip:addSpace()
      --wcl_strip:addButton("UPG","Verifica &Aggiornamenti RSciTE", buttonUpg_click)
      --wcl_strip:addSpace()
      --wcl_strip:addButton("OK","&Chiudi", buttonCanc_click, true)
      wcl_strip:show()
    end --endif
  end --endfunction


  visInfoDistribuzioneStripe()
end
