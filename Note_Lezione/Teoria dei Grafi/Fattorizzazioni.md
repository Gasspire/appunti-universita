#flashcards/fattorizzazioni

Definizione di spigoli paralleli e di matching
?
Dato un grafo $\mathcal{G}=(V,E)$, due spigoli $e_1, e_2 \in E$ si dicono paralleli se $e_1 \cap e_2 = \emptyset$ (non hanno alcun vertice in comune). Un insieme di spigoli $M \subseteq E$ si definisce matching (o accoppiamento) se gli spigoli di $M$ sono a due a due paralleli.

Definizione di fattore (o perfect matching)
?
Si definisce fattore (o (1)-fattore, accoppiamento completo, classe di parallelismo) di $\mathcal{G}$ un matching $M \subseteq E$ tale che:
1) per ogni $e_1, e_2 \in M$, $e_1 \cap e_2 = \emptyset$ (spigoli paralleli);
2) $\bigcup_{v \in M} v = V$ (l'unione dei vertici degli spigoli di $M$ coincide con l'intero insieme $V$).
In altre parole, è una partizione dell'insieme dei vertici $V$ in spigoli tutti tra loro paralleli.

Definizione di fattorizzazione
?
Si definisce fattorizzazione $\mathcal{F}$ (o (1)-fattorizzazione) di $\mathcal{G}$ una partizione dell'insieme degli spigoli $E$ in classi ognuna delle quali è un fattore (o (1)-fattore).

Definizione di matching massimale e massimo
?
Un matching $M$ di un grafo $\mathcal{G}$ si dice massimale se per ogni $s \in E \setminus M$, $M \cup \{s\}$ non è un matching (equivalentemente, se non è contenuto strettamente in un altro matching).
Un matching $M$ si dice massimo se non esiste alcun matching $M'$ tale che $|M'| > |M|$ (cioè ha la massima cardinalità possibile nel grafo).

Teorema della condizione necessaria per la fattorizzabilità
?
Teorema: Se esiste una fattorizzazione di $\mathcal{G}$, allora il numero di vertici del grafo è pari.
Dimostrazione: Poiché ogni fattore è una partizione di $V$ in spigoli mutuamente disgiunti (ciascuno avente esattamente 2 vertici), ogni fattore copre tutti i vertici senza sovrapposizioni. Di conseguenza, il numero totale di vertici $|V|$ deve essere espresso come $2 \times |M|$, dove $|M|$ è il numero di spigoli del fattore. Essendo $|M|$ un numero intero, $|V|$ deve essere necessariamente pari.

Teorema di fattorizzabilità del grafo completo $K_n$
?
Teorema: Un grafo completo $K_n$ è fattorizzabile se e solo se $n$ è pari.
Dimostrazione: Se $K_n$ è fattorizzabile, per il teorema precedente $n$ deve essere pari. Viceversa, se $n = 2k$ ($k \in \mathbb{N}$), si può esplicitamente costruire una fattorizzazione ponendo $X = \mathbb{Z}_{2k-1} = \{1, 2, \dots, 2k-1\}$ e $X' = X \cup \{\infty\}$. La fattorizzazione $\mathcal{F} = \{F_1, F_2, \dots, F_{2k-1}\}$ è definita per ogni $i = 1, \dots, 2k-1$ da:
$$F_i = \{[\infty, i]; [i + 1, i - 1]; [i + 2, i - 2]; \dots; [i + (k - 1), i - (k - 1)]\}$$
Una verifica diretta mostra che $\mathcal{F}$ costituisce una partizione valida di $P_2(X')$, ricoprendo tutti gli spigoli di $K_n$.

Teorema di fattorizzabilità del grafo bipartito completo $K_{n,n}$ \[OPZIONALE\]
?
Teorema: Un grafo bipartito completo $K_{n,n}$ è sempre fattorizzabile.
Dimostrazione: Sia $K_{n,n} = (A, B; E)$ con $A = \mathbb{Z}_n = \{1, 2, \dots, n\}$ e $B = \mathbb{Z}'_n = \{1', 2', \dots, n'\}$ ($A \cap B = \emptyset$). Definiamo la fattorizzazione $\mathcal{F} = \{F_1, F_2, \dots, F_n\}$ dove ciascun fattore è:
$$F_i = \{[1, (1 + i)']; [2, (2 + i)']; \dots; [n, (n + i)']\} \quad \forall i = 1, 2, \dots, n$$
(considerando l'aritmetica in $\mathbb{Z}_n$). Ciascun $F_i$ associa ad ogni elemento di $A$ un elemento distinto di $B$, formando un perfect matching. Poiché al variare di $i$ gli spigoli generati sono tutti distinti e in totale pari a $n \times n = |E|$, l'insieme $\mathcal{F}$ è una partizione dell'insieme degli spigoli in fattori, soddisfacendo la definizione di fattorizzazione.

Teorema di fattorizzazione di $K_{4k}$ mediante blocchi più piccoli \[OPZIONALE\]
?
Teorema: Se $n = 4k$, è possibile definire una fattorizzazione di $K_{4k}$ contenente due fattorizzazioni di $K_{2k}$ ed una fattorizzazione di $K_{2k,2k}$.
Dimostrazione: Siano $\mathcal{F} = \{F_1, \dots, F_{2k-1}\}$ e $\mathcal{G} = \{G_1, \dots, G_{2k-1}\}$ due fattorizzazioni di $K_{2k}$ definite rispettivamente sugli insiemi di vertici disgiunti $A = \mathbb{Z}_{2k} = \{1, 2, \dots, 2k\}$ e $B = \mathbb{Z}'_{2k} = \{1', 2', \dots, (2k)'\}$. Sia inoltre $\mathcal{H} = \{H_1, \dots, H_{2k}\}$ una fattorizzazione del grafo bipartito completo $K_{2k,2k}$ definito sull'unione dei vertici $V = A \cup B$. 
Costruiamo la famiglia $\mathcal{K} = \{K_1, \dots, K_{2k-1}\}$ dove ogni elemento è dato dall'unione $K_i = F_i \cup G_i$ ($\forall i = 1, \dots, 2k-1$). Poiché $F_i$ copre $A$ e $G_i$ copre $B$, la loro unione $K_i$ è un matching perfetto su $A \cup B$. 
L'insieme globale di fattori $\Pi = \mathcal{K} \cup \mathcal{H}$ contiene in totale $(2k - 1) + 2k = 4k - 1$ fattori. Poiché tutti gli spigoli interni ad $A$ (da $\mathcal{F}$), interni a $B$ (da $\mathcal{G}$) e tra $A$ e $B$ (da $\mathcal{H}$) vengono inclusi una ed una sola volta, $\Pi$ costituisce una fattorizzazione valida per il grafo completo $K_{4k}$.

Definizione di pseudo-fattorizzazione (per $n$ dispari)
?
Quando $n$ è dispari, il grafo $K_n$ non è fattorizzabile. Si definisce pseudo-fattorizzazione di $V$ (o del grafo) la partizione degli spigoli $P_2(V)$ in $n$ classi $F_1, F_2, \dots, F_n$ ottenuta con il seguente procedimento:
1) Si introduce un vertice fittizio $\infty$ ponendo $V' = V \cup \{\infty\}$;
2) Si costruisce la fattorizzazione standard su $V'$ (essendo $|V'|$ pari, essa ha $n$ fattori);
3) Da ciascun fattore si elimina lo spigolo contenente $\infty$.
Ciascuna classe risultante $F_i$ conterrà tutti i vertici di $V$ eccetto uno, e per ogni vertice $v_i \in V$ esisterà esattamente una classe in cui esso non compare.

Definizione di matching completo e $A$-perfetto in un grafo bipartito
?
Dato un grafo bipartito $\mathcal{G}=(A,B,E)$, un matching $M$ si definisce completo (o $A$-perfetto) se ogni vertice dell'insieme $A$ è estremo di uno spigolo di $M$. Ciò implica che $|M| = |A|$ e che $|A| \le |B|$.

Teorema di König-Hall (Criterio dei Matrimoni)
?
Sia $\mathcal{G}=(A,B,E)$ un grafo bipartito. Esiste in $\mathcal{G}$ un matching completo ($A$-perfetto) se e solo se per ogni sottoinsieme $X \subseteq A$ vale la condizione:
$$|\Gamma_{\mathcal{G}}(X)| \ge |X|$$
dove $\Gamma_{\mathcal{G}}(X)$ indica l'insieme dei vertici di $B$ adiacenti ad almeno un vertice di $X$.

Il problema dei matrimoni (Formulazione combinatoria)
?
Il problema dei matrimoni costituisce la classica interpretazione applicativa del Teorema di König-Hall : dato un insieme di $n$ ragazzi e $n$ ragazze, in cui ogni ragazza esprime una lista di preferenze (ragazzi che sarebbe disposta a sposare), si vuole stabilire sotto quali condizioni sia possibile sposare contemporaneamente ciascuna ragazza con un ragazzo di suo gradimento, in modo che nessuno rimanga senza partner. 
Il problema si modella con un grafo bipartito $\mathcal{G}=(A,B,E)$, in cui l'insieme $A$ rappresenta le ragazze, l'insieme $B$ rappresenta i ragazzi, e sussiste uno spigolo se e solo se il ragazzo è gradito alla ragazza. Una soluzione ottimale (un matrimonio combinatorio completo) corrisponde matematicamente a un matching completo ($A$-perfetto) nel grafo. Il teorema di König-Hall afferma che tale abbinamento globale esiste se e solo se ogni possibile sottoinsieme di $k$ ragazze gradisce complessivamente almeno $k$ ragazzi distinti.

Teorema 6.5.3 (Estensione di un rettangolo latino)
?
Sia $M$ un rettangolo latino di ordine $m \times n$ con $m < n$. Allora $M$ può essere sempre esteso ad un quadrato latino di ordine $n \times n$ aggiungendo $n - m$ righe nuove.