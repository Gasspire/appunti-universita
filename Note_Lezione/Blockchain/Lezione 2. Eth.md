
**Nonce** negli account rappresenta, in un certo senso il numero di transazioni che ha fatto un certo account. Grazie a questo, poiché ad ogni nuova transazione l'utente inserisce la propria nonce, quello che accade è che vengono prevenuti attacchi di replay poiché un vecchio pacchetto valido non lo è più valido proprio a causa della nonce diversa. 

In Bitcoin abbiamo gli uTXO che fungono da sorta di nonce.

Le nonce le possiedono anche gli account a contratto ma li useranno per contare il numero di contratti creati da un certo contratto.

Per quanto riguarda gli **indirizzi**, nel caso di un regular account, abbiamo che questo è banalmente l'hash della public key. Invece, quello di un contratto è formato dall'hash dell'indirizzo del creator concatenato alla sua nonce.

Il codice dei contratti è salvato nella block chain e i contract account possiedono il **code hash** che rappresenta un identificativo che serve come chiave per accedere facilmente al codice.

I contratti possiedono anche un campo che si chiama **storage root** che è la root del *merkle patricia trie*. La root di questo tipo di alberi è particolare.

La memoria del contratto cambierà sempre e, dunque, la storage root cambierà a sua volta.

---
## Merkle Patricia Trie

Ogni foglia di questo albero contiene dei dati e, come sempre, ogni livello superiore alle foglie è composto dall'hash delle due foglie in maniera ricorsiva esattamente con il classico merkle tree. La root rappresenta un **commitment**.

I patricia trie o radix tree sono una mappa *key $\to$ value* e qui voglio cercare una key e ottenere un valore. Inseriamo i valori nelle foglie e la ricerca viene effettuata attraverso la chiave di ricerca. Se arrivo ad un vicolo cieco il valore non è presente.
![[Pasted image 20260512112938.png|449]]

I merkle patricia trie sono una combinazione della costruzione di merkle con i patricia tree. Questa sarà una **struttura dinamica** in cui la root sarà un nodo che rappresenterà in qualche modo tutti gli altri dati e sarà possibile effettuare un **proof of membership**. Nei Merkle Patricia Tree non abbiamo solo due figli ma possiamo averne di più.

Questa struttura dovrà anche essere efficiente da aggiornare. Se inserisco un nuovo valore, sarà necessario fare solamente un certo numero di aggiornamenti di nodi tendenzialmente legato alla profondità dell'aggiornamento.

---
## World State
È una rappresentazione degli stati di tutti gli account del mondo. Questo è un Merkle Patricia Trie di tutti gli stati di tutti gli account. Questo è un database banalmente in cui la chiave per la ricerca è proprio l'indirizzo dell'account (sia esso un contratto o un EOA).

Io posso chiedere a qualcuno di provare la sua presenza tramite la PoM.

Ogni nodo contiene il World State tramite il Root Node. 

Per ogni contratto abbiamo lo storage root che è un altro albero che possiede ogni contratto. Vengono mappati valori di 256 bit in hash di 256 bit. Se io ho delle variabili A, B e un'array, posso identificare i nomi delle variabili (in questo caso A e B) e queste saranno le chiavi di ricerca e il value viene dato ricercando in questo albero.

Se cerco qualcosa nell'account storage che non c'è, viene dato come valore di ritorno 0. Questo ci aiuta nel definire dati li pongo uguali a 0.

Ogni nodo nella rete ha una copia di questo storage.

--- 
## Transazioni

Nelle transazioni standard fatte da un EOA, abbiamo il classico sistema di firma fatto mediante ECDSA in una *recoverable variant* che ci permette di capire chi è il mandante. Questi trasferiscono un numero intero di **wei** verso:
- **Un altro EOA** e questo viene chiamata *currency transfer*
- **Ad un contratto** e viene chiamata *contract activation* con possibilmente alcuni dati da inviare per attivarlo. La richiesta è quindi una cosa del tipo voglio attivare la funzione x sul contratto c. Queste informazioni riguardo alle funzioni sono contenute in data.
- **Nessuno** e si usa per la creazione di un nuovo contratto. L'utente fornirà il codice del contratto, abbiamo già visto come viene creato l'indirizzo. Nella realtà il campo init contiene del codice e ci si aspetta che questo, una volta eseguito, genererà un altro codice che sarà il reale codice del contratto. Creare un contratto ha un costo e verrà gestito tramite il meccanismo del gas.
Inoltre la transazione ha il campo **nonce** che abbiamo discusso prima e il **gas** che vedremo dopo.
Le transazioni possono avere un numero di $wei \geq 0$. 

In pratica, passiamo da uno stato A, a uno stato B tramite una transazione.

IMMAGINE SIMPLE TRANSACTION

---
## Message

I messaggi sono quelli generati dai contratti. Questi non necessitano firme e sono una **conseguenza della transazione originale**.
Possiamo gestire tre casi:
1. Ad un **altro account**: sto mandando soldi a qualcuno in termini di WEI.
2. Ad un **altro contratto**: attivo un altro contratto.
3. Nulla: un contratto crea un altro contratto.
---
## Block Building 
Anziché avere i miner, abbiamo i validatori. Questi collezionano transazioni e una volta scelto il set di transazioni per il prossimo blocco (vedremo dopo come viene scelto), si eseguono le transazioni e **tutti i validatori devono concordare sul prossimo world state**, se tutti sono d'accordo, questo sarà il nuovo stato. Proprio per questo motivo **il codice deve essere deterministico**.