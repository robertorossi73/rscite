--[[
Questo file contiene nuove funzioni da aggiungere al framework 

TODO : da terminare
]]

do
  require("luascr/rluawfx")
  
  --Questa funzione converte la tabella passata come parametro, in una stringa
  --nella quale ogni elemento è separato dagli altri attraverso un separatore
  local function rfx_TableToString(tabellaDati, separatore)
    local i
    local v
    local lista = false
    
    for i,v in pairs(tabellaDati) do
      if (lista) then
        lista = lista.."|"..v
      else
        lista = v
      end
    end
    
    if not(lista) then
      return ""
    else
      return lista
    end
  end
  
  --Questa funzione presenta una lista di elementi editabili, al termine
  --ritorna la tabellaDati modificata
  --tabellaDati, in input, è una tabella contenente la lista 
  --degli elementi + i loro valori, in questo modo :
  --  tabellaDati[1]="elemento1=a"
  --  tabellaDati[2]="elemento2=b"
  --  tabellaDati[...]=...
  --TODO : è necessario cambiare il nome ai pulsanti, parametrizzando la
  --       funzione presente nella dll
  local function rwfx_ShowEditList (tabellaDati, titolo)
    local a = true
    local b 
    local lista = false
    local elemento
    local valore
    local dati={}
    
    lista = rfx_TableToString(tabellaDati, "|")
    
    while a do
      a=rwfx_ShowList_presel(lista,"titolo","test",false)
      if (a) then
        dati=rfx_Split(tabellaDati[a+1],"=")
        b = rwfx_InputBox(dati[2], "Modifica Valori",
                          "Specificare il nuovo valore per\r\n"..dati[1],rfx_FN());
        if b then
          b = rfx_GF()
          tabellaDati[a+1]=dati[1].."="..b
          lista = rfx_TableToString(tabellaDati, "|")
          --print(b)
        end
      end
    end
    return tabellaDati
  end
  
  local tmp = {}
  tmp[1]="elemento1=ciao"
  tmp[2]="elemento2=miao"
  tmp[3]="elemento3=bao"
  tmp = rwfx_ShowEditList(tmp,"ciao")
  for i,v in pairs(tmp) do
    print(v)
  end
 end
 