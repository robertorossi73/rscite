--[[
Version : 2.1.3
Web     : http://www.redchar.net

Questa procedura consente di inserire la lista di file presenti in una
cartella indicata dall'utente. Inoltre consente di scegliere, tramite un
filtro, quali file elencare

Copyright (C) 2004-2023 Roberto Rossi 
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

  local function InsertListFiles ()
    local nomeFile
    local testo
    local idf
    local cartella
    local filtro
    local comando
    local conPercorso
    local line
    local opzioniDir
    local idv, strLst
    
    -- 85=Seleziona Cartella
    -- 86=Filtro
    -- 87=Indica il filtro per la lettura dell'elenco file (es.: *.*) :
    -- 88=Si desidera inserire anche il percorso assoluto dei file, oltre al nome ?
    -- 89=Tipo inserimento
    -- 90=solo nomi file|solo nomi cartelle|nomi file + nomi cartelle|solo file (ricorsivo)|solo nomi cartelle(ricorsivo)|file + cartelle(ricorsivo)
    -- 91=Lista con...
    cartella = rwfx_BrowseForFolder(_t(85),rfx_FN())
    if cartella then
      cartella = rfx_GF()
      filtro = rwfx_InputBox("*.*", _t(86), 
        _t(87), 
        rfx_FN())

      if filtro then
        filtro = rfx_GF()
        if (rwfx_MsgBox(_t(88),_t(89),MB_YESNO + MB_DEFBUTTON2) == IDYES) then
          conPercorso = true
        end
        nomeFile = props["SciteUserHome"].."/scitetmp.dat"
        
        --[[
          Lista... :
                  0.solo nomi file 
                  1.solo nomi cartelle
                  2.file + cartelle 
                  3.solo file (ricorsivo)
                  4.solo nomi cartelle (ricorsivo)
                  5.file + cartelle (ricorsivo)
        ]]
        
        strLst = _t(90)
        idv = rwfx_ShowList(strLst,_t(91));
        --idv=0
        
        if (idv) then
          if (idv==1) then --solo nomi cartelle
            opzioniDir = "/b /aD"
          elseif (idv==2) then --nomi file con cartelle
            opzioniDir = "/b"
          elseif (idv==3) then --nomi file senza cartelle (ricorsivo)
            opzioniDir = "/b /a-D /s"
          elseif (idv==4) then --solo nomi cartelle (ricorsivo)
            opzioniDir = "/b /aD /s"
          elseif (idv==5) then --nomi file con cartelle (ricorsivo)
            opzioniDir = "/b /s"
          else --nomi file senza cartelle
            opzioniDir = "/b /a-D"
          end
          
          if (string.len(cartella) == 3) then
            comando = 'dir '..opzioniDir..' "'..cartella..filtro..'">"'..nomeFile..'"'
          else
            comando = 'dir '..opzioniDir..' "'..cartella..'\\'..filtro..'">"'..nomeFile..'"'
          end
          os.execute(comando)
          
          if nomeFile then            
            for line in io.lines(nomeFile) do              if ((idv == 3) or --nomi file senza cartelle (ricorsivo)
                  (idv == 4) or --nomi file con cartelle (ricorsivo)
                  (idv == 5)) then --solo nomi cartelle(ricorsivo)
                if (not(conPercorso)) then
                  line = string.sub(line,string.len(cartella)+2)
                end
              else --solo file e/o cartelle
                if (conPercorso) then
                  if (string.len(cartella)==3) then
                    line = cartella..line
                  else
                    line = cartella.."\\"..line
                  end                
                end
              end
              
              editor:ReplaceSel(line.."\r\n")
            end          
            os.remove(nomeFile)
          end
        end --idv
      end --end filtro
    end --selezione cartella
  end -- endfx
  
  InsertListFiles()
end
