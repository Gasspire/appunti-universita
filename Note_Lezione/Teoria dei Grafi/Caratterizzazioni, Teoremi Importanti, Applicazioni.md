## Caratterizzazioni
#### Alberi
Dato un grafo $G=(V,E)$ tale che $|V| = n$ e $|E| = m$ le seguente affermazioni sono equivalenti:
1. G è un albero (aciclico e connesso).
2. G è connesso e m = n-1.
3. G è aciclico e m = n-1.

#### Grafi euleriani
Dato un grafo $G=(V,E)$ connesso e tale che $|V| = n$ e $|E| = m$ le seguente affermazioni sono equivalenti:
1. G è Euleriano.
2. I vertici hanno tutti grado pari.
3. Esiste una decomposizione in cicli.

#### Grafi orientati fortemente connessi
Dato un digrafo $G=(V,E)$ connesso e tale che $|V| = n$ e $|E| = m$ le seguente affermazioni sono equivalenti:
1. $G$ è fortemente connesso
2. Ogni arco appartiene ad un circuito
3. G non contiene cocircuiti.

## Teoremi Importanti
### Alberi
#### Unicità della catena
Sia $G = (V,E)$ un albero e siano $x,y \in V$ due vertici distinti qualsiasi, esisterà una e una sola catena che ha come estremi x e y. (DIM per contraddizione in caso di cammino alternativo (ciclo))

#### Disconnessione del grafo in caso di una sola catena
Sia $G = (V,E)$ un grafo e siano $x,y \in V$ due vertici distinti qualsiasi i quali sono sempre estremi di una sola catena:
1. G è connesso (banale)
2. per ogni spigolo vale che $G-\{e\}$ è sconnesso (come sopra)

#### Numero di spigoli per grafo senza uno spigolo sconnesso
Sia $G = (V,E)$ un grafo, tale che se togli uno spigolo si disconnette. Allora abbiamo che $m = n-1$. (DIM per induzione su vertici)

#### Procedura di Kruskal su Grafo completo e correttezza
Sia A l'albero di costo minimo e sia T l'albero ottenuto dall'algoritmo di Kruskal, allora $c(A) = c(T)$. (DIM Opz. Se sono uguali, ggwp. Se sono diversi, togli da A e metti in T il primo diverso e poi arrivi a vedere che anche T è un MST)


### Grafi Euleriani e Hamiltoniani
#### Esistenza di cicli
Se in un grafo, ogni vertice ha almeno grado 2, esiste un ciclo.

#### Connessione del grafo |V| >= 3 se grado >= n/2
Dato un grafo con $|V| \geq 3$ se $\forall v \in V, d(v) \geq n/2$ allora G è connesso. (DIM se u,v non sono adiacenti, hanno almeno un vertice in comune)


#### Ore
Sia G un grafo semplice con $|V| \geq 3$ se tutti i vertici non adiacenti sono tali che $d(u) + d(v) \geq n$ allora G è hamiltoniano. (dim. Assurdo supp. aggiungere spigoli fino ad avere un cammino hamiltoniano, notiamo quella cosa della catena, calcoliamo i gradi, arriviamo all'assurdo)

#### Dirac
Sia G un grafo semplice con $|V|\geq 3$ e
## Applicazioni
#### Formula di Cayley
_Problema_ Determinare il numero di tutti i possibili isomeri degli alcani, ovvero composti organici con formula $C_n H_{2n+2}$, calcolando le diverse configurazioni strutturali spaziali che mantengono inalterata la formula molecolare.
_Traduzione_ Modellando la molecola come un grafo in cui gli atomi sono i vertici e i legami chimici sono gli spigoli, si ottiene una struttura connessa con $\vert{}V\vert{} = 3n+2$ atomi e $\vert{}E\vert{} = 3n+1$ legami. Poiché $\vert{}E\vert{} = \vert{}V\vert{} - 1$, il grafo è rigorosamente un albero. Il problema combinatorio equivale a calcolare quanti alberi etichettati distinti possono essere costruiti su tale insieme di vertici.
_Soluzione_
Il numero esatto di alberi etichettati su un insieme di $n$ vertici è dato dalla formula $n^{n-2}$, valore che coincide con il numero totale di spanning tree estraibili da un grafo completo $K_n$. La dimostrazione costruttiva del teorema si basa sul **codice di Prüfer**, il quale stabilisce una corrispondenza biunivoca perfetta tra ogni possibile albero etichettato su $n$ vertici e una sequenza ordinata di lunghezza $n-2$ formata da interi scelti tra $1$ e $n$.
#### Il grafo del Cavallo
*Problema* data una scacchiera $n \times n$ è possibile muovere un cavallo occupando tutte le caselle una ed una sola volta? Si può percorrere una cammino chiuso che quindi occupi tutte le caselle una sola volta a e poi ritorni alla prima? Se sì, quanti cicli esistono?
*Traduzione* Definiamo il grafo $G_n$ i cui vertici rappresentano tutte le caselle della scacchiera e questi sono connessi da spigoli solamente se il cavallo può passare da una casella all'altra tramite il suo movimento a L. La ricerca di un percorso che occupi tutte le caselle è la ricerca di un **cammino Hamiltoniano** o di un **ciclo hamiltoniano**
*Soluzione*: 
- per $n = 5$ esiste un cammino hamiltoniano ma non un ciclo.
- per n>5 questo ammette cicli hamiltoniani se e solo se n è pari.
- Rimane un problema aperto determinare il numero di cicli hamiltoniani.

#### Commesso Viaggiatore
*Problema* Un commesso deve visitare un certo numero di città. Conoscendo la distanza che lega tutte le città l'una con l'altra, vuole determinare il percorso più breve che gli consente di partire da una città, visitare tutte le città e poi tornare al punto di partenza.
*Traduzione* Assumendo siano tutte collegate, abbiamo un grafo completo su $n$ vertici dove i vertici rappresentano le città. Associamo ad ogni spigolo un peso. Dunque, in questo senso abbiamo la ricerca di un **ciclo hamiltoniano di peso minimo**
*Soluzione*:
Questo è un problema NP-Hard, tuttavia c'è un algoritmo che trova una soluzione quasi ottimale in tempi ragionevoli. L'idea è la seguente:
1. Costruiamo l'MST $A$
2. Si duplicano tutti gli spigoli ottenendo un multigrafo euleriano E.
3. Cerchiamo un cammino chiuso hamiltoniano percorrendo un ciclo euleriano e, ogni volte che troviamo un vertice già visitato $x_i$, sostituiamo il cammino $[x_{i-1}. x_i, \dots, x_{i+h}]$ con lo spigolo $(x_{i-1},x_{i+h})$ dove $x_{i+h}$ è il primo vertice non visitato, o, in assenza di questo, il vertice di partenza.
#### Postino Cinese
*Problema* Si vuole determinare un percorso semplice (che quindi attraversa tutte le strade una sola volta) ritornando al punto di partenza.
*Traduzione* Abbiamo un grafo $G$ dove i vertici rappresentano gli incroci e gli spigoli pesati rappresentano le strade. L'obbietto è quello di trovare un **ciclo euleriano di peso minimo**.
*Soluzione*:
Ci sono due casi:
1. Se il grafo è euleriano, la soluzione si ottiene banalmente con l'algoritmo di ricerca del ciclo euleriano.(**Algoritmo di Fleury**)
2. Se non lo è, il problema è più complesso:
	1. Se non è euleriano, abbiamo un numero pari di vertici di grado dispari (vedi caratterizzazione e corollario dell'handshake lemma)
	2. Dobbiamo dunque rendere il grafo euleriano manualmente (ripercorrendo più volte delle strade), in questo caso, raddoppiamo gli spigoli che collegano vertici di grado dispari così da minimizzare il ciclo euleriano.
#### Colorazione delle cartine geografiche
*Problema* Vogliamo colorare le cartine geografiche in modo tale che paesi confinanti abbiano colori diversi.
*Traduzione* I paesi sono i vertici gli spigoli collegano paesi confinanti. Il grafo è planare visto che si tratta di cartine geografiche e, per il teorema dei 4 colori, esiste una colorazione che permette ciò.

#### Problema dei matrimoni
*Problema* Abbiamo un gruppo di ragazzi che conosce un gruppo di ragazze e vogliamo fare in modo che ognuno ne sposi una diversa ma facendo in modo che tutti i ragazzi si sposino.
*Traduzione* Abbiamo un grafo bipartito con A e B e vogliamo trovare un matching A-completo. 
*Soluzione*
- Il teorema di Konig-Hall ci dice che il grafo bipartito in questione (con $|A| = r \leq |B| = s$) ammette matching  A-perfetto se e solo se per ogni $X \subseteq A, |X| = k, 1 \leq k \leq r$, si ha che $|\Gamma(X)|\geq k$. Cioè che per ogni sotto insieme di $k$ vertici di A, il numero di vertici adiacenti è almeno k.
- Un'altra formulazione si può avere usando gli insiemi trasversali. Sia E l'insieme che comprende tutti i ragazzi e siano $F_i$ le ragazze che conosce l'i-esimo ragazzo. Se riusciamo a trovare un trasversale, significa che abbiamo trovato una ragazza per ogni ragazzo.

#### Grafo della regina
*Problema* Vogliamo cercare di piazzare quante più regine possibili su una scacchiera $8 \times 8$ in modo che nessuna ne mangi un'altra.
*Traduzione*:
1. La scacchiera ha 64 caselle ognuna delle quali rappresenta un vertice. Ogni casella è collegata ad un'altra se e solo se una regina può passare da una all'altra tramite i suoi movimenti. In questa formulazione si tratta di trovare l'insieme stabile più grande possibile.
2. Allo stesso modo possiamo rappresentare questo problema in termini di stabilità esterna. In questo senso, vogliamo determinare il numero di stabilità esterna più piccolo possibile in maniera tale che una casella sia sotto il controllo di almeno una regina. (NB: i problemi non sono equivalenti)
#### Caso dei ripetitori TV
*Problema* Vogliamo piazzare il minor numero di ripetitori tv in maniera tale che questi ricoprano tutte le case.
*Traduzione* Cerchiamo di trovare su un grafo bipartito (da una parte i ripetitori, dall'altra le case) il minor insieme esternamente stabile che ricopra tutte le case possibili.