--[[
Version : 0.2.0
Web     : http://www.redchar.net

Questa procedura implementa una linea di comando per tutte le funzioni di 
RSciTE

---IDEE
  Questa procedura potrebbe funzionare in diversi modi, vediamone alcuni :
  
  - potrebbe mostrare (nella combo) l'elenco delle funzioni presenti in F12
    precedute da apposite combinazioni racchiuse tra <> o (). Questi caratteri
    sarebbero poi usati come scorciatoie per lanciare il comando
  - la combo potrebbe essere usata per memorizzare gli ultimi comandi usati.
    Come nel caso precedente i comandi verrebbero estratti da F12
  - la combo viene usata per memorizzare gli ultimi comandi usati.
    L'elenco comandi disponibile è indipendente da f12 e permette l'uso di 
    comandi con parametri, es:
    cmd "parametro con spazi" parametrosenzaspazi
    Si potrebbe ipotizzare l'uso di comandi del sistema operativo, come ad esempio
    quelli da console.
    Allo stesso modo si potrebbe ipotizzare l'implementazione di comandi stile Vim
  - si potrebbe implementare una via di mezzo tra f12 e linea di comando classica
    In questo caso la combo conterrebbe inizialmente solo i comandi F12, in seguito
    si aggiungerebbero quelli usati nel tempo

  Accanto alla casella di comando si potrebbero inserire alcuni tasti :
  - un tasto per richiamare l'elenco degli ultimi file aperti
  - un tasto per la pagina d'aiuto (html)
  - un tasto per l'esecuzione
  
Copyright (C) 2013 Roberto Rossi 
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

---------------------------------- Versioni -----------------------------------

V.1.0.0
- versione iniziale, primo rilascio
]]

do 
  require("luascr/rluawfx")
  require("luascr/wcl_strip") --gestore interfaccia grafica SciTE

  --questa funzione usa la variabile globale :
  --  PUBLIC_previous_command
  
  --verifica la presenza di un dato elemento all'interno di una tabella
  --ritorna false nel caso l'elemento non sia presente
  --altrimenti torna il suo indice
  local function table_exist(tbl, el)
    local i
    local v
    
    for i, v in pairs(tbl) do
      if v == el then
        return i
      end
    end
    return false
  end

  --salva la tabella delle ultime espressioni eseguite
  local function save_expressions(values)
    local nomef = rfx_UserFolderRSciTE()..'/tmp/cmdline.ini'
    local v
    local count = 1
    
    while (count < 26) do
      v = values[count]
      if (v) then
        rfx_setIniVal(nomef, "General", "lua"..tostring(count) , v)
      end
      count = count + 1
    end
  end

  --ritorna la tabella delle ultime 100 espressioni eseguite
  local function get_expressions()
    local nomef = rfx_UserFolderRSciTE()..'/tmp/cmdline.ini'
    local result = {}
    local i = 1
    local v
    
    tbl = rfx_GetIniSec
    
    while(i < 26) do
      v = rfx_GetIniVal(nomef, "General", "lua"..tostring(i))
      if (v ~= "") then
        result[i] = v
      else
        break
      end
      i = i + 1
    end    
    
    return result
  end
  
  --stampa nella zona di output tutti i comandi che contengono la stringa
  --inserita, escludendo i numeri
  --Ritorna true se è stato eseguito un comando
  --Se goFirst=true viene eseguito il primo elemento della lista ottenuta dal filtro(scelta)
  local function goCommands(scelta_orig, goFirst)
    local scelta = scelta_orig
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
    
    local sceltain
    local listaFxStr = ""
    local listaExtensionFiles = {}
    local flag
    local msg1 = _t(6)
    local dimLista
    local dimStandardList
    local i
    local v
    local short = 1
    local lscelta = 0
    local sceltan = ""
    local sep1 = " "
    local sep2 = " > "
    local lst_cmds = {}
    local txt_cmds = ""
    local lst_find = {}
    local lst_find_str = ""
    local id
    local result = false
    local userList = ""
    local prevVal = ""
    
    scelta = string.upper(scelta)
    
    lscelta = string.len(scelta)
    if (lscelta > 0) then
      --prende solo numeri
      sceltan = string.gsub(scelta,"[^0-9]","")
      --elimina numeri
      scelta = string.gsub(scelta,"[0-9]","")
    end
    
    local listaFx = rfx_GetIniSec(fileIni, nomeSezione)
    
    --output:ClearAll()
    for i,v in ipairs(listaFx) do 
      
      if (string.find(string.upper(v), scelta,1, true))          
      then
        --txt_cmds = sep1..short..sep2.." "..v
        txt_cmds = v
        lst_cmds[short] = txt_cmds
        --print(txt_cmds)
        short = short + 1
      end
      --output:append("\n")
    end    
    
    --se c'è un solo comando nella lista che contiene sia 
    --il testo cercato che il numero comando, lo esegue
    id = 1
    for i,v in ipairs(lst_cmds) do 
      --print(v)
      if ( string.find(string.upper(v), scelta,1, true) and
           string.find(string.upper(v), sep1..sceltan ,1, true)
          ) then
        --rwfx_MsgBox(v,"",MB_OK)
        lst_find[id] = v
        id = id + 1        
        --break
      end
    end
    
    --se è stato trovato un solo elemento corrispondente lo esegue
    if (not(goFirst) and 
        (table.maxn(lst_find) == 1) and 
        (sceltan ~= "")) then
      --auto esecuzione funzione solo se inserisco anche numero
      output:ClearAll()
      print(lst_find[1])
      --wcl_strip:setValue("COMMAND",lst_find[1])       
      wcl_strip:setValue("ESEGUI",lst_find[1])       
    else
      if ((goFirst) 
            and 
            (table.maxn(lst_find) > 0) 
            ) 
            then --esegui
        PUBLIC_previous_command = scelta_orig
        rwfx_MsgBox(lst_find[1],"",MB_OK)
        result = true
      else    
        output:ClearAll()
        i = 1
        while (i <= table.getn(lst_find)) do
          if (i == 1) then
            print("!"..lst_find[i])
          else
            print(lst_find[i])
          end
          i = i + 1
        end
        wcl_strip:setList("CMD", lst_find)
        wcl_strip:setValue("CMD", scelta)

--~         for i,v in ipairs(lst_find) do 
--~           print(v)
--~         end
        if (table.getn(lst_find) > 0) then
          --wcl_strip:setValue("COMMAND",lst_find[1])
          wcl_strip:setValue("ESEGUI","Esegui comando : [ "..lst_find[1].." ]")
          --save_expressions(lst_find[1])

        else
            --TODO : qui potranno, in futuro,  essere analizzati 
            --       eventuali comandi non presenti nella lista di F12,
            --       come ad esempio, i comandi in stile vim 
            --        (es. : ":w" salva i cambiamenti)
            
            --TODO : da tradurre
            --wcl_strip:setValue("COMMAND","Comando non riconosciuto!")
            wcl_strip:setValue("ESEGUI","Comando non riconosciuto!")
        end
      end
      
    end
    
    --dimStandardList = table.getn(listaFx) --dimensione lista script 
    return result
  end
  
  function buttonOk_click(control, change)
    goCommands(wcl_strip:getValue("CMD"), true)
  end
  
  function combo_change(control, change)
    goCommands(wcl_strip:getValue("CMD"), false)
  end
  
  function buttonHelp_click(control, change)
    --TODO : apertura manuale
    goCommands("", false)
  end

  local function main()
 
    wcl_strip:init()

    wcl_strip:addButtonClose()
    
          --TODO : da tradurre
    --wcl_strip:addLabel(nil, "Esegui : ")
    --wcl_strip:addLabel("COMMAND", " ")
    --wcl_strip:addNewLine()
    
          --TODO : da tradurre
    wcl_strip:addLabel(nil, "Comando : ")
    --wcl_strip:addLabel(nil, _t(58).." :")
    wcl_strip:addCombo("CMD", combo_change)
    wcl_strip:addText("CMD", "", combo_change)

          --TODO : da tradurre
    --wcl_strip:addButton("ESEGUI","&Esegui", buttonOk_click, true)
          --TODO : da tradurre
    wcl_strip:addNewLine()
    --wcl_strip:addSpace();
    wcl_strip:addButton("HELP","Aiuto", buttonHelp_click, false)
    wcl_strip:addButton("ESEGUI","&Esegui", buttonOk_click, true)
    --wcl_strip:addButton("ANNULLA","&Annulla", buttonCanc_click)
    wcl_strip:show()
    
    --wcl_strip:setList("CMD", get_expressions())
    if (PUBLIC_previous_command) then
      print(PUBLIC_previous_command)
      wcl_strip:setValue("CMD", PUBLIC_previous_command)
      goCommands(PUBLIC_previous_command, false)
    else
      goCommands("", false)
    end
    
    
  end
  
  main()
end


