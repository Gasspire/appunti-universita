Scrypt 
Proprietà della Blockchain: Consistenza, Chain Quality e Chain Growth (o **Liveness**)
Cosa può fare un Attaccante che ha 51% della potenza della rete?
Selfish Mining 1 se q > p, $(\frac{q}{p})^z$ 
$1-\alpha n p \Delta$ è l'efficienza con $\alpha$ la percentuale di nodi onesti, $n$ il numero di nodi nella rete, $p$ la probabilità che un singolo nodo risolvi l'hash puzzle, $\Delta$ la latenza di propagazione. $$(1-\alpha n p \Delta)\alpha n$$ È la potenza effettiva a disposizione dei nodi corretti.
Vantaggi del consenso di Nakamoto: partecipazione anonima, imprevedibilità e tolleranza ai nodi malevoli.
Idea dei Mixing: Non mantiene registri, assenza di identificazione.
Principi:
- Serie di mixer che eliminano il SpF
- Commissione all or nothing per garantire anonimato del servizio
- Uniformità delle transazioni
- Automatizzazione lato client
CoinJoin: RICORDA BLIND SIGNATURE e PROBLEMI

ZKP:
- COMPLETNESS: $$\forall x \in L, Pr(<P,V>(x) = 1)\geq \frac{2}{3}$$
- SOUNDNESS:$$\forall x \notin L, Pr(<P,V>(x) =1) \leq \frac{1}{3}$$
- ZK: La capacità computazionale di V non è arricchita dall'interazione con P poiché tutto ciò che ne ottiene è qualcosa di calcolabile a partire da x soltanto.
- PZK: Esiste una macchina a stati finiti polinomiale in grado di generare una view senza conoscere il segreto tale che questa sia indistinguibile rispetto ad una reale interazione tra P e V.

ECDSA HD WALLET:
Siano $y,G^y$ rispettivamente la master secret key e la master public key e k il chain code:
- Generazione della i-esima chiave privata: $$x_i = y+h(k||i)$$
- Generazione della i-esima chiave pubblica:$$P_i = G^{x_i} = G^y \cdot G^{h(k||i)}$$
- Generazione dell'i-esimo indirizzo:$$A_i = h(P_i)$$
In generale il tutto deriva da un **master seed** composto da una serie di parole mnemoniche da cui si derivano poi una serie di bit la cui prima metà compone la master secret key e la seconda metà il chain code.

Multisignature di Schnoor:
