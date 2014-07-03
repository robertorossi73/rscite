--[[Esempio Script LUA per RSciTE

Le Estensioni di RSciTE sono un metodo semplice e veloce per consentire 
la creazione di nuove funzioni da utilizzare all'interno dell'editor.

Per creare una nuova Estensione � necessario seguire alcune, semplici regole :

1) Le Estensioni devono risiedere nella cartella "\RScite\Extensions\"
    presente all'interno della directory utente, nella sottocartella relativa
    ai dati delle applicazioni
    (es.: "C:\user\roberto\Dati applicazioni\RScite\Extensions\")
2) Le Estensioni devono chiamarsi "scriptX.lua", dove X � un numero intero
    tra 1 e 50.
3) Il titolo di ogni script, che comparir� nella finestra di F12, viene ricavato
    dalla prima linea del file oppure, nel caso in cui questa sia vuota, 
    dalla seconda linea (come succede in questo esempio).
4) All'interno di una Estensione � possibile utilizzare qualsiasi istruzione
    LUA supportata da SciTE/RSciTE, comprese le funzioni speciali della 
    distribuzione.

]]

do --inizio script. Utile per isolare le variabili presenti nello script
   --dal resto dell'ambiente LUA e dalle funzioni di RSciTE

  --carica le funzioni speciali di RSciTE
  require("luascr/rluawfx")
  
  --visualizza un messaggio di prova, utilizzando una funzione speciale di RSciTE
  rwfx_MsgBox("Sample Script","Sample Message",MB_OK)
 
end --fine dello script
