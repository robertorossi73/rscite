--[[ # -*- coding: utf-8 -*-
Version : 1.1.0
Web     : http://www.redchar.net

Consente di rappresentare una funzione matematica in modo grafico usando
due servizi online.

Copyright (C) 2012-2015 Roberto Rossi 
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

-----------------------------------Versioni------------------------------------
1.0.1
release iniziale

]]


do
  require("luascr/rluawfx")
  
  function normalizeUrl(url)
    local result = ""

    result = string.gsub(url,"[$]","%%24")
    result = string.gsub(result,"[%%]","%%25")
    result = string.gsub(result,"[&]","%%26")
    result = string.gsub(result,"[+]","%%2B")
    result = string.gsub(result,"[,]","%%2C")
    result = string.gsub(result,"[/]","%%2F")
    result = string.gsub(result,"[:]","%%3A")
    result = string.gsub(result,"[;]","%%3B")
    result = string.gsub(result,"[=]","%%3D")
    result = string.gsub(result,"[?]","%%3F")
    result = string.gsub(result,"[@]","%%40")
    result = string.gsub(result,"[ ]","%%20")
    result = string.gsub(result,"[<]","%%3C")
    result = string.gsub(result,"[>]","%%3E")
    result = string.gsub(result,"[#]","%%23")
    result = string.gsub(result,"[{]","%%7B")
    result = string.gsub(result,"[}]","%%7D")
    result = string.gsub(result,"[|]","%%7C")
    result = string.gsub(result,"[\\]","%%5C")
    result = string.gsub(result,"[%^]","%%5E")
    result = string.gsub(result,"[~]","%%7E")
    result = string.gsub(result,"[\[]","%%5B")
    result = string.gsub(result,"[\]]","%%5D")
    result = string.gsub(result,"[`]","%%60")

    return result
  end
  
  function buttonOk_click(control, change)
    local tipo
    local url = ""
    
    tipo = wcl_strip:getValue("TVAL")
    url = normalizeUrl(wcl_strip:getValue("QVAL"))
    if (tipo == "WolframAlpha") then
      url = "http://www.wolframalpha.com/input/?i="..url
    else
      url = "https://www.google.com/search?q="..url
    end
    
    rwfx_ShellExecute(url,"")
  end
  
  local function main()
    -- funzioni di esempio
    local samples = {"sin(x^2)",
                      "x^2, x, sin(x), ln(x)",
                      "sin(x)*log(x)*(pi*2)",
                      "x/4,(x/3.2)^2,sin(pi*x+174),sin(cos(pi)*7)",
                      "x^2, (x/2)^2, ln(x), cos(pi*x/5)",                      "100-3/(sqrt(x^2+y^2))+sin(sqrt(x^2+y^2))+sqrt(200-(x^2+y^2)+10*sin(x)+10sin(y))/1000, x is from -15 to 15, y is from -15 to 15, z is from 90 to 101",
                      "exp(-((x-4)^2+(y-4)^2)^2/1000) + exp(-((x+4)^2+(y+4)^2)^2/1000) + 0.1exp(-((x+4)^2+(y+4)^2)^2)+0.1exp(-((x-4)^2+(y-4)^2)^2)"
                      }
  
    wcl_strip:init()
    wcl_strip:addButtonClose()
    
    wcl_strip:addLabel(nil, _t(268))--funzione
    wcl_strip:addCombo("QVAL")
    wcl_strip:addNewLine()
    wcl_strip:addLabel(nil, _t(269))
    wcl_strip:addCombo("TVAL")
    
    wcl_strip:addButton("OK",_t(270),buttonOk_click, true)
    
    wcl_strip:show()
    wcl_strip:setList("TVAL",{"WolframAlpha", "Google"})
    wcl_strip:setList("QVAL",samples)
    wcl_strip:setValue("TVAL", "Google")
    wcl_strip:setValue("QVAL", editor:GetSelText())
  end
  
  main()
end
