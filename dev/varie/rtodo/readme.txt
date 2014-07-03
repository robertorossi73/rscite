-------------------------- Simple Robert's TODO List --------------------------

Questa procedura consente di trattare, ed interpretare, il file come fosse l'elenco delle cose da fare, cioè la classica "TODO List".

La lista sarà strutturata in sezioni, ognuna delle quali conterrà n. elementi, uno per ogni attività.

Ogni attività consentirà di specificare la priorità (da 0 a 9) e lo stato di avanzamento (da 0 a 9), inoltre saranno previste le date di inserimento dell'attività e di completamento

Questo sistema, teoricamente, permetterà anche di stilare una lista di cose fatte, realizzando un software in grado di trasformare una todo list in una sorta di log dei cambiamenti e delle attività.

La procedura consentirà queste operazioni :

- elenco sezioni
- elenco attività presenti in una sezione, sia in ordine naturale (come scritto nel file), sia ordinate per priorità, oppure ordinate per data
- elenco di tutte le attività, sia in ordine naturale (come scritto nel file), sia ordinate per priorità, oppure ordinate per data
- cambio priorità di un'attività
- cambio stato di un'attività
- aggiunta/inserimento di una attività di primo o secondo livello ad una sezione, con priorità, stato e data di inserimento.
- posizionamento cursore su un'attività selezionata da una lista

------------------------- Sintassi del file TODO List -------------------------

Prendendo spunto dalla sintassi di un file INI, il file di tipo todo prevede queste regole :

1) Ogni sezione è identificata da una linea racchiusa tra parentesi quadre.
2) Ogni elemento di una sezione è inserito su una singola linea, la quale inizia con un valore o più valori, che ne identifica le caratteristiche,un segno di pipe+uguale (|=), usato come separatore, ed infine il testo. In aggiunta sono previsti gli elementi di secondo livello (sottoelementi), che si distinguono da quelli principali per un segno di pipi+uguale+uguale(|==).
3) Per ogni elemento di sezione, nella parte sinistra del simbolo di pipe+uguale (|=), saranno presenti le sue proprietà.

---------------------------------- Il Futuro ----------------------------------

Dopo una prima release le caratteristiche necessarie in seguito potrebbero essere :

- supporto per gli elementi/attività multilinea
- generazione lista delle cose fatte
