--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura Utilizza il software di ottimizzazione realizzato da Google:
http://code.google.com/p/closure-compiler/downloads/list


Copyright (C) 2009 Roberto Rossi 
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

  local function main ()
    local testo = ""
    local nomef = ""
    local comando = ""
    local batfile = ""
    local idf
    local estensione
    local tipo
    
    batfile = os.getenv("TMP")
    batfile = batfile.."\\sciteStr.bat"        
    
      idf = io.open(batfile, "w")
      if (idf) then
        estensione = string.lower(props["FileExt"])        
        estensione = '*.'..estensione        
        if (string.find(props["file.patterns.js"],estensione,1,true)) then
          tipo = "js"
        else
          tipo = ""
        end
        
        if (tipo ~= "") then
          nomef = rfx_FN()
          comando = "echo off\n"
          comando = comando.."cls\n"
          comando = comando.."echo Google Js Compiler\n"
          comando = comando.."rem ricerca versione Java\n"
          comando = comando.."FOR /F \"skip=2 tokens=2*\" %%A IN ('REG QUERY \"HKLM\\Software\\JavaSoft\\Java Runtime Environment\" /v CurrentVersion') DO set JavaCurVer=%%B\n"
          comando = comando.."IF \"%JavaCurVer%\"==\"\" GOTO nontrovato\n"
          comando = comando.."rem path java\n"
          comando = comando.."rem FOR /F \"skip=2 tokens=2*\" %%A IN ('REG QUERY \"HKLM\\Software\\JavaSoft\\Java Runtime Environment\\%JavaCurVer%\" /v JavaHome') DO set JAVA_HOME=%%B\n"
          comando = comando.."rem echo %JavaCurVer%\n"
          comando = comando.."\n"
          comando = comando.."echo Please wait...compressing\n"
          comando = comando.."java -jar \""..props["SciteDefaultHome"].."\\compiler.jar.jar\" "
          comando = comando.."--type="..tipo.." -o \""..nomef.."\" \""..props["FilePath"].."\"\n"
          comando = comando.."GOTO fine\n"
          comando = comando.."\n"
          comando = comando..":notrovato\n"
          comando = comando.."\n"
          comando = comando.."This function require Java! Java is missing. Install Java and retry.\n"
          comando = comando.."pause\n"
          comando = comando..":fine\n"
          idf:write(comando)
          io.close(idf)
          
          rfx_WF(testo.."\n")
          os.execute("\""..batfile.."\"")
          testo = rfx_GF()
          scite.MenuCommand(IDM_NEW)
          editor:ReplaceSel(testo)        
        else
          io.close(idf)
          rwfx_MsgBox(_t(156),_t(155),MB_OK)          
              --155=Impossibile continuare
              --156=Questa procedura supporta esclusivament file CSS (.css) e file Javascript (.js)!
        end --if tipo
      else
        rwfx_MsgBox(_t(157).."\n"..batfile,_t(155),MB_OK)          
          --155=impossibile continuare
          --157=Impossibile creare file temporaneo!
      end --endif batfile
  end -- endfx
  
  main()
end

