--[[
Version : 2.0.8
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
    if not(testo == '') then
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
    else
      rwfx_MsgBox(rfx_GetStr("Nessuna Selezione! Selezionare del testo e riprovare."),
                  rfx_GetStr("Attenzione!"),MB_OK)
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
  
  --procedura principale
  local function EseguiFormattazione ( )
    local opzioni = ""
    local scelta
    local posizione
    
    -- 60=Formatta al margine destro
    -- 61=Formatta indicando la posizione del margine destro
    -- 62=Formatta solo linee che eccedono il margine
    -- 63=Formatta solo linee che eccedono la posizione indicata
    -- 64=Formattazione Testo
    -- 65=Margine Destro
    -- 66=Indicare la posizione del margine destro :
    -- 67=\r\n\r\nSolo le linee che eccedono questa posizione verranno formattate.
    
    posizione = tonumber(props["edge.column"])
    opzioni = _t(60).."|"..
              _t(61).."|"..
              _t(62).."|"..
              _t(63)
    scelta = rwfx_ShowList(opzioni,_t(64))
    
    if (scelta) then
      if (scelta == 0) then --normale
        FormattaSelezione(posizione)
      elseif (scelta == 1) then --indicando posizione
        posizione = rwfx_InputBox(props["edge.column"], _t(65),_t(66), rfx_FN());
        if (posizione) then
          posizione = rfx_GF()
          posizione = tonumber(posizione)
          if (posizione > 0) then
            FormattaSelezione(posizione)
          end
        end
      elseif (scelta == 2) then --solo linee che eccedono
        FormattaLineePiuLunge(posizione)
      elseif (scelta == 3) then --linee che eccedono con posizione
        posizione = rwfx_InputBox(props["edge.column"], _t(65),
        _t(66)..
        _t(67), rfx_FN());
        if (posizione) then
          posizione = rfx_GF()
          posizione = tonumber(posizione)
          if (posizione > 0) then
            FormattaLineePiuLunge(posizione)
          end
        end
      end
    end    
  end
  
  EseguiFormattazione()
end --modulo
