## Isomorfismo

Due grafi si definiscono **isomorfi** se esiste un'applicazione biunivoca tale che ogni nodo di $G_1$ può essere mappato in un nodo di $G_2$ preservando il grado.  

Questo problema non è risolvibile tramite un algoritmo polinomiale e questo lo rende perfetto per il nostro scopo di avere una **Zero Knowledge proof**.

Il prover sceglierà una permutazione a caso su $G_1$ e crea una mappa del grafo che chiamerà H. Il verifier a questo punto deciderà un numero random C tra 1 e 2 e lo manderà al prover. 

Una volta ricevuto C, il prover trova una permutazione che ci permette di trovare un $\rho$ che dia $G_c$

Passo passo vediamo:
1. $G_1 \xrightarrow{\pi} H$
2. $G_c \xrightarrow{\rho} H$

Se la permutazione $\rho$ permette di ottenere da $G_c$ $H$, allora viene accettato, altrimenti viene rifiutato.

### 1. Il Presupposto (Il Segreto)

Il Prover possiede due grafi, $G_1$ e $G_2$, che sono isomorfi. Conosce cioè una funzione (una permutazione $\rho$) tale che $G_2 = \rho(G_1)$. Questo $\rho$ è il **segreto** che il Prover non vuole rivelare.

### 2. Fase di Impegno (Commitment)

Il Prover sceglie una permutazione casuale $\pi$.

- Crea un nuovo grafo $H$, che è l'immagine di $G_1$ tramite $\pi$ ($H = \pi(G_1)$).
    
- Invia il grafo $H$ al Verifier.
    
- _Perché lo fa?_ $H$ è "coperto" dalla casualità di $\pi$, quindi il Verifier non può capire come $H$ sia collegato a $G_1$ o $G_2$ solo guardandolo.
    

### 3. Fase di Sfida (Challenge)

Il Verifier invia una sfida casuale $c$. Può scegliere solo tra due valori: **1** o **2**.

- Se $c=1$, sta chiedendo: "Dimostrami che $H$ è isomorfo a $G_1$".
    
- Se $c=2$, sta chiedendo: "Dimostrami che $H$ è isomorfo a $G_2$".
    

### 4. Fase di Risposta (Response)

Il Prover calcola la risposta $\sigma$ in base alla sfida:

- **Se $c=1$:** Il Prover rivela $\sigma = \pi$. Infatti, $H$ era stato costruito proprio come $\pi(G_1)$.

- **Se $c=2$:** Il Prover deve mostrare la relazione tra $G_2$ e $H$. Poiché conosce sia il segreto $\rho$ (che collega $G_1$ a $G_2$) sia $\pi$ (che collega $G_1$ a $H$), può calcolare la composizione $\sigma = \pi \circ \rho^{-1}$ (nell'appunto è scritto semplicemente $\pi \circ \rho$, la logica è la stessa: combinare le due permutazioni).
### 5. Verifica

Il Verifier riceve $\sigma$ e controlla se:

$$H = \sigma(G_c)$$

- Se la sfida era 1, controlla se $H = \sigma(G_1)$.
    
- Se la sfida era 2, controlla se $H = \sigma(G_2)$.
    
    Se l'uguaglianza è verificata, il Prover ha superato il turno.
## Verifichiamo che il protocollo sia Zero Knowledge

Dobbiamo a questo punto verificare le proprietà di Soundness e Completness
- **Soundness:** Dobbiamo verificare che un attaccante non riesca a convincere il verifier di quello che sia valido. Questo vorrebbe dire trovare una permutazione che renda $G_1$ in $G_2$ senza che, però, $G_1$ e $G_2$ siano isomorfi.
  L'attaccante per fare questa cosa deve sperare di beccare il c scelto dal verifier così da creare la mappa che trasforma H in $G_c$ che lui ha indovinato. Questa cosa funziona al $50\%$. Questa cosa a noi va bene perché la Soundness è valida se la probabilità è un certo valore e a noi per diminuire questa probabilità basta iterare nuovamente questo processo passando dal $50\%$ al $25\%$ ecc. 
- **Completeness**: Banalmente vediamo che il protocollo funziona per come lo abbiamo descritto.
Dimostriamo adesso che è Zero Knowledge cioè che il verifier non ha imparato nulla sull'isomorfismo dei grafi cioè che non ha ricevuto alcuna informazione. 
La view sarà  
- $H_1, c_1, \rho_1$
- $H_2, c_2, \rho_2$
- ...
- $H_n, c_n, \rho_n$
Il fatto che sia Zero knowledge vuol dire che possiamo simulare la comunicazione solo tramite le informazioni pubbliche del protocollo. Per farlo possiamo scegliere uno c a caso e anche un $\rho$ a caso e poi calcoliamo $H$ tramite c e $\rho$ facendo in modo che passiamo da $G_c$ a $H$ tramite $\rho$. Poiché possiamo a costruirlo a posteriori, questa cosa è facile da ricostruire ed è del tutto indistinguibile da una comunicazione legittima. 
## Idea del Protocollo Diffie-Hellman
Solito protocollo Diffie-Hellman
![[Diffie-Hellman.png|518]]

Sfruttiamo questa idea come segue:
Vogliamo provare che $(g, g^x, g^y, g^{xy})$ sia una quadrupla Diffie-Hellman tale che:
$$DL_{g}(g^{y}) = DL_{g^x}(g^{xy})$$

Il prover sceglierà dei valori a caso che sono $u = g^r,v = X^r$ che  vengono mandati al verificatore. Il verificatore sceglie $C \xleftarrow{R} \{1,\dots,m\}$ e lo manda al prover. Il prover risponderà con $Z = r+ cy  \mod m$ . Alla fine la verificherà sarà:
1. $g^z =? u \cdot Y^c$ 
2. $x^Z =? v \cdot W^c$

#### Completness
Se la quadrupla è valida, allora questa rispetta il protocollo e funziona correttamente.
Siano $X=g^x,Y=g^Y, Z = g^{x,y}$:
- $g^z = g^{r+cy} = g^r \cdot (g^Y)^c$
#### Zero Knowledge
Cerchiamo innanzitutto di capire la view:
* (u,v), c, z 
Vediamo come costruire una tripletta a posteriori:
1. Scegliamo c random tra 1, ..., m
2. Scegliamo z random tra 0, ... m
3. Calcoliamo $u = g^z/ y^c$ e $v = X^z/W^c$ 
In questo modo, quando il Verificatore andrà a controllare se $X^z = v \cdot W^c$, l'uguaglianza sarà vera per costruzione, anche se il simulatore non sa assolutamente nulla di $x$ o $y$.
#### Soundness
Proviamo a capire cosa può fare l'attaccante per fregare il verifier
![[soundness_diffie.png|475]]

L'attaccante per fregare il verifier dovrebbe riuscire a calcolare $\alpha$ che è:
$$\alpha = \frac{\beta + s c}{x}-yc$$ Dunque, anche scegliendo $\beta$, per riscrivere il tutto abbiamo bisogno di indovinare c a priori. Ancora, abbiamo che l'attaccante può indovinare con probabilità $\frac{1}{m}$ dove m è la grandezza del gruppo degli esponenti.

## Teorema
Se esistono funzioni unidirezionali, allora qualunque linguaggio in NP, ammette una **Zero Knowledge Proof** computazionale cioè che il verifier è computazionalmente limitato. 

La dimostrazione è complessa e molto articolata (non la famo)
