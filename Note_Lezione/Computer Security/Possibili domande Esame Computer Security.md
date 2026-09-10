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
* Come avviene la risoluzione delle controversie nel caso di equo recapito? 
* Cosa è l'equa delega? 
* Cosa è il Protocollo Crispo e come avviene la sua tipica esecuzione? 
* Come avviene la risoluzione delle controversie nel caso di equa delega nel protocollo Crispo?
* Come funzionano tutte le chiavi presenti nel protocollo Crispo? Ne possiamo fare a meno? Descrivi una versione del protocollo senza tutte quelle chiavi.
* Una versione semplificata del protocollo Crispo omette l'utilizzo di diverse chiavi. Cosa comporta a livello di proprietà garantite? Che vantaggi perdiamo? 
* Quale è la differenza tra analisi formale e informale?
* Cosa è il Model Checking e come si distingue dall'analisi formale?
* Cosa vogliamo ottenere mediante analisi formale?
* Come mai l'analisi formale surclassa il model checking
* Quando parliamo di model checking, come descriviamo i protocolli?
* Quali sono i limiti del model checking e da cosa derivano 
* Cosa intendiamo con Theorem Proving?
* Quando usiamo Isabelle, facciamo uso di una specifica tipologia di logica, quale e da cosa deriva.
* Le dimostrazioni in Isabelle sfruttano un principio fondamentale quale e quando è possibile applicarlo.
* Durante l'analisi formale facciamo uso di due livelli di ragionamento, quali e come si distinguono?
* Isabelle è un framework composto da cosa?
* Una traccia in Isabelle da cosa è composta? 
* Quali sono i principali di tipi in Isabelle e da cosa sono composti?
* Quale è la principale differenza tra parts e used? 
* Cosa ci permette di fare analz e cosa lo distingue da knows?
* Cosa rappresenta Synth? Chi è il solo a poterlo utilizzare?
* Quali sono le principali regole del protocollo che abbiamo visto a lezione? Perché abbiamo NIL?
* Come si modella Spy mediante le regole che abbiamo visto a lezione? 
* Cosa è un Proof Assistant
* Come modelliamo la proprietà di segretezza/confidenzialità mediante Isabelle?
* Come modelliamo la proprietà di autenticazione in Isabelle?
* Come si distingue Knows tra Spy e non?
* Come funziona analz?
* Cosa contiene used?
* Che vincoli abbiamo sul TTP?
* Descrivi tutte le 5 regole che descrivono il protocollo che abbiamo visto.
* Parlami del Codice sulla Privacy pre 2018. 
* Cosa è un dato personale e cosa è un dato sensibile? Questa definizione cambia nel GDPR?
* Cosa ci dice l'articolo 7 della carta dei diritti fondamentali dell'UE?
* Cosa ci dice l'articolo 8 della carta dei diritti fondamentali dell'UE?
* Quali sono i principali ruoli del trattamento citati nella Legge 196/2003 allegato B?
* Perché è storicamente importante la legge 196/2003? 
* Quali sono i limiti della legge 196/2003 e come questi cambiano nel GDPR?
* Parlami dei requisiti minimi di sicurezza della legge 196/2003. 
* Quali sono i primi 5, poi 10 poi 15 poi 20 poi 25 e poi 29 requisiti minimi di sicurezza?
* Cosa ha l'obbligo di fare il titolare del trattamento? 
* Cosa è il GDPR e quali sono i suoi principi?
* Cosa è la profilazione?
* Cosa è un trattamento?
* Quali sono i principi fondamentali per il trattamento dei dati? (articolo 5)
* Quando un trattamento si dice lecito e quali sono le condizioni per il consenso al trattamento?
* Quali sono le categorie particolari di dati personali e come questi vengono/possono essere trattati?
* Quando abbiamo analizzato la legge 196/2003 abbiamo specificato come la diversità del trattamento tra dati personali e dati sensibili sia estremamente esagerata nei modi in cui viene fatta. Questa distinzione è tuttavia presente anche nel GDPR ma questa ha un approccio diverso che lo rende gestibile, come mai?
* Quali sono i diritti dell'interessato?
* Cosa vi è nel diritto di accesso dell'interessato (art. 15)
* Parlami del diritto di rettifica/cancellazione e portabilità.
* Diritto all'opposizione
* In un mondo dominato dall'uso di AI, cosa ci dice l'articolo 22 del GDPR riguardo ai processi automatizzati?
* Cosa ci dice l'articolo 25 del GDPR riguardo alla protezione dei dati?
* Nell'articolo 25 e nell'articolo 32 del GDPR viene recitata sempre una sorta di "formula" per parlare di misure di sicurezza? Quale e perché è così importante? 
* Nell'articolo 30 del GDPR si parla di registro delle attività del trattamento. Perché è importante e cosa conserva
* Parlami dell'articolo 32 del GDPR. Cosa viene citato tra le misure di sicurezza da adottare?
* Come cambia l'approccio tra il GDPR e la legge 196/03?
* Cosa è un data breach o violazione dei dati personali?
* Cosa succede in caso di data breach (art. 33 34 e 35)
* Cosa è l'attività di DPIA?
* Cosa è l'attività d Risk Assessment?
* Quali sono i vincoli del SysAdmin? Perché non è possibile che cancelli i log?
