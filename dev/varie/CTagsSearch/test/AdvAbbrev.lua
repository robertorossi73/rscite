--[[
Version : 2.1.3
Web     : http://www.redchar.net

Inserimento guidato abbreviazioni

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

  --ritorna la parola a sinistra del cursore
  --quando seleziona=true, lascia la parola selezianta al termine della
  --funzione
  local function getCurrentLeftWord (seleziona)
    local result
    local pos
      pos = editor.CurrentPos
      editor:WordLeftExtend()
      result = editor:GetSelText()
      if (not(seleziona)) then
        editor:GotoPos(pos)
      end
    return result
  end
  
  --ritorna il nome del file modello in base al tipo di file corrente
  local function getNomeModelFile (defaultFileName)
    local folder = props["SciteDefaultHome"].."/abbrev/"
    local result
    
    if (defaultFileName ~= "") then
      if (defaultFileName == "abbrev.properties") then
        folder = props["SciteDefaultHome"]..'/abbrev/'
      end
      result = folder..defaultFileName
    else
      result = rfx_getCurrent_abbrev_file()
    end
    return result
  end
  
  -- presa una linea, separa i dati (max 4) e li restituisce
  local function dividiDatiRichiesta ( linea, separatore )
    local d1 = nil
    local d2 = nil
    local d3 = nil
    local d4 = nil
    local pos = 1

    pos = string.find(linea, separatore)
    if pos then --dato 1
      d1 = string.sub(linea, 1, pos - 1)
      linea = string.sub(linea, pos + 1)
    end
    pos = string.find(linea, separatore)
    if pos then --dato 2
      d2 = string.sub(linea, 1, pos - 1)
      linea = string.sub(linea, pos + 1)
    end
    pos = string.find(linea, separatore)
    if pos then --dato 3
      d3 = string.sub(linea, 1, pos - 1)
      linea = string.sub(linea, pos + 1)
    end
    if (linea ~= "") then
      if not(d1) then
        d1 = linea
        d2 = ""
        d3 = ""
        d4 = ""
      elseif not(d2) then
        d2 = linea
        d3 = ""
        d4 = ""
      elseif not(d3) then
        d3 = linea
        d4 = ""
      else
        d4 = linea
      end --scelta d
    end
    return d1, d2, d3, d4
  end

  --sezione colore da parte dell'utente
  local function selezionaColore ()
    local r,g,b
    local scelta

    code,r,g,b = rwfx_GetColorDlg()
    if code then
      r = string.format("%X",r)
      g = string.format("%X",g)
      b = string.format("%X",b)
      if (string.len(r) == 1) then r = "0"..r end
      if (string.len(g) == 1) then g = "0"..g end
      if (string.len(b) == 1) then b = "0"..b end
      scelta = r..g..b
    else
      scelta =  ""
    end
    return scelta
  end

  --data la linea di un modello, ritorna il file .ini indicato
  --sintassi :
  --[#abbrevfile:xxxx.ini#]
  local function getModelFileFromLine(linea)
    local pos
    local result = ""
    local nome = "%[%#abbrevfile"
    
    pos = string.find(linea, nome)
    if pos then
      result = string.sub(linea, string.len(nome),(string.len(linea) - 2))
    end
    return result
  end

  --data la linea di un modello, ritorna il file script da eseguire
  --sintassi :
  --[#dofile:xxxx#]
  local function getDoFileFromLine(linea)
    local pos
    local result = ""
    local nome = "%[%#dofile"
    
    pos = string.find(linea, nome)
    if pos then
      result = string.sub(linea, string.len(nome),(string.len(linea) - 2))
      if (not((string.find(result,"\\") or string.find(result,"/")))) then
        result = props["SciteDefaultHome"].."/luascr/"..result
      end
    end
    return result
  end
  
  --funzione per gestione e richieste inserite in modelli
  local function compilaModello ( linea )
    local pos --inizio template
    local pos2 --fine template
    local posSeparatore --posizione prima virgola in template
    local comando --comando per richieste
    local titolo --titolo per richieste
    local richiesta --richiesta
    local tblRichieste = {}--richieste precedenti
    local iRichiesta = 1 --indice richiesta attuale
    local indice
    local default --valore predefinito per richieste
    local dato --valore impostato dall'utente
    local modello
    local colore
    local lstElementi --lista elementi tra cui scegliere
    local lstTxt --lista elementi concatenati
    local i --indice numerico temporaneo
    local tmpTxt --testo temporaneo

    pos = 0
    while pos do
      pos = string.find(linea, "%[%#", pos + 1)
      pos2 = pos
      if pos then --trovato inizio modello
        pos2 = string.find(linea, "%#%]", pos2 + 1)
        if pos2 then --trovato fine modello
          modello = string.sub(linea, pos + 2, pos2 - 1)
          posSeparatore = string.find(modello,";")--separatore richiesta
          if ((modello == "colore") or
              (modello == "colore1") or
              (modello == "colore2") or
              (modello == "colore3") or
              (modello == "colore4") or
              (modello == "color")) then
            -- gestione inserimento colori
            colore = selezionaColore()
            linea = string.gsub(linea, "%[%#"..modello.."%#%]", colore)
          elseif ((modello == "richiesta1") or
                  (modello == "richiesta2") or
                  (modello == "richiesta3") or
                  (modello == "richiesta4") or
                  (modello == "richiesta5")) then
              -- gestione valori richieste precedenti
              indice = tonumber(string.sub(modello,10))
              linea = string.gsub(linea, "%[%#"..modello.."%#%]", tblRichieste[indice])
          elseif (posSeparatore) then --gestione richieste
            comando,titolo,richiesta,default = dividiDatiRichiesta(modello,";")
            if (comando=="richiesta") then --richiesta semplice
              dato = rwfx_InputBox(default, titolo, richiesta, rfx_FN());
              if not(dato) then
                dato = ""
              else
                dato = rfx_GF()
              end --dato
              tblRichieste[iRichiesta]=dato
              iRichiesta = iRichiesta + 1
              linea = string.gsub(linea, "%[%#"..modello.."%#%]", dato)
            elseif (comando=="lista") then --lista elementi da inserire
              lstElementi = rfx_Split(modello,";")
              table.remove(lstElementi, 1) --rimuove il comando
              table.remove(lstElementi, 1) --rimuove il titolo
              
              lstTxt = lstElementi[1]
              i = 2
              --compone la lista da visualizzare
              while (i <= table.getn(lstElementi)) do
                lstTxt = lstTxt.."|"..lstElementi[i]
                i = i + 1
              end

              scelta = rwfx_ShowList(lstTxt,titolo)
              if (scelta) then
                tmpTxt = lstElementi[scelta+1]
                --linea = string.gsub(linea, "%[%#"..modello.."%#%]", tmpTxt)
                linea = string.sub(linea,1, pos-1)..tmpTxt..string.sub(linea,pos2+2)
              else
                linea = ""
              end --endscelta
            end -- end scelta comando
          end --end gestione richieste
        end --if pos2
      end --if
    end --while
    return linea
  end

  -- funzione per scansione linee
  local function inserisciLinee (indice, linea)
    editor:NewLine()
    editor:ReplaceSel(linea)
  end

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

  --caricamento file con modelli
  local function getAbbrevFormats(nomefModels)
    local lstFormat={}
    local idf
    local i
    local line
    local ch

    idf = io.open(nomefModels, "r")
    if (idf) then
      i = 1
      for line in idf:lines() do
        ch = string.sub(trimStringa(line),1,1)        
        if ((ch ~= "#") and --elimina commenti, sezioni e linee vuote
            (ch ~= "[") and
            (ch ~= ";") and
            (line ~= "")) then
          lstFormat[i] = line;
          i = i + 1;
        end
      end
      io.close(idf)
    end
    return lstFormat
  end

  --ritorna la parte a sinistra del =
  local function GetTitle (linea)
    local pos
    local titolo=""

    pos = string.find(linea,"=")
    if (pos) then
      titolo=string.sub(linea,1,(pos-1))
    end
    return titolo
  end

  --ritorna la parte di linea successiva a =
  local function GetFormat( linea )
    local pos
    local formato=""

    pos = string.find(linea,"=")
    if (pos) then
      formato=string.sub(linea,pos+1)
    end
    return formato
  end

  -- splitta le linee che compongono il modello e ritorna una tabella
  local function SplitLines ( linea )
    local parola = ""
    local result = {}
    local pos = 0
    local i = 1

    pos = string.find(linea, "\\n")
    while pos do
      parola = string.sub(linea, 1, (pos - 1))
      result[i] = parola
      i = i + 1
      linea = string.sub(linea, (pos + 2))
      pos = string.find(linea, "\\n")
    end --endwhile
    result[i] = linea
    return result
  end --endfunction

  --funzione principale
  local function AbbrevSelectionFormat (nomefModels)
    local pos = 0
    local formato
    local lstFrmts
    local strLst = ''
    local valore
    local idv
    local posPipe
    local selezione
    local cursorpos
    local posInizioSelezione = 0
    local lineaInizioSelezione = 0
    local nSpazi = 0
    local dimLista = 0
    local newIniFile=""
    local newScriptFile=""
    
    lstFrmts = getAbbrevFormats(nomefModels)

    for idv, valore in pairs(lstFrmts) do
      if (strLst == '') then
        strLst = GetTitle(valore)
      else
        strLst = strLst..'|'..GetTitle(valore)
      end
    end
    if (strLst ~= '') then
      --  10- Personalizza modelli
      strLst = strLst..'|'..
               "....|".._t(10).."..."
    end
    
    -- 11- Abbreviazioni Avanzate
    idv = rwfx_ShowList(strLst,_t(11))
    if (idv) then
      dimLista = table.getn(lstFrmts)
      if (idv < dimLista) then
        formato = GetFormat(lstFrmts[idv+1])
        
        --controllo se ho selezionato un link a file modello
        newIniFile = getModelFileFromLine(formato)
        if (newIniFile == "") then
          newScriptFile = getDoFileFromLine(formato)
        end
        
        if (newIniFile ~= "") then
          --nuovo file ini
          AbbrevSelectionFormat(getNomeModelFile(newIniFile))
        elseif (newScriptFile ~= "") then
          dofile(newScriptFile)
        else
          --inizio inserimento modello
          selezione = editor:GetSelText()
          if (selezione == "") then
            cursorpos = editor.CurrentPos
          else
            cursorpos = -1
          end
          posInizioSelezione = editor.SelectionStart
          lineaInizioSelezione = editor:LineFromPosition(posInizioSelezione)
          nSpazi = (posInizioSelezione -
                    editor:PositionFromLine(lineaInizioSelezione)
                   )

          --inizio sostituzioni
          formato = string.gsub(formato,"\\n","\n"..string.rep(" ",nSpazi))
          formato = compilaModello(formato)
          --fine sostituzioni
          posPipe = string.find(formato,"|")
          formato = string.gsub(formato,"|",selezione)

          editor:ReplaceSel(formato)
          if ((cursorpos > -1) and (posPipe)) then
            editor:GotoPos(cursorpos + posPipe - 1)
          end
        end
        
      elseif ((idv - 1) == dimLista) then
        scite.Open(nomefModels);
      end --endif idv <
    end --endif idv
  end

  AbbrevSelectionFormat(getNomeModelFile(""))  
  
end

