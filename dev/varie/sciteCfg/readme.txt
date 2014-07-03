---------------------------- Configuratore RSciTE -----------------------------

----------------------------- Specifiche di base ------------------------------

Questo software consente la modifica dei file di configurazione di 
SciTE, utilizzando una più comoda interfaccia grafica.

Inizialmente il software consentirà l'editazione dei soli file principali,
SciTEGlobal.properties e SciTEUser.properties, limitandosi ai valori non 
multilinea e predefiniti (l'utente non potrà aggiungere impostazioni non
previste). Inoltre, verranno gestite le linee commentate, e verrà data
la possibilità di abilitare/disabilitare un elemento, proprio usando il commento.
Esisterà un file di configurazione che conterrà l'elenco delle configurazioni
supportate. In questo file sarà possibile inserire commenti, ogni linea 
con primo carattere # verrà considerata commento.

In un secondo tempo verra implementata la gestione dei valori personalizzati
e liberi, ma sempre monolinea, inoltre saranno supportati gli elementi che
specificano tipi di file (*|*.php|*.c *.cpp *.cxx *.h).

Come terzo passaggio verranno supportati i valori multilinea.

Il quarto step consisterà nella possibilità di editare altri file, oltre ai
due citati precedenemente.

Dopo di che, chi più ne ha più ne metta...


------------------------------ Opzioni semplici -------------------------------

Le opzioni semplici sono quelle cosi composte :

[nome univoco]=[valore]

Il valore può essere di 3 tipi :

1) valore intero scelto da un range (1,2,3.....)
2) valore stringa generico (può contenere variabili precedute da $)
3) valore esadecimale preceduto da # (colore) (può contenere variabili precedute da $)
4) valore booleano si / no (1 / 0)

Queste tipologie di valori saranno utilizzabili sin dalla prima versione del
configuratore.

Opzioni semplici da includere -------------------------------------------------

Nella prima release del configuratore saranno supportati i parametri
semplici specificati nel file predefProps.cfg.


------------------------ Interfaccia di configurazione ------------------------

L'interfaccia utilizzerà le Strips. All'avvio del configuratore compariranno 
una serie di pulsanti che divideranno le configurazioni in sezioni. Ogni
sezione corrisponderà ad un determinato pannello nel quale l'utente potrà
effettuare le sua scelte.

Le sezioni teoricamente da implementare:

# Window sizes and visibility
# Sizes and visibility in edit pane
# Element styles
# Checking
# Indentation
# Wrapping of long lines
# Behaviour
# RSciTE

per i valori impostabili vedere "sciteg-predef.properties"