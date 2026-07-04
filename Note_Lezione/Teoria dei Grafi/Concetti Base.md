#flashcards

Definizione di Grafo non orientato
?
Si definisce grafo non orientato o semplicemente grafo (graph) una coppia
G = (V, E), dove V è un insieme finito non vuoto ed E ⊆ V × V è una relazione simmetrica
definita sull'insieme V .
<!--SR:!2026-07-07,3,250-->

Definizione di Spigoli incidenti
?
Due spigoli e, e′ ∈ E si dicono incidenti se hanno un vertice in comune (e = (u, v), e′ = (v, w)). Due vertici u, v ∈ V si dicono adiacenti se esiste uno spigolo che li congiunge (∃e ∈ E t.c. e = (u, v)). Diremo anche che uno spigolo e ∈ E è incidente in un vertice v ∈ V se v è un suo estremo (e = (u, v) o e = (v, u)).

Definizione di ordine del Grafo
?
Si definisce ordine di G il numero n = |V |.

Definizione di grado di un vertice
?
Per ogni vertice v ∈ V si definisce grado di v il numero di spigoli incidenti in tale vertice e si indica con d(v).
<!--SR:!2026-07-07,3,250-->

Definizione di vertice isolato e universale
?
vertici di G tali che d(v) = 0 sono detti isolati (non sono adiacenti a nessun vertice del grafo); i vertici tali che d(v) = n − 1, dove n = |V |, sono detti universali (sono adiacenti a tutti i vertici del grafo).
<!--SR:!2026-07-07,3,250-->

Definizione di grafo orientato o digrafo
?
Si definisce grafo orientato o digrafo (digraph) una coppia G = (V, E), dove V è un insieme finito non vuoto ed E ⊆ V × V è una relazione definita sull'insieme V .
<!--SR:!2026-07-07,3,250-->

Definizione di grado di entrata e di uscita
?
Dato un digrafo G = (V, E), per ogni vertice v ∈ V si definisce grado di
entrata (in-degree) di v il numero di archi aventi v come secondo estremo e si indica con de (v); si definisce grado di uscita (out-degree) di v il numero di archi aventi v come primo estremo e si indica con du (v). Si definisce grado di v il numero di archi entranti ed uscenti di v, ovvero d(v) = de (v) + du (v).
<!--SR:!2026-07-07,3,250-->

Definizione di pozzo e sorgente
?
Un vertice v ∈ V tale che d(v) = 0 si definisce isolato (nessun arco sarà
entrante o uscente da v); un vertice s ∈ V tale che $d_e$(s) = 0 si definisce sorgente; un vertice p ∈ V tale che $d_u$(p) = 0 si definisce pozzo.
<!--SR:!2026-07-07,3,250-->

Definizione di grafo pesato
?
![[Pasted image 20260704161540.png]]
<!--SR:!2026-07-07,3,250-->

Definizione di Loop
?
Dato un grafo (risp. digrafo) G = (V, E), se e = (u, v) è uno spigolo (risp. arco) tale che u = v, allora e si definisce loop o cappio.

Definizione di multigrafo
?
Si definisce multigrafo non orientato (o multigrafo) una (n + 1)−upla ordinata M = (V, E1 , ..., En ) dove V è un insieme non vuoto finito ed E1 , ..., En sono n relazioni simmetriche definite in V .
<!--SR:!2026-07-07,3,250-->

Definizione di multigrafo orientato
?
Si definisce multigrafo orientato (o multidigrafo) una (n + 1)−upla ordinata M = (V, E1 , ..., En ) dove V è un insieme non vuoto finito ed E1 , ..., En sono n relazioni definite in V.
<!--SR:!2026-07-07,3,250-->

Definizione di intorno aperto e intorno chiuso
?
Dato un vertice v ∈ V , si definisce intorno aperto (open neighborhood ) di v l’insieme N (v) = {u ∈ V | (v, u) ∈ E}, anche detto insieme dei vicini di v.
Dato un vertice v ∈ V , si definisce intorno chiuso (closed neighborhood )
di v l’insieme N [v] = N (v) ∪ {v}.

Quando un vertice domina un altro
?
In alcuni testi, un vertice v ∈ V domina un vertice u ∈ V se v è adiacente a tutti i vertici adiacenti ad u. In questo senso, il concetto di "dominante" può anche essere esteso ad un insieme di vertici.
<!--SR:!2026-07-07,3,250-->

Cosa è un insieme dominante e il numero dominante
?
Un insieme X ⊆ V si definisce insieme dominante (dominating set) se $$N[X] = V = \bigcup N[v]$$
Poiché un grafo può ammettere più insiemi dominanti, si definisce numero
dominante (domination number ) la cardinalità minima di un insieme dominante.

Definizione di cammino
?
Dati due vertici u, v ∈ V , si definisce catena o cammino (walk ) di estremi
u e v una sequenza finita di spigoli del tipo
$$C(u, v) = ((u = v_0 , v_1 ), (v_1 , v_2 ), . . . , (v_{m−1} , v_m = v))$$
in cui due spigoli consecutivi qualsiasi sono adiacenti o identici. A sua volta, un tale cammino determinerà una sequenza di vertici $u = v_0 , v_1 , . . . , v_m = v$ dove u sarà detto vertice iniziale e v sarà detto vertice finale.

Definizione di cammino elementare e cammino semplice
?
Un cammino C(u, v) si dice elementare o percorso (path) se i vertici che la compongono sono tutti distinti, si dice semplice o tracciato (trail ) se gli spigoli che la compongono sono tutti distinti.
<!--SR:!2026-07-07,3,250-->

Definizione di Ciclo
?
Fissati k vertici tutti distinti v1 , v2 , . . . , vk ∈ V , con k ≥ 3, si dice che essi
formano un ciclo (cycle) Ck di lunghezza k se esiste una catena elementare Pk = C(v1 , vk ) e
(v1 , vk ) ∈ E.

Definizione di Corda e Grafo Cordale
?
Dato un cammino elementare Pk (o un ciclo Ck ) si definisce corda di Pk (o di Ck ) uno spigolo e = (viq , vir ) ∈ E tale che viq , vir ∈ V ed e non è uno spigolo di Pk (o di Ck ).
Un grafo si dice cordale se ogni ciclo di lunghezza k ≥ 4 in esso contenuto possiede almeno una corda.

Distanza tra due vertici
?
![[Pasted image 20260704165158.png]]

Cosa è una componente connessa
?
![[Pasted image 20260704164745.png]]

Definizione di Fortemente connesso
?
Un digrafo G si dice fortemente connesso se per ogni coppia di vertici
u, v ∈ V esiste un cammino orientato C(u, v) e C(v, u).

Definizione di Cut-Vertex e Cut-Edge
?
Dato G un grafo connesso, un vertice v ∈ V si chiama cut-vertex (punto di articolazione) se G/{v} non è più connesso. Uno spigolo e ∈ E si chiama cut-edge (istmo, ponte) se G/{e} non è più connesso.
<!--SR:!2026-07-07,3,250-->

Handshaking Lemma
?
![[Pasted image 20260704164939.png]]

Corollario handshaking lemma
?
![[Pasted image 20260704165002.png]]
<!--SR:!2026-07-07,3,250-->

Grafo Nullo
?
Un grafo si definisce nullo se V ̸= ∅ ed E = ∅.

Grafo completo
?
Un grafo si dice completo se ogni suo vertice è adiacente a tutti gli altri vertici, ovvero se per ogni v ∈ V, d(v) = n − 1, con n = |V |.

Grafo p-regolare
?
Un grafo si dice regolare se ∆(G) = δ(G). In particolare, se ∆(G) = δ(G) = p, allora il grafo si dice p−regolare o regolare di grado p.
<!--SR:!2026-07-07,3,250-->

Grafo cammino, ciclo e ruota
?
Un grafo di ordine n costituito da un solo ciclo (sugli n vertici) si chiama grafo ciclo (cycle graph) e si indica Cn . Un grafo ottenuto da Cn rimuovendo uno spigolo si definisce grafo cammino (path graph) su n vertici e si denota con Pn . Un grafo ottenuto da Cn−1 unendo ogni vertice ad un nuovo vertice v ∈ V si definisce ruota (wheel ) su n vertici e si denota con Wn .
<!--SR:!2026-07-07,3,250-->

Insieme stabile
?
Un insieme T ⊆ V si dice stabile se esso non contiene vertici adiacenti, cioè per ogni u, v ∈ T, (u, v) $\notin$  E.
<!--SR:!2026-07-07,3,250-->

Grafo bipartito
?
![[Pasted image 20260704165344.png]]


Grafo Cubo
?
Si definisce un grafo cubo di ordine k, o un k−cubo, un grafo tale che i vertici corrispondono ad una k−upla (a0 , a1 , ..., ak ) a coefficienti in {0, 1} assegnati in modo tale due k−uple sono adiacenti se e solo se differiscono per una ed una sola componente. Denotiamo tale grafo con Qk .

Definizione di sottografo
?
Si definisce sottografo di G il grafo G ′ = (V ′ , E ′ ) tale che V ′ ⊆ V ed E ′ ⊆ E.
<!--SR:!2026-07-07,3,250-->

Definizione di sottografo indotto
?
Si definisce sottografo indotto (induced subgraph) di G il sottografo G ′ = (V ′ , E ′ ) tale che V ′ ⊆ V ed E ′ = {(u, v) ∈ E | u, v ∈ V ′ }.

Definizione di grafo parziale
?
Si definisce grafo parziale di G (spanning subgraph) il sottografo G ′ = (V ′ , E ′ ) tale che V = V ′ ed E ′ ⊆ E.

Definizione di isomorfismo
?
![[Pasted image 20260704165615.png]]
<!--SR:!2026-07-07,3,250-->

Definizione di matrice di adiacenze e di incidenza
?
![[Pasted image 20260704165700.png]]
![[Pasted image 20260704165713.png]]
