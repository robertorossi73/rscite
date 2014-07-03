--[[
Author  : Roberto Rossi
Version : 1.0.4
Web     : http://www.redchar.net

Questa procedura consente la generazione e l'inserimento di un certo numero
di GUID all'interno del file corrente

Modelli generati :
1)
    // {87AF24BD-C9F9-4c69-B913-798429857EED}
    DEFINE_GUID(<<name>>, 
    0x87af24bd, 0xc9f9, 0x4c69, 0xb9, 0x13, 0x79, 0x84, 0x29, 0x85, 0x7e, 0xed);
2)
    // {87AF24BD-C9F9-4c69-B913-798429857EED}
    IMPLEMENT_OLECREATE(<<class>>, <<external_name>>, 
    0x87af24bd, 0xc9f9, 0x4c69, 0xb9, 0x13, 0x79, 0x84, 0x29, 0x85, 0x7e, 0xed);

3)
    // {87AF24BD-C9F9-4c69-B913-798429857EED}
    static const GUID <<name>> = 
    { 0x87af24bd, 0xc9f9, 0x4c69, { 0xb9, 0x13, 0x79, 0x84, 0x29, 0x85, 0x7e, 0xed } };

4)
    {87AF24BD-C9F9-4c69-B913-798429857EED}
    
]]


do
  require("luascr/rluawfx")
  
  --ritorna una delle sezioni che compongono la guid, in questo modo :
  -- parte 1 = primi 8 caratteri
  -- parte 2..3 = successivi 4 caratteri
  -- parte 4..11 = successivi 2 caratteri 
  -- esempio guid in ingresso = "{921C080F-0900-4AD1-ACCC-33F46C24EA23}"
  local function getPartGUID(guid, parte)
    local result = ""
    
    if (parte == 1) then
      result = string.sub(guid, 2, 9)
    elseif (parte==2) then
      result = string.sub(guid, 11, 14)
    elseif (parte==3) then
      result = string.sub(guid, 16, 19)
    elseif (parte==4) then
      result = string.sub(guid, 21, 22)
    elseif (parte==5) then
      result = string.sub(guid, 23, 24)
    elseif (parte==6) then
      result = string.sub(guid, 26, 27)
    elseif (parte==7) then
      result = string.sub(guid, 28, 29)
    elseif (parte==8) then
      result = string.sub(guid, 30, 31)
    elseif (parte==9) then
      result = string.sub(guid, 32, 33)
    elseif (parte==10) then
      result = string.sub(guid, 34, 35)
    elseif (parte==11) then
      result = string.sub(guid, 36, 37)
    end
    
    return "0x"..result
  end
  
  local function getDefineGUID(guid)
    --DEFINE_GUID(<<name>>, 0x87af24bd, 0xc9f9, 0x4c69, 0xb9, 0x13, 0x79, 0x84, 0x29, 0x85, 0x7e, 0xed);
    local result = "DEFINE_GUID(name, "
    result = result..getPartGUID(guid, 1)..", "
    result = result..getPartGUID(guid, 2)..", "
    result = result..getPartGUID(guid, 3)..", "
    result = result..getPartGUID(guid, 4)..", "
    result = result..getPartGUID(guid, 5)..", "
    result = result..getPartGUID(guid, 6)..", "
    result = result..getPartGUID(guid, 7)..", "
    result = result..getPartGUID(guid, 8)..", "
    result = result..getPartGUID(guid, 9)..", "
    result = result..getPartGUID(guid, 10)..", "
    result = result..getPartGUID(guid, 11)..");"
    
    return result
  end
  
  local function getOleGUID(guid)
    --IMPLEMENT_OLECREATE(<<class>>, <<external_name>>, 
    --0x87af24bd, 0xc9f9, 0x4c69, 0xb9, 0x13, 0x79, 0x84, 0x29, 0x85, 0x7e, 0xed);
    local result = "IMPLEMENT_OLECREATE(class, external_name, "
    result = result..getPartGUID(guid, 1)..", "
    result = result..getPartGUID(guid, 2)..", "
    result = result..getPartGUID(guid, 3)..", "
    result = result..getPartGUID(guid, 4)..", "
    result = result..getPartGUID(guid, 5)..", "
    result = result..getPartGUID(guid, 6)..", "
    result = result..getPartGUID(guid, 7)..", "
    result = result..getPartGUID(guid, 8)..", "
    result = result..getPartGUID(guid, 9)..", "
    result = result..getPartGUID(guid, 10)..", "
    result = result..getPartGUID(guid, 11)..");"
    
    return result
  end
  
  local function getConstGUID(guid)
    --static const GUID <<name>> = 
    --{ 0x87af24bd, 0xc9f9, 0x4c69, { 0xb9, 0x13, 0x79, 0x84, 0x29, 0x85, 0x7e, 0xed } };
    local result = "static const GUID name = { "
    result = result..getPartGUID(guid, 1)..", "
    result = result..getPartGUID(guid, 2)..", "
    result = result..getPartGUID(guid, 3)..", { "
    result = result..getPartGUID(guid, 4)..", "
    result = result..getPartGUID(guid, 5)..", "
    result = result..getPartGUID(guid, 6)..", "
    result = result..getPartGUID(guid, 7)..", "
    result = result..getPartGUID(guid, 8)..", "
    result = result..getPartGUID(guid, 9)..", "
    result = result..getPartGUID(guid, 10)..", "
    result = result..getPartGUID(guid, 11).." } };"
    
    return result
  end  
  
  local function formatGUIDs(guid)
    local result = ""
    local scelta
    local standardGUID = guid
    local defineGUID = getDefineGUID(guid)
    local oleGUID = getOleGUID(guid)
    local constGUID = getConstGUID(guid)

    local opzioni = standardGUID.."|"..
                    defineGUID.."|"..
                    oleGUID.."|"..
                    constGUID
    
    scelta = rwfx_ShowList(opzioni,_t(165))
    if scelta then
        if (scelta == 0) then --standard
          result = guid
        elseif (scelta == 1) then
          result = defineGUID
        elseif (scelta == 2) then
          result = oleGUID
        elseif (scelta == 3) then
          result = constGUID
        end
    end
    
    return result
  end
  
  local function InsertGUIDs ()
    local nguid
    local opzioni
    local testo
    local dest
    
    dest = rfx_FN()
    
    if (rfx_GetGUID(dest)) then
      testo = rfx_GF()
      testo = formatGUIDs(string.lower(testo))
      if (testo ~= "") then
        editor:ReplaceSel(testo)
      end
    end
   
  end -- endfx
  
  InsertGUIDs()
  
end

