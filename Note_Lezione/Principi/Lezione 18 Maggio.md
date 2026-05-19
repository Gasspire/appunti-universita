## Ordering, Fairness & progress

- **Ordering**: Se A invia M1 e M2 allo stesso processo B sullo stesso comunicator e B lancia due recv compatibili con entrambi i messaggi, questi arriveranno in ordine.
- **No Fairness**: Se più Recv sono compatibili con un messaggio, non è specificato quale verrà servita. Quello che potrebbe capitare è che un processo potrebbe monopolizzare i messaggi. Al giorno d'oggi le implementazioni cercano di gestire il tutto in maniera equa ma non è una garanzia che dervia dallo standard. 
- **Progress**: Se ci sono una send e una recv compatibili tra loro, l'implementazione è obbligata  a farle andare avanti prima o poi. Non possono essere bloccate per sempre senza un motivo.
Sono garanzie valide nelle comunicazioni *point to point*.

## MPI_STATUS e MPI_Get_count

Lo status è una struct C che viene riempita nel caso di una Recv bloccante. Questa contiene i seguenti campi:
- **MPI_SOURCE**: Ci riferisce il rank che ci ha inviato il messaggio. (Utile nel caso si usino wildcard)
- **MPI_TAG**: Ci riferisce il tag del messaggio. (Utile nel caso si usino wildcard)
- **MPI_ERROR**: Ci dice il codice dell'eventuale errore.
- **(opachi)**: Sono dei campi non accessibili in maniera diretta ma tra questi ci interessa specificamente **MPI_Get_count**  che ci restituisce il numero di elementi effettivamente trasferiti. Potrebbe servire nel caso in cui il mittente potrebbe inviare messaggi di diverso tipo e, in base al numero di dati inviati, possiamo distinguerli.

## Blocking vs Non-Blocking

Possiamo fare la classica distinzione tra comunicazione bloccante e la comunicazione non bloccante. 
- **Bloccante**: fino a quando non abbiamo la garanzia che la chiamata sia safe, il programma non va avanti.
- **Non-Bloccante**: queste fanno andare avanti il calcolo e rimangono in attesa di eventuali messaggi. Ad una certa avremo bisogno di effettuare delle Wait per sincronizzare il calcolo coon il messaggio da ricevere. Abbiamo una complessità maggiore ma il vantaggio è quello di non avere sprechi di CPU_TIME. 

## Deadlock da Send Simmetrica

Gestione scorretta di send e recv. Devono essere nel giusto ordine.

## Compilare e lanciare

## Errori comuni
- Deadlock
- Mismatch datatypes
- Buffer piccolo nella Recv (meglio buffer più grande)
- MPI_Finalize prima della fine.

## MPI_Wtime

Utile a misurare il tempo di esecuzione di una sezione di codice.

La Barrier ci può aiutare a garantire che tutti i processi siano coordinati prima della misurazione. 

MPI_Wtick restituisce la risoluzione del timer in secondi. Facciamo la misurazione un certo numero di volte così da averne una media.

## Legge di Amdhal e Gustafson
$$T(n) = \alpha + n/\beta$$
Con:
- $\alpha$ la latenza
- $\beta$ la banda di picco in byte/secondo
- n la dimensione messaggio in byte

Questo rappresenta un minimo teorico.
Conseguenza di questo modello sono:
1. **Pochi messaggi grandi battono tanti messaggi piccoli** a causa della presenza massiva della latenza.
2. **Aggregare le comunicazioni** tramite *pack* e *unpack*. (Design pattern Request Batch)
3. **La latenza domina su messaggi piccoli**.
4. **Sovrapporre calcolo e comunicazione non blocking**.





