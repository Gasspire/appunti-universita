#flashcards/reti-di-flusso

Definizione di rete di flusso, sorgente, pozzo e capacità
?
Una rete di flusso è un grafo orientato $G=(V,E)$ in cui ogni spigolo $(u,v) \in E$ è associato a una capacità non negativa $c(u,v) \ge 0$. Se $(u,v) \notin E$, si assume $c(u,v)=0$. Nella rete si distinguono due vertici particolari:
1) la **sorgente** $s \in V$, che non ha spigoli entranti (o da cui il flusso si genera);
2) il **pozzo** $t \in V$, che non ha spigoli uscenti (o in cui il flusso si esaurisce).

Definizione di flusso ammissibile
?
Data una rete di flusso $G=(V,E)$, un flusso ammissibile è una funzione $f: V \times V \to \mathbb{R}$ che soddisfa le seguenti due proprietà per tutti i vertici $u, v \in V$:
1) **Vincolo di capacità:** Il flusso su uno spigolo non può superare la sua capacità ed è non negativo: $0 \le f(u,v) \le c(u,v)$.
2) **Conservazione del flusso:** Per ogni vertice $u$ diverso dalla sorgente $s$ e dal pozzo $t$, la somma del flusso entrante deve essere uguale alla somma del flusso uscente:
$$\sum_{v \in V} f(v,u) = \sum_{v \in V} f(u,v)$$

Definizione di valore del flusso
?
Il valore di un flusso ammissibile $f$, indicato con $|f|$, rappresenta la quantità totale di flusso che esce dalla sorgente $s$ (o, equivalentemente, che entra nel pozzo $t$). Si definisce formalmente come:
$$|f| = \sum_{v \in V} f(s,v) - \sum_{v \in V} f(v,s)$$

Definizione di taglio in una rete di flusso e capacità del taglio
?
Un taglio $(S,T)$ in una rete di flusso è una partizione dei vertici $V$ in due insiemi disgiunti $S$ e $T = V \setminus S$ tali che la sorgente $s \in S$ e il pozzo $t \in T$.
La **capacità del taglio**, indicata con $c(S,T)$, è la somma delle capacità di tutti gli spigoli orientati che vanno da un vertice di $S$ a un vertice di $T$:
$$c(S,T) = \sum_{u \in S, v \in T} c(u,v)$$
*Nota:* Gli spigoli che tornano da $T$ a $S$ non vengono conteggiati nella capacità del taglio.

Lemma del flusso attraverso un taglio
?
**Enunciato:** In una rete di flusso, il flusso netto attraverso un qualsiasi taglio $(S,T)$ è uguale al valore totale del flusso $|f|$. In simboli:
$$f(S,T) = \sum_{u \in S, v \in T} f(u,v) - \sum_{v \in T, u \in S} f(v,u) = |f|$$

Dimostrazione del Lemma del flusso attraverso un taglio
?
**Dimostrazione:** Sappiamo dalla definizione che il valore del flusso è $|f| = \sum_{v \in V} f(s,v) - \sum_{v \in V} f(v,s)$. Per ogni vertice $u \in S \setminus \{s\}$, la conservazione del flusso impone che $\sum_{v \in V} f(u,v) - \sum_{v \in V} f(v,u) = 0$. 
Sommando questa espressione su tutti i vertici appartenenti a $S$, otteniamo:
$$\sum_{u \in S} \left( \sum_{v \in V} f(u,v) - \sum_{v \in V} f(v,u) \right) = |f|$$
Poiché $V = S \cup T$, possiamo scomporre la sommatoria interna rispetto a $v$:
$$\sum_{u \in S} \left( \sum_{v \in S} f(u,v) + \sum_{v \in T} f(u,v) - \sum_{v \in S} f(v,u) - \sum_{v \in T} f(v,u) \right) = |f|$$
Le sommatorie doppie su $S \times S$ (ovvero $\sum_{u \in S}\sum_{v \in S} f(u,v)$ e $\sum_{u \in S}\sum_{v \in S} f(v,u)$) contengono esattamente gli stessi termini e si elidono a vicenda. Di conseguenza, l'equazione si riduce a:
$$\sum_{u \in S, v \in T} f(u,v) - \sum_{u \in S, v \in T} f(v,u) = |f|$$
che corrisponde precisamente a $f(S,T) = |f|$.

Teorema della limitazione superiore del flusso
?
**Enunciato:** Il valore di un qualsiasi flusso ammissibile $f$ in una rete è sempre minore o uguale alla capacità di un qualsiasi taglio $(S,T)$ della rete stessa. In simboli: $|f| \le c(S,T)$.

Dimostrazione del Teorema della limitazione superiore del flusso
?
**Dimostrazione:** Dal lemma del flusso attraverso un taglio, sappiamo che per un taglio generico $(S,T)$ vale $|f| = \sum_{u \in S, v \in T} f(u,v) - \sum_{v \in T, u \in S} f(v,u)$.
Dato che il vincolo di capacità impone che ogni flusso sia non negativo ($f(v,u) \ge 0$), la seconda sommatoria è non negativa, quindi possiamo scrivere la disuguaglianza:
$$|f| \le \sum_{u \in S, v \in T} f(u,v)$$
Sempre per il vincolo di capacità, sappiamo che per ogni spigolo $f(u,v) \le c(u,v)$. Sostituendo questa relazione nella sommatoria otteniamo:
$$|f| \le \sum_{u \in S, v \in T} c(u,v) = c(S,T)$$
Resta così dimostrato che la capacità di un taglio qualunque funge da maggiorante per il valore del flusso.

Definizione di rete residua e cammino aumentante
?
Dati una rete di flusso $G=(V,E)$ e un flusso ammissibile $f$, si definisce:
1) **Rete residua $G_f$**: Un grafo orientato avente gli stessi vertici di $G$, in cui gli spigoli possiedono una capacità residua $c_f(u,v)$. Per ogni spigolo di $G$, se $f(u,v) < c(u,v)$ si introduce uno spigolo in avanti con capacità $c_f(u,v) = c(u,v) - f(u,v)$; se $f(u,v) > 0$ si introduce uno spigolo all'indietro con capacità $c_f(v,u) = f(u,v)$.
2) **Cammino aumentante**: Un cammino orientato semplice dalla sorgente $s$ al pozzo $t$ all'interno della rete residua $G_f$, in cui ogni spigolo ha capacità residua strettamente positiva.

Teorema del Flusso Massimo - Taglio Minimo (Max-Flow Min-Cut Theorem)
?
**Enunciato:** In una rete di flusso, il valore del flusso massimo è uguale alla capacità del taglio minimo.

Dimostrazione del Teorema del Flusso Massimo - Taglio Minimo
?
**Dimostrazione:** Il teorema si dimostra provando l'equivalenza di tre affermazioni fondamentali:
1) $f$ è un flusso massimo in $G$.
2) La rete residua $G_f$ non contiene alcun cammino aumentante.
3) Esiste un taglio $(S,T)$ tale che $|f| = c(S,T)$.

- **(1) $\implies$ (2):** Ragioniamo per assurdo. Se in $G_f$ esistesse un cammino aumentante da $s$ a $t$, potremmo calcolare la capacità residua minima $\epsilon > 0$ lungo questo cammino e incrementare il flusso in $G$ di una quantità pari a $\epsilon$. Ciò produrrebbe un nuovo flusso ammissibile di valore $|f| + \epsilon$, contraddicendo l'ipotesi che $f$ sia un flusso massimo.
- **(2) $\implies$ (3):** Supponiamo che non esistano cammini aumentanti in $G_f$. Definiamo $S$ come l'insieme di tutti i vertici raggiungibili da $s$ tramite cammini in $G_f$, e sia $T = V \setminus S$. Chiaramente $s \in S$. Poiché non ci sono cammini aumentanti verso il pozzo, $t \notin S$, quindi $t \in T$; $(S,T)$ è dunque un taglio valido. 
Consideriamo un vertice $u \in S$ e un vertice $v \in T$. Lo spigolo $(u,v)$ non può esistere in $G_f$. Questo implica che se lo spigolo orientato esiste in $G$, deve essere saturo, ossia $f(u,v) = c(u,v)$ (altrimenti ci sarebbe uno spigolo in avanti in $G_f$). Analogamente, se esiste lo spigolo $(v,u)$ in $G$, il suo flusso deve essere nullo, $f(v,u) = 0$ (altrimenti ci sarebbe uno spigolo all'indietro in $G_f$). Applicando il Lemma del taglio:
$$|f| = \sum_{u \in S, v \in T} f(u,v) - \sum_{v \in T, u \in S} f(v,u) = \sum_{u \in S, v \in T} c(u,v) - 0 = c(S,T)$$
- **(3) $\implies$ (1):** Poiché per il teorema della limitazione superiore sappiamo che per ogni flusso ammissibile $f'$ vale $|f'| \le c(S,T)$, l'esistenza di un flusso specifico $f$ il cui valore uguaglia esattamente la capacità del taglio implica matematicamente che $f$ ha raggiunto il valore massimo possibile e il taglio la capacità minima.

Descrizione dell'Algoritmo di Ford-Fulkerson
?
L'algoritmo di Ford-Fulkerson è un metodo iterativo per calcolare il flusso massimo in una rete.
**Procedura:**
1. **Inizializzazione:** Si imposta il flusso iniziale $f(u,v) = 0$ per ogni coppia di vertici $u,v \in V$.
2. **Costruzione della rete residua:** Si genera la rete residua $G_f$ corrente associata al flusso $f$.
3. **Ricerca del cammino aumentante:** Si cerca un cammino semplice $P$ da $s$ a $t$ in $G_f$ (ad esempio usando una ricerca in ampiezza BFS, variante nota come algoritmo di Edmonds-Karp, o una ricerca in profondità DFS).
4. **Condizione di arresto:** Se non si trova alcun cammino aumentante, l'algoritmo termina. Il flusso corrente $f$ è il flusso massimo e i vertici raggiungibili da $s$ in $G_f$ definiscono il taglio minimo.
5. **Aggiornamento (Augmenting):** Se il cammino $P$ esiste, si individua la capacità residua minima del cammino: $\epsilon = \min_{(u,v) \in P} c_f(u,v)$.
6. Per ogni spigolo $(u,v) \in P$:
   - se $(u,v)$ è uno spigolo in avanti in $G$, si incrementa il flusso: $f(u,v) \leftarrow f(u,v) + \epsilon$;
   - se $(u,v)$ è uno spigolo all'indietro in $G$ (ovvero lo spigolo originale è $(v,u)$), si riduce il flusso: $f(v,u) \leftarrow f(v,u) - \epsilon$.
7. Si torna al punto 2.