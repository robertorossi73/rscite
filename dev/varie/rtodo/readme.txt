-------------------------- Simple Robert's TODO List --------------------------

Questa procedura consente di trattare, ed interpretare, il file come fosse l'elenco delle cose da fare, cio� la classica "TODO List".

La lista sar� strutturata in sezioni, ognuna delle quali conterr� n. elementi, uno per ogni attivit�.

Ogni attivit� consentir� di specificare la priorit� (da 0 a 9) e lo stato di avanzamento (da 0 a 9), inoltre saranno previste le date di inserimento dell'attivit� e di completamento

Questo sistema, teoricamente, permetter� anche di stilare una lista di cose fatte, realizzando un software in grado di trasformare una todo list in una sorta di log dei cambiamenti e delle attivit�.

La procedura consentir� queste operazioni :

- elenco sezioni
- elenco attivit� presenti in una sezione, sia in ordine naturale (come scritto nel file), sia ordinate per priorit�, oppure ordinate per data
- elenco di tutte le attivit�, sia in ordine naturale (come scritto nel file), sia ordinate per priorit�, oppure ordinate per data
- cambio priorit� di un'attivit�
- cambio stato di un'attivit�
- aggiunta/inserimento di una attivit� di primo o secondo livello ad una sezione, con priorit�, stato e data di inserimento.
- posizionamento cursore su un'attivit� selezionata da una lista

------------------------- Sintassi del file TODO List -------------------------

Prendendo spunto dalla sintassi di un file INI, il file di tipo todo prevede queste regole :

1) Ogni sezione � identificata da una linea racchiusa tra parentesi quadre.
2) Ogni elemento di una sezione � inserito su una singola linea, la quale inizia con un valore o pi� valori, che ne identifica le caratteristiche,un segno di pipe+uguale (|=), usato come separatore, ed infine il testo. In aggiunta sono previsti gli elementi di secondo livello (sottoelementi), che si distinguono da quelli principali per un segno di pipi+uguale+uguale(|==).
3) Per ogni elemento di sezione, nella parte sinistra del simbolo di pipe+uguale (|=), saranno presenti le sue propriet�.

---------------------------------- Il Futuro ----------------------------------

Dopo una prima release le caratteristiche necessarie in seguito potrebbero essere :

- supporto per gli elementi/attivit� multilinea
- generazione lista delle cose fatte
