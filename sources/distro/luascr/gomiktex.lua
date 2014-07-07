--[[
Version : 2.0.1
Web     : http://www.redchar.net

Questa procedura apre il file corrente all'interno di TexWorks, presente in
MikTeX.

Copyright (C) 2012-2013 Roberto Rossi 
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

V.2.0.0
- supporto per TexLive

V.1.0.0
- Supportata V.2.9 di MikTeX

]]

do
  require("luascr/rluawfx")

  local function main()
    local exeTwork = rfx_findFileInPath("miktex-texworks.exe") --miktex
    
    if (not(exeTwork)) then
      exeTwork = rfx_findFileInPath("texworks.exe") --TexLive
    end
    
    if (exeTwork) then
      rwfx_ShellExecute(exeTwork,"\""..props["FilePath"].."\"");
    else
      print("\nLatex is missing. Install MikTex or TextLive and retry!!")
    end
  end

  main()
end

