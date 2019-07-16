--[[
Author  : Roberto Rossi
Version : 1.1.2
Web     : http://www.redchar.net

Genera l'MD5 del file corrente o della selezione

TODO : aggiungere possibilità di generare MD5 di un file che si seleziona con
        la normale finestra di selezione file. In questo modo sarà possibile 
        ottenere l'md5 di file molto grandi
       sarebbe interessante anche generare l'md5 del file selezionato nel testo
        o dei file selezionati nel testo (uno per riga)
]]

do
  require("luascr/rluawfx")
  
  --local tipi_md5 = {"Selezione corrente","Tutto il File Corrente"}
  md5lua_tipi_md5 = {_t(245),_t(246)}
  
  --genera file bat con comando completo, ritorna il path del bat
  function md5lua_genBat()
    local batfile
    local txtfile
    local idf
    local comando
    
    batfile = os.getenv("TMP")
    txtfile = batfile.."\\sciteStr.txt"
    batfile = batfile.."\\sciteStr.bat"        
    idf = io.open(batfile, "w")
    if (idf) then
      comando = "\""..props["SciteDefaultHome"].."\\md5sum.exe\" \""..txtfile.."\""
      idf:write(comando)
      io.close(idf)
    end
    return batfile
  end
  
  --genera il file di cui fare l'md5 inserendo "testo".
  --se remove è true, il file non viene creato, ma cancellato
  function md5lua_genText(testo, remove)
    local txtfile
    local idf
    local comando
    
    txtfile = os.getenv("TMP")
    txtfile = txtfile.."\\sciteStr.txt"        
    if remove then
      os.remove(txtfile)
    else
      idf = io.open(txtfile, "w")
      if (idf) then
        idf:write(testo)
        io.close(idf)
      end
    end
  end
  
  --ritorna l'md5 del testo passato come parametro
  function md5lua_genMd5 (testo)
    local result = ""
    local pos
    local posn
    
    md5lua_genText(testo,false)
    result = rfx_exeCapture("\""..md5lua_genBat().."\"")
    md5lua_genText(testo,true)
    pos = string.find(result, "*")
    if pos then
      result = rfx_Trim(string.sub(result,2, (pos - 1)))
    end
    
    result = string.reverse(result)
    pos = string.find(result, "\\")
    if pos then
      result = rfx_Trim(string.sub(result,1, (pos - 1)))
    end
    result = string.reverse(result)
    
    return result
  end -- endfx
  
  function md5lua_buttonCanc_click(control, change)
    wcl_strip:close()
  end

  function md5lua_buttonOk_click(control, change)
    local testo = ""
    local scelta = wcl_strip:getValue("TIPO")
    
    if (scelta == md5lua_tipi_md5[2]) then
      --tutto il file
      testo = editor:GetText()
    else
      --selezione
      testo = editor:GetSelText()
    end
    
    if (testo ~= "") then
      --wcl_strip:setValue("MD5",md5lua_genMd5(testo))
      print("MD5 : "..md5lua_genMd5(testo))
    else
      --wcl_strip:setValue("MD5","** !? **")
      print("MD5 : ","** !? **")
    end
  end
  
  function md5lua_main()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    --wcl_strip:addLabel(nil, "Calcola MD5 di:")
    wcl_strip:addLabel(nil, _t(247))
    wcl_strip:addCombo("TIPO")
    --wcl_strip:addButton("ESEGUI","&Calcola MD5", buttonOk_click, true)
    wcl_strip:addButton("ESEGUI",_t(248), md5lua_buttonOk_click, true)
    --wcl_strip:addLabel(nil, "MD5 Calcolato:")
    --wcl_strip:addLabel(nil, _t(249))
    --wcl_strip:addText("MD5","")
    --wcl_strip:addButton("ANNULLA","&Chiudi", buttonCanc_click)
    --wcl_strip:addButton("ANNULLA",_t(250), md5lua_buttonCanc_click)

    wcl_strip:show()
    wcl_strip:setList("TIPO", md5lua_tipi_md5)
    wcl_strip:setValue("TIPO", md5lua_tipi_md5[1])
  end

  md5lua_main()
  
end