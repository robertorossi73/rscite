--[[
Author  : Roberto Rossi
Version : 2.2.0
Web     : http://www.redchar.net

Questa procedura implementa un rudimentale correttore ortografico. 
Partendo dalla posizione del cursore scansiona il testo fino a trovare la 
prima parola non corretta nel testo.
Riconosce i file HTML e i caratteri speciali con &xxx;

TODO : 
  - funzione per ignorare parola fino al riavvio del software
  - funzione per settaggio dizionari (lingua) da utilizzare. Ogni lingua sarà
    composta da due file, quello di base del programma e quello utente/personale.
  - completare codici html interpretati

Copyright (C) 2011-2015 Roberto Rossi 
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
V.2.2.0
- corretta evidenziazione parole

V.2.0.0
- Aggiunta funzione per controllo di tutto il file con la sola evidenziazione
- Completata traduzione

]]

do

  --variabili globali :
  --  PUBLIC_dizionario = elenco parole dizionario
  --  PUBLIC_dizionari_file = elenco file/dizionari caricati

  require("luascr/rluawfx")
  
  --codici html interpretati
  local lstCodiciHtml = {
                          agrave="à";
                          egrave="è";
                          igrave="ì";
                          ograve="ò";
                          ugrave="ù"
                        }
                          
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
      result = string.sub(testo, pos1)
    end
    return result
  end

  --consente di evidenziare, con una sottolineatura una parte di testo
  local function decorate_range(pos,len,ind)
    
    editor.IndicatorCurrent = 2
    
    if (ind == -1) then
        editor:IndicatorClearRange(pos, len)
    else
        editor:IndicatorFillRange(pos, len)
    end
  end

  --consente di evidenziare, con una sottolineatura il testo selezionato
  local function highlight_current_selection(reset)
    local pos = editor.CurrentPos
    if (editor.SelectionEnd > editor.SelectionStart) then
      pos = editor.SelectionStart
    else
      pos = editor.SelectionEnd
    end
    local len = editor.SelectionEnd - editor.SelectionStart
    local ind = 128
    if (reset) then
      decorate_range(pos,len,-1)
    else
      decorate_range(pos,len,ind)
    end
  end

  --elimina l'evidenziazione del testo
  local function reset_highlight(filename)
    decorate_range(0,editor.TextLength,-1)
  end
  
  --questa funzione carica il file di testo contenente il dizionario.
  --Il dizionario viene caricato una sola volta per sessione, il secondo 
  --parametro indica se forzare il caricamento del dizionario indipendentemente
  --dal fatto che esista gia un dizionario in memoria.
  --Ogni dizionario caricato viene aggiunto al precedente, sommandosi in memoria
  local function CaricaDizionario (nomeFile, forceLoad)
    local i = 1
    local okLoad = false --forza lettura dati da file
    
    if not(PUBLIC_dizionario) then --inizializza dizionario
      PUBLIC_dizionario = {}
    end
    
    if not(PUBLIC_dizionari_file) then --elenco file/dizionari
      PUBLIC_dizionari_file = {}
      okLoad = true
    else
      if not(PUBLIC_dizionari_file[nomeFile]) then
        --carica dizionario se non ancora caricato
        okLoad = true
      end
    end
    
    if (forceLoad) then --forza caricamento dizionario
      okLoad = true
    end
    
    if (okLoad) then      
      if (rfx_fileExist(nomeFile)) then
        PUBLIC_dizionari_file[nomeFile] = true --file dizionario caricato

        for line in io.lines(nomeFile) do
          --elimina linee commentate
          if (string.sub(line, 1, 1) ~= "/" ) then
            PUBLIC_dizionario[line]=true
          end
          i = i + 1
        end
      --else
        --print("\nFile : "..nomeFile.. "doesn't exist!!")
      end
    end --endif
    
  end
  
  --converte i codici html in caratteri normali
  local function convertiHtmlInCaratteri ( linea )
    local ch1
    local ch2
    local ch
    local result = linea
    local sostituto
    local trova
    
    ch1, ch2 = string.find(result,"(&%w*;)")
    
    while (ch1) do
      ch = string.sub(result,ch1, ch2)      
      trova = string.sub(ch,2, string.len(ch)-1) --eliminazione primo e ultimo ch
      sostituto = lstCodiciHtml[trova]
      if not(sostituto) then
        sostituto = ""
      end      
      result = string.gsub(result, ch, sostituto)
      ch1, ch2 = string.find(result,"(&%w*;)")
    end

    return result
  end
  
  -- controlla se il file corrente ha sintassi XML o simili.
  -- ritorna false se il file è XML o simile
  -- ritorna true se il file NON è XML o simile
  local function ControlloSeFileNONXml ( )
    local normale = true
    local lexerAttuale
    
    lexerAttuale = scite.SendEditor(SCI_GETLEXER)
    --se uso un lexer html
    if ((SCLEX_HTML == lexerAttuale) or (SCLEX_XML == lexerAttuale)) then
      normale = false -- è un file a base xml
    end --if    
    return normale
  end

  --questa funzione aggiunge la parola data al dizionario personale e alle lista
  --delle parole caricate
  local function add_word_to_personal_dct(word)
    local nomef = rfx_UserFolderRSciTE()..'/personal.dct'
    local idf
    
    word = string.lower(word)
    idf = io.open(nomef,"a")
    if (idf) then
      idf:write(tostring(word).."\n")
      PUBLIC_dizionario[word] = true
      io.close(idf)
    end
  end
  
  --funzione che richiede correzione per parola selezionata
  --       All'utente viene chiesto cosa fare della parola selezionata.
  --        Sarà possibile selezionare :
  --        - correggere manualmente
  --        - ignora parola e continua controllo ortografico
  --        - aggiungi parola al dizionario personale
  -- ritorna true se l'utente sceglie di continuare il controllo ortografico
  local function gest_selected_word()
    local selected_word = ""
    local word = ""
    local scelta
    local result = false

    local opz = ""    
    opz = opz.._t(256) --"Correggi parola manualmente"
    opz = opz.._t(257) --"|Ignora parola e continua controllo ortografico"
    opz = opz.._t(258) --"|Aggiungi parola al dizionario e continua"
    opz = opz.._t(259) --"|Aggiungi parola al dizionario e termina"
    
    selected_word = editor:GetSelText()
    word = rfx_Trim(selected_word)
    
    if (not(word == "")) then      
      --scelta = rwfx_ShowList_Repos(opz,"Parola : "..word,"spellcheck_main");
      scelta = rwfx_ShowList_Repos(opz,_t(260)..word,"spellcheck_main");
      if scelta then
        if (scelta == 0) then -- correggi manualmente
          --non si fa nulla
        elseif (scelta == 1) then -- ignora parola e continua controllo ortografico
          result = true
        elseif (scelta == 2) then -- aggiungi parola al dizionario e continua
          --TODO : tutto
          add_word_to_personal_dct(word)
          highlight_current_selection(true)
          result = true
        elseif (scelta == 3) then -- aggiungi parola al dizionario e termina
          add_word_to_personal_dct(word)
          highlight_current_selection(true)
        end
      end
    end    
  
    return result
  end --end function
  
  -- cerca nel file la prima parola non presente nel dizionario
  -- ritorna true se è stata raggiunta la fine del file, altrimenti false
  local function EsaminaParole ()
    local posizione
    local parola
    local flagProssimo = true
    local documentoNonXML = true --true=controlla documenti non XML/HTML o simili
    local stopAnalisi = false
    local trovataFine = false
    
    documentoNonXML = ControlloSeFileNONXml()
    
    while flagProssimo do
      if not(editor.CurrentPos == editor.TextLength) then
        --stabilisce inizio scansione
        editor:SetSel(editor.CurrentPos,editor.CurrentPos)
        editor:WordRight()
        editor:WordLeft()
        editor:WordRightExtend()
        --editor:WordRightEndExtend()
        parola = editor:GetSelText()
        parola = trimStringa(parola)
        if (documentoNonXML or 
            (not((parola == "</") or
                 (parola == "></") or
                 (string.sub(parola,string.len(parola)) == "<")
                )
            and not(stopAnalisi))) then
          if (string.find(parola,"^%a+")) then
            parola = string.lower(parola)
            if not(documentoNonXML) then
              parola = convertiHtmlInCaratteri(parola)
            end
            
            --se la parola non è presente nel dizionario si ferma
            if not(PUBLIC_dizionario[parola]) then
              flagProssimo =  false
              trovataFine = false
              highlight_current_selection(false)
            end --if dizionario
          end --if find
        else
          if (parola == '>')then
            stopAnalisi = false
          else
            stopAnalisi = true
          end
        end --if <
      else
        --rwfx_MsgBox(rfx_GetStr("Raggiunta Fine del file."),
        --            rfx_GetStr("Controllo Ortografico"));
        rwfx_MsgBox("\n".._t(178),_t(179));
        flagProssimo = false
        editor:SetSel(editor.CurrentPos,editor.CurrentPos)
        trovataFine = true
      end --if
    end --while
    
    return trovataFine
  end

  --functione princiaple
  local function main ()
    local curpos
    local continua = true
    
    if (rwfx_isEnglishLang()) then
      CaricaDizionario(props["SciteDefaultHome"]..'/luascr/dct/english.dct',false)
      CaricaDizionario(rfx_UserFolderRSciTE()..'/personal.dct',false)
    else
      CaricaDizionario(props["SciteDefaultHome"]..'/luascr/dct/italiano.dct',false)
      CaricaDizionario(rfx_UserFolderRSciTE()..'/personal.dct',false)
    end
    if (PUBLIC_optionScript == "RH") then
      reset_highlight() --elimina evidenziazione parole in testo
    elseif (PUBLIC_optionScript == "AA") then
      --analizza l'intero file
      curpos = editor.CurrentPos
      reset_highlight()--elimina precedenti evidenziazioni
      while (continua) do
        continua = false
        if (not(EsaminaParole())) then
          continua = true --analisi continua
        end
      end
      editor:GotoPos(curpos)
    else
      while (continua) do
        continua = false
        if (not(EsaminaParole())) then
          continua = gest_selected_word()
        end
      end
    end
  end--end function

  main()
end 
