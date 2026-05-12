## Da appunti di Fill (Se leggi, ti lovvo)

La **Legge 196** del 2003 nota , come **Codice della Privacy** o Codice in materia di protezione dei dati personali, è la normativa italiana fondamentale che regola la raccolta, il trattamento e la circolazione dei dati personali, garantendo il rispetto dei diritti fondamentali della persona.

Il codice distingue tra **dati personal**i (nome, dati identificativi ecc. cioè tutti quelli che servono a identificare una persona) e categorie particolari di dati, un tempo definiti **"sensibili"** (religione, opinioni politiche, salute, dati biometrici/genetici).

Questa legge rimase in attività per 15 anni dal 2003 al 2018 quando entrò in vigore in Italia il **GDPR** che è stato pubblicato in realtà già nel 2016.

Nell'arco di questi 15 anni di non compliance, la legge 196 imponeva dei **requisiti minimi di sicurezza** che, se adottati, si era tecnicamente apposto benché questi fossero, per l'appunto, requisiti minimi.  Fino al 2018 le sanzioni erano fisse, basse e tutte italiane, il che rendeva la cybersecurity un problema secondario (erano dettate dal precedente **codice privacy**). Dal 2018 il GDPR ha introdotto sanzioni europee milionarie basate sul fatturato. Il Codice Privacy italiano è stato quindi modificato: ha lasciato al GDPR le mega-multe, ma ha mantenuto e aggiornato la parte sui reati penali (come il trattamento illecito dei dati) per punire chi commette veri e propri crimini con i dati altrui.

## Privacy vs Data Protection

La privacy è un diritto fondamentale del cittadino sancito dall'articolo 7 della carta dei diritti che riguarda la vita privata e la famiglia. 

```
Carta dei diritti Art. 7:
Ogni persona ha diritto al rispetto della propria vita privata e familiare, del proprio domicilio e delle proprie comunicazioni.
```

La **data protection**, invece, è il modo in cui la privacy si realizza nel mondo digitale trattata nell'articolo 8. 
La cybersecurity è essenziale per garantire la data protection, poiché senza misure di sicurezza adeguate, i dati possono essere compromessi anche se si rispettano tutti gli altri diritti del titolare. La protezione dei dati non deve limitarsi alla sola protezione da accessi indebiti, ma deve garantire il pieno controllo dei dati da parte del proprietario

```
Carta dei Diritti Art. 8:
1. Ogni persona ha diritto alla protezione dei dati di carattere personale che la riguardano.

2. Tali dati devono essere trattati secondo il principio di lealtà, per finalità determinate e in base al consenso della persona interessata o a un altro fondamento legittimo previsto dalla legge. Ogni persona ha il diritto di accedere ai dati raccolti che la riguardano e di ottenerne la rettifica.

3. Il rispetto di tali regole è soggetto al controllo di un'autorità indipendente.
```
Come possiamo notare viene posto il focus nella **protezione dei dati** ma anche sul **consenso di trattamento da parte dell'intressato** e il **controllo che questo ha sui suoi dati**.

## Titolare, Responsabile e Incaricato
Questi sono ruoli introdotti già nella legge 196 ma il GDPR ne delinea nuove responsabilità e confini.
* **Titolare del trattamento** è colui che detiene il dato e decide come e perché trattare i dati. Lui è il primo responsabile davanti alla legge nel caso in cui vi siano data breach.
* **Responsabile del trattamento** è un soggetto esterno che il titolare delega alla gestione dei dati. Basti pensare ad esempio a un'azienda in cloud che magari riceve e gestisce il database di un sito web. Se non mette in sicurezza i suoi server, ne risponde direttamente.
* **Incaricato o Persona Autorizzata** questo è il ruolo che detengono le persone che eseguono materialmente le istruzioni ricevute (aprono i file ecc.).
## Allegato B legge 196 del 2003 

L'Allegato B della Legge 196 del 2003 parlava di **'misure minime di sicurezza'**, che includevano 29 requisiti. Queste misure erano l'archetipo della sicurezza e sono ancora rilevanti oggi, sebbene la loro incarnazione tecnica sia superata a causa dell'evoluzione tecnologica che, di base, non prevedeva il cloud o lo smart working moderno. 

Il GDPR, pur menzionando la sicurezza (articoli 32, 33, 34), **si concentra principalmente sugli aspetti funzionali e sui diritti dell'interessato** cioè colui a cui si fa riferimento nei dati. È fondamentale comprendere che la protezione dei dati non è solo una questione tecnologica, ma anche **legale e organizzativa**. La sicurezza informatica deve essere integrata con la protezione dei dati per garantire un controllo completo e la conformità normativa.

Il GDPR non ci dà delle indicazioni fisse sul cosa implementare in termini di sicurezza, bensì ci dice di applicare le giuste misure secondo lo **stato dell'arte** (Art. 32 del GDPR) e secondo il contesto e le finalità del trattamento. Questo non lega i titolari a specifiche implementazioni che potrebbero, un domani, risultare obsolete. Dunque, molte aziende fanno riferimento a standard internazionali come la **ISO 27001**.

## Analisi punti allegato B

```
1. Il trattamento di dati personali con strumenti elettronici è consentito agli incaricati dotati di credenziali di autenticazione che consentano il superamento di una procedura di autenticazione relativa a uno specifico trattamento o a un insieme di trattamenti.
```

Questa normativa non specifica chi deve adottare, bensì rimane sul generico di "Tutti quelli che trattano i dati" e questo indicata tutti i computer aziendali, clienti, dipendenti e fornitori che trattano i dati devono essere compliance a questa norma. 
Questo chiaramente rende il tutto più complicato poiché la superficie da mettere in sicurezza è parecchio ampia, tuttavia non si possono fare eccezioni.  È proprio quel **TUTTI GLI INCARICATI** a fare la differenza.

Viene fatta questa generalizzazione poiché i dati personali sono ormai ovunque ed è quindi necessario avere delle misure di sicurezza obbligatorie poiché sono pochissimi i casi in cui non sono presenti.
La responsabilità della compliance è dell'azienda.

Verde
```
2. Le credenziali di autenticazione consistono in un codice per l'identificazione dell'incaricato associato a una parola chiave riservata conosciuta solamente dal medesimo oppure in un dispositivo di autenticazione in possesso e uso esclusivo dell'incaricato, eventualmente associato a un codice identificativo o a una parola chiave, oppure in una caratteristica biometrica dell'incaricato, eventualmente associata a un codice identificativo o a una parola chiave.
```

L'autenticazione può avvenire tramite conoscenza (password), possesso (dispositivo) o biometria, o una combinazione di questi Questa è di per sé una buona norma poiché comprende tutti i possibili stati e offre una buona flessibilità.

Verde

```
3. Ad ogni incaricato sono assegnate o associate individualmente una o più credenziali per l'autenticazione.
   
4. Con le istruzioni impartite agli incaricati è prescritto di adottare le necessarie cautele per assicurare la segretezza della componente riservata della credenziale e la diligente custodia dei dispositivi in possesso ed uso esclusivo dell'incaricato.
```
Si sottolinea che le credenziali devono essere assegnate **individualmente** a ciascun incaricato, non condivise, e che l'amministratore di sistema (sysadmin) dovrebbe operare con **privilegi bassi per le operazioni di routine e avere un set di credenziali separato per la manutenzione.** È infatti responsabilità di colui che riceve le credenziali (siano essere di qualunque tipo) custodirle in maniera tale da non eliminarne la riservatezza. 

Verde

```
5. La parola chiave, quando è prevista dal sistema di autenticazione, è composta da almeno otto caratteri oppure, nel caso in cui lo strumento elettronico non lo permetta, da un numero di caratteri pari al massimo consentito; essa non contiene riferimenti agevolmente riconducibili all'incaricato ed è modificata da quest'ultimo al primo utilizzo e, successivamente, almeno ogni sei mesi. In caso di trattamento di dati sensibili e di dati giudiziari la parola chiave è modificata almeno ogni tre mesi.
```

Questa normativa, forse anche a causa del tempo passato dalla sua ideazione, non rispecchia più uno scenario adeguato. Questa dà indicazioni solo sulla lunghezza della password **ma non sulla sua complessità intesa come caratteri speciali ecc.** Banalmente, la password "12345678" sarebbe una password valida per questa normativa.
Addirittura, in ambito ospedaliero vengono spesso usate password di 3 o 4 caratteri per l'accesso al sistema.

Questa normativa è dunque obsoleta o, comunque non completa. I requisiti sulle password sono ormai standardizzati da NIST 2004.

SEGNATA ROSSA

Inoltre, questa normativa non gestisce le credenziali in maniera equa differenziando gli accessi a dati sensibili e non. Tuttavia, la sicurezza dovrebbe essere uniforme e non dovrebbero essere fatte distinzioni di questo genere poiché  un accesso al sistema è comunque un problema. Inoltre, il cambio della password che cambia ogni 3 mesi, impone che si aspetti prima di cambiare la password anche dopo un attacco (chiaramente per quello che può essere interpretato).

Obbligare gli utenti a cambiare password ogni 90 giorni spesso produce risultati peggiori. Gli utenti, stufi di dover ricordare nuovi codici, usano schemi prevedibili (es. `Inverno2024!`, poi `Primavera2024!`) questo può chiaramente limitare i danni in alcuni casi ma se un hacker ne ha presa una in inverno, beccherà anche quella in primavera.

I dati sensibili, sebbene non definiti direttamente dal GDPR con questo termine, sono 'categorie particolari di dati personali'. Vengono elencati come dati sensibili l'origine **razziale** o **etnica**, le **convinzioni religiose** o **filosofiche**, le **opinioni politiche, lo stato di salute, la vita sessuale e l'orientamento sessuale**. Si sottolinea che questi sono dati personali che appartengono a un sottoinsieme particolare. Dal 2016, sono stati inclusi anche i dati genetici e biometrici dove con biometrici intendiamo quelli misurabili ed esterni come l'impronta digitale e il volto mentre i genetici riguardano nello specifico il genoma. 

```
6. Il codice per l'identificazione, laddove utilizzato, non può essere assegnato ad altri incaricati, neppure in tempi diversi.

7. Le credenziali di autenticazione non utilizzate da almeno sei mesi sono disattivate, salvo quelle preventivamente autorizzate per soli scopi di gestione tecnica. 

8. Le credenziali sono disattivate anche in caso di perdita della qualità che consente all'incaricato l'accesso ai dati personali.

9. Sono impartite istruzioni agli incaricati per non lasciare incustodito e accessibile lo strumento elettronico durante una sessione di trattamento.
```

Da 6. l'idea è che un login non possa essere riutilizzato da qualcun altro. Questo perché altrimenti potrebbe succedere che il precedente proprietario possa ritentare di accedervi o che non sia ben chiaro chi sia a effettuare certe operazioni.
Questo previene attacchi basati su informazioni precedentemente acquisite e garantisce che ogni azione sia attribuibile a un'unica persona, anche se con lo stesso nome.
Una corretta procedura di **offboarding** (cancellazione dell'account) dovrebbe risolvere il problema **eliminando l'account, revocando gli accessi e la cancellazione degli spazi di lavoro.**
La gestione del cambiamento (change management) è fondamentale e qualsiasi cambiamento, come l'arrivo di un nuovo dipendente, la modifica dei ruoli o l'introduzione di un nuovo software, deve essere gestito con procedure specifiche. 

Un mese potrebbe essere un periodo più appropriato per la disattivazione, specialmente per assenze prolungate come il 'sabbatico', e che dovrebbero essere richieste autorizzazioni speciali per periodi più lunghi. 

Si solleva la questione delle credenziali 'mai utilizzate', che potrebbero rimanere attive e rappresentare una vulnerabilità se non gestite correttamente nell'offboarding. Si propone di differenziare la gestione delle credenziali a seconda che siano state utilizzate o meno. 

La 8 ci indica, invece, che è chiaramente necessario disattivare le credenziali qualora si perdesse la possibilità di trattare i dati.

La 9, infine, ci dice che devono essere imposte delle policy sul cosa si può e non si può fare durante la sessione di trattamento per non lasciare lo strumento disponibile a terzi durante la sessione.

## Seconda Lezione

```
10. Quando l'accesso ai dati e agli strumenti elettronici è consentito esclusivamente mediante uso della componente riservata della credenziale per l'autenticazione, sono impartite idonee e preventive disposizioni scritte volte a individuare chiaramente le modalità con le quali il titolare può assicurare la disponibilità di dati o strumenti elettronici in caso di prolungata assenza o impedimento dell'incaricato che renda indispensabile e indifferibile intervenire per esclusive necessità di operatività e di sicurezza del sistema. In tal caso la custodia delle copie delle credenziali è organizzata garantendo la relativa segretezza e individuando preventivamente per iscritto i soggetti incaricati della loro custodia, i quali devono informare tempestivamente l'incaricato dell'intervento effettuato.
```

Immaginiamo questo scenario: Sono l'incaricato e per due mesi non posso lavorare per diversi motivi ma io sono abilitato ad accedere ad un client per mezzo esclusivo di password. In questo periodo l'azienda titolare del dato deve essere abilitata ad assicurarsi che quei dati siano disponibili.

Chiaramente l'incaricato non può dare la propria password a qualcuno, ma allora come garantiamo la continuità operativa? Ci sono delle disposizioni scritte che sanciscono:
- Ci siano copie delle credenziali in maniera tale che questa password rimanga segreta.
- Viene individuato preventivamente per iscritto il soggetto fiduciario che è il custode della copia.
Qualora il titolare avesse necessità di intervenire sul dato, il fiduciario deve immediatamente informare l'incaricato.

Qua ci dice infatti, che non è possibile dare la propria password a qualcun altro, deve esistere un'altra soluzione.

Questa policy è segnata Rossa poiché ormai superata grazie all'uso alle cartelle condivise, ci sono n persone, n-1 vanno via ma 1 rimane sempre.

Al giorno d'oggi, anche le mail hanno account condivisi a cui si accede con diverse credenziali.

```
11. Le disposizioni sul sistema di autenticazione di cui ai precedenti punti e quelle sul sistema di autorizzazione non si applicano ai trattamenti dei dati personali destinati alla diffusione.
```

Questa viene segnata di rosso poiché noi vogliamo delle norme generiche per ogni tipo di dato, senza fare troppe distinzioni.

#### Sistemi di autorizzazioni

```
12. Quando per gli incaricati sono individuati profili di autorizzazione di ambito diverso è utilizzato un sistema di autorizzazione.
```

Tradotto se ci sono diversi profili di autorizzazione, allora serve un sistema di autorizzazione per distinguerli. 

Questa è una regola universale in realtà poiché "quando" in realtà si traduce in sempre.

Viene segnata rossa poiché troppo ovvia

```
13. I profili di autorizzazione, per ciascun incaricato o per classi omogenee di incaricati, sono individuati e configurati anteriormente all'inizio del trattamento, in modo da limitare l'accesso ai soli dati necessari per effettuare le operazioni di trattamento.
```

I profili non possono essere definiti a posteriori del trattamento in modo da limitare l'accesso ai soli dati necessari per le operazioni di trattamento. Così da minimizzare ciò che vede il profilo.

Mezzo giallo perché i profili autorizzativi stanno nel sistema e nei gruppi a prescindere, Abbastanza scontata.

```
14. Periodicamente, e comunque almeno annualmente, è verificata la sussistenza delle condizioni per la conservazione dei profili di autorizzazione.
```

Rosso - giallo perché in realtà il cambiamento può essere gestito tramite delle policy o delle risorse.

```
15. Nell'ambito dell'aggiornamento periodico con cadenza almeno annuale dell'individuazione dell'ambito del trattamento consentito ai singoli incaricati e addetti alla gestione o alla manutenzione degli strumenti elettronici, la lista degli incaricati può essere redatta anche per classi omogenee di incarico e dei relativi profili di autorizzazione
```
Quando ogni anno si aggiorna la lista degli incaricati può essere redatta anche per classi omogenee di incarico e dei relativi profili di autorizzazione.

è chiaro che la gestione dell'autenticazione/autorizzazione sia gestita bene.

```
16. I dati personali sono protetti contro il rischio di intrusione e dell'azione di programmi di cui all'art. 615-quinquies del codice penale, mediante l'attivazione di idonei strumenti elettronici da aggiornare con cadenza almeno semestrale.
```

Art. 615 malware.
Applicare idonei (stato dell'arte) strumenti da aggiornare ogni 6 mesi.

Solo 6 mesi? Vogliamo aggiornamenti continui.

```
17. Gli aggiornamenti periodici dei programmi per elaboratore volti a prevenire la vulnerabilità di strumenti elettronici e a correggerne difetti sono effettuati almeno annualmente. In caso di trattamento di dati sensibili o giudiziari l'aggiornamento è almeno semestrale.
```

Rosso: non è una misura generale e noi vogliamo aggiornamenti continui!

```
18. Sono impartite istruzioni organizzative e tecniche che prevedono il salvataggio dei dati con frequenza almeno settimanale.
```

Perché almeno settimanale?  Chiaramente la risposta qui è "dipende" poiché dipende dall'organizzazione:
- RTO dice Quanto velocemente dobbiamo tornare operativi?
- RPO dice "Quanti dati possiamo permetterci di perdere?". Un RPO di 1 ora significa che, in caso di guasto, i backup devono garantire il recupero dei dati fino a 1 ora prima dell'evento.
Chiaramente vorremmo un RTO di 1 secondo e un RPO di un minuto.

Rosso, è troppo limitante e chiaramente troppo semplicistico.

#### DPS 
Documento di programma di sicurezza 

#### Ulteriori misure in caso di dati sensibili o giudiziari

```
20. I dati sensibili o giudiziari sono protetti contro l'accesso abusivo, di cui all'art. 615-ter del codice penale, mediante l'utilizzo di idonei strumenti elettronici.
```

Anche qui, lo teniamo ma cosa si intende per idoneo? Chiaramente facciamo riferimento allo stato dell'arte.

Abbiamo un qualcosa di molto simile al punto 16 ma che era per i dati personali.

I dati sensibili invece parla di accesso abusivo (?) questo era interpretato con il termine encryption at rest (memoria di massa)

Rosso perché la cifratura dovrebbe essere ovunque nel 2026. 
```
21. Sono impartite istruzioni organizzative e tecniche per la custodia e l'uso dei supporti rimovibili su cui sono memorizzati i dati al fine di evitare accessi non autorizzati e trattamenti non consentiti.
```

Le USB sono spesso perse e non più trovate, allo stesso modo gli hard disk esterni. Cifratura anche qui. 
Lasciate stare le pendrive, giallo: cifratura di default e dovrebbero essere pendrive SOLO aziendali.

Passa al cloud 
```
22. I supporti rimovibili contenenti dati sensibili o giudiziari se non utilizzati sono distrutti o resi inutilizzabili, ovvero possono essere riutilizzati da altri incaricati, non autorizzati al trattamento degli stessi dati, se le informazioni precedentemente in essi contenute non sono intelligibili e tecnicamente in alcun modo ricostruibili.
```

Distruggere e rendere inutilizzabili OVVERO (oppure) rendere intelligibili e irricostruibili i dati sulla USB. Serve sanitizzare le usb cioè sovrascrivere i dati anche a livello fisico (formattazione più e più volte)
Sanitizzare costa più che ricomprare.
Rosso: banniamo le USB in toto ma verde perché va bene sanitizzare.

```
23. Sono adottate idonee misure per garantire il ripristino dell'accesso ai dati in caso di danneggiamento degli stessi o degli strumenti elettronici, in tempi certi compatibili con i diritti degli interessati e non superiori a sette giorni.
```

Siamo alla stessa discussione di 18. 
Va garantito sempre per garantire l'operabilità. Verde il ripristino ma rosso perché dovrebbe essere riferimento a tutti i tipi di dati.

```
24. Gli organismi sanitari e gli esercenti le professioni sanitarie effettuano il trattamento dei dati idonei a rivelare lo stato di salute e la vita sessuale contenuti in elenchi, registri o banche di dati con le modalità di cui all'articolo 22, comma 6, del codice, anche al fine di consentire il trattamento disgiunto dei medesimi dati dagli altri dati personali che permettono di identificare direttamente gli interessati. I dati relativi all'identità genetica sono trattati esclusivamente all'interno di locali protetti accessibili ai soli incaricati dei trattamenti ed ai soggetti specificatamente autorizzati ad accedervi; il trasporto dei dati all'esterno dei locali riservati al loro trattamento deve avvenire in contenitori muniti di serratura o dispositivi equipollenti; il trasferimento dei dati in formato elettronico è cifrato.
```

Quindi, vogliamo che i dati sensibili vengano trattati in maniera disgiunta rispetto agli altri dati personali tramite pseudoanonimizzazione/anonimizzazione.

Anche qui rossastro perché fa riferimento ad altri dati.

Anonimato e cifratura so cose diverse. Dati cifrati se montati sono in chiaro, l'anonimato è garantito in ogni caso. 

I dati sul genoma vanno su locali protetti e non possono uscire da lì se non tramite contenitori con serrature ecc. il trasferimento dei dati in formato elettronico è cifrato.

```
25. Il titolare che adotta misure minime di sicurezza avvalendosi di soggetti esterni alla propria struttura, per provvedere alla esecuzione riceve dall'installatore una descrizione scritta dell'intervento effettuato che ne attesta la conformità alle disposizioni del presente disciplinare tecnico.
```

Si riferisce ai casi in cui la misura viene fatta da enti terzi fatta da una descrizione scritta dell'intervento effettuato che ne attesta la conformità alle disposizioni del presente disciplinare tecnico.

La sicurezza è ricorsiva e dobbiamo assicurarci che tutti siano compliance. 

Sarebbe da aggiornare..

Questa era la situazione fino al 2018.

Tutte questa date, questi limiti ecc. sono dei limiti che dipendono dal contesto. Non è possibile dire "ogni sei mesi, ogni anno ecc."

```
27. Agli incaricati sono impartite istruzioni scritte finalizzate al controllo ed alla custodia, per l'intero ciclo necessario allo svolgimento delle operazioni di trattamento, degli atti e dei documenti contenenti dati personali. Nell'ambito dell'aggiornamento periodico con cadenza almeno annuale dell'individuazione dell'ambito del trattamento consentito ai singoli incaricati, la lista degli incaricati può essere redatta anche per classi omogenee di incarico e dei relativi profili di autorizzazione.
```

Istruzioni? Che istruzioni? non è specificato cosa. Rossa la seconda parte, la prima sni perché non è specificato.

```
28. Quando gli atti e i documenti contenenti dati personali sensibili o giudiziari sono affidati agli incaricati del trattamento per lo svolgimento dei relativi compiti, i medesimi atti e documenti sono controllati e custoditi dagli incaricati fino alla restituzione in maniera che ad essi non accedano persone prive di autorizzazione, e sono restituiti al termine delle operazioni affidate.
```
Questi atti devono essere presi e riposati.

Anche qui, i dati sono limitati

```
29. L'accesso agli archivi contenenti dati sensibili o giudiziari è controllato. Le persone ammesse, a qualunque titolo, dopo l'orario di chiusura, sono identificate e registrate. Quando gli archivi non sono dotati di strumenti elettronici per il controllo degli accessi o di incaricati della vigilanza, le persone che vi accedono sono preventivamente autorizzate
```
Basta con sto sensibili e giudiziari. 
Limitante il fatto che il log deve essere fatto solo dopo l'orario di chiusura
L'ultima parte è totalmente rossa, ci dice che per accedere bisogna chiedere. Tuttavia, se non c'è una vigilanza, chiunque può entrare.

## GDPR 

Abbiamo già notato come la legge 196 faccia riferimento sempre all'idoneità ecc.  il GDPR ci dice che devono essere **CONFORMI ALLO STATO DELL'ARTE**. Qui ci sta un enorme salto di qualità.



Definizioni:
```
dato personale: qualsiasi informazione riguardante una persona fisica identificata o identificabile («interessato»); si considera identificabile la persona fisica che può essere identificata, direttamente o indirettamente, con particolare riferimento a un identificativo come il nome, un numero di identificazione, dati relativi all'ubicazione, un identificativo online o a uno o più elementi caratteristici della sua identità fisica, fisiologica, genetica, psichica, economica, culturale o sociale;
```

L'informazione è il significato di un dato. 

PII: Codice univoco che identifica una persona (CF) è un ID

Si considera un dato personale un informazione che può essere associata a un persona reale. Si deve identificare in maniera univoca e non ambigua.

```
2) «trattamento»: qualsiasi operazione o insieme di operazioni, compiute con o senza l'ausilio di processi automatizzati e applicate a dati personali o insiemi di dati personali, come la raccolta, la registrazione, l'organizzazione, la strutturazione, la conservazione, l'adattamento o la modifica, l'estrazione, la consultazione, l'uso, la comunicazione mediante trasmissione, diffusione o qualsiasi altra forma di messa a disposizione, il raffronto o l'interconnessione, la limitazione, la cancellazione o la distruzione;
```

Qualunque tipo di operazione, anche la cancellazione e la distruzione.

```
4) «profilazione»: qualsiasi forma di trattamento automatizzato di dati personali consistente nell'utilizzo di tali dati personali per valutare determinati aspetti personali relativi a una persona fisica, in particolare per analizzare o prevedere aspetti riguardanti il rendimento professionale, la situazione economica, la salute, le preferenze personali, gli interessi, l'affidabilità, il comportamento, l'ubicazione o gli spostamenti di detta persona fisica; 
```
Analisi dei dati e fare previsioni sul comportamento della persona.

Uso dei dati per calcolare per esempio il rendimento di uno studente, quanto è veloce a fare qualcosa ecc.

```
5) «pseudonimizzazione»: il trattamento dei dati personali in modo tale che i dati personali non possano più essere attribuiti a un interessato specifico senza l'utilizzo di informazioni aggiuntive, a condizione che tali informazioni aggiuntive siano conservate separatamente e soggette a misure tecniche e organizzative intese a garantire che tali dati personali non siano attribuiti a una persona fisica identificata o identificabile;
```