--[[
Author  : Roberto Rossi
Version : 2.0.0
Web     : http://www.redchar.net

Questa procedura provvede alla compilazione del file di setup della distribuzione
RSciTE, utilizzando Inno Setup come compilatore.

ATTENZIONE : 
  Questa procedura dere essere eseguita dall'interno di RSciTE, utilizzando
  il comando "Esegui" presente nel menu "Strumenti"

]]

do
  require("luascr/rluawfx") --libreria standard di RSciTE  

  --Configurazioni generali script
  local InnoSetup = "C:\\Program Files\\Inno Setup 5\\iscc.exe" --Eseguibile Inno Setup
  local InnoSetupAlt = "C:\\Program Files (x86)\\Inno Setup 5\\iscc.exe" --Eseguibile Inno Setup
  local InnoSetupAlt2 = "C:\\Programmi\\Inno Setup 5\\iscc.exe" --Eseguibile Inno Setup
  local InnoSetupAlt3 = "D:\\Program Files (x86)\\Inno Setup 5\\iscc.exe" --Eseguibile Inno Setup

  -----------------------------------------------------------------------------
  local flagOk = true
  local flagErrorNsis = false
  local nomeFCompresso = "rscite"

--salva il file contenente la definizione della costante AppVerName= per InnoSetup
local function saveInnoSetup_AppVerName(ver)
  local idf=io.open("./AppVerName.iss","w")
  idf:write("AppVerName=RSciTE "..ver)
  idf:close()
end
  
--ritorna la versione di RSciTE corrente, correttamente
--formattata per la produzione dei file di installazione
local function getRSciTEVersion()
  local versionTbl = rfx_GetVersionTable()
  local vScite
  local vDistribuzione
  local result

  vScite = versionTbl.FileMajorPart.."_"..
                   versionTbl.FileMinorPart.."_"..versionTbl.FileBuildPart
  vDistribuzione = versionTbl.Distro
  
  result = vScite.."-"..vDistribuzione..versionTbl.AddPart
  return rfx_Trim(result)
end
      
local function s(comando) 
  return os.execute(comando);
end --endfunction

--ritorna il numero di versione chiedendolo all'utente
local function getVersionNumber()
  local numver = ""
  local vScite = getRSciTEVersion()
  
  numver = rwfx_InputBox(vScite, "Versione pacchetto","Specifica versione pacchetto da creare :",rfx_FN());
  if numver then
    numver = rfx_GF()
    numver = rfx_Trim(numver)
    
    if (numver == "") then
      print("\nAttenzione : Impossibile continuare se non si specifica il numero di versione!")
    end
  else
    numver = ""
  end
  
  return numver
end --endfunction

--procedura principale
local function startProc(version)
  local cmd = ""
  local exe = ""
  local resultExeName = "setup-"..nomeFCompresso..version
  local flagErrorNsis
  local flagOk = true
  local setupVersion = ""
  
  setupVersion = string.gsub(version, "RSciTE","")
  setupVersion = string.gsub(setupVersion, "_",".")
  
  nomeFCompresso = nomeFCompresso..version
  
    --eliminazione vecchio file di setup
    if (rfx_fileExist(".\\output\\"..resultExeName..".exe")) then
      s("del \".\\output\\"..resultExeName..".exe\"")
    end
    
    if (rfx_fileExist(InnoSetup) or 
        rfx_fileExist(InnoSetupAlt) or 
        rfx_fileExist(InnoSetupAlt2) or 
        rfx_fileExist(InnoSetupAlt3)) 
        then
      if (rfx_fileExist(InnoSetupAlt)) then
        exe = InnoSetupAlt
      elseif (rfx_fileExist(InnoSetup)) then
        exe = InnoSetup
      elseif (rfx_fileExist(InnoSetupAlt2)) then
        exe = InnoSetupAlt2
      elseif (rfx_fileExist(InnoSetupAlt3)) then
        exe = InnoSetupAlt3
      end
      cmd = "/F\""..resultExeName.."\" rscite.iss"
      saveInnoSetup_AppVerName(setupVersion) --save version
      rwfx_ShellExecute(exe,cmd)
    else 
      flagErrorNsis = true;
      flagOk = false;
    end
    
    if (flagOk) then
      print("\nProcedura Conclusa con successo.")
    else 
      print("\n\n Attenzione, sono stati riscontrati i seguenti errori :")
      if (flagErrorNsis) then
        print("\n - Manca il file '"..InnoSetup.."' o '"..InnoSetupAlt.."'\n   Impossibile completare la creazione dell'installazione!")
      end
      print("\n\n")
    end --endif
end --endfunction

local function main()
  local version = getVersionNumber()
  if not(version == "") then
    startProc(version)
  end
end

main()
end