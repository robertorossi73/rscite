--[[
Version : 3.3.4
Web     : http://www.redchar.net

Questa procedura permette l'anteprima di un file markdown, convertendolo in html
per poi mostrarlo all'interno del browser web del sistema

Copyright (C) 2015-2019 Roberto Rossi
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
    <!DOCTYPE html><html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8">
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

    local function getUsedModel(fileName)
        local idf
        local txt
        local line = ""
        local pos
        local result = ""
        
        idf = io.open(fileName, "r")
        if (idf) then
            line = idf:read()
            io.close(idf)
            
            pos = string.find(line, ":")
            if (pos) then
                result = rfx_Trim(rfx_RemoveReturnLine(string.sub(line, pos + 1)))
                return result
            end
        end
        
        return result
    end
    
    local function prepareHtmlHeader(html, template)
        local result = "<!-- coding=utf-8 - Template:"..template.."\n"
        
        result = result.."Produced By : ".._t(442)
        
        result = result.."\n"
        
        result = result.." -->\n"..html.."\n"
        
        return result 
    end
    
    --ritorna il nome del file html di preview
    local function markdown_getHtmlName()
        local fname = props["FileNameExt"]
        
        --fname = string.gsub(fname, "%.", "_")
        --return os.getenv("TMP").."\\preview-"..props["FileName"]..".html"
        return props["FileDir"].."\\preview-"..fname..".html"
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
    local function markdown_modHtml(htmlFile, cssFile, model)
        local idf
        local text = ""
        local result = false
        local cssText = ""
        local headerTxt = ""
        local fileName
        
        fileName = props["SciteDefaultHome"].."\\luascr\\md\\"..model..".css"
        if (cssFile == false) then
            if (rfx_fileExist(fileName)) then
                cssText = get_Css_from_file(fileName)
            else
                cssText = get_Css_from_file(props["SciteDefaultHome"]..
                                                "\\luascr\\md\\default.css")
            end
        else
            cssText = get_Css_from_file(cssFile)
        end
        
        headerTxt = prepareHtmlHeader(markdown_header, model).."\n"..cssText.."\n"..markdown_header2

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


---------------------------- Procedura principale ----------------------------
    local function markdown_main()
        local function exist_in_table(tbl, value)
            local val
            local i
            local result = false
            
            for i, val in ipairs(tbl) do
                if (val == value) then
                    result = true
                    break
                end
            end
            
            return result
        end
        
        local tblTemplates = {
                              "github",
                              "dark",
                              "foghorn",
                              "handwriting",
                              "markdown",
                              "metro_vibes",
                              "metro_vibes_dark",
                              "modern",
                              "screen",
                              "solarized_dark",
                              "solarized_light"
                             }
        local htmlFile = markdown_getHtmlName()
        local previousModel = getUsedModel(htmlFile)
                             
        wcl_strip:init()
        wcl_strip:addButtonClose()

        wcl_strip:addLabel(nil, _t(416))
        wcl_strip:addCombo("TVAL", nil)
        wcl_strip:addButton("OKBTN",_t(418),buttonOk_click, true)
        wcl_strip:addButton("OKBTN2",_t(419),buttonOk2_click, false)
        wcl_strip:show()

        wcl_strip:setList("TVAL", tblTemplates)
        if (exist_in_table(tblTemplates, previousModel)) then
            wcl_strip:setValue("TVAL", previousModel)
        else
            wcl_strip:setValue("TVAL", tblTemplates[1])
        end        
    end

    function buttonOk_click(control, change)
        markdown_ButtonClick(false)
    end
    
    function buttonOk2_click(control, change)
        markdown_ButtonClick(true)
    end
    
    function markdown_ButtonClick(OpenHtml)
        local htmlModel = wcl_strip:getValue("TVAL")
        local htmlFile = markdown_getHtmlName()
        local htmlFileDest = markdown_getHtmlName()
        local cssFile = props["SciteDefaultHome"].."\\luascr\\md\\"..
                        htmlModel..".css"
        
        if (rfx_fileExist(cssFile) == false) then
            cssFile = props["SciteDefaultHome"].."\\luascr\\md\\default.css"
        end
        
        print(_t(338)..htmlFileDest.._t(343))
        rfx_exeCapture(markdown_genBat())        
        markdown_modHtml(htmlFile, cssFile, htmlModel)
        
        if (OpenHtml) then
            rwfx_ShellExecute(htmlFile,"")
        end
        
        wcl_strip:close()
    end
    
    local function main()
        local htmlFile = markdown_getHtmlName()
        local previousModel = getUsedModel(htmlFile)
        
        if (previousModel == "") then
            previousModel = "default"
        end
        
        if (PUBLIC_optionScript == "RUN") then
            --preview in browser
            rfx_exeCapture(markdown_genBat())
            markdown_modHtml(htmlFile, false, previousModel)
            rwfx_ShellExecute(markdown_getHtmlName(),"")
            PUBLIC_optionScript = ""
        elseif (PUBLIC_optionScript == "CREATE") then
            PUBLIC_optionScript = ""
            markdown_main()
        end
    end
    
    main()
end

