--[[
Author  : Roberto Rossi
Version : 1.1.2
Web     : http://www.redchar.net

Questa procedura imposta il valore della variabile "edge.column", che consente  
la visualizzazione del margine destro
]]

require("luascr/rluawfx")
do

  local function mainEdgeCol(scelta, col)
    local originalCol
    
    if (scelta == 0) then --colonna corrente
      col = editor.Column[editor.CurrentPos]
      editor.EdgeColumn=col
    elseif (scelta == 1) then --indica colonna
      if col then
        editor.EdgeColumn=col - 1
      end
    elseif (scelta == 2) then --ripristina
      --TODO : supportare file di personalizzazione dell'utente [cartella utente]\SciTEUser.properties 
      originalCol = rfx_GetIniVal(
                    props["SciteDefaultHome"].."\\SciTEGlobal.properties", 
                    "", "edge.column")
      editor.EdgeColumn= originalCol
    end
    
  end
  
  --button ok
  function buttonOk_click(control, change)
    local val = wcl_strip:getValue("VAL")
    if (tonumber(val) and (tonumber(val) > 0)) then
      if (control == 2) then --posizione cursore
        mainEdgeCol(0, false)
      elseif (control == 4) then --posizione specificata
        mainEdgeCol(1, tonumber(val))
      elseif (control == 5) then --posizione originale
        mainEdgeCol(2, false)
      end
      
    end
  end
  
  --main function
  local function main()
    local options = rfx_Split(_t(161), "|")
      wcl_strip:init()      
      wcl_strip:addButtonClose()
            
      wcl_strip:addLabel(nil, _t(162)..":")
      wcl_strip:addText("VAL",editor.EdgeColumn)
      wcl_strip:addButton("OK1",options[1],buttonOk_click, false) --posizione cursore
      wcl_strip:addNewLine()
      wcl_strip:addSpace()
      wcl_strip:addButton("OK2",options[2],buttonOk_click, true) --posizione specificata
      wcl_strip:addButton("OK3",options[3],buttonOk_click, false) --posizione originale
      
      wcl_strip:show()
  end
  
  main()
  
end 
