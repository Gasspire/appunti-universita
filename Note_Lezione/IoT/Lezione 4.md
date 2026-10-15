Rete cellulare consuma assj

Posso costruire il livello applicativo direttamente sopra il data link layer skippando il network e transport.
![[Pasted image 20261015174420.png]]

Zigbee si ferma al DLL poi o costruiamo sopra o usiamo cose pronte.

---
## RFID
Primo protocollo di comunicazione Wireless iot.

Ideato per dare un ID a delle cose nei container.

Funziona tramite dei tag (piccoli chip con solo un antenna senza batteria) che potevano essere letti tramite dei reader che funzionavano tramite piccole frequenze che alimentavano il tag.

Il problema del wireless è che il canale è occupato da tanti dispositivi e quindi serve la gestione di qualcosa. 

RFID risolve:
- No batteria.
- Risolve la privacy perché si doveva essere molto vicini al tag.
- C'era anche una sorta di coordinazione nella comunicazione.

![[Pasted image 20261015181600.png]]
![[Pasted image 20261015181646.png]]

**La connessione non esiste è un ideale.**

Nel primo settore ci vanno le info di produzione quali UID, tipologia e chi cazzo ha fatto l'RFID.

In ogni settore l'ultimo è il "trailer" e contiene alcune informazioni di "sicurezza" relative al settore stesso. (come si può accedere e come si può modificare). Totale se abbiamo 64 blocchi da 16 byte, di 1 kb ce ne rimangano 752 b.

![[Pasted image 20261015183633.png]]

BCC cosa sono, ATQA messaggio di risposta.

Key A e Key B so 2 chiavi per gestire meglio i permessi di scrittura o lettura. I bit di accesso ci dicono come possiamo accedere ai blocchi.
	![[Pasted image 20261015183920.png]]