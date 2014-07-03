--[[
Version : 0.0.1
Web     : http://www.redchar.net

Questa procedura consente l'apertura del file corrente all'interno di uno o 
più browser presenti nel sistema.

------------ Versioni ------------
V.1.0.0
- Release iniziale

TODO :
- aggiungere opzione per aprire file corrente oppure indirizzo selezionato nel testo
- verificare possibilità di verificare presenza browse tramite controllo file su disco invece di controllare i registri.
  . per firefox verificare presenza del file prifiles.ini in C:\Documents and Settings\user\Dati applicazioni\Mozilla\Firefox
  . per opera cercare operaprefs.ini in C:\Documents and Settings\user\Dati applicazioni\Opera\Opera
  . per chrome cercare C:\Documents and Settings\user\Impostazioni locali\Dati applicazioni\Google\Chrome\Application\chrome.exe
  . per safari cercare LastSession.plist in C:\Documents and Settings\user\Dati applicazioni\Apple Computer\Safari

- per ottenere i percorsi di sistema sarebbe interessante, utilizzando il comando reg.exe generare un file ini con tali dati, in modo da poterli rileggere in un secondo tempo
- considerare sottochiave 'Wow6432Node' su sistemi a 64bit
- considerare lettura chiavi di registro a 64bit con parametro /reg:64 di reg.exe

Copyright (C) 2011 Roberto Rossi 
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
]]
  
do
  
  --ritorna true se il sistema è a 64bit
  local function os_is_64bit()
    local processor = os.getenv("PROCESSOR_ARCHITECTURE")
    
    if (processor == "x68") then
      return false
    else
      return true
    end
  end
  
  --questa funzione esegue il comando di interrogazione del registro e 
  -- ritorna i dati ottenuti
  local function get_values_registry_key(keyname, recursive, force32bit)
    local opt = ""
    local cmd = ""
    local resultStr
    local result = {}
    local i = 1
    local w = ""
    local idf
    
    if (recursive) then
      opt = " /s"
    else
      opt = ""
    end
    
    if (not(force32bit)) then
      if (os_is_64bit()) then
        opt = opt.." /reg:64"
      end
    end
    
    nomef = rfx_UserFolderRSciTE().."\\tmp\\reg.dump"
    opt = opt.." > \""..nomef.."\""
    
    cmd = "reg QUERY \""..keyname.."\""..opt
    os.execute(cmd)    
    resultStr = ""
    idf = io.open(nomef, "r")
    if (idf) then
      resultStr = idf:read("*a")    
      io.close(idf)
    end
    
    --separa linee
    for w in string.gmatch(resultStr, "[^\n]*") do
      if (w ~= "") then
        result[i] = w
        --print(w)
        i = i + 1
      end
    end

    if (table.getn(result) == 0) then
      result = false
    end
    return result
  end
  
  --questa funzione, interpreta i dati restituiti 
  -- da get_value_registry_key ritornando il contenuto del valore desiderato
  local function get_value_registry_key(tblData, keyname, valuename)
    --TODO : da implementare
    local i = 0
    local v = ""
    local key = ""
    local value = ""
    local typeValue = "reg_sz" 
    local pos
    local result = ""
    
    valuename = string.lower(valuename)
    keyname = string.lower(keyname)
    for i,v in ipairs(tblData) do
      v = string.lower(v)
      if (string.sub(v,1,1) ~= " ") then
        key = v
        value = ""
      else
        value = rfx_Trim(v)        
      end

      if ((key == keyname) and
          (string.sub(value, 1, string.len(valuename)) == valuename)
         )then
        pos = string.find(value, typeValue,1, true)
        value = rfx_Trim(string.sub(value, pos + string.len(typeValue)))
        result = value
      end
    end
    
    return result
  end
  
  --verifica la presenza di apple safari
  --ritorna nil nel caso non sia presente, altrimenti ritorna il percorso del
  --file eseguibile
  local function exist_safari()
  --TODO : exist_safari
  end
  
  --verifica la presenza di google chrome
  --ritorna nil nel caso non sia presente, altrimenti ritorna il percorso del
  --file eseguibile
  local function exist_chrome()
    local localPath = os.getenv("LOCALAPPDATA")
    
    --TODO : exist_chrome
  end

  --verifica la presenza di opera
  --ritorna nil nel caso non sia presente, altrimenti ritorna il percorso del
  --file eseguibile
  local function exist_opera()
  --TODO : exist_opera
  end
  
  --verifica la presenza di firefox
  --ritorna nil nel caso non sia presente, altrimenti ritorna il percorso del
  --file eseguibile
  local function exist_firefox()
  --TODO : exist_firefox
  end

  --verifica la presenza di internet explorer
  --ritorna nil nel caso non sia presente, altrimenti ritorna il percorso del
  --file eseguibile
  local function exist_ie()
  --TODO : exist_ie
  end

  --ritorna l'elenco delle voci selezionabile dalla lista di richiesta
  local function get_selection_list()
  --TODO : tutto da fare
  end
  
  local function main()
  --TODO : tutto da fare
  print(os.getenv("ciao"))
  end --end function

  
  --main()
--  print(get_value_registry_key(get_values_registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Mozilla\\Mozilla Firefox",true, true), "HKEY_LOCAL_MACHINE\\SOFTWARE\\Mozilla\\Mozilla Firefox", "CurrentVersion"))
  
--print(get_value_registry_key(get_values_registry_key("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders",true), "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders", "AppData"))

--  get_values_registry_key("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders",false)

end
