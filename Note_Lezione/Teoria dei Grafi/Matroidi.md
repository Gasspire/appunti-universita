#flashcards/matroidi

Definizione di Matroide (tramite insiemi indipendenti)
?
Una matroide è una coppia $M = (E, \mathcal{I})$ dove $E$ è un insieme finito e $\mathcal{I}$ è una famiglia di sottoinsiemi di $E$ (chiamati **insiemi indipendenti**) che soddisfa i seguenti tre assiomi:
1. **Assioma dell'insieme vuoto:** $\emptyset \in \mathcal{I}$.
2. **Proprietà ereditaria:** Se $A \in \mathcal{I}$ e $B \subseteq A$, allora $B \in \mathcal{I}$ (ogni sottoinsieme di un insieme indipendente è indipendente).
3. **Proprietà di scambio (o di estensione):** Se $A, B \in \mathcal{I}$ con $|A| > |B|$, allora esiste un elemento $x \in A \setminus B$ tale che $B \cup \{x\} \in \mathcal{I}$.

Esempio base di Matroide (Matroide Uniforme)
?
La matroide uniforme $U_{k,n}$ è definita su un insieme $E$ di $n$ elementi. Un sottoinsieme $I \subseteq E$ è considerato indipendente (ovvero appartiene a $\mathcal{I}$) se e solo se la sua cardinalità è minore o uguale a $k$ ($|I| \le k$). Le basi di questa matroide sono tutti i sottoinsiemi di cardinalità esattamente pari a $k$.

Definizione di Matroide Grafica (o Matroide dei cicli)
?
Dato un grafo non orientato $G=(V,E)$, la matroide grafica (o matroide associata a $G$), denotata con $M(G)$, è definita prendendo come insieme di base l'insieme degli spigoli $E$ del grafo. Un sottoinsieme di spigoli $I \subseteq E$ è **indipendente** se non contiene cicli (cioè se il sottografo indotto da $I$ è una foresta). 
**Basi:** Le basi di $M(G)$ corrispondono agli alberi di copertura (spanning trees) del grafo $G$.
**Circuiti:** I circuiti della matroide (i sottoinsiemi dipendenti minimali) corrispondono esattamente ai cicli semplici del grafo.

Definizione di Matroide Trasversale
?
Sia $E$ un insieme finito e sia $\mathcal{A} = \{A_1, A_2, \dots, A_m\}$ una famiglia di sottoinsiemi di $E$. Un sottoinsieme $I \subseteq E$ si dice **trasversale parziale** di $\mathcal{A}$ se esiste una funzione iniettiva da $I$ all'insieme degli indici $\{1, \dots, m\}$ tale che ogni elemento $x \in I$ appartenga al corrispondente insieme $A_{f(x)}$. 
La matroide $M = (E, \mathcal{I})$, dove $\mathcal{I}$ è la famiglia di tutti i trasversali parziali di $\mathcal{A}$, prende il nome di **matroide trasversale**.

Esempio di Matroide Trasversale (Applicazione / Esempio 10.3.1)
?
Consideriamo l'insieme $E = \{1, 2, 3, 4, 5\}$ e la famiglia $\mathcal{A}$ composta dagli insiemi $A_1 = \{1, 2\}$, $A_2 = \{2, 3\}$, $A_3 = \{1, 4\}$.
Un insieme è indipendente se è un trasversale parziale di $\mathcal{A}$. Ad esempio:
- L'insieme $\{1, 2, 4\}$ è indipendente perché possiamo associare $1 \in A_1$, $2 \in A_2$, $4 \in A_3$. (Questa è anche una base, poiché ha cardinalità 3, massima possibile).
- L'insieme $\{1, 2, 3\}$ è indipendente: $1 \in A_1$, $3 \in A_2$, non c'è un elemento per $A_3$, ma è un trasversale *parziale*.
- L'insieme $\{1, 4\}$ è indipendente.

Esercizio tipico (Esercizio 71/72): Dimostrare che i cicli di un grafo formano i circuiti di una matroide
?
In un grafo $G=(V,E)$, si dimostra che la famiglia dei cicli semplici soddisfa l'assioma dei circuiti per le matroidi:
1. Nessun ciclo è contenuto propriamente in un altro ciclo.
2. Se $C_1$ e $C_2$ sono due cicli distinti che condividono uno spigolo $e$ ($e \in C_1 \cap C_2$), allora esiste un terzo ciclo $C_3$ interamente contenuto in $(C_1 \cup C_2) \setminus \{e\}$.
Questa proprietà garantisce che definendo "indipendenti" gli insiemi di spigoli privi di cicli, si ottenga una struttura di matroide valida (la matroide grafica).

Matroide di Fano
?
La matroide di Fano è una particolare matroide definita sull’insieme $E = \{1, 2, 3, 4, 5, 6, 7\}$. 
Le sue **basi** sono costituite da tutti i sottoinsiemi di $E$ formati da tre elementi, **eccetto** i 7 sottoinsiemi seguenti: 
$\{1, 2, 4\}, \{2, 3, 5\}, \{3, 4, 6\}, \{4, 5, 7\}, \{5, 6, 1\}, \{6, 7, 2\}, \{7, 1, 3\}$.
**Proprietà Geometriche:** Tale matroide può essere rappresentata visivamente tramite il piano di Fano. Le basi sono precisamente tutti gli insiemi di tre elementi che **non sono allineati** (i 7 insiemi esclusi corrispondono alle 7 "rette" del piano, inclusa la circonferenza interna).
**Proprietà Algebriche:** La matrice che rappresenta tale matroide è binaria ed euleriana.