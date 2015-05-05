--[[ # -*- coding: utf-8 -*-
Version : 1.0.2
Web     : http://www.redchar.net

Generatore di testi "Lorem Ipsum"
;materiale tratto da http://lipsum.com

Copyright (C) 2012-2015 Roberto Rossi 
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

-----------------------------------Versioni------------------------------------
1.0.2
  - testi tratti da http://www.lipsum.com/
  - release iniziale

]]


do
  require("luascr/rluawfx")
  
  local lorem_types = {_t(263), _t(264), _t(265), _t(266)}
  --local lorem_types = {"Inserisci Parole", "Inserisci Frasi", "Inserisci Paragrafi", "Inserisci Caratteri"}
  
  --ritorna il paragrafo identificato da id (1-150)
  local function getLoremPar(id)
    local nomeFile = props["SciteDefaultHome"].."/luascr/loremgen2.ini"
    local sezione = "paragraphs"
    local valore = "par"..tostring(id)
    local data
    local i
    local v
    
    data = rfx_GetIniVal(nomeFile, sezione, valore)
    return data
  end
  
  --ritorna tabella con le parole contenuto in par
  local function splitWord (par)
    return rfx_Split(par, " ")
  end
  
  --rtorna tabella con le frasi contenute in par
  local function splitPhrases (par)
    return rfx_Split(par, "%.")
  end

  --ritorna una tabella composta da n linee
  local function insList(nlines)
    local ncl = 0
    local i
    local v
    local tmp_lines
    local par_i = 1
    local par
    
    while (ncl < nlines) do
      if (par_i == 251) then
        par_i = 1
      end
      
      par = getLoremPar(par_i) 

      tmp_lines = splitPhrases(par)
      
      for i,v in ipairs(tmp_lines) do
        if (v ~= "") then
          if (ncl < nlines) then
            v = v..".\n"
            editor:ReplaceSel(v)
            ncl = ncl + 1
          end
        end
      end
      
      par_i = par_i + 1
    end
  end
  
  --ritorna un testp composto da n caratteri
  local function insChars(nchars)
    local nc = 0
    local i
    local v
    local tmp_lines
    local par_i = 1
    local par
    
    while (nc < nchars) do
      if (par_i == 251) then
        par_i = 1
      end
      
      par = getLoremPar(par_i)

      if (string.len(par) >= nchars) then
        editor:ReplaceSel(string.sub(par,1,nchars))
        nc = nchars
      else
        i = nchars - nc
        editor:ReplaceSel(string.sub(par,1,i))
        if (i <= string.len(par)) then
          nc = nc + i
        else
          nc = nc + string.len(par)
        end
      end
      
      par_i = par_i + 1
    end
  end
  
  --ritorna un testo composta da n parole
  local function insWords(nwords)
    local ncw = 0
    local i
    local v
    local tmp_words
    local par_i = 1
    local par
    
    while (ncw < nwords) do
      if (par_i == 251) then
        par_i = 1
      end
      
      par = getLoremPar(par_i) 

      tmp_words = splitWord(par)
      
      for i,v in ipairs(tmp_words) do
        if (v ~= "") then
          if (ncw < nwords) then
            editor:ReplaceSel(v.." ")
            ncw = ncw + 1
          end
        end
      end
      
      par_i = par_i + 1
    end
  end
  
  --ritorna una tabella composta da n paragrafi
  local function insPar(nPar)
    local np = 0
    local i
    local v
    local tmp_lines
    local par_i = 1
    local par
    
    while (np < nPar) do
      if (par_i == 251) then
        par_i = 1
      end
      
      par = getLoremPar(par_i)

      editor:ReplaceSel(par.."\n")
      np = np + 1
      par_i = par_i + 1
    end
  end
  
  function buttonOk_click(control, change)
    local tval = wcl_strip:getValue("TVAL") --tipo inserimento
    local qval = tonumber(wcl_strip:getValue("QVAL")) --quantità
    
    if (qval > 0) then
      if (tval == _t(263)) then --parole
        insWords(qval)
      elseif (tval == _t(264)) then --frasi/lista
        insList(qval)
      elseif (tval == _t(265)) then --paragrafi
        insPar(qval)
      elseif (tval == _t(266)) then --caratteri
        insChars(qval)
      end
    else
      --\nImpossibile procedere, la quantità deve essere maggiore di 0!
      print(_t(267))
    end
    
  end
  
  local function main()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    --wcl_strip:addLabel(nil, "Numero Elementi : ")
    wcl_strip:addLabel(nil, _t(261))
    wcl_strip:addText("QVAL", "8")

    wcl_strip:addLabel(nil, _t(262))
    --wcl_strip:addLabel(nil, "Tipo  : ")
    wcl_strip:addCombo("TVAL")
    
    --wcl_strip:addButton("OK","&Inserisci",buttonOk_click, true)
    wcl_strip:addButton("OK",_t(251),buttonOk_click, true)
    
    wcl_strip:show()
    wcl_strip:setList("TVAL",lorem_types)
    wcl_strip:setValue("TVAL", lorem_types[1])
  end
  
  main()
end
