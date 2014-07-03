------------------------- Editor Configurazioni SciTE -------------------------

Questa procedura consente la modifica, tramite maschere guidate, delle impostazioni
presenti all'interno dei file .properties di SciTE/RSciTE.

----------------------------- Modalità operative ------------------------------

Una volta indicato il file da modificare, la procedura elencherà tutte le 
proprietà (supportate) editabili.

Internamente la procedura caricherà l'intero file di configurazione andando ad
intervenire sulle parti editate.

Inizialmente verranno supportate solamente le impostazioni, a singola linea 
mentre, in un secondo tempo, anche quelle su più linee, successivamente si passerà all'editazione di tutte le impostazioni, indipendentemente dal file .properties 
editato.

L'editor interverrà esclusivamente sul file SciTEUser.properties che, essendo
relativo all'utente corrente, non interferisce con le impostazioni di default.

Nella release iniziale saranno supportate le impostazioni monolinea, inoltre
sarà abilitata l'editazione di questi tipi di dati :

Tipo 1) on/off, 1/0, come ad esempio 'split.vertical=1'
Tipo 2) valori interi, come ad esempio 'position.top=0'
Tipo 3) valori testo, come ad esempio 'find.files=xxxxx'

Quando lanciato, l'editor di configurazione proporrà un'elenco ricavato dal 
file SciTEGlobal.properties, dal quale verranno scartate le linee che terminano 
con il carattere '\' (segno dell'impostazione multilinea, e tutte le linee che
non contengono il carattere '=' (che segnala un'assegnazione). Inoltre le
linee che iniziano con '###' (tripli cancelletto) vengono usate, nell'elenco
visualizzato all'utente, come separatori di sezione a titolo informativo.

Per default l'editor supporrà che le impostazioni siano di tipo testo, mentre
esisterà un file nel quale possono essere specificati i tipi per le variabili.
In tale file potrànno anche essere specificati i messaggi da visualizzare
durante l'editazione della singola impostazione, inoltre sarà possibile indicare
un titolo esplicativo da usare nell'elenco visualizzato all'utente, per
rendere più comprensibile l'elemento.

----------------------------- Operazioni interne ------------------------------

Internamente l'editor caricherà, prima di tutto l'elenco delle impostazioni da
elencare dal file SciTEGlobal.properties inserendo il tutto in una apposita
tabella di coppie nome-valore.

TODO : continua...