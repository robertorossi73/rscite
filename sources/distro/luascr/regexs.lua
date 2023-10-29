--[[# -*- coding: utf-8 -*-
Version : 2.0.4
Web     : http://www.redchar.net

Questa procedura consente l'esecuzione di qualsiasi software 
per ricerca e sostituzione testi

Copyright (C) 2012-2023 Roberto Rossi 
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
    
    --controlla la presenza del software, chiede dove si trova, suggerisce
    --  di scaricarti e riprovare
    --  ritorna il path completo del file eseguibile 
    local function getGrep(resetCfg)
        local result = ""
        local cfgfile = "serepath.cfg"
        
        result = rfx_getApplicationPath(
                                    --"Attenzione: è necessario specificare quale applicazioni usare per la funzione di 'Ricerca e Sostituzione Multipla'.\n\nVerrà ora chiesto di selezionare il file eseguibile(.exe) dell'applicazione che si desidera utilizzare.",
                                    _t(501),
                                    --"Selezionare file exe dell'applicazione...",
                                    _t(502),
                                    --"Non è stata selezionata nessuna applicazione, impossibile continuare.",
                                    _t(503),
                                    --"Si desidere scaricare una applicazione dal web? \n\nRispondendo 'Si' sarà possibile installare, gratuitamente, una delle applicazioni consigliate.",
                                    _t(504),
                                    "dnGrep: Powerful search for Windows.|AstroGrep: Windows grep utility|grepWin: Regular expression search and replace",
                                    {"https://dngrep.github.io/", "https://astrogrep.sourceforge.net/", "https://github.com/stefankueng/grepWin/releases"},
                                    cfgfile,
                                    resetCfg
                                )
        
        return result
    end
    
    local function regexs_startApp()
        local pathExe = getGrep(false)
        
        --rwfx_ShellExecute(exeApp,"\""..props["FileDir"].."\"")
        if (pathExe ~= "") then
            --rwfx_ShellExecute(exeApp,"\""..props["FileDir"].."\"")
            rwfx_ShellExecute(pathExe,"")
        end
    end

    
    function regexs_main(startApp)
        if (startApp) then
            regexs_startApp()
        else
            getGrep(true)
        end
    end

    --regexs_main(true) --test: avvia applicazione
    --regexs_main(false)  --test: riconfigura

end

