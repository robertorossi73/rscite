-------------------------- Gestore Linee Annotative ---------------------------

Questa procedura consente di inserire, editare ed eliminare le linee annotative all'interno del file corrente. 

Le linee annotative sono delle linee di testo visualizzate all'interno del file, ma che non sono scritte direttamente nel file che si sta editando.

L'idea alla base di questo gestore è quella di poter inserire delle annotazioni all'interno dei file, memorizzandole in posizioni indipendenti.

-------------- Cosiderazioni su dove salvare le note (ipotesi A) --------------
Le note vengono salvate in un singolo file/cartella, nel profilo utente.

L'inconveniente di questop metodo è dato dalla scomodità che nasce per spostare le note legate ad un singolo file, tra due sistemi. Per limitare il problema si potrebbero prevedere delle funzioni di importazione/esportazione delle note per poterle trasferire tra pc diversi, inoltre di fondamentale importanza sarebbe una procedura che permette di impostare la cartella nella quale dovrà essere salvato l'archivio.

Per rendere più rapida l'individuazione e il raggiungimento dei dati da parte del programma, sarà prevista una cartella per memorizzare le note, nella quale verranno creati n file per le note vere e proprie, piu un file indice che conterrà l'elenco dei file a cui sono associati dei dati.

La cartella, residente nella directory utente si chiamarà "annotations". Qui sarà presente il file _index.dat, che conterrà l'elenco dei file dotati di note, con il nome del file contenente le stesse, ad esempio :

c:\file1.txt
9iiuw4nf.dat
c:\folderA\folderB\file2.txt
x57oil2e.dat
c:\folderX\file3.txt
txcx1not.dat

A righe alterne sono presenti, nome file originale, nome file note (associato al precedente), nome file originale, nome file note (associato al precedente), nome file originale, nome file note (associato al precedente), ecc...

I nomi dei file utilizzati per contenere i dati saranno casuali e memorizzati nella stessa cartella di _index.dat (nota il carattere _ usato come prefisso consente di avere l'indice come primo elemento della cartella quando questa viene visualizzata nei gestori file)

-------------- Cosiderazioni su dove salvare le note (ipotesi B) --------------
Le note vengono salvate nella stessa cartella dei files originali.

Questo metodo prevede la creazione di file paralleli a quelli originali, nei quali verranno salvate le note in questo formato:

[numero linea]|[nota]

i file avranno lo stesso nome del file al quale si riferiscono, con estensione .note. Ad esempio, inserendo note nel file "test.txt" verrà generato "test.txt.note".

I file .note verranno salvati in una sottocartella ".rscite" creata nella cartella dove risiedono i file originali, questo per ridurre la confusione, rendendo separati i file di RSciTE.

-------------------------- Libreria LUA di gestione ---------------------------

Per la gestione delle annotazioni saranno necessarie alcune funzioni/classi. Ecco un riassunto :

- funzione che consente di determinare se un file sono associate delle note (esiste il file .dat)
- funzione che salva le note presenti nel file corrente
- funzione che carica le note per il file corrente