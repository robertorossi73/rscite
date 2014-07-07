--[[
Version : 3.0.2
Web     : http://www.redchar.net

Questa procedura inserisce una stringa composta da caratteri casuali,
utili soprattutto per nomi file temporanei, password casuali, ecc...

Copyright (C) 2004-2013 Roberto Rossi 
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
  
     --math.randomseed(os.time())
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
  
  function buttonOk_click(control, change)
    local eol_tbl = {[0]="\r\n", [1]="\r", [2]="\n"}
    local eol = eol_tbl[editor.EOLMode]
    
    local tval = wcl_strip:getValue("TVAL")
    local dval = tonumber(wcl_strip:getValue("DVAL"))
    local nval = tonumber(wcl_strip:getValue("NVAL"))
    local i = 0
    local scelta
    
    if (tval == _t(93)) then
      scelta = 0 --solo numeri
    elseif (tval == _t(94)) then
      scelta = 1 --numeri e lettere
    else
      scelta = 2 --esadecimale
    end

    math.randomseed(os.time())
    while (i < nval) do
      linea = ComponiStringaCasuale(dval, scelta)
      if (nval > 1) then
        linea = linea..eol
      end

      editor:ReplaceSel(linea)
      i = i + 1
    end
  end

  local function main()
      wcl_strip:init()
      wcl_strip:addButtonClose()
      
      --wcl_strip:addLabel(nil, "Tipo Valori casuali : ")
      wcl_strip:addLabel(nil, _t(96))
      wcl_strip:addCombo("TVAL")
      --wcl_strip:addLabel(nil, "Numero caratteri per valori casuali : ")
      wcl_strip:addLabel(nil, _t(97))
      wcl_strip:addText("DVAL", "8")
      --wcl_strip:addLabel(nil, "Numero Valori da inserire : ")
      wcl_strip:addLabel(nil, _t(98))
      wcl_strip:addText("NVAL", "1")
      --wcl_strip:addButton("OK","&Inserisci",buttonOk_click, true)
      wcl_strip:addButton("OK",_t(251),buttonOk_click, true)
      
      wcl_strip:show()
      wcl_strip:setList("TVAL",{_t(93), _t(94), _t(95)})
      wcl_strip:setValue("TVAL", _t(93))
  end
  
  main()
end

