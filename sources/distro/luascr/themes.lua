--[[
Author  : Roberto Rossi
Version : 1.2.0
Web     : http://www.redchar.net

Questa procedura consente l'attivazione di un tema che modifica la colorazione
delle entità nella finestra di SciTE.

La procedura è pensata per gestire, in futuro, anche temi diversi dal classico
chiaro/scuro.

Copyright (C) 2018-2023 Roberto Rossi 
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
  
    local THEMES_list_functions = {
                            --"Attiva tema colori scuro (dark)",
                            _t(423),
                            --"Ripristina combinazione colori originale (chiara)"
                            _t(424)
                            }
       
    --attiva o elimina il tema dark
    local function themes_lua_set(activeTheme)
        local lines_for_theme = {
                            "styles\\abaqus",
                            "styles\\ada",
                            "styles\\adcl",
                            "styles\\alisp",
                            "styles\\apdl",
                            "styles\\asl",
                            "styles\\asm",
                            "styles\\asn1",
                            "styles\\au3",
                            "styles\\ave",
                            "styles\\avs",
                            "styles\\baan",
                            "styles\\blitzbasic",
                            "styles\\bullant",
                            "styles\\caml",
                            "styles\\cmake",
                            "styles\\cobol",
                            "styles\\coffeescript",
                            "styles\\conf",
                            "styles\\cpp",
                            "styles\\csound",
                            "styles\\css",
                            "styles\\d",
                            "styles\\ecl",
                            "styles\\eiffel",
                            "styles\\erlang",
                            "styles\\escript",
                            "styles\\euphoria",
                            "styles\\flagship",
                            "styles\\forth",
                            "styles\\fortran",
                            "styles\\freebasic",
                            "styles\\gap",
                            "styles\\haskell",
                            "styles\\hex",
                            "styles\\html",
                            "styles\\inno",
                            "styles\\json",
                            "styles\\kix",
                            "styles\\latex",
                            "styles\\lisp",
                            "styles\\lot",
                            "styles\\lout",
                            "styles\\lua",
                            "styles\\markdown",
                            "styles\\matlab",
                            "styles\\maxima",
                            "styles\\metapost",
                            "styles\\mmixal",
                            "styles\\modula3",
                            "styles\\mql",
                            "styles\\nim",
                            "styles\\nncrontab",
                            "styles\\nsis",
                            "styles\\opal",
                            "styles\\oscript",
                            "styles\\others",
                            "styles\\pascal",
                            "styles\\perl",
                            "styles\\pov",
                            "styles\\powerpro",
                            "styles\\powershell",
                            "styles\\progress",
                            "styles\\ps",
                            "styles\\purebasic",
                            "styles\\python",
                            "styles\\r",
                            "styles\\rebol",
                            "styles\\registry",
                            "styles\\ruby",
                            "styles\\rust",
                            "styles\\scriptol",
                            "styles\\sdlBasic",
                            "styles\\smalltalk",
                            "styles\\sorcins",
                            "styles\\specman",
                            "styles\\spice",
                            "styles\\sql",
                            "styles\\tacl",
                            "styles\\tal",
                            "styles\\tcl",
                            "styles\\tex",
                            "styles\\txt2tags",
                            "styles\\vb",
                            "styles\\verilog",
                            "styles\\vhdl",
                            "styles\\visualprolog",
                            "styles\\yaml",
                            "styles\\nim",
                            "styles\\cil",
                            "styles\\raku",
                            "styles\\dataflex",
                            "styles\\asciidoc",
                            "styles\\hollywood",
                            "dark-theme"
                            }
        local pos
        local i
        local value
        local line
        local lineNum
        
        --eliminazione linee relative ai temi
        for i, value in ipairs(lines_for_theme) do
            line = "import "..props["SciteDefaultHome"].."\\themes\\"..value
            pos = editor:findtext(line)
            if (pos) then
                lineNum  = editor:LineFromPosition(pos)
                print("Delete line -> "..value)
                editor:GotoLine(lineNum)
                editor:LineDelete()
            end
        end
        
        --inserimento linee relative al tema scelto
        if (activeTheme) then
            for i, value in ipairs(lines_for_theme) do
                if (string.find(value, "styles\\", 1, true)) then
                    line = "import "..props["SciteDefaultHome"].."\\themes\\"..value
                    editor:AppendText("\r\n"..line)
                end
            end
            editor:AppendText("\r\nimport "..props["SciteDefaultHome"]..
                            "\\themes\\"..activeTheme.."-theme")
        end
    end
    
    function buttonOk_click(control, change)
        local option = wcl_strip:getValue("TVAL")
        local userOpt = props["SciteUserHome"].."\\SciTEUser.properties"
        local isOk = false
        local idf

        --messaggio di conferma definitivo
        --rwfx_MsgBox("Sta per essere modificato il file di configurazione"..
        --            " del profilo utente corrente (SciTEUser.properties).\n\n"..
        --            " Si desidera procedere?"
        --            ,"Attenzione",MB_YESNO + MB_DEFBUTTON2)
        isOk = rwfx_MsgBox(_t(426),_t(427),MB_YESNO + MB_DEFBUTTON2)
        
        if (isOk == IDYES) then
            output:ClearAll()
            --apertura file opzioni
            if (not(rfx_fileExist(userOpt))) then
                idf = io.open(userOpt, "w")
                io.close(idf)
            end
            
            scite.Open(userOpt)
            if (option == THEMES_list_functions[1]) then
                --attiva tema
                themes_lua_set("dark")
            else
                --disattiva tema
                themes_lua_set(nil)
            end
            scite.MenuCommand(IDM_SAVE)
            scite.MenuCommand(IDM_CLOSE)
            --rwfx_MsgBox("La configurazione è stata modificata, si consiglia di"..
            --            " riavviare il programma per abilitare completamente le"..
            --            " nuove impostazioni."
            --            ,"Consiglio", MB_OK)
            rwfx_MsgBox(_t(428),_t(429), MB_OK)
        end
        wcl_strip:close()
    end
  
    function buttonCancel_click(control, change)
        wcl_strip:close()
    end
  
  
    local function main()
        wcl_strip:init()
        wcl_strip:addButtonClose()

        --wcl_strip:addLabel(nil, "Tema colori: ")
        wcl_strip:addLabel(nil, _t(430).." ")
        wcl_strip:addCombo("TVAL")
        --wcl_strip:addButton("OK","Esegui operazione", buttonOk_click, false)
        wcl_strip:addButton("OK",_t(431), buttonOk_click, false)
        --wcl_strip:addButton("CANCEL","Annulla", buttonCancel_click, true)
        wcl_strip:addButton("CANCEL",_t(432), buttonCancel_click, true)
    
        wcl_strip:show()
    
        wcl_strip:setList("TVAL", THEMES_list_functions)
        wcl_strip:setValue("TVAL", THEMES_list_functions[1])
    end
  
    main()
    --themes_lua_set("dark")
end