--[[
Version : 2.0.2
Web     : http://www.redchar.net

Questa procedura copia il nome del file corrente con percorso
nella clipboard

Modifiche
V.2.0.2
- Supporto lingua inglese
V.2
- Nuova Licenza
V.1.0.1
- corretto troncamento ultimo carattere

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
  editor:CopyText(props["FilePath"].." ");
end
