#flashcards

Definizione di Grafo non orientato
?
Si definisce grafo non orientato o semplicemente grafo (graph) una coppia
G = (V, E), dove V è un insieme finito non vuoto ed E ⊆ V × V è una relazione simmetrica
definita sull'insieme V .

Definizione di Spigoli incidenti
?
Due spigoli e, e′ ∈ E si dicono incidenti se hanno un vertice in comune (e = (u, v), e′ = (v, w)). Due vertici u, v ∈ V si dicono adiacenti se esiste uno spigolo che li congiunge (∃e ∈ E t.c. e = (u, v)). Diremo anche che uno spigolo e ∈ E è incidente in un vertice v ∈ V se v è un suo estremo (e = (u, v) o e = (v, u)).

Definizione di ordine del Grafo
?
Si definisce ordine di G il numero n = |V |.

Definizione di grado di un vertice
?
Per ogni vertice v ∈ V si definisce grado di v il numero di spigoli incidenti in tale vertice e si indica con d(v).

Definizione di vertice isolato e universale
?
vertici di G tali che d(v) = 0 sono detti isolati (non sono adiacenti a nessun vertice del grafo); i vertici tali che d(v) = n − 1, dove n = |V |, sono detti universali (sono adiacenti a tutti i vertici del grafo).

Definizione di grafo orientato o digrafo
?
Si definisce grafo orientato o digrafo (digraph) una coppia G = (V, E), dove V è un insieme finito non vuoto ed E ⊆ V × V è una relazione definita sull'insieme V .

Definizione di grado di entrata e di uscita
?
Dato un digrafo G = (V, E), per ogni vertice v ∈ V si definisce grado di
entrata (in-degree) di v il numero di archi aventi v come secondo estremo e si indica con de (v); si definisce grado di uscita (out-degree) di v il numero di archi aventi v come primo estremo e si indica con du (v). Si definisce grado di v il numero di archi entranti ed uscenti di v, ovvero d(v) = de (v) + du (v).

Definizione di pozzo e sorgente
?
Un vertice v ∈ V tale che d(v) = 0 si definisce isolato (nessun arco sarà
entrante o uscente da v); un vertice s ∈ V tale che $d_e$(s) = 0 si definisce sorgente; un vertice p ∈ V tale che $d_u$(p) = 0 si definisce pozzo.

Definizione di grafo pesato
?
![[Pasted image 20260704161540.png]]

Definizione di Loop
?
Dato un grafo (risp. digrafo) G = (V, E), se e = (u, v) è uno spigolo (risp. arco) tale che u = v, allora e si definisce loop o cappio.

Definizione di multigrafo
?
Si definisce multigrafo non orientato (o multigrafo) una (n + 1)−upla ordinata M = (V, E1 , ..., En ) dove V è un insieme non vuoto finito ed E1 , ..., En sono n relazioni simmetriche definite in V .
