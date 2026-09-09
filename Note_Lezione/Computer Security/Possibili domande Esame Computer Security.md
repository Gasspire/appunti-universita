* Descrivi il protocollo Needham Schroeder Simmetrico in termini di cosa vuole ottenere e come avviene la sua esecuzione 
* Spiega il fallimento del protocollo di Needham Schroeder spiegando quale specifica proprietà viene violata e come questa possa essere sfruttata da un attaccante.
* Spiega come mitigare l'attacco Denning-Sacco.
* Spiega la funzione dei Timestamp e la difficoltà iniziale della loro applicazione. 
* Quale è la differenza tra un Timestamp e una Nonce? Che garanzie ci fornisce uno e quali garanzie ci fornisce l'altro.
* Descrivi il problema del Single Sign On e quale fu una delle prime soluzioni per risolverlo.
* Descrivi la prima versione di Kerberos nota come BAN Kerberos. Ci sono dei paragoni rispetto a quello che viene fatto con Needham Schroeder Simmetrico? 
* Kerberos è progettato per risolvere un problema specifico, quale? Come si articola l'esecuzione del protocollo Kerberos? 
* Spiega il protocollo Kerberos scrivendo come avviene una sua tipica esecuzione.
* Quando facciamo riferimento ai Timestamp, affermiamo che questi non sono affidabili poiché non danno alcuna garanzia a chi li riceve che questi non siano stati manipolati. Perché allora A invia T1, T2 e T3 in Kerberos? 
* Sappiamo che la concatenazione di due messaggi non può essere in alcun modo autenticati. Come mai allora abbiamo nel messaggio 3 e 5 del protocollo Kerberos abbiamo una concatenazione? Questa concatenazione è sfruttabile da un'attaccante? 
* Perché inviamo il nome del servizio in chiaro al messaggio 3 nel protocollo Kerberos? Questa cosa può essere sfruttata da un attaccante? 
* Quando parliamo del protocollo Kerberos, abbiamo diverse chiavi. Cosa sappiamo di queste chiavi? Sono legate tra loro e se sì, come? 
* È possibile un attacco di un Dolev Yao + a questo protocollo? Se sì, in che condizioni e da cosa nasce la possibilità di questo attacco e come si risolve?
* Come vanno gestite le chiavi nel protocollo Kerberos in relazione ai lifetime?
* Notiamo che nel protocollo Kerberos vengono effettuate delle cifrature annidate. Come mai viene fatto ciò? Per un senso di maggiore protezione?
* Come funziona il protocollo Kerberos V? Quali sono i due principali cambiamenti rispetto a Kerberos IV?
* Cosa è una carta magnetica e come funziona? 
* Cosa è una Smart Card e come si differenzia dal suo predecessore? 
* Cosa compone una Smart Card? Cosa ci ricorda?
* Quale standard deve rispettare una Smart Card? Cosa comprende?
* Come si distinguono le tipologie di attacchi alle smart card e come funzionano?
* Cosa è un attacco di Microprobbing? Di che tipo è?
* Parlami del noto attacco alle Pay-TV e come questo veniva eseguito. Di che tipo è? 
* Cosa è un attacco di Eavesdropping? E cosa è un attacco di Fault Induction? 
* Quale attacco fu progettato per i micro controllori PIC16C84? Spiega come questo veniva eseguito e descrivi lo pseudo codice che ci stava dietro.
* Cosa è la crittografia visuale? Quale è il ruolo del nostro occhio in questa tecnologia?
* Quale è la logica alla base della crittografia visuale? Da cosa prende spunto? 
* Quale è il cifrario basilare da cui prende spunto la crittografia visuale? 
* Perché si usa lo XOR nei cifrari piuttosto che usare un banalissimo OR o un AND? 
* Come possiamo implementare la crittografia visuale su un immagine a bianco e nera? Quali sono gli "share" prodotti e come vengono prodotti? 
* Nello specifico, come funziona l'implementazione della crittografia visuale 2x2? 
* Quanti livelli di "grigio" possiamo implementare in una matrice 2x2? Perché, invece, non lo facciamo?
* Cosa deve garantire un cifrario per essere definito Perfettamente sicuro?
* Come funziona One time pad?
* Descrivi il processo di cifratura di un immagine mediante crittografia visuale.
* Cosa è uno schema a soglia in crittografia visuale? 
* Cosa è uno schema a gruppo di accesso in crittografia visuale?
* Quanta è la differenza di contrasto tra una scala e l'altra in crittografia visuale nella classica implementazione 2x2 
* Descrivi la proprietà di Non ripudio.
* In che modello di attaccante siamo quando trattiamo la proprietà di non ripudio?
* Parlami del problema della Equa Compravendita.
* Quando una compravendita si definisce Equa.
* Quali sono i vari protocolli di equa compravendita nei vari casi di agenti onesti e disonesti o mezzo affidabile e non? Cosa ci insegano?
* Perché il paper Zhou Gollman sembra fare una trattazione inutile quando parla del quarto caso? E perché, appunto, fallisce?
* Cosa è il "rilascio posticipato" e come funziona?
* Quando si rende necessaria la presenza di un TTP? 
* Quale è l'idea rivoluzionaria del protocollo Zhou Gollman oltre al rilascio posticipato? 
* Il rilascio posticipato è davvero utile nel protocollo Zhou Gollman? Prova a descriverne una versione che non adotta questa strategia. Che difetti ha però questa nuova versione?
* Descrivi il protocollo Zhou Gollman per l'equa compravendita. 
* Quale è il ruolo della label nel protocollo Zhou Gollman per l'equa compravendita?
* Prova a emulare il protocollo Zhou Gollman nel caso in cui uno dei due interlocutori voglia imbrogliare.
* Parlami della proprietà di Equo recapito in entrambe le sue versioni.
* Quando parliamo di raccomandata, di che tipo di equo recapito stiamo parlando?
* Quali sono i presupposti del protocollo Abadi et al.? Che cosa osserviamo riguardo alla PKI? 
* Qual è il ruolo della funzione ack nel protocollo Abadi et al.? 
* Descrivi il protocollo Abadi et Al. Che tipo di equo recapito otteniamo?
* Nel noto protocollo Abadi et al. non otteniamo equo recapito forte, bensì debole. Perché? Come facciamo a ottenere equo recapito forte?