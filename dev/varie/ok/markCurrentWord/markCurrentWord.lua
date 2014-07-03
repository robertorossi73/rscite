--[[
Author  : Roberto Rossi
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura implementa la selezione della parola corrente su tutto il testo
del documento corrente

TODO : 
  - implementabile su tasto CTRL+ALT+F
  - inserire note su autore ufficiale della procedura di base, compresa licenza
  - menu che consenta di :
    1. evidenziare parola in corrispondenza del cursore
    2. evidenziare parola in corrispondenza del cursore, cercando anche parziali
    3. come punto 1. con inserimento di segnalibri
    4. come punto 2. con inserimento di segnalibri
    5. come punto 1. con copia linee in clipboard
    6. come punto 2. con copia linee in clipboard
    7. come punto 1. con conteggio occorrenze trovate su output
    8. come punto 2. con conteggio occorrenze trovate su output
]]

do
  require("luascr/rluawfx") --libreria standard di RSciTE  

  --elimina qualsiasi evidenziazione
  local function clearOccurrences()
      scite.SendEditor(SCI_INDICATORCLEARRANGE, 0, editor.Length)
  end

  --evidenzia il testo selezionato su tutto il documento corrente
  local function markWordOccurrences(txt)
      scite.SendEditor(SCI_INDICSETSTYLE, 0, INDIC_ROUNDBOX)
      scite.SendEditor(SCI_INDICSETFORE, 0, 255) --color
      scite.SendEditor(SCI_INDICSETALPHA, 0, 80) --alpha channel
      if (txt ~= "") then
        local flags = SCFIND_WHOLEWORD --seleziona parola singola
        --local flags = 0 --seleziona anche parziale
        local s,e = editor:findtext(txt,flags,0)
        while s do
            scite.SendEditor(SCI_INDICATORFILLRANGE, s, e - s)
            s,e = editor:findtext(txt,flags,e+1)
        end
      end
  end
  
  -- evidenzia la parola corrente su tutto il documento
  local function markOccurrences()
      clearOccurrences()
      markWordOccurrences(GetCurrentWord())
  end

  --indica se il caratteri specificato fa o meno parte di una parola
  local function isWordChar(char)
      local strChar = string.char(char)
      if strChar ~= nil then
        local beginIndex = string.find(strChar, '%w')
        if beginIndex ~= nil then
            return true
        end
        if strChar == '_' or strChar == '$' then
            return true
        end
      end 
      
      return false
  end

  -- ritorna la parola in corrispondenza del cursore
  local function GetCurrentWord()
      local beginPos = editor.CurrentPos
      local endPos = beginPos
      if editor.SelectionStart ~= editor.SelectionEnd then
          return editor:GetSelText()
      end
        while isWordChar(editor.CharAt[beginPos-1]) do
            beginPos = beginPos - 1
        end
        while isWordChar(editor.CharAt[endPos]) do
            endPos = endPos + 1
        end
      return editor:textrange(beginPos,endPos)
  end

  markOccurrences()

end
