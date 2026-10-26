Il protocollo NFC fa parte della famiglia RFID ma che usa alta frequenza per poter scambiare dati e avviare altre azioni come pagamenti, o aprire pagine sul browser.

Usa HF RFID 13.56 MHz, questo **aumenta la banda** ma **diminuisce la distanza di copertura** che ci permette anche di avere della sicurezza in più.

Tutti i dati dei tag NFC sono in formato **NDEF**.

Tecnologia
![[Pasted image 20261020171558.png]]

Come funziona la comunicazione:
1. In maniera passiva come RFID 
2. Comunicazione attiva (richiede che i dispositivi siano caricati a batteria)

L'iniziatore è in genere in polling loop perché continua in loop a chiedere chi ha davanti.

![[Pasted image 20261020171834.png]]

NFC-2 è quello più famoso arriva a 2 KB e ha velocità 106 kbps.

I MIFARE Classic non sono spesso leggibili perché hanno un formato proprietario.

Stack tecnologici sono: 
![[Pasted image 20261020172044.png]]

Quando il nostro telefono va in **Card emulation:**
- APDU ci permette di emulare la card
- EMV, transit ecc. permettono le comunicazioni bancarie ecc.

Per **Peer-To-Peer** abbiamo quasi la stessa cosa ma **usiamo LLCP perché permette lo scambio di messaggi**.

Per quanto riguarda lettura e scrittura:
- NDEF + RTD è importante **perché ci permette di scrivere o leggere un tag** NFC
- I tipi ci servono pure per capire con **cosa stiamo lavorando in termini di protocollo**.

Come sono composti i messaggi:
![[Pasted image 20261020172312.png]]

- **MB (Message Begin - bit 7):**
    - **1:** Indica che questo è il **primo record** all'interno del messaggio NDEF.
    - **0:** Il record è intermedio o finale.
    - _Nota:_ Se un messaggio contiene un solo record, sia `MB` che `ME` sono impostati a `1`.
- **ME (Message End - bit 6):**
    - **1:** Indica che questo è l'**ultimo record** che compone il messaggio NDEF.
    - **0:** Segue almeno un altro record.
- **CF (Chunk Flag - bit 5):**
    - **1:** Indica che il record fa parte di un **payload frammentato (chunked)** distribuito su più record contigui.
    - **0:** Il record contiene il payload completo o è il frammento finale di un chunk.
- **SR (Short Record - bit 4):**
    - **1:** Il campo `PAYLOAD LENGTH` è di **1 solo Byte** (quindi la dimensione del payload va da $0$ a $255$ byte).
    - **0:** Il campo `PAYLOAD LENGTH` è di **4 Byte** (necessario per payload $\ge 256$ byte).
- **IL (ID Length Present - bit 3):**
    - **1:** Il campo `ID LENGTH` (1 Byte) e il campo opzionale `ID` sono **presenti** nel record NDEF.
    - **0:** I campi `ID LENGTH` e `ID` **non sono presenti** (risparmiando spazio in memoria).
- **TNF (Type Name Format - bit 2..0, 3 bit):**
    - Definisce la **struttura e il contesto del campo `TYPE`** (ovvero la modalità con cui interpretare i dati memorizzati nel payload, come ad esempio un URL, testo semplice, MIME type o URI):
![[Pasted image 20261020172543.png]]

URI = **Uniform Resource Identifier** è una sequenza di caratteri che identifica universalmente ed univocamente una risorsa.

0x04 ci dà azioni per sistema operativo android.
Useremo 0x01 e 0x02.

Per 0x01 utilizzeremo dei valori specifici di TYPE per dare un tipo di prefisso.

Esempio:
![[Pasted image 20261020172953.png]]

La memoria dei tag NTAG213 è organizzata in pagine di 4 byte e i dati utente vengono scritti a partire dalla **Pagina 3**.
- **Pagina 3 (`E1 10 12 00`):** È il **Capability Container (CC)**, che definisce lo standard NDEF supportato e la dimensione della memoria usabile.
- **Pagina 4 (`03 0D`):** Rappresenta il wrapper **TLV (Tag-Length-Value)**. Il byte `03` indica che segue un messaggio NDEF e `0D` (13 in decimale) è la lunghezza totale del record NDEF sottostante.
- **Header NDEF (`D1 01 09 55`):**
    - `D1`: Byte di controllo con i flag `MB`, `ME`, `SR` attivi e `TNF = 1` (Well-Known Type).
    - `01` e `09`: Indicano rispetivamente 1 byte per la lunghezza del Tipo e 9 byte per la lunghezza del Payload.
    - `55`: Codice ASCII del tipo di Record `'U'` (URI).
- **Payload (`02` + `"unict.it"`):** Il byte `02` è il prefisso NDEF che abbreviando la stringa sta per `https://www.`. I byte successivi (`75 ... 74`) rappresentano la stringa ASCII `"unict.it"`.
- **Terminatore (`FE`):** Marca la fine del messaggio NDEF all'interno della memoria del tag.
```
// Struttura del messaggio NDEF per l'URL "https://www.unict.it" (16 byte totali)
uint8_t ndef[16] = {
  0x03, 0x0D, 0xD1, 0x01,  // Header TLV (Tag=0x03, Len=13), Header NDEF (0xD1), Type Len (1B)
  0x09, 0x55, 0x02, 0x75,  
  // Payload Len (9B), Type 'U' (URI), Prefisso "https://www.", inizio "u"
  0x6E, 0x69, 0x63, 0x74,  // Stringa ASCII "n", "i", "c", "t"
  0x2E, 0x69, 0x74, 0xFE   // Stringa ASCII ".", "i", "t", Terminator TLV (0xFE)
};

void loop() {
  uint8_t uid[7], len;

  // 1. Rileva una scheda o tag RFID/NFC nelle vicinanze
  if (!nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &len))
    return;

  // 2. Filtra solo i tag della famiglia NTAG21x (che utilizzano un UID a 7 byte)
  if (len != 7) return;

  // 3. Scrittura sequenziale della memoria a blocchi/pagine di 4 byte
  // Cicla 4 volte per scrivere le Pagine 4, 5, 6 e 7 (4 pagine x 4 byte = 16 byte)
  for (uint8_t p = 0; p < 4; p++)
    nfc.ntag2xx_WritePage(4 + p, &ndef[p * 4]);

  // Notifica il completamento della scrittura sulla porta seriale
  Serial.println("Done: tap the tag with your phone!");
  delay(2000); // Pausa di 2 secondi prima di una nuova scansione
}
```

---
è anche possibile utilizzare lo smartphone in versione card emulation come segue:

![[Pasted image 20261020173556.png]]

![[Pasted image 20261020173716.png]]

NFC ha una password hashata o si usano le chiavi A e B.

---
## Reti WLAN

Si chiamano così perché dovrebbero coprire un'area locale. 

Servono a collegare dei dispositivi a internet (IEEE 802.11)
![[Pasted image 20261020174403.png]]
Il WI-FI (fisico e MAC compatibile con Ethernet) che conosciamo è praticamente questo.
Nomenclatura:
- STA: è qualunque client.
- AP: sono i ponti con la comunicazione cablata
- BSSID: è il nome di UN AP.
- SSID: è il nome che si sceglie per rappresentare più AP che estendono la stessa rete.
- DS: Cavo fino al router
Perché avere lo stesso SSID? Aumentare la copertura di rete fuori dall'ethernet.

**Topologia di rete WLAN**
![[Pasted image 20261020175017.png]]

La tecnologia P2P permette di comunicare tutti assieme.
Mesh -> ognuno fa quello che vuole a meno che si progetti un buon protocollo di comunicazione.
![[Pasted image 20261020175718.png]]
Era possibile passare da AM a FM (cambia il tipo di canale (ampiezza di frequenza, cambia proprio la frequenza ma l'ampiezza rimane quella))
Il TWT permetteva di andare in sleep per consumare meno.


![[Pasted image 20261020180717.png]]

1. Il Wi-Fi trasporta dati digitali (`0` e `1`) attraverso l'aria usando **onde radio** (onde elettromagnetiche).
    - La **frequenza** (espressa in Hertz, Hz) indica quante oscillazioni dell'onda avvengono in un secondo. Dire che il Wi-Fi funziona a **2.4 GHz** significa che l'onda radio oscilla circa **2.4 miliardi di volte al secondo**.
2. **Modulazione di Frequenza (FM) e Modulazioni Digitali:**
    - Nelle radio classiche (es. Radio FM), la voce o la musica vengono codificate modificando la frequenza dell'onda portante (**Modulazione di Frequenza - FM**).
    - Il Wi-Fi si basa su concetti simili di modulazione della frequenza portante, ma utilizza tecniche digitali avanzate (come **OFDM - Orthogonal Frequency-Division Multiplexing**). Queste tecniche dividono la frequenza in sotto-canali per "impacchettare" i bit di dati digitali dentro l'onda radio.
3. **Perché dividere in Canali e Frequenze specifici:**
    - Poiché l'aria è un mezzo condiviso aperto a tutti, se due dispositivi trasmettono sulla stessa identica frequenza nello stesso momento, i loro segnali radio si "sommano" distruggendosi a vicenda (collisione).
    - **Allocare frequenze e canali specifici** serve quindi a creare delle "corsie stradali" separate per fare in modo che i dispositivi possano comunicare senza sovrapporsi e cancellare i rispettivi segnali.
### 📌 Frequenze e Canali nel Wi-Fi a 2.4 GHz
1. **Struttura dello Spettro:**
    - La banda ISM a 2.4 GHz (2400–2483.5 MHz) è divisa in **13 canali** in Europa (spaziati tra loro di soli **5 MHz**).
    - Ciascun canale Wi-Fi ha una larghezza di banda reale di **20–22 MHz**.
2. **Problema della Sovrapposizione (Overlap):**
    - Poiché la larghezza di un canale (20 MHz) è maggiore della distanza tra due canali adiacenti (5 MHz), i canali si sovrappongono parzialmente generando interferenze (es. il Canale 3 si sovrappone sia al 1 che al 6).
    - Gli unici tre canali **totalmente non sovrapposti** (Non-Overlapping) utilizzabili contemporaneamente nella stessa area sono **1, 6 e 11**.
### ⚠️ Coesistenza e Interferenze nella Banda 2.4 GHz

1. **Affollamento del Mezzo Fisico:**
    - La banda a 2.4 GHz è priva di licenza e viene condivisa da molteplici tecnologie: **Wi-Fi**, **Bluetooth / BLE**, **ZigBee (802.15.4)** e dispositivi domestici (forni a microonde, videocamere).
2. **Problemi nei Dispositivi IoT (es. ESP32):**
    - **Collisioni RF e Perdita di Pacchetti:** Segnali di tecnologie diverse presenti sulla stessa frequenza o su canali sovrapposti generano rumore di fondo, provocando degradazione del segnale e ritrasmissioni.
    - **Multiplexing Temporale (Antenna Condivisa):** Sui microcontrollori come l'ESP32 — che condividono lo stesso chip radio e la stessa antenna per Wi-Fi e Bluetooth — la trasmissione Wi-Fi prolungata può bloccare temporaneamente lo scambio di pacchetti Bluetooth/BLE, richiedendo meccanismi di coesistenza software a divisione di tempo.

![[Pasted image 20261020181116.png]]

Nel Wi-Fi non è possibile rilevare una collisione mentre si trasmette (_Collision Detection_), perché la propria trasmissione radio copre e acceca il ricevitore del dispositivo stesso. Di conseguenza, si adotta un approccio preventivo basato sul protocollo **CSMA/CA (Carrier Sense Multiple Access with Collision Avoidance)**.
#### 1. Ascolto del Canale e DIFS (Distributed Inter-Frame Space)
- Prima di trasmettere, il nodo effettua il **Carrier Sensing** (ascolta il mezzo radio).
- Se il canale risulta libero, il dispositivo non trasmette immediatamente, ma attende un intervallo di tempo fisso chiamato **DIFS**.
- Se il canale rimane libero per l'intera durata del DIFS, il nodo passa alla fase successiva per ridurre la probabilità che due nodi trasmettano nello stesso istante.
#### 2. Meccanismo di Backoff Casuale (Exponential Backoff)
- Trascorso il DIFS, il nodo attende un tempo di **Backoff casuale** (_Random Backoff Time_), estratto all'interno di una finestra di collisione (**Contention Window**).
- Durante questa attesa, il nodo continua ad ascoltare il canale: se il canale rimane libero fino allo scadere del timer di Backoff, il nodo invia finalmente il frame di dati.
#### 3. Risposta prioritaria: SIFS (Short Inter-Frame Space) e ACK
- Nel Wi-Fi, ogni frame dati unicast deve essere confermato dal destinatario tramite un pacchetto di **ACK (Acknowledgment)** per garantire che sia arrivato integro.
- Il destinatario attende un intervallo chiamato **SIFS** prima di inviare l'ACK.
- **Perché SIFS è più breve di DIFS ($SIFS < DIFS$)?** Fornire all'ACK un tempo di attesa più breve garantisce al destinatario la **massima priorità d'accesso al canale**, impedendo a qualsiasi altro nodo (ancora in attesa del proprio DIFS) di occupare il mezzo prima che la conferma di ricezione sia stata trasmessa.
#### 4. Gestione delle Collisioni e Adattamento della Finestra
- Se l'emittente non riceve l'ACK (a causa di una collisione o di forte rumore RF), considera il pacchetto perso.
- A ogni fallimento, la dimensione della **Contention Window viene raddoppiata in modo esponenziale** (fino a un limite massimo `CWmax`).
- L'estrazione del tempo di Backoff casuale su un intervallo via via più ampio riduce drasticamente la probabilità di collisioni ripetute in presenza di molti dispositivi concorrenti.




![[Pasted image 20261020182133.png]]

Abbiamo un canale in cui cui A e C possono parlare con AP. Entrambi possono parlare contemporaneamente perché il loro canale dal loro punto di vista è libero. AP ha il compito di gestire la comunicazione. Come? 

A dice tramite RTS voglio parlare con te.
AP dice CTS per indicare ad A che può mandare i dati. 
Il CTS viene raggiunto anche da C e lui aumenterà il NAV per stare zitto per un certo tempo.

---

![[Pasted image 20261020182647.png]]

QoS serve a fare divisione della banda WI-FI (non c'è in tutti).

La cosa importante sono i 4 indirizzi, la duration e retry e alcuni flag:
- **Address 1: Receiver Address (RA)** $\rightarrow$ L'indirizzo del dispositivo wireless che riceve direttamente il segnale radio (es. l'Access Point o la scheda di rete del client).
- **Address 2: Transmitter Address (TA)** $\rightarrow$ L'indirizzo del dispositivo wireless che sta trasmettendo fisicamente il segnale radio.
- **Address 3: Destination Address (DA)** o **Source Address (SA)** $\rightarrow$ L'indirizzo del destinatario finale o del mittente originale del pacchetto a livello di rete.
- **Address 4: Source Address (SA)** $\rightarrow$ Utilizzato solo in scenari specifici (es. Wireless Distribution System / Mesh) per indicare il mittente originale quando il pacchetto attraversa più bridge wireless.

Questi servono perché in un frame **Ethernet (802.3)** su cavo servono solo 2 indirizzi (_Source MAC_ e _Destination MAC_) perché la connessione è punto-a-punto o gestita direttamente dallo switch.

Nel **Wi-Fi (802.11)**, una stazione wireless (client) non comunica direttamente con la rete cablata o con un altro client situato in un'altra sottorete, ma passa quasi sempre attraverso un **Access Point (AP)**. Bisogna quindi distinguere chi **trasmette via radio** da chi è il **mittente originale**, e chi **riceve via radio** da chi è il **destinatario finale**.