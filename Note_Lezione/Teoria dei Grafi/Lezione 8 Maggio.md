Definizione di circuito: un ciclo orientato in cui tutti o tutti gli archi sono **positivi** o sono tutti **negativi**

Un ciclo è somma di cicli elementari  i cui archi sono a coppie disgiunti. Se in un ciclo passo due volte dallo stesso vertice, allora quello non è un ciclo elementare 

Esempio grafo con ciclo a 8.

*Proprietà*
Un ciclo è elementare se e solo se è **un ciclo minimale** cioè non ci sono altri cicli contenuti in esso

**Cocicli**
Considerato un grafo orientato $G(X,S)$ si considera un sotto insieme $A \subseteq X$, si denota con $w^-(A)$ l'insieme degli archi entranti e con  $w^+(A)$ l'insieme degli archi uscenti da $A$. Un cociclo si indica come $w(A) = w^+(A) \cup w^-(A)$. 
Un cociclo rappresenta una partizione degli archi di $G$.

Si definisce un **cociclo elementare** se e solo se i sotto insiemi dei nodi di $w^+(A)$ e di $w^-(A)$ sono entrambi connessi nel grafo di partenza. Cioè se $A_1 \cup A_2 = A$ e $A_1 \cap A_2 = 0$ e $A_1, A_2 \neq 0$.
In poche parole ho una partizione e gli insiemi di archi e nodi sono connessi nel senso che formano una componente connessa del grafo $G$ (nel senso non orientato del termine). 
 
NB: Tutti i w nelle formule credo dovrebbero essere $\omega$ cioè omega.

Cone nel caso dei cicli si può assegnare un valore tra 0, 1 e -1.

Si chiama **cocircuito** un cociclo in cui gli archi hanno tutti la stessa direzione cioè o sono tutti entranti o sono tutti uscenti. Spesso si usa il termine cociclo per chiamare il taglio nel senso di partizione di archi.

*Proprietà 1*
Un cociclo è somma di **cocicli elementari** disgiunti per archi.

*Proprietà 2*
Un cociclo è elementare se e solo se è **minimale** cioè se non contiene altri cocicli.

NO DIM PROPRIETÀ.

#### Numero ciclomatico e cociclomatico
**Lemma di colorazione di Minty (1960)**
Sia $G$ un grafo con $m$ archi, coloriamo l'arco 1 con il colore nero e tutti gli altri di colore rosso, verde o nero. Può accadere soltanto una di queste opzioni:
1. $\exists$ Un ciclo elementare contenente l'arco 1 tale e contiene archi rossi e neri con le proprietà che gli archi colorati di nero hanno tutti la stessa direzione (cioè formano un circuito).
2. $\exists$ Un cociclo elementare contenente l'arco 1 e gli altri archi sono colorati di nero e di verde e hanno la proprietà che tutti gli archi colorati di nero hanno tutti la stessa direzione (cioè formano un cocircuito).

*Corollario*
Dato un grafo orientato $G$ gli archi appartengono o ad un circuito elementare o a un cocircuito elementare ma non a entrambe le cose.

**Vettori linearmente indipendenti**
**Definizione di base**

La dimensione di $V = n$ se $\exists$ una base di $V$ formata da $n$ vettori. 

In maniera analoga, possiamo definire che i cicli $\mu^1, \mu^2$ sono linearmente indipendenti se la loro unica combinazione lineare uguale a 0 indica che $a_i= 0 \forall i$ 

Una base di cicli è un insieme di cicli elementari tale che questi ogni ciclo $\mu$ di G si può scrivere come combinazione lineare di questi cicli elementari $\mu^1, \dots, \mu^k$.
Ina maniera unica:
$$\mu = a_1 \mu^1 + \dots + a_k \mu^k$$

La dimensione dello spazio vettoriale dei cicli è il numero di cicli che formano una base di cicli di G e si chiama **numero ciclomatico** e viene denotato con $\nu(G) = m - n + p$ con m archi, n nodi e p componenti connesse.

Analogamente, un insieme di cocicli è $w^1, \dots, w^e$ è linearmente indipendente $aw^1+ \dots aw^e = 0 \to a_i = 0 \forall i$. 
Una base di cocicli è un insieme di cocicli elementare tali che ogni cociclo si può scrivere come combinazione lineare dei cocicli elementari in maniera unica.

La dimensione dello spazio di cocicli è il numero di cocicli elementari che costituiscono una base di cocicli di $G$
Il numero cociclomatico è uguale alla dimensione dello spazio dei cocicli e si indica come $\lambda = n - p$ con n nodi e p componenti connesse.

Esempio:
![[cicli elementari.png]]

RICORDA CHE I **CICLI ELEMENTARI NON TENGONO CONTO DELLA DIREZIONE DEGLI ARCHI**. SONO I CIRCUITI CHE HANNO BISOGNO DI TENERE CONTO DELLA DIREZIONE.

Se la matrice è composta **solo da un segno allora parliamo di circuito**.

Esempio domanda esame: Sai trovare la base di un ciclo?

Numero cociclomatico $\lambda(G) = n-p$
![[cocicli.png|660]]

Metodo: 
1. Fissiamo un nodo. Scegliamo b e chiamiamo $A_1 = \{b\}$ e troviamo il cociclo $w(A_1) = w^-(A_1) + w^+(A_1) = \{4, 6\} \cup \{1\}$ il vettore sarebbe, quindi $\{-1, 0, 0 , 1, 0, 1 \}$. Questo è elementare perché l'insieme dei nodi di b fanno una partizione non solo di nodi ma anche di archi : $C_1 = w(A)$ e $C_2= \{(a,c)(c,a),(c,d)\})$ e $C_1 \cup C_2 = G$ e $C_1 \cap C_2 = 0$ quindi è un cociclo elementare.
2. Adesso si considera un arco $(x,y)\in A_1:x\in A_1,y\notin A_1$. Consideriamo l'arco $(b,d)$ e, costruiamo $A_2 = A_1 \cup \{d\} = \{b,d\}$ e reiteriamo il processo visto in uno. $w(A_2) = \{(b,c),(c,d),(a,b)\}$, se calcoliamo il cociclo: $\{-1,0,0,-1,1\}$. Anche in questo caso è elementare (perché questo tipo di costruzione crea solo cocicli elementari).
3. Si reitera il processo, fino ad arrivare a $A_4 = A_3 \cup \{a\} = \{a,b,c,d\} = V(G)$ e quindi abbiamo finito e abbiamo trovato 3 cocicli.

Questo algoritmo è un teorema e fornisce una base di cocicli elementari $n-p$. Vedremo dopo il teorema (credo).

---
#### Grafi fortemente connessi
Sia $G=(X,U)$ connesso. Un cammino orientato di lunghezza zero consiste in un solo nodo $x \in X$. Un cammino orientato di lunghezza l è una **sequenza di archi**. 

La seguente relazione $\forall x \in X, \forall y \in X$:
$x R y \leftrightarrow \exists$ un cammino orientato da x verso y e da y verso x formando una **classe di equivalenza.**
Essendo una classe di equivalenza valgono le proprietà **riflessiva, transitiva e simmetrica**.

Nasce la classe $A(x_0) = \{x\in X: x R x_0\}$ formano una partizione di $G$ e le classi si chiamano **componenti fortemente connesse**. Quando abbiamo una sola componente fortemente connessa, allora diciamo che il grafo è **fortemente connesso.**