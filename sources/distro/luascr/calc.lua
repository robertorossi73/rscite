--[[
Version : 2.3.0
Web     : http://www.redchar.net

Questa procedura permette di calcolare il valore di una espressione matematica.
Opzionalmente c'è la possibilità di avviare la calcolatrice di windows.

Supporta la variabile R alla quale viene assegnato il risultato dell'ultima
espressione. Cosi come la variabile PI che contiene il famoso 3.14

Copyright (C) 2004-2018 Roberto Rossi 
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
  
    --MATH_variables variabile globale per dati memorizzazione variabili
    --MATH_log_functions array con espressioni eseguite  
    local MATH_Expression = ""
    local MATH_Expression_Vars = ""

    function rfx_MPSolve()
        local parser = "\""..props["SciteDefaultHome"].."\\tools\\MathParseKit\\WinCalculator.exe\""
        local cmdStr = ""
        local batFile = rfx_FN()..".bat"
        local pos

        cmdStr = parser.." \""..rfx_FN().."\" -vs \""..MATH_Expression.."\" "..MATH_Expression_Vars
        rfx_shellAndWait(cmdStr)
        tmpVars = rfx_GF()
        return tmpVars
    end

    -- sostituisci tutte le variabili nel testo specificato
    local function math_substVariables (text)
        local result = ""
        local i
        local v
        local nameV
        local valueV
        
        result = text
        for i,v in ipairs(MATH_variables) do
            nameV = v[1]
            valueV = v[2]
            result = math_substword(result, string.lower(nameV), valueV)
            result = math_substword(result, string.upper(nameV), valueV)
        end
        return result
    end

    --sostituzione una singola parola con un nuovo testo
    local function math_substword (line, word, newtext)
        line = string.gsub(line, '%f[%a]'..word..'%f[%A]', newtext)
        return line
    end
  
    --esegue le operazioni conclusive e stampa il risultato
    local function math_result_write()
        local result
        
        result = rfx_MPSolve()
        MATH_variables["R"] = result
        MATH_log_functions = math_limit_table_push(MATH_log_functions, 50, MATH_Expression)
        
        print(MATH_Expression.." = "..result)
    end
    
    function buttonCalcW_click(control, change)
        rwfx_ShellExecute("calc.exe","")
        wcl_strip:close()
    end
  
  function buttonCalc_click(control, change)
    local tmpVars = rfx_GF()
    local vars = rfx_Split(tmpVars, "|")
    local i
    local v
    local ctrl
    local gotoNext = true
    local varName
    local varValue
      
    MATH_Expression_Vars = ""
    for i,v in ipairs(vars) do 
        if (tonumber(wcl_strip:getValue("NVAL"..tostring(i)))) then
            varValue = wcl_strip:getValue("NVAL"..tostring(i))
            varName = v
            print(varName.." = "..varValue)
            MATH_Expression_Vars =  MATH_Expression_Vars.." "..tonumber(varValue)
            MATH_variables[string.upper(varName)] = varValue
        else
            gotoNext = false
        end
    end
    if (gotoNext) then
        --print(MATH_Expression.." = "..rfx_MPSolve())
        math_result_write()
    else
            --print("Espressione matematica non valida.")
            print(_t(308))
    end
    wcl_strip:close()        
  end
  
    -- aggiunge in testa a una tabella un elemento e limita la dimensione della
    --      tabella a x (nelements) elementi
    --      vengono eliminati tutti gli elementi identici a quello aggiunti
    function math_limit_table_push(logs, nelements, value)
        local result = {}
        local i
        local v
        local idx
        
        idx = 1
        result[idx] = value
        idx = idx + 1
        for i, v in ipairs(logs) do
            if (v ~= value) then
                result[idx] = v
                if (idx > nelements) then
                    break;
                end
                idx = idx + 1
            end
        end    
        
        return result
    end
    
    local function math_exist_MATH_variables(index)
        local result = false
        local i
        local v
        local tbl = MATH_variables
         
        for i,v in pairs(tbl) do 
            if (i == string.upper(index)) then
                result = true
                break
            end
        end
        
        return result
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
        value = ""
        v = string.upper(v)
        wcl_strip:addLabel(nil, v)
        if (math_exist_MATH_variables(v) == true) then
            value = MATH_variables[v]
        end   
        wcl_strip:addText("NVAL"..tostring(i) ,value, nil)
        wcl_strip:addNewLine()
    end    
    wcl_strip:addSpace()
    --wcl_strip:addButton("OKBTN","Valuta Espressione",buttonCalc_click, true)
    wcl_strip:addButton("OKBTN",_t(305),buttonCalc_click, true)
    wcl_strip:show()
  end

    function calc_math_initialize ()
        if (MATH_variables == nil) then
            MATH_variables = {}
            MATH_variables["R"] = "0.0"
            --MATH_variables["PI"] = tostring(math.pi) --variabile gia esistente in MathParser
        end
        if (MATH_log_functions == nil) then
            MATH_log_functions = {}
        end        
    end
    
  function buttonOk_click(control, change)
    MATH_Expression = wcl_strip:getValue("TVAL")
    local vars = {}
    local tmpVars
    local parser = "\""..props["SciteDefaultHome"].."\\tools\\MathParseKit\\WinCalculator.exe\""
    local cmdStr = ""
    local batFile = rfx_FN()..".bat"
    
    cmdStr = parser.." \""..rfx_FN().."\" -v \""..MATH_Expression.."\""
    
    rfx_shellAndWait(cmdStr)
    tmpVars = rfx_GF()
    if (tmpVars ~= "") then
        vars = rfx_Split(tmpVars, "|")
        if ((#vars > 0) and
            (string.sub(tmpVars,1,5) ~= "Error")
            ) then
          wcl_strip:close()
          getVars(vars)
        else
            --print("Espressione matematica non valida.")
            print(_t(308))
        end
    else
        math_result_write()
        wcl_strip:close()
    end
  end
  
  local function main()
    
    calc_math_initialize()
  
    MATH_Expression_Vars = ""
    
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    wcl_strip:addLabel(nil, _t(306))
    wcl_strip:addCombo("TVAL")
    wcl_strip:addButton("OKBTN",_t(305),buttonOk_click, true)
    wcl_strip:addButton("CALC",_t(409),buttonCalcW_click, false)
    wcl_strip:show()
    
    wcl_strip:setList("TVAL", MATH_log_functions)
  end
  
  main()
end --fine dello script
