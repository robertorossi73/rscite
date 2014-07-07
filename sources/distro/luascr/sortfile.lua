--[[
Version : 3.1.1
Web     : http://www.redchar.net

Questa procedura ordina il file corrente

Copyright (C) 2012-2013 Roberto Rossi e Luigi Altomare: 
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
3.1.0
  - eliminato tasto chiusura 
  - chiusura dialog dopo ordinamento
  
3.0.7
  - ordinamento rimuovendo spazi finali sulle linee
  - nuova interfaccia basata su Stripes 
  - Luigi Altomare: corretto un bug nelle linee originarie #59 e #73
    in entrambe le linee sostituite la variabili
    "elemento(x)" con "l_elemento(x)"
  - Luigi Altomare: nell'ordinamento per colonna aggiunto l'ordinamento
    delle linee secondo la colonna 1 in caso di uguaglianza
    delle stringhe dalla colonna scelta in poi
2.1
  - ordinamento per colonna
2.0
  - nuova licenza
1.3.1 :
  - porting a SciTE 1.34
  
1.3.0 :
  - aggiunto ordinamento selezione

1.2.0 :
  - aggiunta modalità ordinamento ascendente/discendente
  - corretto ordinamento file, dove la prima riga veniva sempre inserita
    come ultimo elemento
  - corretto ordinamento file che non hanno l'ultima riga vuota
]]


do
  require("luascr/rluawfx")
  
  local g_columnID = 1 --la prima colonna è 1
  --local g_tbl_what = {"Tutto il file corrente", "La selezione corrente"}
  local g_tbl_what = {_t(226), _t(227)}
  --local g_tbl_type = {"Discendente", "Ascendente"}
  local g_tbl_type = {_t(228), _t(229)}

  --rimuove gli spazi e i ritorni a capo dalla fine linea
  local function SpaceStrip (s_tmp)
    while string.sub(s_tmp,string.len(s_tmp),string.len(s_tmp))==" "  or
          string.sub(s_tmp,string.len(s_tmp),string.len(s_tmp))=="\n" or
          string.sub(s_tmp,string.len(s_tmp),string.len(s_tmp))=="\r" do
             s_tmp=string.gsub(s_tmp," $","")
             s_tmp=string.gsub(s_tmp,"\n$","")
             s_tmp=string.gsub(s_tmp,"\r$","")
    end -- while

    return s_tmp
  end -- function SpaceStrip
  
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

  --inserisce una linea in fondo al file
  local function insertLinea( idx, linea )
    editor:AddText(linea)
  end
  
  local function ConfrontoElementiAsc (elemento1, elemento2)
    local l_elemento1
    local l_elemento2
    
    l_elemento1 = SpaceStrip(string.sub(elemento1, g_columnID))
    l_elemento2 = SpaceStrip(string.sub(elemento2, g_columnID))
    
    if (l_elemento1 == l_elemento2) then
      if (elemento1 < elemento2) then
        return true
      else
        return false
      end
    else -- else (l_elemento1 == l_elemento2)
      if (l_elemento1 < l_elemento2) then
        return true
      else -- else (l_elemento1 < l_elemento2)
        return false
      end -- end if (l_elemento1 < l_elemento2)
    end -- end if (l_elemento1 == l_elemento2)
  end  --  end local function ConfrontoElementiAsc

  local function ConfrontoElementiDsc (elemento1, elemento2)
    local l_elemento1
    local l_elemento2
    
    l_elemento1 = SpaceStrip(string.sub(elemento1, g_columnID))
    l_elemento2 = SpaceStrip(string.sub(elemento2, g_columnID))
    
    if (l_elemento1 == l_elemento2) then
      if (elemento1 > elemento2) then
        return true
      else
        return false
      end
    else -- else (l_elemento1 == l_elemento2)
      if (l_elemento1 > l_elemento2) then
        return true
      else -- else (l_elemento1 > l_elemento2)
        return false
      end -- end if (l_elemento1 > l_elemento2)
    end -- end if (l_elemento1 == l_elemento2)
  end  --  end local function ConfrontoElementiDsc

  --ordina file corrente, oppure solo la selezione
  local function OrderCurrentBuffer(tipo,sortAll)
    local linea,pos
    local i=0
    local tbLinee = {} --tabella file
    local lineaCorrente
    local ultimaLinea
    local primaLinea
    local inizioSel
    local fineSel
    local i
    local v
    
    if (sortAll) then
      editor:DocumentEnd()
      linea = editor:GetCurLine()
      if (linea ~= "") then
        editor:NewLine()
      end
      --lettura tutto file
      i = 1
      linea = editor:GetLine(i-1)
      while linea do --lettura linee
        tbLinee[i] = linea
        i = i + 1
        linea = editor:GetLine(i-1)
      end
    else
      --lettura selezione
      i = 1
      inizioSel = editor.SelectionStart
      fineSel = editor.SelectionEnd
      primaLinea = editor:LineFromPosition(inizioSel)
      ultimaLinea = editor:LineFromPosition(fineSel)
      lineaCorrente = primaLinea
      while (lineaCorrente <= ultimaLinea) do
        editor:GotoLine(lineaCorrente)
        editor:Home()
        editor:LineEndExtend()
        linea = editor:GetSelText()
        tbLinee[i] = linea
        i = i + 1
        lineaCorrente = lineaCorrente + 1
      end --endwhile      
    end
    
    if (tipo==0) then --ordinamento ascendente
      table.sort(tbLinee,ConfrontoElementiAsc)
    elseif (tipo==1) then --ordinamento discendente
      table.sort(tbLinee,ConfrontoElementiDsc)
    end
    
    if (sortAll) then
      editor:ClearAll()      
      for i,v in pairs(tbLinee) do
        insertLinea(i,v)
      end      
    else
      i = 1
      lineaCorrente = primaLinea
      while (lineaCorrente <= ultimaLinea) do
        editor:GotoLine(lineaCorrente)
        editor:Home()
        editor:LineEndExtend()
        editor:ReplaceSel(tbLinee[i])
        i = i + 1
        lineaCorrente = lineaCorrente + 1
      end
    end
    
    
  end
  
  local function Ordina(opt)
    local scelta = 0 --ordinamento standard, ascendente
    local allBuffer = true
    local column = 0
    local sort = true
    
    g_columnID = opt[3]
    if ( g_columnID > 0) then
      if (table_exist(g_tbl_type, opt[2]) == 1) then
        scelta = 1 --ordinamento discendente
      else
        scelta = 0 --ordinamento ascendente
      end
      
      if (table_exist(g_tbl_what, opt[1]) == 2) then
        -- selezione corrente
        if (editor.SelectionEnd ~= editor.SelectionStart) then
          allBuffer = false
        else
          --print("\nImpossibile procedere, Nessuna selezione disponibile!")
          print(_t(240))
          sort = false
        end
      end
      
      if (sort) then
        OrderCurrentBuffer(scelta, allBuffer)
      end
    end
  end

  function buttonOk_click(control, change)
    local opt = {}
    local error_level = 0
    local cl = 0
    
    opt[1] = wcl_strip:getValue("COSA") --ordinamento tutto/selezione
    opt[2] = wcl_strip:getValue("TIPO") --ascendente/discendente
    
    cl = tonumber(wcl_strip:getValue("COLONNA"))
    if (cl) then
      opt[3] = math.abs(cl) --colonna per ordinamento (default = 1)
    else
      opt[3] = 0
    end
    
    --opt[4] = math.abs(tonumber(wcl_strip:getValue("COLONNA2"))) --ultima colonna per ordinamento (default = ultima della linea)
    
    if (not(table_exist(g_tbl_what, opt[1]))) then
      error_level = 1
    end
    
    if (not(table_exist(g_tbl_type, opt[2]))) then
      error_level = 2
    end

    if (opt[3] < 1) then
      error_level = 3
    end
    
    if (error_level == 0) then
      --nessun errore procedere all'ordinamento
      --print("\nOrdinamento in corso...")
      print(_t(230))
      Ordina(opt)
      --print("\nOrdinamento terminato.")
      print(_t(231))
    end
    
    if (error_level == 1) then -- errore selezione COSA
      --print("\nImpossibile continuare, 'Cosa Ordinare' non valido!")
      print(_t(232))
    end
    if (error_level == 2) then -- errore selezione TIPO
      --print("\nImpossibile continuare, 'Tipo Ordinamento' non valido!")
      print(_t(233))
    end
    if (error_level == 3) then -- errore indicazione colonna
      --print("\nImpossibile ordinare, 'Prima Colonna' non valida!")
      print(_t(234))
    end
    wcl_strip:close()
  end

  --function buttonCanc_click(control, change)
    --wcl_strip:close()
  --end
  
  local function ShowStrip()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    --wcl_strip:addLabel(nil, "Cosa ordinare : ")
    wcl_strip:addLabel(nil, _t(235))
    wcl_strip:addCombo("COSA")

    --wcl_strip:addLabel(nil, "Tipo di ordinamento : ")
    wcl_strip:addLabel(nil, _t(236))
    wcl_strip:addCombo("TIPO")

    wcl_strip:addNewLine()

    --wcl_strip:addLabel(nil, "Prima Colonna per ordinamento : ")
    wcl_strip:addLabel(nil, _t(238))
    wcl_strip:addText("COLONNA","1")

    wcl_strip:addSpace()
    --wcl_strip:addSpace()
    --wcl_strip:addLabel(nil, "Ultima Colonna per ordinamento : ")
    --wcl_strip:addText("COLONNA2","")

    --wcl_strip:addButton("ANNULLA",_t(239), buttonCanc_click)
    
    --wcl_strip:addButton("ESEGUI","&Esegui Ordinamento", buttonOk_click, true)
    wcl_strip:addButton("ESEGUI",_t(237), buttonOk_click, true)

    wcl_strip:show()

    wcl_strip:setList("TIPO", g_tbl_type)
    wcl_strip:setValue("TIPO", g_tbl_type[2])

    wcl_strip:setList("COSA", g_tbl_what)
    wcl_strip:setValue("COSA", g_tbl_what[2])
  end
  
  ShowStrip()
end
