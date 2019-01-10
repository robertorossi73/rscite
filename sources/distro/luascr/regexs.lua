--[[
Version : 2.0.0
Web     : http://www.redchar.net

Questa procedura consente l'esecuzione di dnGREP.

Copyright (C) 2012-2018 Roberto Rossi 
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
    require("luascr/rluawfx")

    --genera file bat con comando completo, ritorna il path del bat
    local function checkCfgDnGrep_genBat(folderDnGrep, fromFile, toFile)
        local batfile
        local idf
        local comando
        local exe = props["SciteDefaultHome"].."/tools/cloc/cloc.exe"

        batfile = os.getenv("TMP")
        batfile = batfile.."\\sciteDnGrep.bat"
        idf = io.open(batfile, "w")
        if (idf) then
            comando = "mkdir \""..folderDnGrep.."\"\n"
            comando = comando.."copy \""..fromFile.."\" \""..toFile.."\""
            idf:write(comando)
            io.close(idf)
        end
        return batfile
    end

    --verifica la presenza delle configurazione di dngre e nel caso non esistesse
    -- la crea impostando come editor di default scite
    local function checkCfgDnGrep()
        local result = false
        local folder = os.getenv("APPDATA").."\\dnGREP"
        local fileName = "\\dnGREP.Settings.dat"
        local filePath = folder..fileName
        local idf
        local fileData
        local localFilePath = props["SciteDefaultHome"].."\\tools\\dngrep"..fileName
        
        if (not(rfx_fileExist(filePath))) then
            os.execute(checkCfgDnGrep_genBat(folder, 
                            props["SciteDefaultHome"].."\\tools\\dngrep\\default-dnGREP.Settings.dat" , 
                            filePath))
            if (rfx_fileExist(filePath)) then
                idf = io.open(filePath, "r")
                if (idf) then
                    fileData = idf:read("*a")    
                    fileData = string.gsub(fileData, 
                                    "PathSciTE.exe", 
                                    props["SciteDefaultHome"].."\\SciTE.exe")
                    io.close(idf)
                    
                    idf = io.open(filePath, "w")
                    if (idf) then
                        idf:write(fileData)
                        io.close(idf)
                        result = true
                    end
                    
                    if not(rfx_fileExist(localFilePath)) then --file locale per versione portabile
                        idf = io.open(localFilePath, "w")
                        if (idf) then
                            idf:write(fileData)
                            io.close(idf)
                            result = true
                        end
                    end
                    
                end            
            end
        end
        
        return result
    end
  
  local function main ()
    local exeApp = props["SciteDefaultHome"].."/tools/dngrep/dnGREP.exe"
    local par = ""
    local netVer = rfx_dotNetExist()
    if ( netVer["v4"] ) then
        checkCfgDnGrep()
        rwfx_ShellExecute(exeApp,"\""..props["FileDir"].."\"")
    else
      print(_t(272))
      --print("\nAttenzione : Per eseguire questa procedura è necessario la presenza di .NET V.4!\n\nE' possibile scaricarne una copia da \n https://www.microsoft.com/it-it/download/details.aspx?id=17718")
    end
  end --end main

main()


end

