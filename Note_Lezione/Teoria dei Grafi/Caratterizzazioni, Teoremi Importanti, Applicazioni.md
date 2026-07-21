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
3. Cerchiamo un cammino chiuso hamiltoniano percorrendo un ciclo euleriano e, ogni volte che troviamo un vertice già visitato $x_i$, sostituiamo il cammino $\[x_{i-1}. x_i, \\]$