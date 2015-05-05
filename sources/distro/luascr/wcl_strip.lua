--[[
Version : 1.1.6
Web     : http://www.redchar.net

Questa libreria consente un utilizzo più flessibile e dinamico dell'interfaccia 
(GUI) standard di SciTE.

La classe qui definita, "wcl_strip", si pone come obbiettivo quello di 
semplificare l'utilizzo dell'interfaccia grafica standard i SciTE (strip)

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

Riferimento funzioni :

--resetta maschera di dialogo da usare prima di definire la finestra
function wcl_strip:init()

--aggiunge bottone
function wcl_strip:addButton(uniqueName, value, callback, isDefault)
--aggiunge bottone di chiusura (solo windows)
function wcl_strip:addButtonClose()
--aggiunge combo box
function wcl_strip:addCombo(uniqueName, callback)
--aggiunge etichetta di testo 
function wcl_strip:addLabel(uniqueName, value)
--aggiunge nuova linea
function wcl_strip:addNewLine(nlines)
--aggiunge oggetto generico
function wcl_strip:addObj(uniqueName, value, callback )
--aggiunge spazio libero
function wcl_strip:addSpace()
--aggiunge casella di testo editabile
function wcl_strip:addText(uniqueName, value, callback)

--ritorna il valore contenuto nell'oggetto identificato da uniqueName
function wcl_strip:getValue(uniqueName)
--ritorna oggetto identificato dall'id specificato
function wcl_strip:get(idx)
--ritorna l'id dell'oggetto identificato da uniqueName
function wcl_strip:getID(uniqueName)
--imposta il contenuto della lista identificata da uniqueName
function wcl_strip:setList(uniqueName, value)
--imposta il valore nell'oggetto identificato da uniqueName
function wcl_strip:setValue(uniqueName, value)

--apre finestra
function wcl_strip:show()
--chiude finestra
function wcl_strip:close()


]]

-- start Windows Classe Library -----------------------------------------------

OnStrip = nil

--Classe di gestione strip SciTE
wcl_strip = {
	objs = {}, --elenco oggetti	di interfaccia
  wcl_add_close_button = false, --tasto per chiusura dialog (solo windows)
  wcl_strip_newline = 0  --numero \n prima del prossimo controllo
}

--resetta maschera di dialogo da usare prima di definire la finestra
function wcl_strip:init()
  self.objs = {}
  self.wcl_add_close_button = false
  self.wcl_strip_newline = 0
end

--ritorna valore del controllo
function wcl_strip:getValue(uniqueName) 
  return scite.StripValue(wcl_strip:getID(uniqueName))
end

--imposta contenuto lista
function wcl_strip:setList(uniqueName, value)
  local val = ""
  local i
  local v
  
  if (type(value) == "table") then
    --uso tabella di strighe come fonte dati
    for i,v in pairs(value) do
      if (val ~= "") then
        val = val.."\n"
      end
      val = val..v
    end
  elseif (type(value) == "string") then
    --uso stringa classica
    val = value
  else
    val = nil
  end

  if (val) then
    scite.StripSetList(wcl_strip:getID(uniqueName), val)
  else
    print(debug.traceback("\nsetList requires 'value' as string or table!"))
  end
end

--aggiunge una etichetta (testo fisso)
function wcl_strip:addSpace()
  wcl_strip:addObj(nil, "''", nil)
end

--aggiunge tasto per chiusura finestra (solo windows)
function wcl_strip:addButtonClose()
  if (self.wcl_add_close_button) then
    print(debug.traceback("\naddButtonClose already called!"))
  else
    self.wcl_add_close_button = true
  end
end

--aggiunge una combo boxe
function wcl_strip:addCombo(uniqueName, callback)
  wcl_strip:addObj(uniqueName, "{}", callback)
end 

--aggiunge una casella di testo editabile
function wcl_strip:addText(uniqueName, value, callback)
  wcl_strip:addObj(uniqueName, "["..value.."]", callback)
end

--aggiunge una etichetta (testo fisso)
function wcl_strip:addLabel(uniqueName, value)
  local val
  
  if ((type(uniqueName) == "string") and not(value)) then
    val = uniqueName
  else
    val = value
  end
  wcl_strip:addObj(uniqueName, "'"..val.."'", nil)
end

--aggiunge un bottone
function wcl_strip:addButton(uniqueName, value, callback, isDefault)
  local val
  
  if (uniqueName and value and callback) then
    if (isDefault) then
      val = "(("..value.."))"
    else
      val = "("..value..")"
    end
  else
    print(debug.traceback("\naddButton require at least 'uniqueName, 'value' and callback function!"))
  end
  wcl_strip:addObj(uniqueName, val, callback )
end

--aggiunge nuove linee al prossimo controllo
function wcl_strip:addNewLine(nlines)
  if (nlines) then
    self.wcl_strip_newline = self.wcl_strip_newline + nlines
  else
    self.wcl_strip_newline = self.wcl_strip_newline + 1
  end
end

--aggiunge oggetto alla stripe
function wcl_strip:addObj(uniqueName, value, callback )
  local newlines = ""
  local i = 0
  
  if ((wcl_strip:getID(uniqueName)) and (uniqueName ~= nil)) then
    --errore
    print(debug.traceback("\nObject '"..uniqueName.."' already exist!"))
  else
    --verifica e inserisce i ritorni a capo
    while (i < self.wcl_strip_newline) do
      value = "\n"..value
      i = i + 1
    end  
    self.wcl_strip_newline = 0
    
    --aggiunge un oggetto alla stripe
    table.insert(self.objs, {value, callback, uniqueName})
  end
end

--dato il nome univoco di un elemento di interfaccia ne ritorna l'ID relativo
function wcl_strip:getID(uniqueName)
  local idx = nil
  local k
  local obj
	
  for k,obj in pairs(self.objs) do
    if (obj[3] == uniqueName) then  
      idx = k - 1
      break
    end
  end
  
  return idx
end

--dato un id ritorna l'oggetto relativo
function wcl_strip:get(idx)
  return self.objs[idx+1]
end

--imposta il valore dell'oggetto identificato da uniqueName
function wcl_strip:setValue(uniqueName, value)
  local id
  
  if (uniqueName) then
    id = wcl_strip:getID(uniqueName)    
    scite.StripSet(id, value)
  end
end

--mostra la dialog. Se showIndex=true vengono mostrate etichette per identificare i controlli
function wcl_strip:show()
	local strStrip = ""
  local k
  local obj
	
  if (self.wcl_add_close_button) then
    strStrip = "!"
  end
  
  for k,obj in pairs(self.objs) do    
    strStrip = strStrip..obj[1]
  end
  
  scite.StripShow(strStrip)
end

function wcl_strip:close() 
  scite.StripShow("")
end

--ridefinizione funziona standard globale di SciTE per gestione eventi
function OnStrip(control, change)
	local changeNames = {'unknow', 'clicked', 'change', 'focusin', 'focusout'}
	--print('OnStrip '..control..' '..changeNames[change+1])
  --print(wcl_strip:get(control)[1])
  if (wcl_strip:get(control)[2]) then
    wcl_strip:get(control)[2](control, change)
  end
end

-- end Windows Classe Library -------------------------------------------------

-- Esempio di utilizzo
--Test comando ordinamento

--[[
function buttonOk_click(control, change)
  wcl_strip:close()
end

function buttonCanc_click(control, change)
  print(wcl_strip:getValue("COSA"))
  --wcl_strip:close()
end

GUI = wcl_strip
GUI:addButtonClose()
GUI:addLabel(nil, "Cosa ordinare : ")
GUI:addCombo("COSA")

GUI:addLabel(nil, "Tipo di ordinamento : ")
GUI:addCombo("VERSO")

GUI:addButton("ESEGUI","&Esegui Ordinamento", buttonOk_click, true)

GUI:addNewLine()

GUI:addLabel(nil, "Prima Colonna per ordinamento : ")
GUI:addText("COLONNA","1")

GUI:addLabel(nil, "Ultima Colonna per ordinamento : ")
GUI:addText("COLONNA2","")

GUI:addButton("ANNULLA","&Annulla", buttonCanc_click)

GUI:show()

GUI:setList("VERSO", {"Discendente", "Ascendente"})
GUI:setValue("VERSO", "Ascendente")

GUI:setList("COSA", {"Tutto il file corrente", "La selezione corrente"})
GUI:setValue("COSA", "La selezione corrente")


function buttonCanc_click(control, change)
  --print(wcl_strip:getValue("TESTO"))
  dostring(wcl_strip:getValue("TESTO"))
  --alert("ciao")
  --wcl_strip:close()
end

function edit_event(control, change)
  print(control)
  print(change)
  --wcl_strip:close()
end

wcl_strip:addLabel(nil, "Comando : ")
wcl_strip:addText("TESTO","")

wcl_strip:addButton("OK","&Esegui", buttonCanc_click, true)

wcl_strip:show()
]]


