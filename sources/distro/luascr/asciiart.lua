--[[
Version : 1.0.1
Web : http://www.redchar.net

Consente di rappresentare un testo in forma di ascii art utilizzando il
servizio fornito dal sito http://patorjk.com

Copyright (C) 2013 Roberto Rossi
*******************************************************************************
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*******************************************************************************
]]

do
  require("luascr/rluawfx")

  function normalizeUrl(url)
    local result = ""

    result = string.gsub(url,"[$]","%%%%24")
    result = string.gsub(result,"[%%]","%%%%25")
    result = string.gsub(result,"[&]","%%%%26")
    result = string.gsub(result,"[+]","%%%%2B")
    result = string.gsub(result,"[,]","%%%%2C")
    result = string.gsub(result,"[/]","%%%%2F")
    result = string.gsub(result,"[:]","%%%%3A")
    result = string.gsub(result,"[;]","%%%%3B")
    result = string.gsub(result,"[=]","%%%%3D")
    result = string.gsub(result,"[?]","%%%%3F")
    result = string.gsub(result,"[@]","%%%%40")
    result = string.gsub(result,"[ ]","%%%%20")
    result = string.gsub(result,"[<]","%%%%3C")
    result = string.gsub(result,"[>]","%%%%3E")
    result = string.gsub(result,"[#]","%%%%23")
    result = string.gsub(result,"[{]","%%%%7B")
    result = string.gsub(result,"[}]","%%%%7D")
    result = string.gsub(result,"[|]","%%%%7C")
    result = string.gsub(result,"[\\]","%%%%5C")
    result = string.gsub(result,"[%^]","%%%%5E")
    result = string.gsub(result,"[~]","%%%%7E")
    result = string.gsub(result,"[\[]","%%%%5B")
    result = string.gsub(result,"[\]]","%%%%5D")
    result = string.gsub(result,"[`]","%%%%60")

    return result
  end

  function buttonOk_click(control, change)
    local tipo
    local url = "http://patorjk.com/software/taag/#p=display&f=Big&t=xxxxxx"
    local normalizedUrl

    tipo = wcl_strip:getValue("TVAL")
    if (tipo ~= "") then
      normalizedUrl = normalizeUrl(tipo)
      url = string.gsub(url, "xxxxxx", normalizedUrl)
      rwfx_ShellExecute(url,"")
    else
      --print("\nOccorre inserire il testo da convertire!")
      print(_t(302))
    end

    wcl_strip:close()
  end

  local function main()
    wcl_strip:init()
    wcl_strip:addButtonClose()
    wcl_strip:addLabel(nil, _t(303))--testo da convertire
    wcl_strip:addText("TVAL", editor:GetSelText(), nil)
    --wcl_strip:addButton("OK","Converti Testo in ASCII Art",buttonOk_click, true)
    wcl_strip:addButton("OK",_t(304),buttonOk_click, true)
    wcl_strip:show()
  end

  main()
end