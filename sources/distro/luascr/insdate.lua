--[[ Gestione/Inserimento data-ora
Version : 4.0.0
Web     : http://www.redchar.net

Questa procedura permette il trattamento delle data/ora. Non solo consete di inserire, la data e l'ora corrente in vari formati ma permette di convertire le date tra vari formati, ad esempio da timestamp a data e viceversa.

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

  -- passata una data/ora in formato anno-mese-giorno ora:minuti:secondi
  -- ritorna una tabella con i dati corrispendenti
  -- il dato in ingresso è una data nel formato DD-MM-YYYY HH:MM:SS
  local function get_table_for_osdate(data)
    local tbdata = false
    local year = ""
    local month = ""
    local day = ""
    local hour = ""
    local minutes = ""
    local sec = ""
    local tbparts = {}
    local parts1 = {}
    local parts2 = {}
    --table must have fields year, month, and day, and may have fields hour, min, sec,
    
    tbparts = rfx_Split(data, " ")
    if (table.getn(tbparts) == 2) then
      parts1 = rfx_Split(tbparts[1],"-")
      parts2 = rfx_Split(tbparts[2],":")
      if ((table.getn(parts1) == 3) and (table.getn(parts2) == 3)) then
        year = parts1[3]
        month = parts1[2]
        day = parts1[1]
        hour = parts2[1]
        minutes = parts2[2]
        sec = parts2[3]
        tbdata = {}
        tbdata["year"] = year
        tbdata["month"] = month
        tbdata["day"] = day
        tbdata["hour"] = hour
        tbdata["min"] = minutes
        tbdata["sec"] = sec
      end
    end
    
    if (not(tbdata)) then
      --print("\nErrore : Data inserita, non corretta!")
      print(_t(185))
    end
    
    return tbdata
  end
  
  --esecuzione formattazione
  function buttonOk_click(control, change)
    local pos
    local formato
    local data
    local okNext = true
    local currentSelection = editor:GetSelText()
    local currentTimestamp = tonumber(currentSelection)
    local currentDate = "(?)"
    
    data = wcl_strip:getValue("DATA")
    formato = wcl_strip:getValue("FORMATO")
    
    if (okNext) then
    
        if (currentTimestamp) then
          currentDate = os.date("%c",currentTimestamp)
        end
    
        pos = string.find(formato,"->");
        if (pos) then
          formato=rfx_Trim(string.sub(formato,(pos+2)));
        end

        if (formato == "[#convertIntoTimestamp#]") then
          data = get_table_for_osdate(data)
          editor:ReplaceSel(os.time(data));
        else
          data = os.date(formato);
          data = string.gsub(data, '%[%#timestamp%#%]', os.time()) --timestamp
          data = string.gsub(data, '%[%#convertTimestamp%#%]', currentDate) 
          editor:ReplaceSel(data);
        end          
    end
  end

  local function getLstDate(lstDate)
    local currentDate = "(?)"
    local currentTimestamp
    local idv
    local valore
    local result = {}

    if (currentTimestamp) then
      currentDate = os.date("%c",currentTimestamp)
    end
    
    --impostazione configurazione corrente per ora/data/valuta/ecc...
    os.setlocale("")
    
    for idv, valore in pairs(lstDate) do
      valore = string.gsub(valore,"="," -> ")
      result[idv] = os.date(valore);
    end
    
    return result
  end
  
  local function main()
    local tbl
    
    tbl = getLstDate(getTableFormat())
    wcl_strip:init()

    wcl_strip:addButtonClose()
    --wcl_strip:addLabel(nil, "Formato data :")
    wcl_strip:addLabel(nil, _t(83))
    wcl_strip:addCombo("FORMATO")
    
    --wcl_strip:addLabel(nil, "Data/Ora per Conversioni :")
    wcl_strip:addLabel(nil, _t(254))
    wcl_strip:addText("DATA", os.date("%d-%m-%Y %H:%M:%S"))
    
    --wcl_strip:addButton("ESEGUI","&Inserisci Data", buttonOk_click, true)
    wcl_strip:addButton("ESEGUI",_t(255), buttonOk_click, true)

    wcl_strip:show()
    
    wcl_strip:setList("FORMATO", tbl)
    wcl_strip:setValue("FORMATO", tbl[1])
  end
  
  main()
end
