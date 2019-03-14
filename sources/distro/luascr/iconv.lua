--[[
Version : 1.0.5
Web     : http://www.redchar.net

Questa procedura consente la conversione del file corrente da una codifica 
ad un'altra sfruttando l'utilità iconv
]]

do
  require("luascr/rluawfx")

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
  
  local codes_list = {"ARMSCII-8",
                  "ASCII",
                  "BIG5",
                  "BIG5-HKSCS",
                  "C99",
                  "CP1125, Supports Ukrainian",
                  "CP1133, Created by IBM for representation of Lao script",
                  "CP1250, Microsoft Windows Codepage 1250 (EE)",
                  "CP1251, Microsoft Windows Codepage 1251 (Cyrl)",
                  "CP1252, Microsoft Windows Codepage 1252 (ANSI)",
                  "CP1253, Microsoft Windows Codepage 1253 (Greek)",
                  "CP1254, Microsoft Windows Codepage 1254 (Turk)",
                  "CP1255, Microsoft Windows Codepage 1255 (Hebr)",
                  "CP1256, Microsoft Windows Codepage 1256 (Arab)",
                  "CP1257, Microsoft Windows Codepage 1257 (BaltRim)",
                  "CP1258, Microsoft Windows Codepage 1258 (Viet)",
                  "CP437, MS-DOS Codepage 437 (US)",
                  "CP737, MS-DOS Codepage 737 (Greek IBM PC)",
                  "CP775, MS-DOS Codepage 775 (BaltRim)",
                  "CP850, MS-DOS Codepage 850 (Multilingual Latin 1)",
                  "CP852, MS-DOS Codepage 852 (Multilingual Latin 2)",
                  "CP853, MS-DOS Codepage 853 (Multilingual Latin 3)",
                  "CP855, MS-DOS Codepage 855 (Russia)",
                  "CP857, MS-DOS Codepage 857 (Multilingual Latin 5)",
                  "CP858, 'Multilingual' with euro symbol",
                  "CP860, MS-DOS Codepage 860 (Portugal)",
                  "CP861, MS-DOS Codepage 861 (Iceland)",
                  "CP862, MS-DOS Codepage 862 (Israel)",
                  "CP863, MS-DOS Codepage 863 (French Canadian)",
                  "CP864, MS-DOS Codepage 864 (Arabic)",
                  "CP865, MS-DOS Codepage 865 (Norway)",
                  "CP866, MS-DOS Codepage 866 (Russia)",
                  "CP869, MS-DOS Codepage 869 (Greece)",
                  "CP874, MS-DOS Codepage 874 (Thai)",
                  "CP932, Supports Japanese",
                  "CP949, Supports Korean",
                  "CP950, Supports Traditional Chinese",
                  "EUC-CN",
                  "EUC-JISX0213",
                  "EUC-JP",
                  "EUC-KR",
                  "EUC-TW",
                  "GB18030",
                  "GBK",
                  "Georgian-Academy",
                  "Georgian-PS",
                  "HP-ROMAN8",
                  "HZ",
                  "ISO-2022-CN",
                  "ISO-2022-CN-EXT",
                  "ISO-2022-JP",
                  "ISO-2022-JP-1", 
                  "ISO-2022-JP-2",
                  "ISO-2022-JP-3",
                  "ISO-2022-KR",
                  "ISO-8859-1, Latin-1 Western Europe",
                  "ISO-8859-10, Latin-6 Nordic",
                  "ISO-8859-13, Latin-7 Baltic",
                  "ISO-8859-14, Latin-8 Celtic",
                  "ISO-8859-15, Latin-9",
                  "ISO-8859-16, Latin-10 Southeast Europe",
                  "ISO-8859-2, Latin-2 Central Europe",
                  "ISO-8859-3, Latin-3 Southern Europe",
                  "ISO-8859-4, Latin-4 Northern Europe",
                  "ISO-8859-5, Latin / Cyrillic",
                  "ISO-8859-6",
                  "ISO-8859-7, Latin / Greek",
                  "ISO-8859-8",
                  "ISO-8859-9, Latin-5 Turkish",
                  "JAVA",
                  "JOHAB",
                  "KOI8-R",
                  "KOI8-RU",
                  "KOI8-T",
                  "KOI8-U",
                  "MacArabic",
                  "MacCentralEurope",
                  "MacCroatian",
                  "MacCyrillic",
                  "MacGreek",
                  "MacHebrew",
                  "MacIceland",
                  "MacRoman",
                  "MacRomania",
                  "MacThai",
                  "MacTurkish",
                  "MacUkraine",
                  "Macintosh",
                  "MuleLao-1",
                  "NEXTSTEP",
                  "RISCOS-LATIN1",
                  "SHIFT_JIS",
                  "Shift_JISX0213",
                  "TCVN",
                  "TDS565", 
                  "TIS-620",
                  "UCS-2",
                  "UCS-2-INTERNAL",
                  "UCS-2BE",
                  "UCS-2LE",
                  "UCS-4",
                  "UCS-4-INTERNAL",
                  "UCS-4BE",
                  "UCS-4LE",
                  "UTF-16",
                  "UTF-16BE",
                  "UTF-16LE",
                  "UTF-32",
                  "UTF-32BE",
                  "UTF-32LE",
                  "UTF-7",
                  "UTF-8",
                  "VISCII",
                }
  
  local function main()
    local codIn -- codifica file input
    local codOut -- codifica file output
    local sel --selezione utente
    local destfile --file destionazione/output
    local curfile = props["FilePath"]--file sorgente
    local exeStr = props["SciteDefaultHome"].."/tools/iconv/bin/iconv.exe" --comando da eseguire per conversione
    local lstTxt = ""
    local i
    local pos
    local exec = false
    local res = ""
    local isw = false
    local flagOk = false
    
    i = 2;
    lstTxt = codes_list[1];
    while (i <= #codes_list) do
                  lstTxt = lstTxt.."|"..codes_list[i]
                  i = i + 1
    end
    
    --file modificato     
    if (editor.Modify) then
      --if (rwfx_MsgBox("Il file corrente non è stato salvato. Procedere al salvataggio prima di continuare?",
      --    "Convertitore ICONV", MB_YESNO + MB_DEFBUTTON2) == IDYES) then
      if (rwfx_MsgBox(_t(202),
          _t(203), MB_YESNO + MB_DEFBUTTON2) == IDYES) then
        scite.MenuCommand(IDM_SAVE)
        flagOk = true
      end
    else
      flagOk = true 
    end
    
    --codifica file corrente
    --scelta = rwfx_ShowList(lstTxt,"Specifica codifica file corrente")
    scelta = rwfx_ShowList(lstTxt,_t(193))
    if ((scelta) and (flagOk)) then
      codIn = codes_list[scelta+1]
      pos = string.find(codIn,",")
      if (pos) then
        codIn = string.sub(codIn, 1, pos-1)
      end
      
      --nome file destionazione
      --destfile = rwfx_GetFileName("Selezionare File Destinazione"
      --                             ,"", 0,rfx_FN(),
      --                             "All Files (*.*)%c*.*")
      destfile = rwfx_GetFileName(_t(194) ,"", 0,rfx_FN(),_t(195))
      if (destfile) then
        isw = fileIsWritable(rfx_GF())
        if not(isw) then
          --Impossibile continuare. Non possiedi i permessi per scrivere nel file selezionato!
          rwfx_MsgBox(_t(197),_t(9),MB_OK)
        end
      end
      if (destfile and isw) then
        destfile = rfx_GF()
        --codifica file destionazione
        --scelta = rwfx_ShowList(lstTxt,"Specifica codifica file destinazione")
        scelta = rwfx_ShowList(lstTxt,_t(196))
        if (scelta) then
          codOut = codes_list[scelta+1]
          pos = string.find(codOut,",")
          if (pos) then
            codIn = string.sub(codOut, 1, pos-1)
          end      
          exec = true
        end
      end    
    end
    
    if (exec) then
      --exeStr = "iconv -c -f encodinginfile -t encodingoutfile \"inputfile\" > \"destfile\""
      exeStr = "cmd /C \"\""..exeStr.."\" -c -f "..codIn.." -t "..codOut.." \""..curfile.."\" > \""..destfile.."\" \""
      --print(exeStr)
      os.execute(exeStr)

      --procedura conclusa con successo
      print(_t(198))
      
      --if (rwfx_MsgBox("Si desidera Aprire il file '"..destfile.."' ?",
        if (rwfx_MsgBox(_t(147).." '"..destfile.."' ?",
            _t(148), MB_YESNO) == IDYES) then
            scite.Open(destfile)
        end
    end
  
  end


main()
end