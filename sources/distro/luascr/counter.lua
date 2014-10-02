--[[ Conta linee
Version : 1.1.4
Web     : http://www.redchar.net

Questa procedura consente di contare le linee che :

- contengono o non contengono il testo specificato
- che iniziano o non iniziano con il testo specificato
- che terminano o non terminano con il testo specificato

In aggiunta esiste la possibilità di inserire dei segnalibri sulle linee trovate e di abilitare o meno la ricerca ignorando le maiuscole e le minuscole

Copyright (C) 2013 Roberto Rossi 
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

  local lineCount_opts = {
                _t(311),
                _t(312),
                _t(313),
                _t(314),
                _t(315),
                _t(316)
                --"Conta le linee che contengono il testo",
                --"Conta le linee che non contengono il testo",
                --"Conta le linee che iniziano con il testo",
                --"Conta le linee che non iniziano con il testo",
                --"Conta le linee che terminano con il testo",
                --"Conta le linee che non terminano con il testo"
                }
  local lineCount_opts_2 = {
                _t(317),
                _t(318)
                --"Non impostare Nessun Segnalibro",
                --"Inserisci Segnalibri su linee trovate" 
                }
  local lineCount_opts_3 = {
                _t(319),
                _t(320)
                --"Durante la ricerca Ignora Maiuscole/minuscole",
                --"Durante la ricerca Considera Maiuscole/minuscole"
                }
  
  local function contaLinee (strDaCercare, opt, bookmarksOpt, ignoreCaseOpt)
    local linea
    local x
    local i, pos, size, endLine
    local lineeTrovate = 0

    if (strDaCercare) then
      if (ignoreCaseOpt) then --ignora maiuscole/minuscole
        strDaCercare = string.lower(strDaCercare)
      end
    
      i = 0
      size = string.len(strDaCercare)
      linea = editor:GetLine(i)
      if (bookmarksOpt) then --aggiungi bookmarks, pulizia
        scite.MenuCommand(IDM_BOOKMARK_CLEARALL)
      end

      while linea do      
        linea = rfx_RemoveReturnLine(linea)
        
        if (ignoreCaseOpt) then --ignora maiuscole/minuscole
          linea = string.lower(linea)
        end        
        
        if (opt == 1) then --che contengono
          x = string.find(linea, strDaCercare, 1, true)
        elseif (opt == 2) then --che non contengono
          x = string.find(linea, strDaCercare, 1, true)
          if (x) then
            x = nil
          end
        elseif (opt == 3) then --che iniziano
          if (string.sub(linea, 1, size) == strDaCercare) then
            x = true
          else
            x = false
          end
        elseif (opt == 4) then --che non iniziano
          if (string.sub(linea, 1, size) ~= strDaCercare) then
            x = true
          else
            x = false
          end
        elseif (opt == 5) then --che terminano
          endLine = string.sub(linea,-(size))
          print(endLine)
          if (endLine == strDaCercare) then
            x = true
          else
            x = false
          end
        elseif (opt == 6) then --che non terminano
          endLine = string.sub(linea,-(size))
          if (endLine ~= strDaCercare) then
            x = true
          else
            x = false
          end
        end
        
        if (x) then
          pos = editor:PositionFromLine(i)
          editor.CurrentPos = pos
          lineeTrovate = lineeTrovate + 1
          if (bookmarksOpt) then --aggiungi bookmarks
            editor:MarkerAdd(i,1)          
          end
        end
        i = i + 1
        linea = editor:GetLine(i)
      end
      editor.CurrentPos = 0
      editor.SelectionStart = 0
      editor.SelectionEnd = 0

      --print("Il testo \""..strDaCercare.."\" e' stato trovato in \n> "..lineeTrovate.." linee")
      print(_t(321).." \""..strDaCercare.."\" ".._t(322).." \n> "..lineeTrovate.." ".._t(323))
    end--endif
  end
  
  function buttonOk_click(control, change)
    local opt = wcl_strip:getValue("TYPE")
    local opt2 = wcl_strip:getValue("TYPE2") --segnalibri
    local opt3 = wcl_strip:getValue("TYPE3") --maiuscole/minuscole
    local txt = wcl_strip:getValue("TVAL")
    
    if (txt ~= "") then
      if (lineCount_opts_2[2] == opt2) then --inserisci segnalibri
        opt2 =  true
      else
        opt2 = false
      end
      
      if (lineCount_opts_3[1] == opt3) then --ignora maiuscole/minuscole
        opt3 =  true
      else
        opt3 = false
      end
    
      if (lineCount_opts[1] == opt) then
        contaLinee(txt, 1, opt2, opt3)
      elseif (lineCount_opts[2] == opt) then
        contaLinee(txt, 2, opt2, opt3)
      elseif (lineCount_opts[3] == opt) then
        contaLinee(txt, 3, opt2, opt3)
      elseif (lineCount_opts[4] == opt) then
        contaLinee(txt, 4, opt2, opt3)
      elseif (lineCount_opts[5] == opt) then
        contaLinee(txt, 5, opt2, opt3)
      elseif (lineCount_opts[6] == opt) then
        contaLinee(txt, 6, opt2, opt3)
      end
    else
      --print("E' necessario specificare il testo da cercare!")
      print(_t(324))
    end
  end
  local function main()
  
  
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    wcl_strip:addLabel(nil, _t(326).." : ")
    wcl_strip:addText("TVAL",editor:GetSelText(), nil)
    wcl_strip:addNewLine()
    wcl_strip:addSpace();
    wcl_strip:addCombo("TYPE", nil)
    wcl_strip:addNewLine()
    wcl_strip:addSpace();
    wcl_strip:addCombo("TYPE3", nil)
    wcl_strip:addNewLine();
    wcl_strip:addSpace();
    wcl_strip:addCombo("TYPE2", nil)
    wcl_strip:addNewLine();
    wcl_strip:addSpace();
    --wcl_strip:addButton("OKBTN","Conta linee",buttonOk_click, true)
    wcl_strip:addButton("OKBTN",_t(325),buttonOk_click, true)

    wcl_strip:show()

    wcl_strip:setList("TYPE", lineCount_opts)
    wcl_strip:setValue("TYPE", lineCount_opts[1])

    wcl_strip:setList("TYPE2", lineCount_opts_2)
    wcl_strip:setValue("TYPE2", lineCount_opts_2[1])

    wcl_strip:setList("TYPE3", lineCount_opts_3)
    wcl_strip:setValue("TYPE3", lineCount_opts_3[1])
  end

  main()
end

