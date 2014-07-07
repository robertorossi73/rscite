--[[
Version : 1.1.0
Web     : http://www.redchar.net

Questa procedura consente la conversione della selezione corrente, in una
immagine contenente un qrcode

Il software utilizzato, qrcode.exe, è fornito da : http://fukuchi.org/works/qrencode/

In alternativa è possibile sfruttare il servizio online http://qrcode.kaywa.com
Solo la versione online permette l'uso di testo su più linee.

In alternativa  è possibile sfruttare il servizio online https://chart.googleapis.com/chart?
Solo la versione online permette l'uso di testo su più linee.
]]

do
  require("luascr/rluawfx")

  --ritorna la selezione corrente senza ritorni a capo o tabulazioni
  local function getNormalizedUrl (selectionTxt)
    local result = ""
    
    if (selectionTxt ~= result) then --la selezione non è vuota
      result = string.gsub(selectionTxt, "\n\r", "%%0A%%0D")
      result = string.gsub(result, "\r\n", "%%0D%%0A")
      result = string.gsub(result, "\r", "%%0D")
      result = string.gsub(result, "\n", "%%0A")
      result = string.gsub(result, "\t", "%%09")
      result = string.gsub(result, "&", "%%26")
    end
    
    return result
  end

  --lancia il servizio google per la generazione del qrcode
  local function execGoogleQrCode (text, size, errorLevel)
    local onlineService = "https://chart.googleapis.com/chart"
    local url = ""
    
    --(image size in pixel) size = <width>x<height>
    
    --errorLevel = L, M, Q, H
    if (errorLevel == "") then
      errorLevel = "L"
    end
    
    if (size == "") then
      size = "500x500"
    end
    
    url = onlineService.."?chld="..errorLevel.."&chs="..size.."&cht=qr&chl="..getNormalizedUrl(text)
    --https://chart.googleapis.com/chart?chld=L&chs=150x150&cht=qr&chl=Hello%0A%0Dworld
    rwfx_ShellExecute(url,"")
  end
  
  --lancia il servizio online per la generazione del qrcode
  local function execOnlineQrCode (text, dimension)
    local onlineService = "http://qrcode.kaywa.com/img.php"
    local size = "12" --taglia XL (8=L, 6=M, 5=S)
    local url = ""
    
    if (dimension == "L") then
      size = "8"
    elseif (dimension == "M") then
      size = "6"
    elseif (dimension == "S") then
      size = "5"
    end
    url = onlineService.."?s="..size.."&d="..getNormalizedUrl(text)
    --http://qrcode.kaywa.com/img.php?s=8&d=essere%0D%0Ao%0D%0Anon%0D%0Aessere
    --print(url)
    rwfx_ShellExecute(url,"")
  end
  
  --generazione immagine
  local function execQrCode(text, pngFileName)
    local exeStr = props["SciteDefaultHome"].."/tools/qrcode/qrcode.exe" --comando da eseguire per conversione
    local command = "cmd /C \"\""..exeStr.."\" -o \""..pngFileName.."\" \""..text.."\" \""
    
    --~ Usage: qrencode [OPTION]... [STRING]
    --~ Encode input data in a QR Code and save as a PNG image.
    --~ -h           display this message.
    --~ --help       display the usage of long options.
    --~ -o FILENAME  write PNG image to FILENAME. If '-' is specified, the result
    --~              will be output to standard output. If -S is given, structured
    --~              symbols are written to FILENAME-01.png, FILENAME-02.png, ...;
    --~              if specified, remove a trailing '.png' from FILENAME.
    --~ -s NUMBER    specify the size of dot (pixel). (default=3)
    --~ -l {LMQH}    specify error collectin level from L (lowest) to H (highest).
    --~              (default=L)
    --~ -v NUMBER    specify the version of the symbol. (default=auto)
    --~ -m NUMBER    specify the width of margin. (default=4)
    --~ -S           make structured symbols. Version must be specified.
    --~ -k           assume that the input text contains kanji (shift-jis).
    --~ -c           encode lower-case alphabet characters in 8-bit mode. (default)
    --~ -i           ignore case distinctions and use only upper-case characters.
    --~ -8           encode entire data in 8-bit mode. -k, -c and -i will be ignored.
    --~ -V           display the version number and copyrights of the qrencode.
    --~ [STRING]     input data. If it is not specified, data will be taken from
    --~              standard input.    
    
    os.execute(command)
  end
  
  --ritorna la selezione corrente senza ritorni a capo o tabulazioni
  local function getNormalizedSelection ()
    local selectionTxt = editor:GetSelText()
    local result = ""
    
    if (selectionTxt ~= result) then --la selezione non è vuota
      result = string.gsub(selectionTxt, "\n\r", " ")
      result = string.gsub(result, "\r\n", " ")
      result = string.gsub(result, "\r", " ")
      result = string.gsub(result, "\n", " ")
      result = string.gsub(result, "\t", " ")
      result = string.gsub(result, "\"", "\\\"")
    end
    
    return result
  end

  --ritorna true se il file specificato esiste ed è leggibile
  function fileIsWritable(nomef)
    local idf
    if (nomef) then      
      idf = io.open(nomef,"w")
      if (idf) then
        io.close(idf)
        return true
      end
    end
    return false
  end
  
  local function main ()
    local selectionTxt = getNormalizedSelection()
    local pngFileName = ""
    local destfile 
    local isw
    local scelta
    local formato = ""
    local size = ""
    
    if (selectionTxt ~= "") then
      --selezionare tipo di conversione online/offline
      --scelta = rwfx_ShowList("Genera QRCode online(servizio Google)|Genera QRCode Online (qrcode.kaywa.com)|Genera immagine QRCode locale (singola linea)|Cos'è un QRCode?","Generazione QRCode da testo")
      scelta = rwfx_ShowList(_t(204),_t(205))
    
      if (scelta) then            
        if (scelta == 2) then 
          --richiesta file immagine destinazione
          --destfile = rwfx_GetFileName("Selezionare File Destinazione"
          destfile = rwfx_GetFileName( _t(206)
                                       ,"", 0,rfx_FN(),
                                       "PNG Files (*.png)%c*.png")
          if (destfile) then
            pngFileName = rfx_GF()
            isw = fileIsWritable(pngFileName)
            if not(isw) then
              --Impossibile continuare. Non possiedi &i permessi per scrivere nel file selezionato!
              rwfx_MsgBox(_t(197),_t(9),MB_OK)
            else
              if (pngFileName ~= "")then
                execQrCode(selectionTxt, pngFileName)
              end
            end
          end
        elseif (scelta == 0) then --google
          --size = rwfx_InputBox("300x300", "Dimensione immagine QRCode","Inserisce la dimensione dell'immagine del QRCode in pixel",rfx_FN());
          size = rwfx_InputBox(_t(207), _t(208), _t(209),rfx_FN());
          if size then
            size = rfx_GF()
            --scelta = rwfx_ShowList("Livello L|Livello M|Livello Q|Livello H","Generazione QRCode - Correzione errore")
            scelta = rwfx_ShowList(_t(210),_t(211))
            if (scelta) then
              if (scelta == 0) then
                formato = "L"
              elseif (scelta == 1) then
                formato = "M"
              elseif (scelta == 2) then
                formato = "Q"
              elseif (scelta == 3) then
                formato = "H"
              end
              
              execGoogleQrCode(selectionTxt, size, formato)
            end            
            
          end
        elseif (scelta == 1) then
          --XL (8=L, 6=M, 5=S)
          --scelta = rwfx_ShowList("Formato L|Formato XL|Formato M|Formato S","Generazione QRCode")
          scelta = rwfx_ShowList(_t(212),_t(213))
          if (scelta) then
            if (scelta == 0) then
              formato = "L"
            elseif (scelta == 1) then
              formato = "XL"
            elseif (scelta == 2) then
              formato = "M"
            elseif (scelta == 3) then
              formato = "S"
            end
            
            execOnlineQrCode(selectionTxt, formato)
          end
        else
          rwfx_ShellExecute("http://en.wikipedia.org/wiki/QR_code","")
        end
      end
    else
      rwfx_MsgBox(_t(214),_t(9),MB_OK)
    end
  end
  
  main()
  
end
