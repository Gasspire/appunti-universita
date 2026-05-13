MPI è uno **standard**, le implementazioni devono rispettare l'interfaccia definita dallo standard. MPI è open-source e c'è un consorzio ed è fondamentale poiché non è influenzato da un vendor che vuole ottimizzarlo per il suo hardware. Poi, naturalmente, è possibile che ognuno si crei le sue ottimizzazioni.

Proprio grazie alla sua caratteristica di essere aperto, questo è estremamente portabile.

---
## Modello di esecuzione SPMD

SPMD sta per *single program, multiple data*. L'idea è di avere tanti processi che eseguono lo stesso programma compilato e, tramite il *rank*, decidiamo quale processo deve eseguire cosa.

Il rank è un *identificativo del processo* che va da 0 a n-1 dove n è il numero totale di processi. Il processo 0 diciamo per convenzione sia il *processo root*. Banalmente, questa cosa viene gestita tramite un if.

Ogni programma MPI è una cosa del tipo:
```
Codice seriale
MPI_Init(&argc, &argv); //i parametri se non servono non mandiamo nulla

// Codice che verrà eseguito da tutti i processi

MPI_Finalize(); 
```

MPI_Init crea il runtime.
Tramite *MPI_Comm_rank* ogni processo conosce il suo rank così. Comm sta per **comunicatore**.
Ogni processo ha un suo spazio di memoria così da evitare problemi di inconsistenza.
Tramite *MPI_Comm_size* viene restituito il numero totale di processi nel comunicatore che vedremo dopo cosa è. 
*MPI_Finalize* semplicemente chiude tutte le sezioni parallele e libera le risorse. È importante che questa funzione venga eseguita da tutti poiché altrimenti non verrebbero chiusi.

Ogni processo si creerà una copia dei dati.

Il comunicatore è un oggetto MPI che racchiude un gruppo di processi e un contesto di comunicazione. È importante che si usino comunicatori diversi per processi diversi così da evitare interferenze.
*MPI_COMM_WORLD* è il comunicatore globale usato da tutti i processi MPI. 
Supponendo di avere $\{r0,r1, \dots, r7\}$, possiamo usare due comunicatori che magari possiamo etichettare come:
- MPI_Comm even_comm$\{r0,r2,r4,r6\}$
- MPI_Comm odd_comm$\{r1,r3,r5,r7\}$
Così facendo, anche messaggi con lo stesso tag non rischieranno di confondersi.

*MPI_Comm_split* permette di partizionare i processi di un comunicatore esistente in sotto gruppi. Uno è quello originale mentre quello nuovo è il secondo. Il parametro key ci dice come mettere in ordine i processi nel comunicatore. Se $key = rank$ l'ordine è quello originale, se $key = - rank$ l'ordine è inverso rispetto a quello originale.

---
## Tipi di dati
*MPI_BYTE* non fa alcun tipo di conversione. È utile per trasferire buffer grezzi.

Non abbiamo dimensione garantita perché dipende dal tipo di architettura (a 64 bit o 32 bit). Se vogliamo questa garanzia, esistono tipi specifici che sono una cosa tipo *MPI_INT32* per la versione a 32 bit o *MPI_INT64* per 64 bit.

La definizione dei dati è utile a capire il tipo per sapere quanti byte dobbiamo trasferire. Utile per la comunicazione tra sender e receiver.

Esistono anche i **tipi derivati** utili in specifici casi:
* *Contiguous* è il caso base di array.
* *Vector* utile per inviare ad esempio le colonne di una matrice.
* *Create_Struct* serve per mandare le struct c.  
* *Indexed* come vector ma ha offset diversi.
Non li useremo.

Per usarli seguiremo il seguente workflow:
1. Fase di definizione del tipo.
2. Fase di commit
3. Fase di utilizzo
4. Fase di liberazione delle risorse.

Ha senso crearli una volta e liberarli alla fine poiché queste operazioni hanno chiaramente un certo overhead.

---
## Tipi di messaggi

La comunicazione ha due componenti:
- **Envelope**: contiene source, destination, tag (intero per distinguere i tipi di messaggi. Possiamo spesso usare anche le wildcard), communicator (cioè in quale comunicatore inviare il messaggio)
- **Data buffer**: buf (puntatore all'inizio del buffer in memoria), count (numero di elementi del tipo), datatype (tipo mpi degli elementi)
---
## MPI_Send e MPI_Recv

Spiegazione parametri che sono quelli visti nei tipi di messaggi.

---
## Modalità di comunicazione

Esistono 4 modalità di send:
* *MPI_Send* è la send standard. Qui lo standard non ci dice niente, ci dice solo che il sender quando la send è conclusa può riusare il buffer liberamente. Non abbiamo un comportamento deterministico perché dobbiamo aspettare che venga fatta la receive.
* *MPI_Bsend* Il sender copia il messaggio in un buffer esterno e poi ritorna immediatamente. Questo messaggio verrà poi inviato.
* *MPI_Ssend* Il sender completa solo quando il destinatario ha ricevere i dati.
* *MPI_Rsend* Eliminiamo l'handshake e garantiamo noi che il ricevitore è pronto. Se questa garanzia non è corretta siamo cucinati. (si utilizza molto poco)x