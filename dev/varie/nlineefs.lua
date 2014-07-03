--[[

Questa procedura, partendo da un elenco di file, calcola il numero di
linee che li compongono (escludendo le linee vuote)

]]

do

  require("luascr/rluawfx")
  
  --ritorna il numero di linee, non vuote, presenti nel file indicato
  local function countLines (nomef)
    local i = 0
    local linea
    local nlinee = 0
    
    for linea in io.lines(nomef) do
      linea = rfx_Trim(linea)
      if (linea ~= "" ) then
        nlinee = nlinee + 1
      end
      i = i + 1
    end

    return nlinee
  end 
  
  local function main()
    local nomef
    local dati
    local total = 0
    local nlinee = 0
    
    for linea in io.lines("C:\\temp\\fc_findfiles.txt") do
      dati = rfx_Split(linea, "\t")
      nomef = rfx_Trim(dati[2]).."\\"..rfx_Trim(dati[1])
      nlinee = countLines(nomef)
      total = total + nlinee
      print(nomef.." - >"..nlinee)
    end
    
    print("Numero Totale Linee : "..total)
  end
  
  main()
end

