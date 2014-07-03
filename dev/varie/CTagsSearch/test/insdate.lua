--[[
Version : 2.3.2
Web     : http://www.redchar.net

Questa procedura Inserisce in corrispondenza della posizione del
cursore, la data e l'ora corrente

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
  
  local fileFormat = ""
  
  if (rwfx_isEnglishLang()) then
    fileFormat = props["SciteDefaultHome"].."/luascr/datefr-en.ini"
  else --lingua diversa da inglese
    fileFormat = props["SciteDefaultHome"].."/luascr/datefr.ini"
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

  local function getTableFormat()
    local lstFormat={};
    local idf, i;
    local line;
    local ch

    idf = io.open(fileFormat, "r");
    if (idf) then
      i = 1;
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
      io.close(idf);
    end
    return lstFormat;
  end

  local function InsCurrentDate ()
    local pos = 0;
    local data;
    local formato;
    local lstDate;
    local strLst = '';
    local valore;
    local idv;
    local pos;
    local dimLista

    --impostazione configurazione corrente per ora/data/valuta/ecc...
    os.setlocale("")
    
    lstDate = getTableFormat();

    for idv, valore in pairs(lstDate) do
      valore = string.gsub(valore,"="," -> ")
      if (strLst == '') then
        strLst = os.date(valore);
      else
        strLst = strLst..'|'..os.date(valore);
      end
    end
    
    -- 82=Personalizza Date
    -- 83=Formato data
    if (strLst ~= '') then
      strLst = strLst..'|'..
               "....|".._t(82).."..."
    end
    
    strLst = string.gsub(strLst, '%[%#timestamp%#%]', os.time()) --timestamp
    
    idv = rwfx_ShowList(strLst,_t(83));
    if (idv) then
      dimLista = table.getn(lstDate)
      if (idv < dimLista) then
        formato = lstDate[idv+1];
        pos = string.find(formato,"=");
        if (pos) then
          formato=string.sub(formato,(pos+1));
        end
        data = os.date(formato);
        data = string.gsub(data, '%[%#timestamp%#%]', os.time()) --timestamp
        editor:ReplaceSel(data);
      elseif ((idv - 1) == dimLista) then
        scite.Open(fileFormat);
      end --endif
    end
  end
  InsCurrentDate();  
end
