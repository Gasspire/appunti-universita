NFC: RFID ad alta frequenza per poter scambiare dati ma anche avviare altre azioni (pagamenti, browser).

Usa HF RFID 13.56 MHz -> aumenta la banda ma diminuisce la distanza di copertura. La bassa distanza è una feature per ottenere sicurezza.

I dati sono in formato NDEF.

Tecnologia
![[Pasted image 20261020171558.png]]

Come funziona la comunicazione:
1. In maniera passiva come RFID 
2. Comunicazione attiva (richiede che i dispositivi siano caricati a batteria)
L'iniziatore è in genere in polling loop perché continua in loop a chiedere chi ha davanti.![[Pasted image 20261020171834.png]]

NFC-2 è quello più famoso arriva a 2 KB e ha velocità 106 kbps.

I classici MIFARE non sono spesso leggibili perché hanno un formato proprietario.

Stack tecnologici sono: 
![[Pasted image 20261020172044.png]]

Quando il nostro telefono va in Card emulation:
- APDU ci permette di emulare la card
- EMVB, transit ecc. permettono le comunicazioni bancarie ecc.
Per Peer-To-Peer abbiamo quasi la stessa cosa ma usiamo LLCP perché permette lo scambio di messaggi.

NDEF è importante perché ci permette di scrivere o leggere un tag NFC. I tipi ci servono pure.

Come sono i messaggi:
![[Pasted image 20261020172312.png]]

Chunck flag ci dice se ci sono vari record o no
short record ci dice che il payload è al massimo 256 Byte
Il ci dice quando è grande l'id del tag
TNF ci dice come leggere i record NDEF:
![[Pasted image 20261020172543.png]]

URI = **Uniform Resource Identifier** è una sequenza di caratteri che identifica universalmente ed univocamente una risorsa.

0x04 ci dà azioni per sistema operativo android.
Useremo 0x01 e 0x02.

Per 0x01 utilizzeremo dei valori specifici di TYPE per dare un tipo di prefisso.

Esempio:
![[Pasted image 20261020172953.png]]

I tag NFC vengono letti per pagine e solo dalla terza pagina in poi.
E1 10 12 00 è standard, 03 0d è l'header NDEF e la sua lunghezza. D1 contiene l'header che abbiamo visto prima poi 01 la lunghezza e il tipo e 55 = U è il type. Gli altri byte sono il payload. FE è il terminatore.

Noi non faremo tutta questa cosa...
![[Pasted image 20261020173350.png]]
Il loop ci permette di capire se stiamo usando un NFC o meno.

![[Pasted image 20261020173556.png]]

Problemi di sicurezza:
![[Pasted image 20261020173716.png]]

Il problema serio è il cloning (copiamo lo UID e lo emuliamo ed è facile farlo).

NFC ha una password hashata o si usano le chiavi A e B.

---
## Reti WLAN

Si chiamano così perché dovrebbero coprire un'area locale. 

Servono a collegare dei dispositivi a internet (IEEE 802.11)
![[Pasted image 20261020174403.png]]
Il WI-FI (fisico e MAC compatibile con Ethernet) che conosciamo è praticamente questo.

STA: è qualunque client.
AP: sono i ponti con la comunicazione cablata
BSSID: è il nome di UN AP.
SSID: è il nome che si sceglie per rappresentare più AP che estendono la stessa rete.
DS: Cavo fino al router

Perché avere lo stesso SSID? Aumentare la copertura di rete fuori dall'ethernet.

**Topologia di rete WLAN**
![[Pasted image 20261020175017.png]]

La tecnologia P2P permette di comunicare tutti assieme.

Mesh -> ognuno fa quello che vuole a meno che si progetti un buon protocollo di comunicazione.
![[Pasted image 20261020175718.png]]
Era possibile passare da AM a FM (cambia il tipo di canale (ampiezza di frequenza, cambia proprio la frequenza ma l'ampiezza rimane quella))

Il TWT permetteva di andare in sleep per consumare meno.
![[Pasted image 20261020180717.png]]

Spesso i canali si sovrappongono e ci sono disturbi.

Questa banda è condivisa tra bluetooth e ZigBee.
L'11 è bello ma il 13 di più (però il 13 è riservato alle forze dell'ordine)

![[Pasted image 20261020181116.png]]

Puoi capire se c'è stata una collisione ma non puoi evitarle, perché dietro tutte le comunicazioni c'è il cavo (cavo che è unico e pieno di collisioni.)

Cerchiamo di evitarle come si suol dire "a culo" con alcuni meccanismi di **avoidance**. Mi metto in ascolto, nel momento in cui il canale è libero, aspetto un certo tempo DIFS e, se nessuno parla, aspetto un tempo random e poi parlo. Chiunque poi voglia mandare una risposta aspetta il SIFS e poi manda un ACK ma solo se il canale non è occupato. SIFS è più piccolo di DIFS perché così è più probabile che se io mando ricevo risposta.

Ogni volta che ci sono problemi, il tempo random aumenta fino a quando la connessione non si libera. 

Ci importa? Not now.

![[Pasted image 20261020182133.png]]

Abbiamo un canale in cui cui A e C possono parlare con AP. Entrambi possono parlare contemporaneamente perché il loro canale dal loro punto di vista è libero. AP ha il compito di gestire la comunicazione. Come? 

A dice tramite RTS voglio parlare con te.
AP dice CTS per indicare ad A che può mandare i dati. 
Il CTS viene raggiunto anche da C e lui aumenterà il NAV per stare zitto per un certo tempo.

![[Pasted image 20261020182647.png]]

QoS serve a fare divisione della banda WI-FI (non c'è in tutti).

La cosa importante sono i 4 indirizzi, la duration e retry e alcuni flag:
- Gli indirizzi servono 