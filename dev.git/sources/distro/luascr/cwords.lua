--[[
Version : 2.1.6
Web     : http://www.redchar.net

Questa procedura mostra statistiche sul file corrente

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

  local caratteriOK = props["chars.alpha"]..props["chars.accented"]..props["chars.numeric"]; --caratteri inclusi in parole

  local function insertLinea( idx, linea )
    editor:AddText(linea);
  end
  
  --conta i ritorni a capo nella stringa
  local function countRetCapInString ( linea )
    local numR=0;
    local numN=0;
    
    for w in string.gfind(linea, "\r") do
      numR = numR + 1;
    end
    for w in string.gfind(linea, "\r") do
      numN = numN + 1;
    end
    
    if (numR > numN) then
      return numR + 1;
    else
      return numN + 1;
    end
  end
  
  --controlla se ch è un carattere facente parte di una parola o un separatore
  local function checkIsChar( ch )
    if (ch ~= '[') and (ch ~= '=') and (ch ~= '(') and (ch ~= '%') then
      if string.find(caratteriOK,ch) then
        return true;
      else
        return false;
      end
    else
      return false;
    end
  end

  local function GetStatLine(linea)
    local ch, token;
    local i;
    --lunghezza file
    local lung;
    --numero caratteri senza separatori, numero parole
    local numChars,numWords;
    --numero spazi
    local numSpaces;
    
    if (linea) then
      lung = string.len(linea);
    else
      lung = 0;
    end
    token = "";
    numChars = 0;
    numWords = 0;
    numSpaces = 0;
    i = 1;
    while (i <= lung) do
      ch = string.sub(linea,i,i);
      if checkIsChar(ch) then
        numChars = numChars + 1;
        token = token..ch;
      else
        if (ch == " ") then
          numSpaces = numSpaces + 1;
        end
        if (token ~= "") then
          numWords = numWords + 1;
        end
        token = "";
      end
      i=i+1
    end 
    if (token ~= "") then
      numWords = numWords + 1;
    end
    --numero parole, numero caratteri senza separatori, numero spazi,
    --numero separatori, lunghezza linea
    return {numWords, numChars, numSpaces, (lung - numChars) , lung};
  end
  
  local function GetStat()
    local i, linea, dati;
    local messaggio;
    --testo selezionato
    local txtSel;
    --lunghezza file
    local lung = 0;
    local lungSel = 0;
    --numero linee
    local nlines=0;
    local nlinesSel=0;
    --media lunghezza linee
    local mediaLLine=0;
    local mediaLLineSel=0;
    --numero caratteri senza separatori
    local numChars=0;
    local numCharsSel=0;
    --numero parole
    local numWords=0;
    local numWordsSel=0;
    --numero spazi
    local numSpaces=0;
    local numSpacesSel=0;
    --numero separatori
    local numSep=0;
    local numSepSel=0;
    
    lung = editor.Length;--lunghezza file
    i = 0;
    linea = editor:GetLine(i);
    while linea do 
      dati = GetStatLine(linea);
      numWords = numWords + dati[1]; --parole
      numChars = numChars + dati[2]; --caratteri in parole
      numSpaces = numSpaces + dati[3]; --spazi
      numSep = numSep + dati[4]; --separatori con spazi
      nlines = nlines + 1; --numero linee
      i = i + 1;
      linea = editor:GetLine(i);
    end
    
    txtSel = editor:GetSelText();
    if (txtSel ~= "") then
      dati = GetStatLine(txtSel);
      lungSel = string.len(txtSel);
      numWordsSel = dati[1]; --parole
      numCharsSel = dati[2]; --caratteri in parole
      numSpacesSel = dati[3]; --spazi
      numSepSel = dati[4]; --separatori con spazi
      nlinesSel = countRetCapInString(txtSel);
    end
    
    -- 25=Statistiche
    -- 26=Totale File Corrente
    -- 27=Parole
    -- 28=Righe
    -- 29=Caratteri(senza spazi)
    -- 30=Caratteri(tutto)
    -- 31=Selezione Corrente
    -- 32=Parole
    -- 33=Righe
    -- 34=Caratteri(senza spazi)
    -- 35=Caratteri(tutto)
    -- 36=Statistiche
    mediaLLine = lung / nlines;--media lunghezza linee
    messaggio = "-- ".._t(25).." -------------------------------------------\n\n";
    messaggio = messaggio.." ".._t(26);
    messaggio = messaggio.."\n".._t(27).." :\t\t\t"..numWords;
    messaggio = messaggio.."\n".._t(28).." :\t\t\t"..nlines;
    messaggio = messaggio.."\n".._t(29).." :\t"..(lung-numSpaces);
    messaggio = messaggio.."\n".._t(30).." :\t\t"..lung;
    messaggio = messaggio.."\n\n ".._t(31);
    messaggio = messaggio.."\n".._t(32).." :\t\t\t"..numWordsSel;
    messaggio = messaggio.."\n".._t(33).." :\t\t\t"..nlinesSel;
    messaggio = messaggio.."\n".._t(34).." :\t"..(lungSel-numSpacesSel);
    messaggio = messaggio.."\n".._t(35).." :\t\t"..lungSel;
    rwfx_MsgBox(messaggio,_t(36), MB_OK)
  end--endfunction
  
  GetStat()
end
