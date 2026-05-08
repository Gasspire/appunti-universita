**Cosa è uno smart contract?**
A differenza di un contratto reale che deve essere scritto da un avvocato, dipende dalla legge e deve essere interpretato, uno smart contract è un codice scritto da un programmatore che, di base, **non può essere ambiguo** poiché il codice dice esattamente quello che fa. **Non è chiaramente necessario che qualcuno lo faccia rispettare** (non c'è un giudice che interpreta la legge e poi ti arresta), poiché la piattaforma che esegue il contratto fa' ciò che deve fare ed è **trasparente a tutti** poiché può essere letto da chiunque.

I contratti ordinari sono detti **dumb contract** anche se sull'intelligenza degli smart contract si può dibattere...

Abbiamo già visto come Bitcoin contenga al suo interno un **linguaggio di scripting** che, però, è **molto limitato** sia per quanto riguarda la logica (possiamo solo accettare o rifiutare una transazione), sia per quanto riguarda la questione loop sia per quanto riguarda il fatto che questo linguaggio è **privo di stati** se non lo stack che, però, non è una vera e propria memoria. Infine, bitcoin script è totalmente **blind** rispetto alle informazioni della blockchain e ciò ci preclude la possibilità di usare informazioni precedentemente mente inserite. Questo è stato fatto proprio perché Bitcoin script non è stato progettato per eseguire realmente programmi. Infatti, gli script accettati da bitcoin script sono limitati all'interno di una **whitelist** che ci dice, sostanzialmente, quali script sono accettati e quali no.

---
## Namecoin
Vediamo un semplice sistema DNS implementato attraverso la blockchain. Supponiamo che questo dia la possibilità di fare un mapping del tipo 
$$\text{Domain name} \to \text{IP ADDRESS}$$
Vorremmo supportare questo tipo di informazioni:
1. NameCoin.register(ownerAddr, domainName, initialVal): per registrare per la prima volta il dominio.
2. NameCoin.update(domainName, newVal, newOwner, ownerSig): per aggiornare l'indirizzo del nostro dominio o per cambiare il proprietario. Per farlo abbiamo chiaramente bisogno della firma del proprietario (ownerSig)
3. NameCoin.lookup(domainName): tutti dovrebbero essere in grado di chiamare questa operazione per trovare l'indirizzo del dominio.

Possiamo provare a implementare questa cosa con Bitcoin scripting. Per farlo necessitiamo di estendere **Script Pub Key** con nuovi comandi implementando un meccanismo simile alla verifica della chiave pubblica per verificare il proprietario. 
![[namecoin_script.png|160]]
 (bomba a tempo):Con uno script di questo tipo, facciamo in modo che in qualche modo abbiamo salvato nello uTXO la coppia (dominio, IP)
Guardando allo script, ci rendiamo conto del fatto che **Bitcoin script non può verificare se un dominio è già stato registrato**, mancando dunque una policy fondamentale dei DNS.

Questa idea è stata implementata ma ha richiesto una hard fork di Bitcoin e ha, quindi, creato una vera e propria moneta nuova ma ha richiesto un nuovo bootstrap e una nuova community vera e propria che la supporta.

## Ethereum Platform
L'idea è proprio quella di superare la limitazione di Bitcoin script per fornire la possibilità di creare contratti particolari basati su un sistema di blockchain. Tra questi contratti sono stati ideati **NFT**, la creazione di **nuova moneta**, **giochi** e **prodotti finanziari** come assicurazioni ecc.

I contratti potrebbero anche contenere soldi e gestirli secondo le regole del contratto.

Nel classico di Bitcoin, sappiamo che la blockchain è basata su transazioni e sulla base di queste è deducibile il bilancio, sappiamo che abbiamo la PoW che ci permette di creare blocchi ogni 10 minuti e conosciamo i problemi degli asic e dei mining pool.

In Ethereum, invece, abbiamo un **network state** che è un database che gestisce stati e abbiamo una blockchain basata su **bundle di transazioni** che in qualche modo modificano il network state attraverso i contratti che sono coinvolti nella transazione.
Abbiamo il classico tipo di account che possiede ETH (esattamente come Bitocoin anche se non parliamo di veri e propri account) e una sorta di account gestito tramite **contratti autonomi** che possono avere un qualunque tipo di informazione e possono possedere anche ETH che possono gestire secondo la logica prestabilita. Un contratto non ha bisogno di chiavi, ha una memoria e ha un indirizzo.

Fino a qualche anno fa Ethereum si basava su Proof of Work mentre dal 2022 si è passati alla **Proof of Stake**. Anche qui abbiamo transazioni ma basate sulla logica dei contratti.

#### Ethereum coin
Abbiamo in ordine:
1. **Ether**
2. **Finney**: 1 Eth = $10^3$ Finney
3. **Szabo**: 1 Eth = $10^6$ szabo
4. **Wei**: 1 Eth = $10^{18}$ wei
In realtà, i pagamenti avvengo sempre in Wei (come in bitcoin avvengono sempre in Satoshi).

**Pre-Merge** avevamo **Ethereum Mining** che si basava su keccak 256 come Proof of work. L'idea era di prevenire l'uso di **Asic** attraverso il mining tramite GPU. Venivano creati blocchi ogni 12 secondi e il reward era di 2 ETH per blocco.
Loro avevano già progettato di cambiare da PoW a PoS, per farlo hanno usato una **bomba a tempo** per aumentare la difficoltà di creazione di un nuovo blocco così tanto che divenisse impossibile creare nuovi blocchi con il nuovo modo. 

Il fatto che qui ci siano 12 secondi per la creazione di un nuovo sembra indebolire il protocollo rispetto a Bitcoin, tuttavia, qui chiaramente il sistema è tarato per funzionare ogni 12 secondi.

I 2 ETH sono fissi e non hanno un limite. Un domani questi potrebbero essere tanti e la moneta potrebbe svalutare ma questo è tenuto in considerazione dal sistema.

## Account
Abbiamo gli **External Owned Account (EOA)** che sono in genere umani che hanno chiavi per firmare con ECDSA indirizzi ecc. esattamente come in Bitcoin e hanno un bilancio.

I **Contract Account** sono i contratti che vivono nella blockchain e questi **non possiedono chiavi** e hanno un **Contractt code IMMUTABILE** che vive nella blockchain e runna attraverso la Ethereum Virtual Machine. 
Essendo immutabile, in genere si usa un **proxy per evitare di non poterli mai cambiare** e il cambio è trasparente a coloro che li usano. Il codice è facilmente decompilabile in un simil solidity. 