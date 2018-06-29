--[[
Version : 2.0.0
Web     : http://www.redchar.net

Questa procedura permette l'anteprima di un file markdown, convertendolo in html
per poi mostrarlo all'interno del browser web del sistema

Copyright (C) 2015-2018 Roberto Rossi 
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

        local markdown_header = [[
        <!DOCTYPE html>
        <html>
         <head>
         <meta http-equiv="content-type" content="text/html; charset=UTF-8">
         <meta charset="utf-8">
         <STYLE type="text/css">
        ]]    
        local markdown_header2 = [[
         </STYLE>
         </head>
         <body class="markdown">
        ]]
        
        local markdown_footer = [[
         </body>
        </html>
        ]]    
    
    --ritorna il nome del file html di preview
    local function markdown_getHtmlName()
        --return os.getenv("TMP").."\\preview-"..props["FileName"]..".html"
        return props["FileDir"].."\\preview-"..props["FileNameExt"]..".html"
    end
    
    local function get_Css_from_file(nomef)
      local result = ""
      local idf
      
      idf = io.open(nomef, "r")
      if (idf) then
        result = idf:read("*a")    
        io.close(idf)
      end

      return result
    end
    
    --aggiunge intestazione e piedi al file html specificato
    local function markdown_modHtml(htmlFile)
        local idf
        local text = ""
        local result = false
        local cssText = ""
        local headerTxt = ""
        
        cssText = get_Css_from_file(props["SciteDefaultHome"]..
                                        "\\luascr\\md\\default.css")
        
        headerTxt = markdown_header.."\n"..cssText.."\n"..markdown_header2
        
        idf = io.open(htmlFile, "r")
        if (idf) then
            text = idf:read("*a") --lettura sorgente
            io.close(idf)
        end
        
        --aggiunta intestazione
        text = headerTxt.."\n"..text
        --aggiunta chiusura
        text = text.."\n"..markdown_footer
        
        idf = io.open(htmlFile, "w")--scrittura destination
        if (idf) then
          result = idf:write(text)
          io.close(idf)
          result = true
        end     
        
        return result
    end
    
    --genera file bat con comando completo, ritorna il path del bat
    local function markdown_genBat(inPath)
        local batfile
        local idf
        local exe = props["SciteDefaultHome"].."\\tools\\markdown\\multimarkdown.exe"
        local tmpFileName = markdown_getHtmlName()
        --local par = "\""..props["FilePath"].."\" > \""..tmpFileName.."\""
        local par = "-c \""..props["FilePath"].."\" > \""..tmpFileName.."\""
        local cmd = "\""..exe.."\" "..par

        batfile = os.getenv("TMP")
        batfile = batfile.."\\sciteMarkdown.bat"
        idf = io.open(batfile, "w")
        if (idf) then          
          idf:write(cmd)
          io.close(idf)
        end
        return batfile
    end
---------------------------- Procedure principale ---------------------------- 

    local function Main ()
        local htmlFile = markdown_getHtmlName()
        local htmlFileDest = markdown_getHtmlName() --props["FileDir"].."\\"..props["FileName"]..".html"
        local copyFile = true
        
        rfx_exeCapture(markdown_genBat())
        markdown_modHtml(htmlFile)
        if (PUBLIC_optionScript == "RUN") then
            --preview in browser
            rwfx_ShellExecute(markdown_getHtmlName(),"")
        elseif (PUBLIC_optionScript == "CREATE") then
            print(_t(338)..htmlFileDest.._t(343))
        end
        PUBLIC_optionScript = ""
    end

    Main()
end

