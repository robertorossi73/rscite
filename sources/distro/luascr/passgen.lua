--[[
Version : 1.0.0
Web     : http://www.redchar.net

Generatore password casuali

Copyright (C) 2019 Roberto Rossi 
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

    function buttonOk_click(control, change)    
        
        local function getPass(lenPass, maxChr, minChr, numChr, symChr, checkChr)
            local chrs = {
                        "0",
                        "1",
                        "2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9", --10
                        
                        "a",
                        "b",
                        "c",
                        "d",
                        "e",
                        "f",
                        "g",
                        "h",
                        "i",
                        "j",
                        "k",
                        "l",
                        "m",
                        "n",
                        "o",
                        "p",
                        "q",
                        "r",
                        "s",
                        "t",
                        "u",
                        "v",
                        "w",
                        "x",
                        "y",
                        "z", --36
                        
                        "A",
                        "B",
                        "C",
                        "D",
                        "E",
                        "F",
                        "G",
                        "H",
                        "I",
                        "J",
                        "K",
                        "L",
                        "M",
                        "N",
                        "O",
                        "P",
                        "Q",
                        "R",
                        "S",
                        "T",
                        "U",
                        "V",
                        "W",
                        "X",
                        "Y",
                        "Z", --62
                        
                        "!",
                        "#",
                        "@",
                        "$" --66
                        }
            local i = 0
            local n
            local ch
            local result = ""
            local addCh = false
            
            while (i < lenPass) do
                addCh = false
                n = math.random(1,#chrs)
                ch = chrs[n]
                
                if (numChr) then
                    if (n < 11) then --è un numero
                        addCh = true
                    end
                end
                
                if (maxChr) then
                    if ((n > 36) and (n < 63)) then --è un caratteri maiuscolo
                        addCh = true
                    end
                end
                
                if (minChr) then
                    if ((n > 10) and (n < 37)) then --è un caratteri minuscolo
                        addCh = true
                    end
                end
                
                if (symChr) then
                    if (n > 62) then --è un simbolo
                        addCh = true
                    end
                end
                
                --controllo caratteri ambigui    
                if (checkChr) then
                    if (string.find("l1O0", ch, 1, true)) then
                        addCh = false
                    end
                end
                
                if (addCh) then
                    result = result..ch
                    i = i + 1
                end
                
            end
            
            return result
        end
        
        
        --local yesOption = "Si"
        local yesOption = _t(453)
        
        local lenp = wcl_strip:getValue("LPASS")
        lenp = tonumber(lenp)
        
        --caratteri ambigui
        local ambchr = wcl_strip:getValue("AMBCHR")
        if (ambchr == yesOption) then
            ambchr = true
        else
            ambchr = false
        end
        
        --numeri
        local numchr = wcl_strip:getValue("NUMCHR")
        if (numchr == yesOption) then
            numchr = true
        else
            numchr = false
        end
        
        --maiuscole
        local maxchr = wcl_strip:getValue("MAXCHR")
        if (maxchr == yesOption) then
            maxchr = true
        else
            maxchr = false
        end

        --minuscole
        local minchr = wcl_strip:getValue("MINCHR")
        if (minchr == yesOption) then
            minchr = true
        else
            minchr = false
        end

        --symboli
        local symchr = wcl_strip:getValue("SYMCHR")
        if (symchr == yesOption) then
            symchr = true
        else
            symchr = false
        end
            
        if (lenp) then
            if ((maxchr == false) and (minchr == false) and
                (numchr == false) and (symchr == false)) then
                --print("\nParametri non corretti!")
                print(_t(455))
            else
                print(getPass(lenp, maxchr, minchr, numchr, symchr, ambchr))
            end
        end
    end
    
    function buttonCancel_click(control, change)    
        wcl_strip:close()
    end
    
    local function passgen_main()
        --local yesNoTbl = {"Si", "No"}
        local yesNoTbl = {_t(453), _t(454)}
    
        -- lunghezza password
        -- caratteri maiuscoli
        -- caratteri minuscoli
        -- numeri
        -- includi simboli !%@#
        -- evita caratteri ambigui es.: l(elle)) e 1(uno) oppure O e 0(zero)
    
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        --wcl_strip:addLabel(nil, "Lunghezza Password: ")
        wcl_strip:addLabel(nil, _t(456).." ")
        wcl_strip:addText("LPASS", "8", false) --lunghezza password

        --wcl_strip:addLabel(nil, "Evita caratteri ambigui: ")
        wcl_strip:addLabel(nil, _t(457).." ")
        wcl_strip:addCombo("AMBCHR", false)
        
        --wcl_strip:addLabel(nil, "Numeri: ")
        wcl_strip:addLabel(nil, _t(458).." ")
        wcl_strip:addCombo("NUMCHR", false)
        
        --wcl_strip:addButton("OKBTN","Genera Password",buttonOk_click, true)
        wcl_strip:addButton("OKBTN",_t(459),buttonOk_click, true)

        wcl_strip:addNewLine()
        
        --wcl_strip:addLabel(nil, "Caratteri MAIUSCOLI: ")
        wcl_strip:addLabel(nil, _t(460).." ")
        wcl_strip:addCombo("MAXCHR", false)
        
        --wcl_strip:addLabel(nil, "Caratteri minuscoli: ")
        wcl_strip:addLabel(nil, _t(4461).." ")
        wcl_strip:addCombo("MINCHR", false)
        
        --wcl_strip:addLabel(nil, "Simboli: ")
        wcl_strip:addLabel(nil, _t(462).." ")
        wcl_strip:addCombo("SYMCHR", false)
        
        --wcl_strip:addButton("CANCELBTN","Chiudi",buttonCancel_click, false)
        wcl_strip:addButton("CANCELBTN",_t(200),buttonCancel_click, false)
        
        wcl_strip:show()
        
        wcl_strip:setList("AMBCHR", yesNoTbl)
            wcl_strip:setValue("AMBCHR", yesNoTbl[1])
        wcl_strip:setList("NUMCHR", yesNoTbl)
            wcl_strip:setValue("NUMCHR", yesNoTbl[1])
        wcl_strip:setList("MAXCHR", yesNoTbl)
            wcl_strip:setValue("MAXCHR", yesNoTbl[1])
        wcl_strip:setList("MINCHR", yesNoTbl)
            wcl_strip:setValue("MINCHR", yesNoTbl[1])
        wcl_strip:setList("SYMCHR", yesNoTbl)
            wcl_strip:setValue("SYMCHR", yesNoTbl[1])
    end
    
    passgen_main()
end
