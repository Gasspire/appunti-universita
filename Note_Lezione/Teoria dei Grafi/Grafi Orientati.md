#flashcards/capitolo9

Definizione di ciclo e spazio dei cicli
?
In un grafo $G$, un ciclo è un cammino chiuso in cui tutti i vertici (tranne eventualmente il primo e l'ultimo) e tutti gli spigoli sono distinti. Lo spazio dei cicli è lo spazio vettoriale (solitamente su $\mathbb{Z}_2$) generato dall'insieme di tutti i cicli del grafo. La sua dimensione è data dal numero ciclomatico $\nu(G) = m - n + p$, dove $m$ è il numero di spigoli, $n$ il numero di vertici e $p$ il numero di componenti connesse.

Definizione di cociclo (o taglio) e spazio dei cocicli
?
Un cociclo (o taglio) di un grafo $G=(V,E)$ è l'insieme di tutti gli spigoli che hanno un estremo in un sottoinsieme di vertici $S \subset V$ e l'altro in $V \setminus S$, la cui rimozione disconnette il grafo (o ne aumenta il numero di componenti connesse). Lo spazio dei cocicli è lo spazio vettoriale generato da tutti i tagli del grafo, la cui dimensione è pari al rango del grafo $\rho(G) = n - p$.

Metodologia per il calcolo dei cicli fondamentali (base dello spazio dei cicli)
?
Per calcolare una base dello spazio dei cicli di un grafo connesso $G$:
1. Si individua un albero di copertura (spanning tree) $T$ del grafo.
2. Si considerano le corde (o cotree), ovvero gli spigoli di $G$ che non appartengono a $T$. In un grafo connesso queste sono esattamente $m - n + 1$.
3. L'inserimento di ogni singola corda in $T$ chiude un unico ciclo, detto **ciclo fondamentale**. L'insieme dei cicli fondamentali così ottenuti costituisce una base vettoriale per lo spazio dei cicli.

Metodologia per il calcolo dei cocicli fondamentali (base dello spazio dei cocicli)
?
Per calcolare una base dello spazio dei cocicli di un grafo connesso $G$:
1. Si fissa un albero di copertura $T$. Gli spigoli di $T$ (rami) sono $n - 1$.
2. La rimozione di un qualsiasi ramo da $T$ divide l'albero in due componenti connesse.
3. Il **cociclo fondamentale** associato a quel ramo è formato dal ramo stesso e da tutte le corde (spigoli non in $T$) che collegano le due componenti. I cocicli fondamentali generati da ciascuno dei rami di $T$ formano una base per lo spazio dei cocicli.

Teorema 9.1.8
?
**Enunciato:** In un grafo $G$, lo spazio dei cicli e lo spazio dei cocicli (considerati come sottospazi vettoriali dello spazio degli spigoli su $\mathbb{Z}_2$) sono ortogonali tra loro. Ne consegue che l'intersezione tra un ciclo qualsiasi e un cociclo qualsiasi contiene sempre un numero pari di spigoli.

Teorema 9.2.3
?
**Enunciato:** Ogni ciclo di un grafo può essere espresso in modo unico come somma (modulo 2) di una combinazione lineare di cicli appartenenti a una base dello spazio dei cicli (come ad esempio la base dei cicli fondamentali associati a un albero di copertura).

Teorema 9.2.4
?
**Enunciato:** Ogni cociclo di un grafo può essere espresso in modo unico come somma (modulo 2) di una combinazione lineare di cocicli appartenenti a una base dello spazio dei cocicli (come la base dei cocicli fondamentali).

Algoritmo di Trémaux
?
L'algoritmo di Trémaux è un metodo sistematico (basato sul principio della ricerca in profondità o Depth-First Search) per esplorare un grafo o trovare l'uscita da un labirinto evitando di percorrere lo stesso cammino all'infinito.
**Procedura:**
1. Si segna il vertice in cui si arriva e lo spigolo percorso. 
2. Quando ci si trova in un vertice, si sceglie uno spigolo non ancora visitato e lo si percorre.
3. Se si giunge a un vertice già esplorato in precedenza (formando un ciclo) o a un vicolo cieco, si torna indietro lungo lo stesso spigolo appena percorso (marcandolo due volte, indicando che è chiuso).
4. Si ripete il procedimento finché non si è esplorato tutto il grafo. L'insieme degli spigoli percorsi una sola volta definisce un albero di copertura per la componente connessa esplorata.

Algoritmo di Dantzig (per il calcolo dei cammini minimi)
?
L'algoritmo di Dantzig è un approccio di tipo "greedy" (goloso) utilizzato per determinare l'albero dei cammini minimi partendo da un vertice sorgente verso tutti gli altri vertici del grafo.
**Procedura:**
1. Si inizializza un insieme di vertici esplorati $S$ contenente solo la sorgente $s$, ponendo la distanza $d(s)=0$.
2. Ad ogni passo, si valutano tutti gli spigoli $(u, v)$ tali che il vertice di partenza $u$ è già in $S$ e il vertice di destinazione $v$ non è ancora in $S$.
3. Tra tutti questi spigoli, si seleziona quello che minimizza la somma $d(u) + w(u,v)$, dove $w(u,v)$ è il peso/costo dello spigolo.
4. Si aggiunge il vertice $v$ all'insieme $S$ assegnandogli in via definitiva la distanza ottima $d(v) = d(u) + w(u,v)$.
5. Si itera questo processo finché tutti i vertici raggiungibili sono stati aggiunti a $S$.

