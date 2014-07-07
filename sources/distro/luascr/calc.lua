--[[
Version : 1.0.4
Web     : http://www.redchar.net

Questa procedura permette di calcolare il valore di una espressione matematica

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
  --carica le funzioni speciali di RSciTE
  require("luascr/rluawfx")
  
  if (not(rfx_MPParseFunction)) then
    rfx_MPParseFunction = package.loadlib(rwfx_NomeDLL,"c_MP_ParseFunction")
    rfx_MPSolve = package.loadlib(rwfx_NomeDLL,"c_MP_Solve")
    rfx_MPSetVariable = package.loadlib(rwfx_NomeDLL,"c_MP_SetVariable")
  end

  local MATH_Expression = ""

  function buttonCalc_click(control, change)
    local tmpVars = rfx_GF()
    local vars = rfx_Split(tmpVars, ",")
    local i
    local v
    local ctrl
    
    for i,v in ipairs(vars) do 
      rfx_MPSetVariable(v, tonumber(wcl_strip:getValue("NVAL"..tostring(i))))
    end
    
    print(MATH_Expression.." = "..rfx_MPSolve())
  end
  
  local function getVars(vars)
    local i
    local v
    
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    wcl_strip:addSpace()
    wcl_strip:addLabel(nil, MATH_Expression)
    wcl_strip:addNewLine()
    
    for i,v in ipairs(vars) do 
        wcl_strip:addLabel(nil, v)
        wcl_strip:addText("NVAL"..tostring(i) ,"", nil)
        wcl_strip:addNewLine()
    end    
    wcl_strip:addSpace()
    --wcl_strip:addButton("OKBTN","Valuta Espressione",buttonCalc_click, true)
    wcl_strip:addButton("OKBTN",_t(305),buttonCalc_click, true)
    wcl_strip:show()
  end
  
  function buttonOk_click(control, change)
    MATH_Expression = wcl_strip:getValue("TVAL")
    local vars = {}
    local tmpVars
    
    if(rfx_MPParseFunction(MATH_Expression, rfx_FN())) then
      tmpVars = rfx_GF()
      if (tmpVars ~= "") then
        vars = rfx_Split(tmpVars, ",")
        if (table.maxn(vars) > 0) then
          wcl_strip:close()
          getVars(vars)
        end
      else
        print(MATH_Expression.." = "..rfx_MPSolve())
      end
    else
      --print("Espressione matematica non valida.")
      print(_t(308))
    end
  end
  
  local function main()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    wcl_strip:addLabel(nil, _t(306))
    wcl_strip:addText("TVAL",editor:GetSelText(), nil)
    wcl_strip:addButton("OKBTN",_t(305),buttonOk_click, true)
    wcl_strip:show()
  end
  
  main()
end --fine dello script
