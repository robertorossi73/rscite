--[[
Version : 2.1.2
Web     : http://www.redchar.net

Questa procedura consente l'apertura di una pagina web all'interno del browser
di default

Inoltre consente l'inserimento della selezione corrente all'interno dell'url
di connessione

Copyright (C) 2004-2020 Roberto Rossi 
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

TODO : 
  - selezionando caratteri speciali come &, questi dovranno essere sostituiti
    con le apposite espressioni html, prima di effettuare la ricerca
  - in assenga di selezione o termine valido, messaggio che indica la 
    necessità di una selezione/posizionamento cursore
  - nella finestra di selezione della fonte, visualizzare testo che si sta
    cercando
]]

do
  require("luascr/rluawfx")


  local function getDataList(nomefini, data)
    result = ""
    for idv, valore in pairs(data) do
      if (result == "") then
        result = valore
      else
        result = result.."|"..valore
      end
    end
    return result
  end
  
  local function mainStart()
    local scelta
    local lista
    local i
    local dati
    local nome
    local url
    local espressione
    local espressione2
    local cartellaScript = props["SciteDefaultHome"].."/luascr/"
    local nomefini = cartellaScript.."searchw.ini"
    local elementi = rfx_GetIniSec(nomefini,"General")
    
--~     --  Google;http://www.google.com/search?q=xxxxxxx
--~     --  Yahoo;http://search.yahoo.com/search?p=xxxxxxx
--~     --  Wikipedia;http://en.wikipedia.org/wiki/xxxxxxx
--~     --  Dictionary;http://dictionary.reference.com/browse/xxxxxxx
--~     --  WhoIs;http://www.whois.net/whois_new.cgi?d=xxxxxxx
--~     --  Php;http://www.php.net/manual-lookup.php?pattern=xxxxxxx
--~     --  C++;http://www.cplusplus.com/query/search.cgi?q=xxxxxxx
--~     --  MSN;http://search.msn.com/results.aspx?q=xxxxxxx
--~     --  MSDN;http://search.msdn.microsoft.com/search/Default.aspx?query=xxxxxxx&brand=msdn&locale=en-us&refinement=00&lang=en-us
--      Nella qeury xxxxxxx viene sostituito con il testo cercato
--                  xxxxxxxdashx viene sostituito con il testo nel quale gli spazi diventano "-"
--~     --  ....
--~     lista = _t(139)
--~     elementi = rfx_Split(lista,"|")
--~     
--~     dati = rfx_Split(elementi[1],";")
--~     lista = dati[1]
--~     i=2
--~     --compone la lista da visualizzare
--~     while (i <= #elementi) do
--~       dati = rfx_Split(elementi[i],";")
--~       lista = lista.."|"..dati[1] --nome
--~       i = i + 1
--~     end
--~     
    lista = getDataList(nomefini,elementi)
    
    scelta = rwfx_ShowList_presel(lista,_t(140),"searchw",false)
    
    if scelta then
      nome = elementi[scelta+1]
      --print(nome)
      url = rfx_GetIniVal(nomefini, "General", nome)
      
      espressione = editor:GetSelText()
      if espressione == "" then
        espressione = props["CurrentWord"]
      end
      
      espressione = rfx_Trim(espressione)
      espressione2 = string.gsub(espressione," ","-")
      if espressione ~= "" then
        comando = string.gsub(url,"xxxxxxxdashx",espressione2)
        comando = string.gsub(comando,"xxxxxxx",espressione)
        --print(comando)
        rwfx_ShellExecute(comando,"")
      end
    end
  end --endfunction
  
  mainStart()
  
end 
