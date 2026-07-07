#flashcards/grafi_planari 
Definizione di Grafo planare
?
Un grafo $\mathcal{G}=(V,E)$ si definisce planare se esiste una rappresentazione nel piano in cui gli spigoli corrispondono a curve continue che collegano i vertici incidenti, in modo tale che due spigoli distinti non si intersechino in alcun punto che non sia un vertice comune. La planarità è una proprietà intrinseca del grafo e non della sua rappresentazione grafica.

Definizioni di Curva piana, di Jordan e Regione connessa
?
- **Curva piana:** una funzione continua $f:I\rightarrow\mathbb{R}^2$. Se $I=[0,1]$, si definisce arco o cammino. È chiusa se $f(a)=f(b)$, aperta altrimenti.
- **Curva di Jordan:** una curva chiusa semplice (iniettiva e senza intersezioni con se stessa).
- **Regione connessa:** una regione del piano dove ogni coppia di punti può essere collegata da una curva di Jordan al suo interno.

Teorema di Jordan
?
**Teorema 4.1.4:** Data una curva di Jordan C, essa divide il piano in due regioni: una limitata (interna) ed una illimitata (esterna), aventi i punti di C come punti di frontiera. La regione illimitata contiene infiniti punti.

Definizione di Grafo piano e Rappresentazione
?
Un grafo $\mathcal{G}=(V,E)$ si definisce piano se ogni suo spigolo $e \in E$ può essere considerato come l'immagine di un'applicazione continua e iniettiva nel piano senza crossing (intersezioni tra spigoli fuori dai vertici). Un grafo si definisce planare se è isomorfo ad un grafo piano. Ogni grafo isomorfo al planare $\mathcal{G}$ prende il nome di rappresentazione di $\mathcal{G}$.

Definizione di Faccia e Crossing number
?
- **Crossing number:** Il minimo numero di crossing (intersezioni) tra tutte le possibili rappresentazioni. Per un planare è zero.
- **Faccia:** In una rappresentazione planare, è una regione del piano delimitata da un ciclo $C(F)$ del grafo, che non contiene altri cicli al suo interno. La lunghezza $L(F)$ è il numero di spigoli del ciclo $C(F)$ che la delimita.

Teorema di Eulero
?
**Teorema 4.1.10:** Dato un grafo planare e connesso $\mathcal{G}=(V,E)$ con $n=|V|$ e $m=|E|$, sia $f$ il numero di facce, allora $n-m+f=2$.
**Dimostrazione:** Per induzione su $m$. 
**Base:** $m=1, n=2, f=1 \Rightarrow 2-1+1=2$ (vero).
**Ipotesi induttiva:** Per $m \ge 3$, supponendo vero per $m' < m$.
Caso 1: Se $\mathcal{G}$ è un albero, $n=m+1, f=1 \Rightarrow (m+1)-m+1=2$ (vero).
Caso 2: Se $\mathcal{G}$ non è un albero, contiene un ciclo. Rimuovendo uno spigolo $s$ del ciclo si ottiene $\mathcal{G}'$. $\mathcal{G}'$ è connesso con $m'=m-1$, $n'=n$, $f'=f-1$. Per ipotesi induttiva $n'-m'+f'=2 \Rightarrow n-(m-1)+(f-1)=2 \Rightarrow n-m+f=2$.

Teorema di Eulero generalizzato
?
**Teorema 4.1.11:** Dato un grafo planare $\mathcal{G}=(V,E)$ con $n$ vertici, $m$ spigoli, $f$ facce e $p$ componenti connesse, allora $n-m+f=p+1$.
**Dimostrazione:** Applicando la formula di Eulero a ogni componente $i$, si ha $n_i - m_i + f_i = 2$. Sommando su tutte le $p$ componenti: $\sum n_i - \sum m_i + \sum f_i = 2p$. Poiché la faccia infinita è contata $p$ volte, le facce totali sono $f = \sum f_i - (p-1)$. Sostituendo: $n - m + f + (p - 1) = 2p \Rightarrow n - m + f = p + 1$.

Teorema sulle lunghezze delle facce
?
**Teorema 4.1.12:** Sia $\mathcal{G}=(V,E)$ un grafo planare e connesso. Allora la somma delle lunghezze delle sue $f$ facce è $\sum_{i=1}^f L(F_i) = 2m$.
**Dimostrazione:** Nel conteggio delle lunghezze, ogni spigolo delimita esattamente due facce; ne consegue che ciascuno di essi viene contato due volte, dando $2m$.

Teoremi sulle facce di uguale lunghezza
?
**Teorema 4.1.13:** Se $\mathcal{G}$ ha $f$ facce tutte di lunghezza $r$, allora $r \cdot f = 2m$ (conseguenza immediata del teorema precedente).
**Teorema 4.1.14:** Sotto le stesse ipotesi, $m = \frac{r(n-2)}{r-2}$.
**Dimostrazione:** Per Eulero $n-m+f=2$. Dal teorema precedente $f = \frac{2m}{r}$. Unendo le relazioni: $n-m+\frac{2m}{r}=2 \Rightarrow m=\frac{r(n-2)}{r-2}$.
**Teorema 4.1.15:** Se G ha tutte facce triangolari ($r=3$), $m=3n-6$; se ha tutte facce quadrangolari ($r=4$), $m=2n-4$.

Definizione di Grafo planare massimale (MP-grafo)
?
Un grafo planare non completo $\mathcal{G}=(V,E)$ si definisce massimale se, aggiungendo uno spigolo $s$ tra due suoi vertici non adiacenti, il grafo risultante $\mathcal{G}+\{s\}$ non risulta più planare. Deve essere necessariamente connesso.

Teorema sui grafi planari massimali
?
**Teorema 4.2.2:** Sia $\mathcal{G}$ un grafo planare massimale, allora: (i) le sue facce hanno tutte lunghezza 3; (ii) $m=3n-6$.
**Dimostrazione:** (i) Se per assurdo esistesse una faccia con $L(F)>3$, conterrebbe almeno due vertici non adiacenti. Aggiungendo uno spigolo tra essi si dividerebbe la faccia senza creare crossing, ottenendo un grafo planare, contro l'ipotesi di massimalità. (ii) Essendo tutte le facce triangolari, dal Teorema 4.1.15 si ha $m=3n-6$.

Condizioni necessarie di planarità
?
**Teorema 4.2.3:** Sia $\mathcal{G}$ un grafo planare, allora: (i) $m \le 3n-6$; (ii) se in G non ci sono facce triangolari, allora $m \le 2n-4$.
**Dimostrazione:** (i) Se è massimale $m=3n-6$. Se non è massimale, aggiungendo spigoli fino alla massimalità si ottiene un grafo con $m'=3n-6$ spigoli, per cui $m < m'$. 
(ii) Se non ci sono facce triangolari, ogni $L(F_i) \ge 4$. Allora $2m \ge 4f$. Sostituendo $f = 2-n+m$ si ha $2m \ge 4(2-n+m) \Rightarrow m \le 2n-4$.
*(Nota: il Teorema 4.2.4 esprime le stesse condizioni come sufficienti per la NON planarità)*

Teorema sul grado dei vertici nei grafi planari
?
**Teorema 4.2.5:** Sia $\mathcal{G}$ planare. (i) Esiste in G almeno un vertice $v$ tale che $d(v) \le 5$; (ii) se $n>4$, ne esistono almeno tre con grado $\le 5$.
**Dimostrazione (i):** Se per assurdo tutti avessero grado $\ge 6$, si avrebbe $2m = \sum d(v_i) \ge 6n \Rightarrow m \ge 3n$. Ma per la planarità $m \le 3n-6$, arrivando all'assurdo $3n \le 3n-6$.
**Dimostrazione (ii):** Se ci fossero al più due vertici con grado $\le 5$, la somma dei gradi sarebbe $\ge 1+1+6(n-2) = 6n-10$, da cui $2m \ge 6n-10 \Rightarrow m \ge 3n-5$, violando il limite planare $m \le 3n-6$.

Teorema di non planarità di K5 e K3,3
?
- **Teorema 4.3.1:** Il grafo completo $K_5$ non è planare. 
**Dimostrazione:** In $K_5$ si ha $n=5$ ed $m=10$. Essendo $m > 3n-6$ (cioè $10 > 9$), non rispetta la condizione di planarità.
- **Teorema 4.3.2:** Il grafo bipartito completo $K_{3,3}$ non è planare. 
**Dimostrazione:** In $K_{3,3}$ si ha $n=6, m=9$ e nessuna faccia triangolare. Poiché $m > 2n-4$ (cioè $9 > 8$), il grafo non è planare.

Operazioni sugli spigoli e Omeomorfismo
?
- **Suddivisione:** Si spezza uno spigolo $s=(x,y)$ aggiungendo un vertice $v$, sostituendolo con $(x,v)$ e $(v,y)$.
- **Riduzione:** Si fondono due spigoli consecutivi $(x,y)$ e $(y,z)$ rimuovendo il vertice $y$, ottenendo il singolo spigolo $(x,z)$.
- **Omeomorfismo:** Due grafi sono omeomorfi se possono essere ottenuti per suddivisione o riduzione da un medesimo grafo.

Teorema di Kuratowski
?
**Teorema 4.3.7:** Un grafo è planare se e solo se non contiene sottografi omeomorfi a $K_5$ o a $K_{3,3}$.