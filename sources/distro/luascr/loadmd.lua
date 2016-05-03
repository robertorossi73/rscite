--[[
Version : 1.1.2
Web     : http://www.redchar.net

Questa procedura permette l'anteprima di un file markdown, convertendolo in html
per poi mostrarlo all'interno del browser web del sistema

Copyright (C) 2015-2016 Roberto Rossi 
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
          <style type="text/css">
        a, a * { cursor: pointer; outline: none;}
        a { color: #2281cf; text-decoration: none; }
        a:hover { text-decoration: underline; }
        p, h1, h2, h3, h4, h5 { margin: 0 0 1em 0; line-height: 1.6em;}

        h1 {
            font-size: 32px;
            margin: 0 0 15px 0;
        }

        h2 {
            font-size: 20px;
            font-weight: bold;
            padding-top: 8px;
            padding-bottom: 0;
            margin-bottom: 2px;
        }

        h3 {
            font-size: 14px;
            margin-bottom: 2px;
        }

        ul li, ol li {
            margin: 7px 0;
        }

        ul {
            margin-left: 1em;
            padding-left: 1em;
        }

        ul ul, ol ul {
            margin-left: .5em;
        }

        ul ol, ol ol {
            margin-left: 1.25em;
        }

        ol {
            margin-left: 1.75em;
            padding-left: .25em;
        }

        pre {
            margin-left: 1em;
        }

        body {
            font-size: 14px;
            font-family: "Open Sans", "lucida grande", "Segoe UI", arial, verdana, "lucida sans unicode", tahoma, sans-serif;
            padding: 20px 45px;
        }
        </style>
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
    
    --aggiunge intestazione e piedi al file html specificato
    local function markdown_modHtml(htmlFile)
        local idf
        local text = ""
        local result = false
        
        idf = io.open(htmlFile, "r")
        if (idf) then
            text = idf:read("*a") --lettura sorgente
            io.close(idf)
        end
        
        --aggiunta intestazione
        text = markdown_header.."\n"..text
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
        local htmlFileDest = props["FileDir"].."\\"..props["FileName"]..".html"
        local copyFile = true
        
        rfx_exeCapture(markdown_genBat())
        markdown_modHtml(htmlFile)
        if (PUBLIC_optionScript == "RUN") then
            --preview in browser
            rwfx_ShellExecute("file://"..markdown_getHtmlName(),"")
        elseif (PUBLIC_optionScript == "CREATE") then
            --verifica presenza file e chiedi se sovrascriver
            if (rfx_fileExist(htmlFileDest)) then
                --if (rwfx_MsgBox("Il file\n'"..htmlFileDest.."'\nesiste. Si desidera sovrascriverlo?","Il file Esiste",MB_YESNO ) == IDNO ) then
                if (rwfx_MsgBox(_t(338)..htmlFileDest.._t(339),_t(340),MB_YESNO ) == IDNO ) then
                    copyFile = false
                end
            end
            
            if (copyFile) then
                --salvataggio file
                if not(rfx_fileCopy(htmlFile,htmlFileDest)) then
                    --se non è riuscito a scrivere avvisare utente
                    rwfx_MsgBox(_t(341)..htmlFileDest,_t(342),MB_OK + MB_ICONEXCLAMATION)
                else 
                    rwfx_MsgBox(_t(338)..htmlFileDest.._t(343),_t(331),MB_OK)
                end
            end
        end
        PUBLIC_optionScript = ""
    end

    Main()
end

