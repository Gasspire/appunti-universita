#flashcards/hamiltoniani_euleriani
Definizione di Ciclo euleriano e Grafo euleriano
?
Dato un grafo $\mathcal{G}=(V,E)$ connesso, un ciclo C di G si definisce euleriano se contiene tutti gli spigoli di G una ed una sola volta. Un grafo connesso G si dice euleriano se contiene almeno un ciclo euleriano.
<!--SR:!2026-07-08,3,250-->

Proposizione sull'esistenza di un ciclo
?
**Proposizione 3.1.1:** Se in un grafo $\mathcal{G}=(V,E)$ ogni vertice ha almeno grado 2 allora G contiene un ciclo.
**Dimostrazione:** Se G è un multigrafo, la tesi risulta immediata. Supponiamo che G sia un grafo semplice, e consideriamo un cammino elementare P di lunghezza massima, cioè tale da contenere tutti i vertici del grafo. Sia $z$ uno degli estremi di P. Poiché ogni vertice ha grado almeno 2, anche $z$ possiede almeno due vicini, diciamo $y$ e $z$. Essendo P un cammino massimo, necessariamente i vertici $y$ e $z$ appartengono a P. Ne segue che i vertici, insieme agli spigoli che li collegano, formano un ciclo.
<!--SR:!2026-07-08,3,250-->

Definizione di Decomposizione di un grafo
?
Si chiama decomposizione di un grafo G una famiglia $\mathcal{F}$ di sottografi $F\subseteq\mathcal{G}$ disgiunti che formano una partizione di G, cioè: l'unione dei loro spigoli è $E(\mathcal{G})$ e la loro intersezione è vuota.
<!--SR:!2026-07-08,3,250-->

Teorema di caratterizzazione dei grafi euleriani
?
**Teorema 3.1.4:** Sia $\mathcal{G}=(V,E)$ un grafo connesso, allora i seguenti fatti sono equivalenti: (i) G è euleriano; (ii) i vertici di G hanno tutti grado pari; (iii) esiste una decomposizione di $\mathcal{G}$ in cicli.
**Dimostrazione:** - $(i) \Rightarrow (ii)$: Se G ha un ciclo euleriano C, ogni volta che si entra in un vertice si deve poi uscirne, dunque gli spigoli incidenti a un vertice si raggruppano in coppie (entrata/uscita). Ciò implica che il grado di ciascun vertice deve essere pari.
- $(ii) \Rightarrow (iii)$: Il grado di ogni vertice è pari, per la Proposizione 3.1.1 esiste un ciclo $C_1$. Se $\mathcal{G}=C_1$, la tesi è provata. Se $\mathcal{G} \neq C_1$, si elimina $C_1$ per ottenere $\mathcal{G}_2$. I vertici in $\mathcal{G}_2$ hanno ancora grado pari, quindi esiste un altro ciclo $C_2$. L'iterazione andrà avanti determinando una decomposizione di G in cicli.
- $(iii) \Rightarrow (i)$: Sia $\mathcal{C}$ una decomposizione di G in cicli. Se $\mathcal{G}$ non è un unico ciclo, consideriamo due cicli che hanno un vertice in comune e uniamoli percorrendo prima uno e poi l'altro. Iterando questo procedimento per tutti i cicli della decomposizione, si otterrà un unico ciclo euleriano.
<!--SR:!2026-07-08,3,250-->

Definizione di Cammino hamiltoniano e Grafo hamiltoniano
?
Dato un grafo $\mathcal{G}=(V,E)$, un cammino si dice hamiltoniano se contiene tutti i vertici di G una ed una sola volta. Un grafo G si dice hamiltoniano se contiene un cammino hamiltoniano chiuso, ossia un ciclo hamiltoniano.
<!--SR:!2026-07-08,3,250-->

Teorema sul grado e la connessione del grafo
?
**Teorema 3.3.3:** Dato un grafo $\mathcal{G}=(V,E)$ con $|V|=n \ge 3$ tale che per ogni $v\in V$, $d(v)\ge \frac{n}{2}$, allora G è connesso.
**Dimostrazione:** Siano $u, v \in V$ due vertici non adiacenti. Per ipotesi $d(u)+d(v) \ge n$. Essendo $u$ e $v$ non adiacenti, i loro spigoli si collegano ai restanti $n-2$ vertici. Per ottenere la somma $\ge n$, deve esistere almeno un vertice adiacente sia a $u$ sia a $v$. Ciò garantisce un cammino tra $u$ e $v$, quindi G è connesso.
<!--SR:!2026-07-08,3,250-->

Teorema di Ore (condizione sufficiente per grafi hamiltoniani)
?
**Teorema 3.3.4 (Ore, 1960):** Sia $\mathcal{G}=(V,E)$ un grafo semplice con $|V|=n \ge 3$. Se tutti i vertici $u,v \in V$ non adiacenti sono tali che $d(u)+d(v)\ge n$ allora G è hamiltoniano.
**Dimostrazione:** Supponiamo per assurdo che G non sia hamiltoniano. Aggiungiamo spigoli fino a ottenere un grafo $\mathcal{G}'$ tale che l'aggiunta di un ulteriore spigolo creerebbe un ciclo hamiltoniano. $\mathcal{G}'$ possiede almeno un cammino hamiltoniano $(v_1, \dots, v_n)$, dove l'unico spigolo mancante per chiudere il ciclo è $(v_1, v_n)$. Se esistesse l'arco $(v_1, v_i)$, allora non potrebbe esistere $(v_{i-1}, v_n)$, altrimenti si formerebbe un ciclo hamiltoniano. Questo implica che $d(v_1) + d(v_n) \le n-1$, assurdo poiché per ipotesi la loro somma deve essere $\ge n$.
<!--SR:!2026-07-08,3,250-->

Teorema di Dirac
?
**Teorema 3.3.5 (Dirac, 1952):** Sia un grafo $\mathcal{G}=(V,E)$ semplice con $|V|=n \ge 3$ e tale che per ogni $u \in V$, $d(u)\ge \frac{n}{2}$, allora G è hamiltoniano.
**Dimostrazione:** Date le ipotesi, per ogni coppia di vertici $u, v$ si ha che $d(u)+d(v) \ge \frac{n}{2}+\frac{n}{2}=n$. Risultano quindi verificate le ipotesi del teorema di Ore, da cui consegue la tesi.
<!--SR:!2026-07-08,3,250-->

Teorema di Bondy-Chvatal
?
**Teorema 3.3.6 (Bondy-Chvatal, 1976):** Sia $\mathcal{G}=(V,E)$ un grafo semplice con $n \ge 3$ e siano $u,v \in V$ non adiacenti tali che $d(u)+d(v)\ge n$. Allora $\mathcal{G}+(u,v)$ è hamiltoniano se e solo se G è hamiltoniano.
**Dimostrazione:** Se G è hamiltoniano, lo sarà a fortiori anche $\mathcal{G}+(u,v)$. Se per assurdo $\mathcal{G}+(u,v)$ fosse hamiltoniano ma G no, ci ritroveremmo nelle condizioni della dimostrazione del teorema di Ore per il grafo massimale non hamiltoniano, che porterebbe a $d(u)+d(v) \le n-1$, contraddicendo l'ipotesi.
<!--SR:!2026-07-08,3,250-->

Definizione di chiusura di un grafo
?
Dato un grafo $\mathcal{G}=(V,E)$, si definisce chiusura di G il grafo ottenuto ricorsivamente unendo vertici non adiacenti la cui somma dei gradi è $\ge n$, iterando fino ad esaurimento di tali vertici.
<!--SR:!2026-07-08,3,250-->

Il grafo del cavallo
?
**Problema:** Data una scacchiera $n\times n$, è possibile muovere il cavallo occupando tutte le caselle una ed una sola volta e ritornare alla casella di partenza?
**Formulazione:** Considerando un grafo i cui vertici sono le caselle e gli spigoli le mosse a "L" del cavallo, la ricerca di un percorso aperto equivale a cercare un cammino hamiltoniano, mentre il percorso chiuso equivale a un ciclo hamiltoniano.
**Soluzione:** Si è dimostrato che esiste un cammino hamiltoniano se e solo se $n \ge 5$ ed esiste un ciclo hamiltoniano se e solo se $n \ge 6$ ed $n$ è pari.
<!--SR:!2026-07-08,3,250-->

Il problema del commesso viaggiatore (TSP)
?
**Problema:** Un commesso viaggiatore deve visitare un certo numero di città e desidera determinare il percorso più breve che gli consenta di partire da una città, visitarle tutte esattamente una volta e tornare al punto di partenza.
**Formulazione:** In un grafo completo $\mathcal{K}_n$ pesato (le distanze sono i pesi), si tratta di determinare un ciclo hamiltoniano di peso minimo.
**Algoritmo risolutivo approssimato:** 1) Si costruisce l'albero ricoprente minimo.
2) Si duplicano i suoi spigoli per ottenere un multigrafo euleriano.
3) Si determina un ciclo euleriano, saltando man mano i vertici già visitati collegandoli direttamente al primo vertice non visitato, così da estrarre un ciclo hamiltoniano di costo al più doppio rispetto alla soluzione ottima.
<!--SR:!2026-07-08,3,250-->

Il problema del postino cinese
?
**Problema:** Determinare un percorso che consenta a un postino di attraversare tutte le strade di sua competenza una e una sola volta, ritornando al punto di partenza minimizzando il percorso.
**Formulazione:** In un grafo pesato (le distanze sono i pesi), si cerca il ciclo euleriano di peso minimo.
**Algoritmo risolutivo:** Se il grafo è euleriano, si cerca semplicemente un ciclo euleriano. Se non lo è (ha vertici di grado dispari), si raddoppiano gli spigoli che connettono le coppie di vertici di grado dispari scegliendo quelli che minimizzano la lunghezza totale dei cammini aggiunti, rendendo così il grafo euleriano, per poi cercarvi il ciclo.
<!--SR:!2026-07-08,3,250-->