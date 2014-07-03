--[[
Version : 2.0.10
Web     : http://www.redchar.net

Questa procedura inserisce una stringa composta da caratteri casuali,
utili soprattutto per nomi file temporanei, password casuali, ecc...

Copyright (C) 2004-2009 Roberto Rossi 
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
  
  --rotorna una stringa composta da caratteri casuali, con queste regole :
  --tipo = 0 -> solo numero
  --tipo = 1 -> lettere + numeri
  --tipo = 2 -> valore esadecimale
  local function ComponiStringaCasuale (lunghezza, tipo )
    local valore = ""
    local i = 0
    local res =""
  
     math.randomseed(os.time())  
     while (i < (lunghezza + 1)) do
      if (tipo == 2) then
        valore = math.random(0,15)
        valore = string.format("%x", valore)
      elseif (tipo == 0) then
        valore = math.random(0,9)
      elseif (tipo == 1) then        
        valore = math.random(48,90)
        if ((valore > 57) and (valore < 65)) then
          if (valore > 60) then
            valore = math.random(65,90)
          else
            valore = math.random(48,57)
          end
        end
        valore = string.format("%c", valore)
      end
      if (i > 0) then
        res = res..valore
      end
      i = i + 1
     end --while
    return res
    end --fx
  
  local function EseguiInserimento()
    local scelta = ""
    local lung = 0
    
    -- 93=Stringa formata da soli numeri
    -- 94=Stringa formata da numeri e lettere
    -- 95=Stringa in formato esadecimale
    -- 96=Stringa Casuale
    -- 97=Lunghezza Stringa
    -- 98=Specifica il numero di caratteri che deve comporre la stringa casuale :
    local opzioni = _t(93).."|"..
                    _t(94).."|"..
                    _t(95)
    
    scelta = rwfx_ShowList(opzioni,_t(96))
    if scelta then
      lung = rwfx_InputBox("8", _t(97),_t(98),rfx_FN());
      if lung then
        lung = rfx_GF()
        lung = tonumber(lung)
        if (lung > 0) then
          linea = ComponiStringaCasuale(lung, scelta)
          editor:ReplaceSel(linea)
        end -- > 0
      end --lung
    end
  end
  
  EseguiInserimento()
end

