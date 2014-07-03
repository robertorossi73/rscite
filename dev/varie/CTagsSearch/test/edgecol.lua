--[[
Author  : Roberto Rossi
Version : 1.0.2
Web     : http://www.redchar.net

Questa procedura imposta il valore della variabile "edge.column", che consente  
la visualizzazione del margine destro
]]

do
  require("luascr/rluawfx")

  local function main()
    local col
    local scelta
    --local listaElementi = "Sposta linea margine destro su colonna corrente|"..
    --                      "Specifica colonna per linea di margine destro|"..
    --                      "Ripristina margine destro"
    local listaElementi = _t(161)
    local originalCol
    
    --scelta = rwfx_ShowList(listaElementi,"Posizione linea margine destro")
    scelta = rwfx_ShowList(listaElementi,_t(162))
    if (scelta) then      
      if (scelta == 0) then --colonna corrente
        col = editor.Column[editor.CurrentPos]
        editor.EdgeColumn=col
      elseif (scelta == 1) then --indica colonna
        --richiesta colonna per indicatore
        col = editor.Column[editor.CurrentPos]
        
        --163=Specificare Colonna
        --164=Specificare colonna su cui posizionare l'indicatore del margine :
        col = rwfx_InputBox(tostring(col), rfx_GetStr(_t(163)),
                            rfx_GetStr(_t(164)),
                            rfx_FN());
        if col then
          col = rfx_GF()
          if (col and (col ~="")) then
            editor.EdgeColumn=col - 1
          end
        end
      elseif (scelta == 2) then --ripristina
        --TODO : supportare file di personalizzazione dell'utente [cartella utente]\SciTEUser.properties 
        originalCol = rfx_GetIniVal(
                      props["SciteDefaultHome"].."\\SciTEGlobal.properties", 
                      "", "edge.column")
        editor.EdgeColumn= originalCol
      end
    end
    
  end
  
  main()
  
end 
