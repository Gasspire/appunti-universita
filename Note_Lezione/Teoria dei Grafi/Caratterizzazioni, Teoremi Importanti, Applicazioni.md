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
Sia G un grafo semplice con $|V|\geq 3$ e per ogni $v \in V, d(v) \geq n/2$ allora G è hamiltoniano. (dim. Ore)

#### Bondy-Chavatal
Sia G un grafo semplice come sopra e siano $u,v$ tale che $d(u)+d(v) \geq n$, $G+(u,v)$ è hamiltoniano solo se lo è $G$. (Dim. Se G è hamiltoniano ovviamente anche G+ lo è. Viceversa, per assurdo se G+ è hamiltoniano e G no, siamo di nuovo nelle condizioni di ore, da cui seguirebbe l'assurdo.) 

### Grafi Planari

#### Eulero
Sia G un grafo planare connesso con $|V| = n, |E| = m$ ed $f$ il numero di facce nel grafo, allora $n-m+f =2$ (dim. induzione sul numero di spigoli togliendone poi uno da quello grande che unisce due facce )

#### Eulero generalizzato
Sia G un grafo planare non necessariamente connesso come sopra, allora $n-m+f = p+1$ (dim. Applico Eulero a tutte le componenti connesse, poi tolgo la faccia infinita e arrivo a p + 1)

#### Somma della lunghezza delle facce
Sia G un grafo planare, sia $L(F_i)$ la lunghezza della i esima faccia, abbiamo che la somma delle lunghezza è uguale a 2m. (dim banale)

#### Somma delle lunghezze uguali per tutte le facce
Come sopra, banalmente sia $r$ la lunghezza delle facce, segue che $r \cdot f = 2m$

#### Numero di spigoli in relazione a facce della stessa lunghezza
Come sopra, dai teoremi precedenti segue che $m = \frac{r\cdot(n-2)}{r-2}$

#### Numero spigoli su facce quadrangolari e triangolari
Dal teorema sopra segue che:
1. Se ha solo facce triangolari $m = 3n-6$
2. Se ha solo facce quadrangolari $m = 2n - 4$

#### Considerazioni su grafo planare massimale
Se un grafo è massimale allora:
1. Ha solo facce triangolare 
2. $m = 3n-6$ (dim ovvia dal fatto che se è massimale, il ciclo deve avere al massimo 3 vertici)
#### Condizioni necessarie ma non sufficienti 1
Se è planare allora:
1. $m \leq 3n-6$ (dim. si aggiungono spigoli fino ad arrivare al massimale)
2. Se non ci sono facce triangolari, allora $m\leq 2n-4$ (dim si arriva da 2m = somma della lunghezza delle facce >= 4 f e poi si usa Eulero)

#### Condizioni necessaria ma non sufficienti 2
Se è planare allora:
1. esiste almeno un vertice tale che il suo grado è $\leq 5$. (dim da hand shake lemma supponi per assurdo che tutti hanno grado maggiore e vedi che grado è maggiore del massimale $2m \geq 6n$)
2. Se $|n| \geq 4$ esistono almeno 3 vertici il cui grado è $\leq 5$. (dim. stessa cosa di prima ma si arriva a $2m \geq 6n-10$)
#### Teorema di Kuratowski 
Se un sottografo è omeomorfo a $K_5$ o $K_{3,3}$ non è planare

### Colorazione dei Vertici
#### Relazione tra numero cromatico e densità (massimo numero di vertici adiacenti tra loro)
Per ogni grafo $G=(V,E)$ si ha che $\chi(G)\geq \omega(G)$ (dim. banale)
#### Relazione tra numero cromatico e grado massimo
Per ogni grafo $G=(V,E)$ si ha che $\chi(G)\leq \Delta(G)+1$ (dim. induzione |V| eliminiamo un vertice e lo vediamo che è il grafo non solo è $\Delta(G')+1$ colorabile ma a maggiorazione lo è anche $\Delta(G)+1$ )
#### Teorema di Brooks
Dato un grafo che non sia isomorfo ad un grafo completo o ad un ciclo di lunghezza dispari, allora abbiamo che $\chi(G)\leq \Delta(G)$
#### Teorema dei 5 colori
Se $G=(V,E)$ è planare, allora $\chi(G) \leq 5$.
#### Proprietà del Polinomio Cromatico 1
Se $G$ non è completo e x e y non sono vertici adiacenti, allora abbiamo che $P(G,\lambda) = P(G+(x,y), \lambda) + P(G\backslash(x,y), \lambda)$ (connessione e contrazione)
#### Proprietà del Polinomio Cromatico 2
(i) $P(\mathcal{G}, \lambda) = a_n[\lambda]_n + a_{n-1}[\lambda]_{n-1} + \dots + a_\chi[\lambda]_\chi$ (Algoritmo di connessione e contrazione)
(ii) $P(\mathcal{G}, \lambda)$ ha grado $n$ ed il suo termine noto è nullo (Sviluppando il polinomio si nota che $\lambda$ è comune a tutti quindi è nullo e il suo grado è n)
(iii) Il coefficiente di $\lambda^n$ è sempre pari a 1 (Dall'algoritmo di connessione e contrazione avremo 1 solo $K_n$)
(iv) $P(\mathcal{G}, \lambda) = \lambda(\lambda-1)\dots(\lambda-\chi+1)Q(\lambda)$ (Scomposizione di ruffini, il polinomio è zero per ogni $\lambda < \chi$ )
(v) I coefficienti di $P(\mathcal{G}, \lambda)$ sono alternativamente $\ge 0, \le 0$ (ind. su spigoli, poi connessione e contrazione come induzione, si nota che è incluso G iniziale e poi porta dall'altra parte)
(vi) Il coefficiente di $\lambda^{n-1}$ è $-m$. (ind. come sopra, poi si sostituisce m' = m-1)
#### Polinomio cromatico dell'albero
$G$ è un albero se e solo se $P(G,\lambda) = \lambda (\lambda-1)^{n-1}$
#### Polinomio cromatico di un ciclo
Sia $\mathcal{C}_n$ un grafo ciclo con $n \ge 3$ vertici, allora si ha che:
$P(\mathcal{C}_n, \lambda) = (\lambda-1)[(\lambda-1)^{n-1} + 1]$ se $n$ è pari,
$P(\mathcal{C}_n, \lambda) = (\lambda-1)[(\lambda-1)^{n-1} - 1]$ se $n$ è dispari.

#### Teorema di Grotzsch
Se G è un grafo planare privo di facce triangolari, allora $\chi(G) \leq 3$.

#### Teorema di Mycielski
 Se $\mathcal{G}$ è un grafo $k$-cromatico e privo di sottografi $\mathcal{K}_3$, allora $M(\mathcal{G})$ è $(k+1)$-cromatico ed è anch'esso privo di $\mathcal{K}_3$.

#### Teorema sulla densità cromatica
Per ogni $h \in N$ esistono grafi aventi densità cromatica $h$.


### Fattorizazzione
#### Teorema di Konig-Hall 1
Sia $\mathcal{G}=(A,B,E)$ un grafo bipartito. Esiste in $\mathcal{G}$ un matching completo ($A$-perfetto) se e solo se per ogni sottoinsieme $X \subseteq A$ vale la condizione:
$$|\Gamma_{\mathcal{G}}(X)| \ge |X|$$
dove $\Gamma_{\mathcal{G}}(X)$ indica l'insieme dei vertici di $B$ adiacenti ad almeno un vertice di $X$.
#### Teorema di Konig-Hall 2
Sia E un insieme finito non vuoto e sia $F=\{F_1,\dots, F_m\}$ una famiglia di sottoinsiemi di E non vuoti, allora $F$ ammette un insieme trasversale se e solo se l'unione di k sottoinsiemi $F_i$ contiene almeno k elementi con $1\leq k \leq m$

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