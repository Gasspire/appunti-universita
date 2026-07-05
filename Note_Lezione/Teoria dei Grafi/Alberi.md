#flashcards/alberi
Definizione di Albero e Foresta
?
Un grafo $\mathcal{G}$ si definisce albero se è aciclico (privo di cicli) e connesso. Un grafo $\mathcal{G}$ aciclico (non necessariamente connesso) prende il nome di foresta.
<!--SR:!2026-07-08,3,250-->

Definizione di Spanning tree
?
Dato un grafo $\mathcal{G}=(V,E)$, si definisce spanning tree un sottografo di $\mathcal{G}$ che sia un albero e che include tutti i vertici di $\mathcal{G}$.
<!--SR:!2026-07-08,3,250-->

Teorema sull'unicità della catena in un albero
?
**Teorema 2.1.3:** Sia $\mathcal{G}=(V,E)$ un albero e siano $x, y \in V$ due vertici distinti qualsiasi di $\mathcal{G}$. Allora esiste una ed una sola catena aventi come estremi $x$ e $y$.
**Dimostrazione:** Per definizione di albero, $\mathcal{G}$ è connesso, pertanto comunque presi due vertici distinti $x, y \in V$ esiste almeno una catena $C(x,y)$ che li congiunge. Tale catena è unica perché se ne esistesse un'altra di estremi $x$ e $y$, si verrebbe a formare un ciclo in $\mathcal{G}$, assurdo per ipotesi.
<!--SR:!2026-07-08,3,250-->

Teorema sulle catene uniche e la connessione del grafo
?
**Teorema 2.1.4:** Sia $\mathcal{G}=(V,E)$ un grafo. Se in esso due vertici distinti sono sempre estremi di una e una sola catena, allora:
(i) $\mathcal{G}$ è connesso;
(ii) per ogni spigolo $e \in E$, il grafo $\mathcal{G} \setminus \{e\}$ non è connesso.
**Dimostrazione:** (i) Basta osservare che se due vertici distinti sono sempre estremi di una ed una sola catena allora, per definizione, $\mathcal{G}$ è connesso.
(ii) Consideriamo uno spigolo qualsiasi $e=(x,y)$ di $\mathcal{G}$ e sia $\mathcal{G}'=\mathcal{G} \setminus \{e\}$. Se il grafo $\mathcal{G}'$ fosse connesso, esisterebbe una catena $C(x,y)$ che unisce i vertici $x$ e $y$. Ciò implica che, nel grafo $\mathcal{G}$ di partenza, esistano due catene congiungenti i vertici $x$ e $y$: la catena $C(x,y)$ e la catena $(x, e, y)$, assurdo per ipotesi.
<!--SR:!2026-07-08,3,250-->

Teorema sul numero di spigoli in grafi connessi vulnerabili alla disconnessione
?
**Teorema 2.1.5:** Sia un grafo $\mathcal{G}$ connesso tale che comunque si fissi in esso uno spigolo $e$, il grafo $\mathcal{G} \setminus \{e\}$ non è connesso. Allora si ha che $m=n-1$.
**Dimostrazione:** Procediamo per induzione su $n=|V|$.
**Base di induzione:** Se $n=1$ si ha subito $m=0$. Se $n=2$, l'unico grafo connesso possibile è quello con $m = 1$.
**Ipotesi induttiva:** Sia un grafo $\mathcal{G}$ connesso con $n>3$ vertici e supponiamo la tesi vera per un qualsiasi grafo connesso $\mathcal{G}'$ con $n'<n$. Si consideri uno spigolo $e=(x,y)$ qualsiasi di $\mathcal{G}$ e poniamo $\mathcal{G}'=\mathcal{G} \setminus \{e\}$. Poiché per ipotesi $\mathcal{G}'$ non è connesso, indichiamo con $\mathcal{G}_1$ e $\mathcal{G}_2$ i due grafi generati dalle due componenti connesse distinte in $\mathcal{G}'$, rispettivamente di vertici $n_1, n_2$ e spigoli $m_1, m_2$. Ovviamente, si ha che $n_1<n$, $n_2<n$ e $n=n_1+n_2$. Per ipotesi induttiva, si ha che $m_1=n_1-1$ e $m_2=n_2-1$, di conseguenza: $m = m_1+m_2+1 = (n_1-1)+(n_2-1)+1 = n_1+n_2-1 = n-1$, da cui la tesi.
<!--SR:!2026-07-08,3,250-->

Teorema di caratterizzazione di un albero
?
**Teorema 2.1.6:** Dato un grafo $\mathcal{G}=(V,E)$ tale che $|V|=n$ e $|E|=m$ i seguenti fatti sono equivalenti:
(i) $\mathcal{G}$ è un albero (aciclico e connesso);
(ii) $\mathcal{G}$ è connesso e $m=n-1$;
(iii) $\mathcal{G}$ è aciclico e $m=n-1$.
**Dimostrazione:**
- $(i) \Rightarrow (ii)$: Immediato dal Teorema 2.1.5.
- $(ii) \Rightarrow (iii)$: Dobbiamo provare che $\mathcal{G}$ è aciclico. Supponiamo per assurdo che abbia un ciclo ed eliminiamo uno spigolo $e=(x,y)$ da quest'ultimo. Ovviamente, il grafo $\mathcal{G} \setminus \{e\}$ rimane ancora connesso. Iteriamo la procedura fino ad ottenere un grafo $\mathcal{G}'$ aciclico e sempre connesso, quindi un albero. Per l'implicazione precedente, $\mathcal{G}'$ avrà $m=n-1$ spigoli, assurdo poiché sono stati tolti spigoli di $\mathcal{G}$ (almeno uno).
- $(iii) \Rightarrow (i)$: Siano $\mathcal{G}_1, \dots, \mathcal{G}_k$ i grafi generati dalle componenti connesse di $\mathcal{G}$. Poiché ogni $\mathcal{G}_i$ è connesso e aciclico allora ciascuno di essi è un albero, quindi $m_i=n_i-1$ per ogni $i$. Di conseguenza $m = \sum m_i = \sum (n_i - 1) = n - k$. Per ipotesi $m=n-1$, quindi deve aversi che $n-1 = n-k \iff k=1$. Essendoci una sola componente connessa, il grafo è un albero.
<!--SR:!2026-07-08,3,250-->

Proposizione sulla creazione di cicli negli alberi
?
**Proposizione 2.1.1:** Dato un albero $\mathcal{G}$, comunque si prendano due vertici $x, y \in V$ non adiacenti, esiste nel grafo $\mathcal{G}+(x,y)$ uno ed un solo ciclo.
**Dimostrazione:** Essendo $\mathcal{G}$ un albero, dal Teorema 2.1.3 si ha che presi due qualunque vertici $x, y \in V$ esiste una catena che li congiunge. Se a questa catena aggiungiamo lo spigolo $(x, y)$ si verrà a formare un ciclo nel nuovo grafo $\mathcal{G}'=\mathcal{G}+(x,y)$.
<!--SR:!2026-07-08,3,250-->

Proposizione sulle foglie (vertici di grado 1)
?
**Proposizione 2.1.2:** Dato un albero $\mathcal{G}$, esistono almeno due vertici di grado 1.
**Dimostrazione:** Poiché $\mathcal{G}$ è un albero, sappiamo che $m=n-1$. Supponendo di avere $k$ vertici di grado 1 ed i restanti $n-k$ di grado maggiore a 1, applicando l'handshaking lemma si ottiene: $2m = 2(n-1) = \sum_{v \in V} d(v) \ge k + 2(n-k)$. Da ciò segue: $2(n-1) \ge k + 2(n-k) \iff 2n - 2 \ge 2n - k \iff k \ge 2$.
<!--SR:!2026-07-08,3,250-->

Proposizione sulla bipartizione degli alberi
?
**Proposizione 2.2.1:** Se $\mathcal{G}$ è un albero allora è bipartito.
**Dimostrazione:** Dopo aver effettuato la suddivisione dell'albero in level classes, basta indicare con A l'insieme dei vertici che stanno nei livelli di grado pari e con B l'insieme dei vertici che stanno nei livelli di grado dispari. È immediato verificare che tali insiemi costituiscono una partizione di V che soddisfa la definizione di grafo bipartito.
<!--SR:!2026-07-08,3,250-->

Teorema sull'unicità del costo dell'albero di economia (MST) in grafi completi
?
**Teorema 2.3.1:** Siano $\mathcal{K}_n=(V,E)$ un grafo completo su $n$ vertici e $\varphi:E \rightarrow \mathbb{R}^+$ la funzione costo. Se $\mathcal{A}$ è l'albero di costo minimo (MTS) ottenuto dall'algoritmo di Kruskal e $\mathcal{T}$ è un altro albero di costo minimo di $\mathcal{K}_n$, allora $c(\mathcal{A}) = c(\mathcal{T})$.
**Dimostrazione:** Banalmente, se $\mathcal{A}=\mathcal{T}$ la tesi è ovvia. Sia dunque $\mathcal{A} \neq \mathcal{T}$; denotiamo con $e_1, e_2, \dots, e_n$ gli spigoli di $\mathcal{A}$ e con $f_1, f_2, \dots, f_n$ gli spigoli di $\mathcal{T}$, e sia $k$ il primo indice in cui i due alberi hanno uno spigolo diverso. Aggiungiamo lo spigolo $e_k$ di $\mathcal{A}$ in $\mathcal{T}$ ottenendo il grafo $\mathcal{T}' = \mathcal{T} + \{e_k\}$, il quale forma uno ed un solo ciclo $C$ contenente $e_k$. Esiste almeno uno spigolo $e'$ di $\mathcal{T}$ nel ciclo $C$ che non esiste in $\mathcal{A}$. Eliminando $e'$ si ottiene il grafo $\mathcal{T}_1 = \mathcal{T} + \{e_k\} \setminus \{e'\}$, il quale è un altro albero su $n$ vertici il cui costo è $c(\mathcal{T}_1) = c(\mathcal{T}) + c(e_k) - c(e')$. Poiché $\mathcal{A}$ è un MST, $c(e_k) \le c(e')$, quindi $c(\mathcal{T}_1) \le c(\mathcal{T})$. Dato che $\mathcal{T}$ è un albero di costo minimo, $c(\mathcal{T}) \le c(\mathcal{T}_1)$, ne consegue $c(\mathcal{T}) = c(\mathcal{T}_1)$. Iterando l'argomento e aumentando gli spigoli in comune si ottiene un albero di costo minimo i cui spigoli sono coincidenti con quelli di $\mathcal{A}$, da cui $c(\mathcal{A}) = c(\mathcal{T})$.
<!--SR:!2026-07-08,3,250-->

Definizione di Grafo Etichettato
?
Un grafo $\mathcal{G}$ si dice etichettato se i vertici sono muniti di una etichetta.
<!--SR:!2026-07-08,3,250-->

Teorema di Cayley
?
**Teorema 2.4.2 (Cayley, 1899):** Il numero di alberi etichettati su $n$ vertici è $n^{n-2}$.
**Dimostrazione:** La dimostrazione si fonda sul codice di Prüfer, che costruisce una corrispondenza biunivoca tra l'insieme degli alberi etichettati su $n$ vertici e l'insieme delle sequenze $(a_1, a_2, \dots, a_{n-2})$ con la proprietà che $1 \le a_i \le n$. Poiché ogni elemento della sequenza può essere scelto in $n$ modi e la sequenza ha lunghezza $n-2$, il numero totale di sequenze (e quindi di alberi) è $n^{n-2}$.
<!--SR:!2026-07-08,3,250-->

Corollario al Teorema di Cayley
?
**Corollario 2.4.1:** Il numero di spanning trees di $\mathcal{K}_n$ è $n^{n-2}$.
<!--SR:!2026-07-08,3,250-->

Descrizione algoritmo di Kruskal
?
Scegli sempre l'arco di peso minimo che lega dei vertici non già appartenenti all'albero.
<!--SR:!2026-07-08,3,250-->
