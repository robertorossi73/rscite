--[[
Version : 3.0.0
Web     : http://www.redchar.net

Questa procedura formatta la selezione corrente, inserendo un ritorno
a capo in corrispondenza del limite destro imposto dalla
variabile 'edge.column', oppure indicato dall'operatore, inoltre consente
di formattare solo le linee più lunghe di un tot

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

V.3.0.0
- introduzione interfaccia Stripe

]]

do 
  require("luascr/rluawfx")
  
  --toglie spazi e tabulazioni a inizio e fine linea
  local function trimStringa( testo )
    local result = ""
    local pos1 = 0
    local pos2 = 0
    
    --trova il primo carattere NON spazio e NON tabulazione
    pos1 = string.find(testo, "[^ \t]")
    --trova l'ultimo carattere NON spazio e NON tabulazione
    pos2 = string.find(testo, "[ \t]+$")
    
    if pos2 then
      if (pos2 > pos1) then
        pos2 = pos2 - 1
      end
      result = string.sub(testo, pos1 , pos2)
    else
      if pos1 then
        result = string.sub(testo, pos1)
      end
    end
    return result
  end

  --elimina gli spazi e le tabulazioni alla fine e all'inizio delle linee
  --selezionate
  --n.b.: è possibile specificare se mantenere la selezione al termine
  --      delel operazioni di taglio
  local function trimLineeSelezionate ( mantieniSelezione )
    local ultimaLinea
    local primaLinea
    local i
    local testo
    local inizio
    local fine    
    
    inizio = editor.SelectionStart
    primaLinea = editor:LineFromPosition(editor.SelectionStart)
    ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
    
    -- scansione Linee
    i = primaLinea
    while (i <= ultimaLinea) do
      editor:GotoLine(i)
      editor:Home()
      editor:LineEndExtend()
      testo = editor:GetSelText()
      testo = trimStringa(testo)
      editor:ReplaceSel(testo)
      i = i + 1
    end --endwhile
    
    if (mantieniSelezione) then
      editor:GotoLine(ultimaLinea)
      editor:LineEnd()
      fine = editor.CurrentPos
      editor.SelectionStart = inizio
      editor.SelectionEnd = fine
    end --if
  end
  
  --individua la posizione dell'ultimo separatore (spazio o tabulazione)
  --presente nel testo passato
  local function trovaUltimoSeparatore ( linea )
    local i
    local lung
    local ch
    local ultimo = nil
  
    lung = string.len(linea)
    i = 1
    while (i <= lung) do
      ch = string.sub(linea,i,i);
      if ((ch == " ") or (ch == "\t")) then
        ultimo = i
      end
      i = i + 1
    end
    
    return ultimo;
  end
  
  local function FormattaSelezione (limiteDestro)
    local testo = ""
    local flagSpazio = nil
    local ultimoCaValido = 0
    local ultimoSeparatore = nil
    local linea = ""
    local i = 0
    local lung = 0
    local ch = ''
    local result = ''
    local primaLinea
    local ultimaLinea
    local inizio
    local fine
    
    --elimina spazi da selezione
    trimLineeSelezionate(true)
    
    --inizio selezione completa linee
    primaLinea = editor:LineFromPosition(editor.SelectionStart)
    ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
    editor:GotoLine(primaLinea)
    editor:Home()
    inizio = editor.CurrentPos
    editor:GotoLine(ultimaLinea)
    editor:LineEnd()
    fine = editor.CurrentPos
    editor.SelectionStart = inizio
    editor.SelectionEnd = fine
    --fine selezione completa linee
    
    testo = editor:GetSelText()
    if (string.len(testo) > 0) then
      if string.find(testo,"\n") then
        testo = string.gsub(testo,"\n"," ")
        flagSpazio = true
      end
      
      if string.find(testo,"\r") then
        if flagSpazio then
          testo = string.gsub(testo,"\r","")
        else
          testo = string.gsub(testo,"\r"," ")
        end
      end
      
      lung = string.len(testo)
      i = 1
      while (i <= lung) do
        ch = string.sub(testo,i,i);
        linea = linea..ch
        if (string.len(linea) >= limiteDestro) then
          ultimoSeparatore = trovaUltimoSeparatore(linea)
          if (ultimoSeparatore) then
            result = string.sub(linea,1,(ultimoSeparatore - 1))
            if (i > (limiteDestro + 1)) then
              editor:ReplaceSel("\n"..result)
            else
              editor:ReplaceSel(result)
            end
            linea = string.sub(linea, (ultimoSeparatore + 1))
          end
        end  
        i = i + 1
      end
      if not(linea == "") then
        if ((primaLinea == ultimaLinea) and (lung < limiteDestro)) then --se seleziono solo una riga
          editor:ReplaceSel(linea) --non inserisco il ritorno a capo
        else
          editor:ReplaceSel("\n"..linea)
        end
      end
    --else
      --print("Impossibile continuare, selezionare il testo!")
    end --if
  end --end function
  
  --formatta solo le linee la cui lunghezza supera dimMassima
  local function FormattaLineePiuLunge ( dimMassima )
  local ultimaLinea
    local primaLinea
    local i
    local testo
    local inizio
    local fine    
    local conteggio
    
    inizio = editor.SelectionStart
    primaLinea = editor:LineFromPosition(editor.SelectionStart)
    ultimaLinea = editor:LineFromPosition(editor.SelectionEnd)
    conteggio = editor.LineCount
    
    -- scansione Linee
    i = primaLinea
    while (i <= ultimaLinea) do
      editor:GotoLine(i)
      editor:Home()
      editor:LineEndExtend()
      testo = editor:GetSelText()
      if (string.len(testo) > dimMassima) then
        FormattaSelezione(dimMassima)
        ultimaLinea = ultimaLinea + (editor.LineCount - conteggio)
        conteggio = editor.LineCount
      end
      editor:Home()
      i = i + 1
    end --endwhile
  end
  
  --esecuzione formattazione
  function buttonOk_click(control, change)
    local scelta
    local posizione
    local okNext = true
    
    scelta = wcl_strip:getValue("OPZIONI")
    posizione = tonumber(wcl_strip:getValue("COLONNA"))
    
    if (not(posizione) or (posizione <= 2)) then
      --print("-> Formattazione Testo\nAttenzione : Colonna specificata per formattazione non valida!")
      print(_t(253))
      okNext = false
    end
    
    if ((scelta ~= _t(60))  and (scelta ~= _t(62))) then
      --print("-> Formattazione Testo\nAttenzione : Tipo di formattazione non valido!")
      print(_t(252))
      okNext = false
    end
    
    if (okNext) then
      if (scelta == _t(60)) then
        FormattaSelezione(posizione)
      else
        FormattaLineePiuLunge(posizione)
      end
    end
  end

  local function main()
    local testo = ""
    local opzioni = {}
    local scelta
    local posizione
    
    --TODO : modificare frasi 60 e 62 per renderle coerenti
    -- 60=Formatta al margine destro
    -- 61=Formatta indicando la posizione del margine destro
    -- 62=Formatta solo linee che eccedono il margine
    -- 63=Formatta solo linee che eccedono la posizione indicata
    -- 64=Tipo allineamento :
    -- 65=Colonna Margine Destro :
    -- 66=&Esegui
    -- 67=\r\n\r\nSolo le linee che eccedono questa posizione verranno formattate.
    
    posizione = tonumber(props["edge.column"])
    opzioni = {_t(60), _t(62)}   
    
    wcl_strip:init()

    wcl_strip:addButtonClose()
    wcl_strip:addLabel(nil, _t(64))
    wcl_strip:addCombo("OPZIONI")
    wcl_strip:addLabel(nil, _t(65))
    wcl_strip:addText("COLONNA",posizione)
    
    wcl_strip:addButton("ESEGUI",_t(66), buttonOk_click, true)

    wcl_strip:show()
    
    wcl_strip:setList("OPZIONI", opzioni)
    wcl_strip:setValue("OPZIONI", opzioni[1])

  end
  
  main()
end --modulo
