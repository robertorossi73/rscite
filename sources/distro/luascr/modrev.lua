--[[
Version : 1.4.2
Web     : http://www.redchar.net

Questa procedura verifica che quella corrente sia l'ultima release disponibile,
in caso contrario permette lo scaricamento e l'installaizone di quest'ultima

- Modulo Revisions con funzioni per SVN e GIT. Questo modulo consente:
  
  . commit file corrente
  . commit cartella corrente
  . commit repository
  . log file corrente
  . log cartella corrente
  . log repository
  . aggiungi file/cartella corrente
  . push (solo git) tutto
  . blame file corrente
  
  le funzioni sono disponibili per TortoiseSVN, TortoiseGIT e GIT Extensions

Copyright (C) 2016-2018 Roberto Rossi 
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
  
    local function modrev_tableReverse ( tbl )
        local size = #tbl
        local nTbl = {}
        local i
        local v
        
        for i,v in ipairs ( tbl ) do
            nTbl[size-i] = v
        end
        return nTbl
    end

    --verifica la presenza dei prerequisiti necessari e ritorna t se è tutto ok
    --se il primo parametro è T allora si limita a restituire un valore se
    --non è presente ciò che serve, con nil mostra anche un messaggio di avviso
    local function modrev_checkGitExt (silent)
        local result = false
        local path = modrev_getExePath("GITE")
        --print(path)
        if (path) then
            if (rfx_fileExist(path)) then
                result = true
            end
        end

        if (not(silent) and not(result)) then
            --gotoWeb = rwfx_MsgBox("GIT Extensions non è installato nel sistema, impossibile procedere. Installare GIT Extensions e riprovare. Si desidera scaricare ora il programma mancante?","Attenzione!",MB_DEFBUTTON2 + MB_YESNO)
            gotoWeb = rwfx_MsgBox(_t(375),_t(9),MB_DEFBUTTON2 + MB_YESNO)
            if (gotoWeb == IDYES) then
                rwfx_ShellExecute("https://gitextensions.github.io/","")
            end
        end
        
        return result
    end
    local function modrev_checkTortoiseGit (silent)
        local result = false
        local path = modrev_getExePath("TGIT")
        local gotoWeb = false
        
        if (path) then
            if (rfx_fileExist(path)) then
                result = true
            end
        end
        
        if (not(silent) and not(result)) then
            --gotoWeb = rwfx_MsgBox("TortoiseGIT non è installato nel sistema, impossibile procedere. Installare TortoiseGIT e riprovare. Si desidera scaricare ora il programma mancante?","Attenzione!",MB_DEFBUTTON2 + MB_YESNO)
            gotoWeb = rwfx_MsgBox(_t(376),_t(9),MB_DEFBUTTON2 + MB_YESNO)
            if (gotoWeb == IDYES) then
                rwfx_ShellExecute("https://tortoisegit.org/","")
            end
        end
        
        return result
    end
    local function modrev_checkTortoiseSvn (silent)
        local result = false
        local path = modrev_getExePath("TSVN")
        
        if (path) then
            if (rfx_fileExist(path)) then
                result = true
            end
        end
        
        if (not(silent) and not(result)) then
            --gotoWeb = rwfx_MsgBox("TortoiseSVN non è installato nel sistema, impossibile procedere. Installare TortoiseSVN e riprovare. Si desidera scaricare ora il programma mancante?","Attenzione!",MB_DEFBUTTON2 + MB_YESNO)
            gotoWeb = rwfx_MsgBox(_t(377),_t(9),MB_DEFBUTTON2 + MB_YESNO)
            if (gotoWeb == IDYES) then
                rwfx_ShellExecute("https://tortoisesvn.net/","")
            end
        end
        
        return result
    end
    
    --dato il percorso di un file ritorna l'elenco di tutte le cartelle accessibili
    --partendo da quella del file specificato
    local function modrev_splitPath (completePath)
        local ch 
        local path
        local parPath
        local chList = {}
        local i = 1
        local v
        local seps = {}
        local result = {}
        
        path = string.gsub(completePath,"/", "\\") --normalize path
        for i = 1, #path do
            chList[i] = path:sub(i, i)
        end

        for i,v in ipairs(chList) do 
            if (v == "\\") then
                table.insert(seps, i)
            end
        end

        for i,v in ipairs(seps) do 
            parPath = string.sub(path, 0, v)
            if (parPath == "\\") then
                parPath = "\\\\"
            elseif (string.sub(path, 0, 1) == "\\") then
                parPath = "\\"..parPath
            end
            table.insert(result, parPath)
        end
        
       return result
    end

    --ritorna la cartella doe è presente il gestore delle revisioni
    --se non esiste, ritorna false
    local function modrev_getGitExtensionsFolder ()
        if (rwfx_RegGetString("SOFTWARE\\GitExtensions", "InstallDir", "HKCU", rfx_FN())) then
            return rfx_GF()
        else 
            return ""
        end
    end
    local function modrev_getTortoiseGitFolder ()
        if (rwfx_RegGetString("SOFTWARE\\TortoiseGIT", "Directory", "HKLM", rfx_FN())) then
            return rfx_GF()
        else 
            return ""
        end
    end
    local function modrev_getTortoiseSvnFolder ()
        if (rwfx_RegGetString("SOFTWARE\\TortoiseSVN", "Directory", "HKLM", rfx_FN())) then
            return rfx_GF()
        else 
            return ""
        end
    end

    --ritorna il path completo del file exe da eseguire
    function modrev_getExePath(tipo)
        local exeFolder
        
        if (tipo == "TGIT") then
            exeFolder = modrev_getTortoiseGitFolder().."bin\\TortoiseGitProc.exe"
        elseif (tipo == "GITE") then
            exeFolder = modrev_getGitExtensionsFolder().."\\GitExtensions.exe"
        elseif (tipo == "TSVN") then
            exeFolder = modrev_getTortoiseSvnFolder().."bin\\TortoiseProc.exe"
        else
            return false
        end
        return exeFolder
    end

    --dato il percorso completo di un file, determina se è incluso in un repository
    --e ritorna la cartella principale del repository stesso
    --La cartella ritornata è quella più vicina al file specificato
    --Se viene passato nil utilizza il percorso del file corrente
    --typeRepo può essere "SVN o "GIT"
    local function modrev_getRepoFolders ( filePath, typeRepo )
        local outList
        local curFolder
        local folders = {}
        local okFolder = false
        
        if (filePath == "") then
            filePath = props["FilePath"] --percorso completo file corrente
        end
        
        folders = modrev_splitPath(filePath)
        --folders = modrev_tableReverse(folders)
        for i,v in ipairs(folders) do 
            --print(v)
            if (not(okFolder)) then
                if (typeRepo == "GIT") then
                    if (rfx_fileExist(v..".git\\index")) then
                        okFolder = v
                    else
                        if (rfx_fileExist(v..".git\\HEAD")) then
                            okFolder = v
                        else
                            if (rfx_fileExist(v..".git\\config")) then
                                okFolder = v
                            end                    
                        end                    
                    end                    
                elseif (typeRepo == "SVN") then
                    if (rfx_fileExist(v..".svn\\wc.db")) then
                        okFolder = v
                    end
                end
            end
        end
        return okFolder
    end

    --compone il comando da eseguire
    local function modrev_composeCommand (flag, currentPath, typeRepo)
        local exe
        local cmds = {}
        
        exe = modrev_getExePath(typeRepo)
        
        if (typeRepo == "TGIT") then
            --Tortoise Git
            --cmds = "\""..exe.."\" /command:"..flag.." /path:\""..currentPath.."\""
            cmds[0] = exe
            cmds[1] = "/command:"..flag.." /path:\""..currentPath.."\""            
        elseif (typeRepo == "GITE") then
            --Git Extensions
            if ((flag == "") and (currentPath == "")) then
                --cmds = "\""..exe.."\""
                cmds[0] = exe
                cmds[1] = ""                
            else
                --cmds = "\""..exe.."\" "..flag.." \""..currentPath.."\""
                cmds[0] = exe
                cmds[1] = flag.." \""..currentPath.."\""
            end
        elseif (typeRepo == "TSVN") then
            --Tortoise Svn
            --cmds = "\""..exe.."\" /command:"..flag.." /path:\""..currentPath.."\""
            cmds[0] = exe
            cmds[1] = "/command:"..flag.." /path:\""..currentPath.."\""
        end
        
        return cmds
    end
    
    -- ritorna il tipo di gestore revisioni utilizzato dal file/cartella
    -- specificata
    -- Tipi supportati : 
    --              GIT
    --              SVN
    local function modrev_getRepoType()
        local isGit = false
        local isSvn = false
        local resutl = false
        
        isGit = modrev_getRepoFolders(props["FilePath"], "GIT")
        if (not(isGit)) then
            isSvn = modrev_getRepoFolders(props["FilePath"], "SVN")
            if (isSvn) then
                result = "SVN"
            end
        else
            result = "GIT"
        end
        return result
    end
    
    function modrev_buttonGITE_click(control, change)
        local op = wcl_strip:getValue("OPERATION")
        local subject = wcl_strip:getValue("SUBJECT")
        
        wcl_strip:close()
        modrev_execGui(op, subject, "GITE")
    end
    function modrev_buttonTGIT_click(control, change)
        local op = wcl_strip:getValue("OPERATION")
        local subject = wcl_strip:getValue("SUBJECT")
        
        wcl_strip:close()
        modrev_execGui(op, subject, "TGIT")
    end
    function modrev_buttonTSVN_click(control, change)
        local op = wcl_strip:getValue("OPERATION")
        local subject = wcl_strip:getValue("SUBJECT")
        
        wcl_strip:close()
        modrev_execGui(op, subject, "TSVN")
    end

    --esegue la funzione scelta
    function modrev_execGui(op, subject, software)
        local operation = ""
        local where = ""
        
        --where option
        --if (subject == "File corrente") then
        if (subject == _t(391)) then
            where = "FILE"
        --elseif (subject == "Cartella corrente") then
        elseif (subject == _t(392)) then
            where = "FOLDER"
        --elseif (subject == "Il Repository") then
        elseif (subject == _t(393)) then
            where = "ALL"
        end
        --operation option
        --if (op == "Commit") then
        if (op == _t(394)) then
            operation = "commit"
        --elseif (op == "Add") then
        elseif (op == _t(395)) then
            operation = "add"
        --elseif (op == "Push") then
        elseif (op == _t(396)) then
            operation = "push"
        --elseif (op == "Log") then
        elseif (op == _t(397)) then
            operation = "log"
        --elseif (op == "Blame") then
        elseif (op == _t(398)) then
            operation = "blame"
        --elseif (op == "Diff") then
        elseif (op == _t(399)) then
            operation = "diff"
        end
        
        if ((where ~= "") and (operation ~= ""))then
            --modrev_main(cmd, filter, typeSoftware)
            modrev_main(operation, where, software)
        else
            if (where == "") then
                --403=Impossibile continuare, non è possibile applicare l'operazione all'elemento scelto.
                print(_t(403))
            elseif (operation == "") then
                --402=Impossibile continuare,l'Operazione specificata non è corretta.
                print(_t(402))
            end
        end
    end
    
    function main_gui()
        local repotp = modrev_getRepoType()
        local operations = {}
        --local subjects = {"File corrente", "Cartella corrente", "Repository"}
        local subjects = {_t(391), _t(392), _t(393)}
        local activeButton = false
        
        wcl_strip:init()
        wcl_strip:addButtonClose()

        --wcl_strip:addLabel(nil, "Operazione:")
        wcl_strip:addLabel(nil, _t(400))
        wcl_strip:addCombo("OPERATION")
        
        --wcl_strip:addLabel(nil, "Applica a:")
        wcl_strip:addLabel(nil, _t(401))
        wcl_strip:addCombo("SUBJECT")
        
        --TODO : attivare il primo tasto che ha l'applicatione installata
        
        if (repotp == "GIT") then   
            activeButton = false
            if (modrev_checkTortoiseGit(true)) then
                activeButton = true
            end
            wcl_strip:addButton("TGIT","&Tortoise GIT", modrev_buttonTGIT_click, activeButton)
            if (not(activeButton) and modrev_checkGitExt(true)) then
                activeButton = true
            end
            wcl_strip:addButton("GITE","Git&Extensions", modrev_buttonGITE_click, activeButton)
            --operations = {"Commit", "Add", "Push", "Log", "Blame", "Diff"}
            operations = {_t(394), _t(395), _t(396), _t(397), _t(398), _t(399)}
        end
        if (repotp == "SVN") then
            activeButton = false
            if (modrev_checkTortoiseSvn(true)) then
                activeButton = true
            end
            wcl_strip:addButton("TSVN","Tortoise SVN", modrev_buttonTSVN_click, activeButton)
            --operations = {"Commit", "Add", "Log", "Blame", "Diff"}
            operations = {_t(394), _t(395), _t(397), _t(398), _t(399)}
        end
        
        if (#operations > 0) then
            wcl_strip:show()
            wcl_strip:setList("OPERATION", operations)
            wcl_strip:setValue("OPERATION", operations[1])
            wcl_strip:setList("SUBJECT", subjects)
            wcl_strip:setValue("SUBJECT", subjects[1])
        else
            --print("Impossibile continuare. Il file corrente non si trova all'interno di un repository!")
            print(_t(404))
        end
    end
    
    --funzione principale
    -- cmd= dipende dal programma al quale va ed è il comando
    --      può valere "commit", "push", "log", "blame", "diff"
    -- type= programma da lanciare TSVN, TGIT oppure GITE
    -- filter= può valere FILE nel caso del file corrente, FOLDER nel caso della cartella
    --oppure ALL nel caso di tutto il repository
    function modrev_main(cmd, filter, typeSoftware)
        local cm = false
        local tblCmd = {}
        local path = false
        local okExe = false
        local tbl
        
        if (typeSoftware == "TSVN") then
            okExe = modrev_checkTortoiseSvn(false)
        elseif (typeSoftware == "TGIT") then
            okExe = modrev_checkTortoiseGit(false)
        elseif (typeSoftware == "GITE") then
            okExe = modrev_checkGitExt(false)
        end
        
        if (okExe) then
            tbl = modrev_splitPath(props["FilePath"])
            if (filter == "FILE") then
                path = props["FilePath"]
            elseif (filter == "FOLDER") then
                path = tbl[#tbl]
            elseif (filter == "ALL") then
                if (typeSoftware == "TSVN") then
                    path = modrev_getRepoFolders(props["FilePath"], "SVN")
                elseif (typeSoftware == "TGIT") then
                    path = modrev_getRepoFolders(props["FilePath"], "GIT")
                elseif (typeSoftware == "GITE") then
                    path = modrev_getRepoFolders(props["FilePath"], "GIT")
                end
            end
            
            if (cmd == "commit") then
                if (typeSoftware == "TSVN") then
                    cm = "commit"
                elseif (typeSoftware == "TGIT") then
                    cm = "commit"
                elseif (typeSoftware == "GITE") then
                    cm = "commit"
                end
            end
            if (cmd == "add") then
                if (typeSoftware == "TSVN") then
                    cm = "add"
                elseif (typeSoftware == "TGIT") then
                    cm = "add"
                elseif (typeSoftware == "GITE") then
                    cm = "add"
                end
            end
            if (cmd == "push") then
                if (typeSoftware == "TGIT") then
                    cm = "push"
                elseif (typeSoftware == "GITE") then
                    cm = "push"
                end
            end
            if (cmd == "log") then
                if (typeSoftware == "TSVN") then
                    cm = "log"
                elseif (typeSoftware == "TGIT") then
                    cm = "log"
                elseif (typeSoftware == "GITE") then
                    cm = "filehistory"
                end
            end
            
            if (cmd == "blame") then
                if (typeSoftware == "TSVN") then
                    cm = "blame"
                elseif (typeSoftware == "TGIT") then
                    cm = "blame"
                elseif (typeSoftware == "GITE") then
                    cm = "blame"
                end
            end
            
            if (cmd == "diff") then
                if (typeSoftware == "TSVN") then
                    cm = "diff"
                elseif (typeSoftware == "TGIT") then
                    cm = "diff"
                elseif (typeSoftware == "GITE") then
                    cm = "difftool"
                end
            end
            
            if (path and cm) then
                --rimuove eventuale ultima \ nel percorso
                if (string.sub(path, -1) == "\\") then
                    path = string.sub(path, 0, string.len(path) - 1)
                end
                tblCmd = modrev_composeCommand(cm, path, typeSoftware)
                rwfx_ShellExecute(tblCmd[0],tblCmd[1])
            else
                if (cm) then
                    --print("\nImpossibile proseguire, il file corrente non fa parte di un repository!")
                    print(_t(378))
                else
                    --print("\nImpossibile proseguire, comando non supportato!")
                    print(_t(379))
                end
            end
        end
    end

    main_gui()
end
