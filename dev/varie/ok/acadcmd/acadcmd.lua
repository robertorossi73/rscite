--[[
Author  : Roberto Rossi
Version : 1.0.0
Web     : http://rsoftware.altervista.org

Questa procedura consente di inserire un comando o una variabile di AutoCAD,
selezionandola da un'elenco
]]

do
  require("luascr/rluawfx")

  local function getData (nomef, isVars)
    local linea = ""
    local datiLinea
    local datiLinee = {}
    local i
    local tipo
    
    i=1
    for linea in io.lines(nomef) do 
      if (linea and (linea ~= "")) then
        datiLinea=rfx_Split(linea,"=")
        if (datiLinea[3]==isVars) then --variabile = "1"
          datiLinee[i] = datiLinea
          i = i + 1
        end
      end
    end
    
    return datiLinee
  end
  
  local function showDialog (visVar)
    local lista = ""
    local datiLinea = {}
    local tmpVar = ""
    local scelta
    local tipo
    local desc
    local titolo
    
    datiLinea = getData(props["SciteDefaultHome"].."\\luascr\\commandcomplete.ini",visVar)
    
    lista = false
    for i=1, table.getn(datiLinea), 1 do
      tipo = datiLinea[i][3] --1=variabili
      desc = datiLinea[i][2]
      
      tmpVar = datiLinea[i][1].." ("..desc..")"
      if (lista) then
        lista = lista.."|"..tmpVar
      else
        lista = tmpVar
      end
    end
    
    if (visVar == "1") then
      titolo = "Variabili Disponibili :"
    else
      titolo = "Comandi Disponibili :"
    end
    
    scelta = rwfx_ShowList(lista,titolo)
    if (scelta) then
      if (visVar == "1") then --varibile
        editor:ReplaceSel(datiLinea[scelta+1][1])
      else
        editor:ReplaceSel("_"..datiLinea[scelta+1][1])
      end
    end
    
  end --endfunction

  local function main()
    local tipo 
    local scelta
    
    scelta = rwfx_ShowList("Elenco Comandi CAD|Elenco Variabili CAD","Inserimento Comando/Variabile")
    if (scelta) then
      if (scelta==0) then
        showDialog("0")
      else
        showDialog("1")
      end
    end
    
  end
  
  main()
  
end 
