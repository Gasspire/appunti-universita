## Block Structure
Struttura del blocco da slide

Receipts trie rappresenta i cambiamenti nel world state e il successo o il fallimento dell transazione o gli output di una transazione. Anche una transazione fallita deve essere registrata.

Beneficiary il beneficiario del reward

LogsBloom 

Abbiamo ciò che riguarda la spesa del gas e ExtraData è un campo per mettere esaster egg.

I campi tagliati sono quelli che riguardavano la vecchia struttura

## Gas 
È un'idea per risolvere il problema della completezza del codice eseguito sulla Ethereum Virtual Machine.  Il codice di ogni contratto va' eseguito su ogni EVM su ogni validatore, proprio per questo motivo, essendo un linguaggio completo che contiene anche loop, non possiamo prevedere quanto tempo duri l'esecuzione e, dunque, senza un limite, potremmo avere attacchi DoS in cui ci sono contratti eseguiti su loop infiniti. Ricordiamoci, inoltre, che c'è un problema che riguarda il limite di tempo di soli 12 secondi. Problema dell'Halting. Inoltre, il problema non è solo il loop ma anche in generale il codice che potrebbe generare referenziazioni infinite e ricorsive.

Vogliamo dunque bloccare le esecuzioni lunghe.

Il Gas rappresenta la soluzione a questo problema:
- Diciamo che il codice eseguito **consuma gas**. Ogni linea di codice ci dice quanto costa in base a quanta memoria consumano (c'è una differenza tra memoria volatile e non volatile. Generalmente la memoria non volatile costa di più perché questa finirà nel world state e, quindi, negli hard disk perennemente) o quanto consumano in termini computazionali.
- Il **gas** è pagato da colui che fa la richiesta (non per forza il creatore del codice).
- Questo gas va' al primo che esegue il codice e, quindi, sono delle fees. Il primo che esegue il codice è colui che crea il blocco. I validatori dovranno pure eseguire il codice ma non riceveranno nulla. Diciamo che il loro interesse è proprio quello di verificare che tutto è corretto poiché i validatori saranno i prossimi che potrebbero essere scelti.
- Questo previene il **dos** poiché se vuoi farlo, devi pagare e, generalmente, dovresti pagare tanto.

Non si sforano i 12 secondi perché servirebbe una quantità di valuta abnorme che è impossibile da eseguire.

Abbiamo un gas limit per ogni blocco creato (credo)

#### Legacy Version (pre-London Upgrade)

Il GasPrice viene fuori da un'analisi economica. Generalmente più sarà alto il prezzo del gas, più veloce sarà la sua inclusione perché i "miner" saranno più invogliati a prenderla dato che guadagnano di più.

Prima si doveva dichiarare sempre gasLimit e GasPrice nella singola transazione. Chi richiede l'esecuzione dichiara il gas massimo che è disposto a pagare. Ciò da al "miner" un upper bound per capire quanto dovrà fare.
 
Il GasPrice è espresso come Wei/Gas ed è un **proposta** fatta da colui che vuole eseguire il contratto. Ci sono dei siti che danno consigli sul gas price. 

Impostare una variabile a 0 costa poco a causa del meccanismo dei merkle patricia trie.

Il gasLimit verrà pagato PRIMA dell'esecuzione del codice. Se rimane, allora viene fatto un refund. 

Si parla di "guadagno" quando viene liberato spazio nello storage. Vedremo dopo cosa si intende.

Se vado out of gas, l'esecuzione fallisce. La transazione è registrata lo stesso ma questa ha fallito con il risultato di out of gas. I soldi sono stati pagati a prescindere dal fallimento delle transazione e un altro effetto e che gli effetti anche del codice eseguito, vengono annullati.

Le transazioni devono essere atomiche.

Possono anche esserci altri tipi di errori:
- **Critical**: Errori accaduti durante l'esecuzione del codice. Divisione per zero, seg fault. L'esecuzione fallisce e siamo nella stessa situazione di out of gas.
- **Managed**: Sono errori critici prevenuti che fanno in modo che, però, il gas non viene speso al suo limite massimo. Non è detto che, però, venga ripristinata la situazione originale. 
La stessa cosa che abbiamo discusso adesso, vale anche per i contratti.
Non solo devo tenere in considerazione l'esecuzione del singolo codice, ma anche dei vari subcall.

Il gas limit posto al contratto chiamato, viene deciso dal contratto chiamante. Se il contratto chiamato và in errore critico, in genere il chiamante può gestire l'errore con ulteriore gas che gli è rimasto. 

#### New mechanics (Post london)

Il gas prices era estremamente volatile e portava una certa incertezza nel sistema.

Viene introdotto il **base fee** cioè è un quantitativo di soldi pagato a prescindere al "miner". Questa è *self-adjusting*, l'idea è che ogni blocco può costare all'incirca 15 Milioni di gas space. Il creatore può decidere quali transazioni mettere fino all'incirca 15 milioni e questo garantisce una certa prevedibilità al mercato. Se ci sono tante transazioni che vogliono essere messe, allora il base fee diminuisce in termini di costo, altrimenti si alza.

Qui il creatore non incassa queste fee, vengono prese dall'account di colui che vuole fare la transazione e vengono bruciate.

Il GasPrize è sostituito dal max priority fee che consiste nella fee extra che si vuole dare al block creator per invogliarlo a mettere la nostra transazione.

Max fee serve a gestire il priority fee
$$max\_fee \geq base\_fee + priority\_fee$$

Se io abbondo con una priority fee, ritorno al punto di partenza in termini di incertezza. Per gestire la logica solo con base fee e priority fee, il problema è che il base fee è incerto e potrebbe cambiare. Per evitare questo, tramite il max fee evitiamo che "oltre questo certo pagamento, non andiamo avanti". La max fee deve rispettare quella equazione.
Io metterò solo max fee e priority fee, se la base fee cambia, allora la priority fee viene abbassata per rispettare il valore max fee.
La max fee e il gas limit ci danno già un'idea di quanto spenderemo.
