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

## Applicazioni
#### Formula di Cayley
L'applicazione dei grafi studiata da Arthur Cayley a partire dal 1850 nasce per risolvere un problema pratico di chimica matematica legato agli **alcani**, composti organici formati solo da carbonio e idrogeno con formula generale $C_n H_{2n+2}$.

Cayley notò che rappresentando queste molecole con un grafo — in cui gli atomi sono i vertici e i legami sono gli spigoli — il carbonio (tetravalente) assume sempre grado 4 e l'idrogeno (monovalente) assume sempre grado 1. Avendo la molecola un totale di $3n+2$ atomi, tramite l'applicazione del lemma delle strette di mano si ricava che il numero complessivo di legami è esattamente $3n+1$. Poiché in questo grafo il numero di spigoli è pari al numero dei vertici meno uno ($|E| = |V| - 1$) e la molecola è una struttura connessa, **il grafo associato a un alcano è sempre e rigorosamente un albero**.

Il motivo che spinse Cayley a cercare una formula derivò dall'esigenza chimica di determinare tutti i possibili **isomeri** degli alcani. Gli isomeri sono composti che possiedono la medesima formula molecolare ma con una struttura spaziale degli atomi differente, il che si traduce in proprietà chimico-fisiche diverse. In termini di teoria dei grafi, trovare tutti i possibili isomeri equivale a risolvere un problema combinatorio: **contare quanti alberi etichettati distinti si possono costruire su un insieme di $n$ vertici**.

Da questa intuizione scaturisce la celebre formula, matematicamente formalizzata nel **Teorema di Cayley (1899)**: **Il numero di alberi etichettati su $n$ vertici è esattamente $n^{n-2}$**.

Una conseguenza pratica diretta di questa formula è che anche il numero totale di _spanning trees_ (alberi ricoprenti) che si possono ottenere da un grafo completo $K_n$ è pari a $n^{n-2}$.

Il calcolo esatto di questa formula fu successivamente dimostrato in maniera costruttiva grazie all'invenzione del **codice di Prüfer**. Prüfer dimostrò che esiste una corrispondenza biunivoca perfetta tra ogni possibile albero etichettato su $n$ vertici e una sequenza ordinata di $n-2$ interi scelti tra 1 e $n$. Poiché per comporre questa sequenza di lunghezza $n-2$ possiamo scegliere tra $n$ opzioni disponibili in ciascuna posizione, il calcolo combinatorio elementare ci dice che le configurazioni possibili sono esattamente $n \cdot n \cdot ... \cdot n = n^{n-2}$. Di conseguenza, esisteranno esattamente $n^{n-2}$ alberi etichettati distinti.

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
Il teorema di Konig-Hall ci dice che il grafo bipartito in questione (con $|A| = r \leq |B| = s$) ammette matching  A-perfetto se e solo se per ogni $X \subseteq A, |X| = k, 1 \leq k \leq r$, si ha che $|\Gamma(X)|\geq k$. Cioè che per ogni sotto insieme di $k$ vertici di A, il numero di vertici adiacenti è almeno k.