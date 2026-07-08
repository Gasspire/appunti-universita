Definizione di Colorazione dei vertici e grafi notevoli
?
Si definisce colorazione dei vertici di un grafo $\mathcal{G}=(V,E)$ un'applicazione $K:V\rightarrow C$ che ad ogni coppia di vertici $x,y \in V$ per cui esiste uno spigolo $(x,y) \in E$ associa $K(x) \neq K(y)$. Equivalentemente, è una partizione dell'insieme dei vertici $V$ in classi tutte stabili.

Definizione di Numero cromatico e numero cromatico di grafi notevoli
?
Si definisce numero cromatico $\chi(\mathcal{G})$ il minimo numero di colori necessari per definire in $\mathcal{G}$ una colorazione dei suoi vertici.
I numeri cromatici per i grafi notevoli sono:
- Grafi completi $\mathcal{K}_n$: $\chi(\mathcal{K}_n) = n$.
- Grafi bipartiti $\mathcal{G}_{r,s}$: $\chi(\mathcal{G}_{r,s}) = 2$.
- Alberi: $\chi(\mathcal{G}) = 2$.
- Cicli $\mathcal{C}_n$: $\chi(\mathcal{C}_n) = 2$ se $n$ è pari, $\chi(\mathcal{C}_n) = 3$ se $n$ è dispari.

Teorema di Brooks
?
**Enunciato:** Dato un grafo connesso $\mathcal{G}=(V,E)$ che non sia isomorfo ad un grafo completo o ad un ciclo di lunghezza dispari, allora si ha che $\chi(\mathcal{G}) \le \Delta(\mathcal{G})$, dove $\Delta(\mathcal{G})$ è il grado massimo dei vertici.

Algoritmo per la determinazione del numero cromatico (connessione e contrazione)
?
L'algoritmo si basa sul principio di connessione e contrazione scelto su due vertici non adiacenti $x,y$:
- **Connessione:** genera il grafo $\mathcal{G}+(x,y)$ ottenuto aggiungendo lo spigolo $(x,y)$.
- **Contrazione:** genera il grafo $\mathcal{G}\setminus(x,y)$ ottenuto fondendo i due vertici in uno unico $x=y$.
L'algoritmo crea una sequenza di grafi completi iterando queste due operazioni. Il grafo completo ottenuto tramite sole contrazioni possiede il minor numero di vertici e il suo ordine $r$ rappresenta il numero cromatico $\chi(\mathcal{G})$.

Esempio di applicazione dell'algoritmo di determinazione del numero cromatico
?
Dato un grafo non completo, si considerano due vertici non adiacenti $a$ e $b$. Si ramifica in due nuovi grafi: $\mathcal{G}+(a,b)$ e $\mathcal{G}\setminus(a,b)$. Se la contrazione fornisce un grafo completo, ci si ferma su quel ramo; altrimenti si ripete la procedura sui nuovi grafi ottenuti scegliendo altre coppie non adiacenti, fino a ottenere solo grafi completi. Il grafo completo più piccolo ottenuto interamente per contrazioni consecutive determina il numero cromatico minimo $\chi$.

Teorema dei 5 colori
?
**Teorema 5.7.1:** Se $\mathcal{G}=(V,E)$ è un grafo planare, allora $\chi(\mathcal{G}) \le 5$.
**Dimostrazione:** Procediamo per induzione su $n=|V|$. Per $n \le 5$ la tesi è ovvia. Per $n \ge 6$, per il Teorema 4.2.5, esiste in $\mathcal{G}$ un vertice $v$ tale che $d(v) \le 5$. Consideriamo il grafo $\mathcal{G} \setminus \{v\}$, anch'esso planare, per cui esiste una 5-colorazione. Siano $x_1, \dots, x_5$ i vertici adiacenti a $v$. Se utilizzano al più 4 colori, assegniamo a $v$ il colore rimanente. Se utilizzano 5 colori distinti, studiamo il sottografo $H_{1,3}$ composto solo dai vertici con i colori 1 e 3. Se non esiste un cammino in $H_{1,3}$ tra $x_1$ e $x_3$, possiamo scambiare i colori nella componente connessa di $x_1$, in modo che questo diventi di colore 3, liberando il colore 1 per $v$. Se invece il cammino esiste, la planarità ci garantisce che non possa esistere alcun cammino tra $x_2$ e $x_4$ nel rispettivo sottografo bicolore $H_{2,4}$. Quindi invertiamo i colori 2 e 4 in $H_{2,4}$ a partire da $x_4$, liberando un colore per $v$.

Teorema dei 4 colori
?
**Teorema 5.7.2:** Se $\mathcal{G}=(V,E)$ è un grafo planare, allora $\chi(\mathcal{G}) \le 4$.

Polinomio cromatico: definizione e principali proprietà
?
**Definizione:** Il polinomio cromatico di un grafo $\mathcal{G}$ è un polinomio $P(\mathcal{G},\lambda)$ nell'incognita $\lambda$ che esprime il numero di $\lambda$-colorazioni distinte che possono esistere in $\mathcal{G}$.
**Principali proprietà e dimostrazioni:**
- Grafo completo: $P(\mathcal{K}_n, \lambda) = \lambda(\lambda-1)\dots(\lambda-n+1) = [\lambda]_n$. **Dimostrazione:** una colorazione propria equivale a scegliere per ogni vertice un colore diverso fra i $\lambda$ a disposizione senza reimmissione.
- Riduzione: se $x$ e $y$ non sono adiacenti, $P(\mathcal{G},\lambda) = P(\mathcal{G}+(x,y),\lambda) + P(\mathcal{G}\setminus(x,y),\lambda)$. **Dimostrazione:** Tutte le $\lambda$-colorazioni di $\mathcal{G}$ si dividono esattamente in quelle in cui $x$ e $y$ hanno colori diversi (calcolate nel grafo connessione) e quelle in cui hanno lo stesso colore (calcolate nel grafo contrazione).
- È un polinomio di grado $n$, il cui termine noto è nullo e il coefficiente di $\lambda^n$ è 1.

Teorema 5.8.3
?
**Enunciato:** Sia $\mathcal{G}$ un grafo con $n$ vertici ed $m$ spigoli. Allora $\mathcal{G}$ è un albero se e solo se $P(\mathcal{G},\lambda) = \lambda(\lambda-1)^{n-1}$.

Teorema 5.8.4
?
**Enunciato:** Sia $\mathcal{C}_n$ un grafo ciclo con $n \ge 3$ vertici, allora si ha che:
$P(\mathcal{C}_n, \lambda) = (\lambda-1)[(\lambda-1)^{n-1} + 1]$ se $n$ è pari,
$P(\mathcal{C}_n, \lambda) = (\lambda-1)[(\lambda-1)^{n-1} - 1]$ se $n$ è dispari.

Definizione Densità cromatica e Proposizioni
?
**Definizione:** Dato un grafo $\mathcal{G}$ con numero cromatico $\chi(\mathcal{G})$ e densità $\omega(\mathcal{G})$, si definisce densità cromatica la differenza $\delta(\mathcal{G}) = \chi(\mathcal{G}) - \omega(\mathcal{G}) \ge 0$.
**Proposizione 5.9.1:** Se $\mathcal{G}$ è un grafo planare, allora $\delta(\mathcal{G}) \le 2$.
**Proposizione 5.9.2:** Se $\mathcal{G}$ è un grafo planare, allora $\delta(\mathcal{G}) \le 1$.

Teorema di Grötzsch
?
**Enunciato:** Se $\mathcal{G}$ è un grafo planare e privo di facce triangolari allora $\chi(\mathcal{G}) \le 3$.

Costruzione di Mycielski
?
Sia $\mathcal{G}$ un grafo. Si introduce un nuovo insieme di vertici $U$ composto da copie $u_i$ per ogni vertice originario $v_i \in V$, più un vertice aggiuntivo universale $w$. Nel nuovo grafo $M(\mathcal{G})$ si mantengono gli spigoli di $\mathcal{G}$, poi ogni $u_i$ viene collegato ai vicini del rispettivo $v_i$, e infine $w$ viene collegato a tutti i nuovi vertici $u_i$. 

Teorema di Mycielski
?
**Enunciato:** Se $\mathcal{G}$ è un grafo $k$-cromatico e privo di sottografi $\mathcal{K}_3$, allora $M(\mathcal{G})$ è $(k+1)$-cromatico ed è anch'esso privo di $\mathcal{K}_3$.

Teorema 5.9.4
?
**Enunciato:** Per ogni $h \in \mathbb{N}$ esistono grafi $\mathcal{G}$ aventi densità cromatica $h$.
**Dimostrazione:** Si considera un grafo $\mathcal{G}$ con $\chi(\mathcal{G})=\omega(\mathcal{G})=2$ a cui si applica $h$ volte iterativamente la costruzione di Mycielski. Ad ogni iterazione, per il Teorema di Mycielski, il numero cromatico aumenta di 1 mentre la densità rimane 2 in quanto non si creano triangoli. Il grafo finale $\mathcal{G}_h$ avrà $\chi(\mathcal{G}_h) = h+2$ e $\omega(\mathcal{G}_h) = 2$, fornendo una densità cromatica $\delta(\mathcal{G}_h) = h$.

Grafo di Grötzsch
?
**Applicazione:** Il grafo di Grötzsch si ottiene iterando per due volte la Costruzione di Mycielski a partire dal grafo base $\mathcal{K}_2$. Nel primo passaggio si ottiene un ciclo $\mathcal{C}_5$, al secondo si ottiene un grafo con 11 vertici, 20 spigoli, numero cromatico $\chi=4$ e densità $\omega=2$, essendo un esempio calzante di grafo non planare e senza triangoli.

Definizione di Insieme stabile e Numero di stabilità
?
Dato un grafo $\mathcal{G}=(V,E)$, un insieme $X \subseteq V$ si definisce **stabile** se non contiene vertici adiacenti, cioè per ogni $x, y \in X$ con $x \neq y$, si ha che $(x,y) \notin E$. 
Si definisce **numero di stabilità** di $\mathcal{G}$ la massima cardinalità $\alpha(\mathcal{G})$ di un insieme stabile di $\mathcal{G}$: $\alpha(\mathcal{G}) = \max \{|X| : X \text{ insieme stabile di } \mathcal{G}\}$.

Definizione di Grafo k-colorabile e Grafo k-cromatico
?
Diremo che un grafo $\mathcal{G}=(V,E)$ è **k-colorabile** se esiste una colorazione dei vertici di $\mathcal{G}$ con $k$ colori. 
Un grafo che ha numero cromatico $\chi(\mathcal{G}) = k$ si dice **k-cromatico**. Equivalentemente, un grafo ha numero cromatico $k$ se risulta $k$-colorabile ma non $(k-1)$-colorabile.

Definizione di Densità di un grafo (Clique number)
?
Dato un grafo $\mathcal{G}=(V,E)$, si definisce **densità** di $\mathcal{G}$ (indicata con $\omega(\mathcal{G})$) il massimo numero di vertici tra loro adiacenti. Formalmente: $\omega(\mathcal{G}) = \max \{|X| : X \subseteq V, <X> \text{ completo}\}$. Tale sottografo generato completo prende anche il nome di *clique*. 
*(Nota: Questo valore fornisce il limite inferiore al numero cromatico, infatti $\chi(\mathcal{G}) \ge \omega(\mathcal{G})$)*.

Definizione di Classe di colorazione
?
Data una colorazione dei vertici, l'insieme dei vertici che condividono lo stesso colore forma una classe di equivalenza detta **classe di colorazione**. Ogni classe di colorazione è necessariamente un *insieme stabile*, poiché due vertici con lo stesso colore non possono essere adiacenti.

