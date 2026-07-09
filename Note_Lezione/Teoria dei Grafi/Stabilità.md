#flashcards/stabilita

Definizione di insieme internamente stabile (o indipendente) e numero di stabilità interna
?
In un grafo $G=(V,E)$, un sottoinsieme di vertici $S \subseteq V$ si dice internamente stabile (o indipendente) se non esistono due vertici in $S$ che siano adiacenti tra loro. Il numero di stabilità interna di $G$, indicato con $\alpha(G)$, è la cardinalità del più grande insieme internamente stabile del grafo.

Definizione di insieme esternamente stabile (o dominante) e numero di stabilità esterna
?
In un grafo $G=(V,E)$, un sottoinsieme di vertici $D \subseteq V$ si dice esternamente stabile (o dominante) se ogni vertice che non appartiene a $D$ è adiacente ad almeno un vertice appartenente a $D$. Il numero di stabilità esterna (o numero di dominazione) di $G$, indicato con $\gamma(G)$, è la cardinalità del più piccolo insieme esternamente stabile del grafo.

Teorema (Relazione tra stabilità interna e copertura dei vertici)
?
**Enunciato:** Dato un grafo $G=(V,E)$ di ordine $n$, un sottoinsieme di vertici $S$ è internamente stabile se e solo se il suo complementare $V \setminus S$ è una copertura dei vertici (ovvero ogni spigolo di $G$ ha almeno un estremo in $V \setminus S$). Ne consegue che $\alpha(G) + \tau(G) = n$, dove $\tau(G)$ è il numero minimo di copertura dei vertici.

Teorema (Relazione tra stabilità interna e cricca)
?
**Enunciato:** Un sottoinsieme di vertici $S$ è internamente stabile in un grafo $G$ se e solo se $S$ induce una cricca (sottografo completo) nel grafo complementare $\overline{G}$. Di conseguenza, il numero di stabilità interna di un grafo coincide con il numero di cricca del suo complementare: $\alpha(G) = \omega(\overline{G})$.

Applicazione: Il grafo delle regine (Stabilità Interna)
?
Il grafo delle regine si costruisce associando un vertice a ciascuna delle 64 caselle di una scacchiera $8 \times 8$; due vertici sono uniti da uno spigolo se due regine posizionate in quelle caselle si attaccherebbero a vicenda (stessa riga, colonna o diagonale). 
Nel senso della **stabilità interna**, il problema consiste nel trovare il numero massimo di regine che possono essere collocate sulla scacchiera senza che si attacchino reciprocamente (problema delle 8 regine). La soluzione corrisponde a trovare l'insieme internamente stabile massimo del grafo, e il numero di stabilità interna in questo caso è $\alpha(G) = 8$.

Applicazione: Il grafo delle regine (Stabilità Esterna)
?
Mantenendo la definizione del grafo delle regine, nel senso della **stabilità esterna** il problema consiste nel determinare il numero minimo di regine da disporre sulla scacchiera affinché ogni casella rimasta vuota sia minacciata (dominata) da almeno una regina. Matematicamente, significa cercare un insieme esternamente stabile (dominante) di cardinalità minima. Per una scacchiera standard $8 \times 8$, il numero di stabilità esterna è $\gamma(G) = 5$.

Applicazione: Il problema dei ripetitori TV
?
In questa applicazione, si costruisce un grafo in cui i vertici rappresentano le postazioni dei ripetitori TV e si inserisce uno spigolo tra due ripetitori se le loro aree di copertura si sovrappongono (cioè se causerebbero interferenza trasmettendo sulla stessa frequenza). 
La **stabilità interna** risponde alla domanda: qual è il numero massimo di ripetitori che possono trasmettere simultaneamente sulla *stessa* frequenza senza causare interferenze? Questo corrisponde a trovare l'insieme internamente stabile massimo del grafo. Per estensione, se si vuole assegnare una frequenza a tutti i ripetitori senza conflitti, si ricorre alla colorazione dei vertici, dove il numero cromatico indica il numero minimo di frequenze totali necessarie.

Definizione di nucleo (kernel) di un grafo
?
In un grafo $G=(V,E)$, un sottoinsieme di vertici $K \subseteq V$ si definisce **nucleo** se è contemporaneamente un insieme internamente stabile (indipendente) ed esternamente stabile (dominante). Ciò significa che:
1) Nessuna coppia di vertici in $K$ è unita da uno spigolo;
2) Ogni vertice al di fuori di $K$ è adiacente ad almeno un vertice di $K$.

Teorema di caratterizzazione dei nuclei nei grafi non orientati
?
**Enunciato:** In un grafo non orientato $G$, un sottoinsieme di vertici $K$ è un nucleo se e solo se è un insieme internamente stabile massimale (ovvero un insieme indipendente che non può essere ampliato con l'aggiunta di altri vertici senza perdere la proprietà di stabilità).

Definizione di eccentricità di un vertice
?
Dato un grafo connesso $G=(V,E)$, l'**eccentricità** $e(v)$ di un vertice $v \in V$ è la massima distanza (lunghezza del cammino minimo) tra $v$ e un qualsiasi altro vertice del grafo. In simboli:
$$e(v) = \max_{u \in V} d(v,u)$$

Definizione di raggio e diametro di un grafo
?
Dato un grafo connesso $G=(V,E)$ e indicata con $e(v)$ l'eccentricità dei suoi vertici:
- Il **raggio** $r(G)$ è il valore minimo di eccentricità nel grafo: $r(G) = \min_{v \in V} e(v)$.
- Il **diametro** $d(G)$ è il valore massimo di eccentricità nel grafo: $d(G) = \max_{v \in V} e(v)$.

Definizione di centro di un grafo
?
Il **centro** di un grafo $G=(V,E)$, denotato con $C(G)$, è il sottoinsieme di vertici la cui eccentricità è esattamente uguale al raggio del grafo. In simboli:
$$C(G) = \{v \in V \mid e(v) = r(G)\}$$

Teorema di Jordan sui centri degli alberi
?
**Enunciato:** Il centro di ogni albero è costituito da un solo vertice oppure da due vertici adiacenti.