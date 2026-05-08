È un framework per penetration test.
Si basa sui moduli e ve ne sono di diversi tipi:
- Auxiliary
- Exploit
- Payload
- Post
- Encoder
- Evasion
- Nop
Per usare un modulo basta scrivere use auxiliary/gather/kerberos_etc.  ogni modulo ha le sue **options** che sono da configurare per poi lanciare l'attacco. Tra queste, troviamo spesso l'host da attaccare da dove ecc. 

Esistono diversi payload che fanno diverse cose. Spesso combiniamo un exploit che sfrutta una certa vulnerabilità per usare diversi **payload**. L'exploit sfrutta la vulnerabilità e il payload è ciò che viene fatto attraverso l'exploit. 

Per eseguire, infine, un modulo, si usa il comando **run** o **exploit**. Spesso gli exploit possono supportare più target per prendere di mira specifiche versioni di SO così da poter usare la versione più adatta dell'exploit.

## Shell Meterpreter
Per ottenere una shell meterpreter è necessario fare 
```
sessions -u [id_sessione]
```

Su una sessione già aperta.
Spesso ci si ritrova ad avere più shell a disposizione, per questo, tramite una shell meterpreter è possibile fare session per vedere tutte le shell aperte.

**Meterpreter Wire Protocol** è il protocollo che spiega il come è fatta meterpreter

Meterpreter permette anche il trasferimento veloce dei file (o dei malware) tramite il comando **upload**.

**Clearev** cancella i log di visualizzatore eventi.

## Struttura di un Payload

È composto da tre parti:
1. **Handler**: Accetta una connessione in entrata al fine di stabilire una connessione. È sostanzialmente un listener
2. **Stager**: È il pezzo del payload che ha il compito di scaricare lo *stage* dalla macchina dell'attaccante. Esempio reverse_tcp, reverse_http ecc. La differenza tra questi è il protocollo utilizzato e il fatto se è *bind* o *reverse*.
3. **Stage**: È quello caricato tramite lo stager e, da lì in poi continua da solo la sua esecuzione. Esempio la shell meterpreter ecc.

Un dropper è un tipo di malware che scarica altri malware. Lo stager funziona esattamente come un dropper.

Ci sono tanti stage notevoli tra cui *stdapi* *Metsrv* *shell* o *VNCInject*. 
VNC serve a condividere lo schermo con possibilità di interazione. È estremamente insicuro.

Usiamo gli stager perché sono ottimi per bypassare misure di sicurezza e sono molto versatili proprio perché modulari.

Gli staged payload hanno svantaggi alla lunga perché occupano molto banda.  

Un payload staged è, in genere tipo *piattaforma/architettura/stage/stager*
Altrimenti, se il payload è stageless allora è tipo *piattaforma/architettura/all_in_one*.

## MSFVenom

Questo è l'unione di due vecchi tool chiamati encoder e payload. Ha la funzione di creare un file con al suo interno un payload.

Quando creiamo un payload con msfvenom -p di tipo stager, questo caricherà solo lo stager e nient'altro, sarà poi meterpreter a decidere cosa scaricare.

Si può fare l'encoding di un payload con l'opzione *-e* 