--[[
Author  : Roberto Rossi
Version : 1.0.0
Web     : http://rsoftware.altervista.org

Questa procedura consente la conversione dei file corrente per questi
formati :
CSV (delimitato da XXX)
PRN/TXT (delimitato da spazi, a campi fissi)
SLK (Excel/OpenOffice)
HTML

Le conversioni possibili sono :
CSV->PRN (TODO)
PRN->CSV (TODO)
CSV->HTML (TODO)
CSV->SLK (TODO)

TODO :  Tradurre messaggi in inglese!
TODO :  CSV->PRN
        PRN->CSV
        CSV->HTML
        CSV->SLK

]]

do
  require(props["SciteDefaultHome"].."/luascr/rluawfx.lua")

  -- elimina eventuale delimitatore iniziale e finale del testo
  local function cancDelimitTesto (linea, limiteTesto)
  local testo
  local primo
  local ultimo
  
  testo = linea
    if ((linea ~= "") and
        (limiteTesto ~= "")) then --eliminazione delimitatori testo
      primo = string.sub(testo,1,1)
      ultimo = string.sub(testo,string.len(testo))
      if (primo == limiteTesto) then
        testo = string.sub(testo,2)
      end
      if (ultimo == limiteTesto) then
        testo = string.sub(testo,1,string.len(testo)-1)
      end
    end
    return testo
  end --endfunction
  
  -- dato un file csv controlla la lunghezza massima di tutti i campi
  -- separatore = separatore tra campi es.: ,
  -- limiteTesto = delimitatore testo es.: "
  local function getLungCampi(separatore, limiteTesto)
    local i
    local c
    local linea
    local campo
    local campoLen
    local tabCampi
    local tabLunghezze = {}
     
    i = 1
    linea = editor:GetLine(i-1)
    while linea do --scansione file
      linea=rfx_RemoveReturnLine(linea)
      tabCampi = rfx_Split(linea,separatore)
      c = 1
      while (c <= table.getn(tabCampi)) do --scansione dimensione campi
        campo = tabCampi[c]
        campo = cancDelimitTesto(campo, limiteTesto)
        campoLen = string.len(campo)
        if (table.getn(tabLunghezze) < c) then
          tabLunghezze[c] = campoLen
        else 
          if (tabLunghezze[c] < campoLen) then
            tabLunghezze[c] = campoLen
          end
        end
        c = c + 1
      end
      i = i + 1
      linea = editor:GetLine(i-1)
    end --endwhile
    
    return tabLunghezze
  end --endfunction
  
  -- converte il file corrente formattato con separatori, in un file 
  -- a campi fissi
  local function csvTOprn (lunghezzeCampi, nomeFileDest)
    local i
    local linea
    local lcampi
    
    i = 1
    linea = editor:GetLine(i-1)
    while linea do 
      linea = rfx_RemoveReturnLine(linea)      
      
      --TODO : inserire codice per conversione
      
      i = i + 1
      linea = editor:GetLine(i-1)
    end
  end --endfunction
  
  -- converte il file corrente formattato con separatori, in un file 
  -- html
  local function csvTOhtm (nomeFileDest)
    --TODO : inserire codice per conversione
  end --endfunction
  
  -- converte il file corrente formattato con separatori, in un file 
  -- slk
  local function csvTOslk (nomeFileDest)
    --TODO : inserire codice per conversione
  end --endfunction
  
  -- converte il file corrente formattato a campi fissi, in un file 
  -- a con separatore
  local function prnTOcvs (lunghezzeCampi, nomeFileDest, separatore)
    --TODO : inserire codice per conversione
  end --endfunction
  
  local function getNomeDest ()
    --TODO : inserire codice per conversione
  end --endfunction
  
  --csvTOprn("10,5,2,3","e:\\test.txt")
  test = getLungCampi(";")
  table.foreach(test,print)
  

end --endmodulo
