#flashcards/edgecoloring

Teorema 7.1.5
?
**Enunciato:** Se $G$ è un grafo bipartito, allora il suo indice cromatico coincide con il suo grado massimo. In simboli: $\chi'(G) = \Delta(G)$.

Teorema 7.1.6
?
**Enunciato:** Per il grafo completo $K_n$, l'indice cromatico $\chi'(K_n)$ è pari a $n-1$ se $n$ è pari, ed è pari a $n$ se $n$ è dispari.

Teorema 7.1.7
?
**Enunciato:** Se $G$ è un grafo regolare di grado $k$ avente un numero dispari di vertici, allora il suo indice cromatico è strettamente maggiore del suo grado. In simboli: $\chi'(G) = k + 1$.

Teorema 7.1.8 (Teorema di Vizing)
?
**Enunciato:** Per ogni grafo semplice $G$, l'indice cromatico $\chi'(G)$ è limitato dal grado massimo $\Delta(G)$ secondo la seguente disuguaglianza: 
$$\Delta(G) \le \chi'(G) \le \Delta(G) + 1$$

Definizione 7.2.1 (Problema della classificazione)
?
In base al Teorema di Vizing, il problema della classificazione divide i grafi semplici in due classi in base al loro indice cromatico:
- **Classe 1**: Un grafo $G$ è di Classe 1 se il suo indice cromatico è uguale al suo grado massimo, ovvero $\chi'(G) = \Delta(G)$.
- **Classe 2**: Un grafo $G$ è di Classe 2 se il suo indice cromatico è uguale al suo grado massimo più uno, ovvero $\chi'(G) = \Delta(G) + 1$.

Definizione e proprietà del Grafo di Petersen
?
**Definizione:** Il grafo di Petersen è un grafo non orientato e semplice, costituito da 10 vertici e 15 spigoli. Si può costruire associando i vertici ai sottoinsiemi di 2 elementi di un insieme di 5 elementi; due vertici sono adiacenti se e solo se i rispettivi sottoinsiemi sono disgiunti.
**Proprietà principali:**
- È un grafo 3-regolare (o cubico).
- Ha calibro (girth) pari a 5, il che significa che il ciclo più corto al suo interno ha lunghezza 5.
- Non è hamiltoniano (non contiene un ciclo che visita tutti i vertici esattamente una volta).
- Riguardo al problema della classificazione, è un grafo di Classe 2, avendo grado massimo 3 ma necessitando di 4 colori per colorare gli spigoli ($\chi'(G) = 4$).
- Non è un grafo planare.

Definizione di Grafo di Linea (Line Graph)
?
Dato un grafo $G = (V,E)$, si definisce grafo di linea di $G$, denotato con $L(G)$, il grafo costruito nel seguente modo:
1. I vertici di $L(G)$ sono in corrispondenza biunivoca con gli spigoli di $G$.
2. Due vertici di $L(G)$ sono adiacenti (collegati da uno spigolo) se e solo se i rispettivi spigoli nel grafo originario $G$ sono incidenti, ossia condividono almeno un vertice.