--[[
Version : 1.0.0
Web     : http://www.redchar.net

Questa procedura accorcia un percorso

Copyright (C) 2020 Roberto Rossi 
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
        --result = string.gsub(result,"[\[]","%%%%5B")
        --result = string.gsub(result,"[\]]","%%%%5D")
        result = string.gsub(result,"[`]","%%%%60")
        return result
    end  
  
    function shortUrl(value)
        local tipo
        local url = "https://tinyurl.com/create.php?source=create&url=xxxxxx"
        --local url2 = "https://tinyurl.com/create.php?source=create&url=http%3A%2F%2Fwww.ciao.com&alias=ciaone1000"
        local normalizedUrl

        tipo = value
        if (tipo ~= "") then
          normalizedUrl = normalizeUrl(tipo)
          url = string.gsub(url, "xxxxxx", normalizedUrl)
          rwfx_ShellExecute(url,"")
        end
    end
  
  local function main ()
    local testo
    local result = ""
    local i=1
    local len
    local lettera
    
    testo = rfx_Trim(editor:GetSelText())
    len = string.len(testo)
    
    if (len > 4) then
        shortUrl(testo)
    else
        --293=\nIndirizzo NON valido!
        print(_t(293))
    end
    
  end 
  main()
end


