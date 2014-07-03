--[[
Version : 2.6.1
Web     : http://www.redchar.net

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
  
  local function StartAddedTools(exeLast)
    local sottoCartella = "/luascr/"
    local cartellaScript = props["SciteDefaultHome"]..sottoCartella
    local fileIni
    
    if (rwfx_isEnglishLang()) then --inglese
      fileIni = cartellaScript.."tools-en.ini"
    else --non inglese
      fileIni = cartellaScript.."tools.ini"
    end

    local nomeSezione 
    nomeSezione = "Tools"
    
    local scelta
    local i, valore
    local listaFxStr = ""
    local flag
    -- frasi : 6- Attenzione : Questa procedura potrebbe modificare l'interno file corrente!\n\n Si desidera procedere?
    --         7- Personalizza Elenco Funzioni
    --         8- Comandi Aggiuntivi by R.R.
    --         9- Attenzione!
    local msg1 = _t(6)
    local dimLista
    local listaFx = rfx_GetIniSec(fileIni, nomeSezione)
    local script = ""
    local dati = {}
    local datistr = ""
    
    for i,valore in pairs(listaFx) do
      if (listaFxStr == "") then
        listaFxStr = valore
      else
        listaFxStr = listaFxStr.."|"..valore
      end
    end
    
    --aggiunta funzione per personalizzazione funzioni
    if (listaFxStr ~= '') then
      listaFxStr = listaFxStr..'|'..
               "....|".._t(7)
    end    

    scelta =  rwfx_ShowList_presel(listaFxStr,_t(8),"addtools",exeLast)
    if (scelta) then
      dimLista = table.getn(listaFx)
      if (scelta < dimLista) then
        scelta = scelta + 1
        datistr = rfx_GetIniVal(fileIni, nomeSezione, listaFx[scelta])
        dati = rfx_Split(datistr,",")
        script = dati[1]
        flag = dati[2]

        if (string.find(script,"\\",1,true) or
            string.find(script,"/",1,true)) then
          --script con percorso impostato e sostituzioni percorsi standard
          script = string.gsub(script,"\${SciteDefaultHome}",props["SciteDefaultHome"])
          script = string.gsub(script,"\${SciteUserHome}",props["SciteUserHome"])
        else
          script = cartellaScript..script --script con percorso standard
        end
        
        if (flag == "0") then
          dofile(script)
        elseif (flag == "1") then
          if (rwfx_MsgBox(msg1,_t(9),MB_YESNO + MB_DEFBUTTON2) == IDYES) then
            dofile(script) 
          end
        end
      elseif ((scelta - 1) == dimLista) then --selezione ultima voce lista
        scite.Open(fileIni); --apertura file delle funzioni
      end--verifica dimensione lista
    end
  end --endf
  
  if (PUBLIC_command) then
    StartAddedTools(true)
  else
    StartAddedTools(false)
  end
  PUBLIC_command = nil
end
