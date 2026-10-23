Rete cellulare consuma assai.

Posso costruire il livello applicativo direttamente sopra il data link layer skippando il network e transport.
![[Pasted image 20261015174420.png]]

Zigbee si ferma al DLL poi o costruiamo sopra o usiamo cose pronte.

---
## RFID
RFID fu il primo protocollo *wireless* adottato in campo IoT.

Questo protocollo nasce dall'idea di voler risolvere il problema del contenuto dei container senza aprirli.

Il funzionamento si basa su dei **Tag passivi** che erano dei piccoli chip con una sola antenna e senza batteria che potevano essere letti attraverso dei **Reader** il cui compito era quello di inviare dei segnali in grado di attivare i tag passivi e riceve le informazioni che questi gli inviavano.

Quando parliamo di wireless in generale, il problema principale è che il canale è occupato da tanti dispositivi e quindi serve la gestione della comunicazione rispetto all'hub a cui questi sono *connessi*. In realtà, la parola *connessione* sembra indicare qualcosa di persistente in maniera passiva quando, in realtà, qui banalmente la connessione non è altro che un continuo scambio di messaggi per tenersi "attivi". 

RFID risolve:
- No batteria, dunque costo piuttosto basso e 0 problemi legati alla sostituzione.
- Risolve la privacy perché si doveva essere molto vicini al tag per poterlo leggere.
- Coordinazione nella comunicazione per cui prima il reader invia il segnale e poi banalmente il tag risponde.

![[Pasted image 20261015181600.png]]
- **Power up (Accensione):**
    - Il reader emette un'onda portante continua (_continuous carrier_).
    - L'antenna del tag raccoglie l'energia del campo elettromagnetico (_energy harvesting_ tramite raddrizzatore + condensatore) e il microchip si sveglia.
- **Command (Comando - _Reader Talks First_):**
    - Il reader invia i comandi modulando la portante con brevi pause (modulazione d'ampiezza ASK - _Amplitude Shift Keying_).
    - Il reader è il primo a parlare (_Reader Talks First_).
- **Reply (Risposta - _Tag Never Transmits_):**
    - Il tag **non genera e non trasmette mai** un proprio segnale radio attivo.
    - Risponde unicamente modificando il proprio carico (in HF) o variando la quantità di segnale riflesso (in UHF tramite _backscatter_).
- **Decode (Decodifica):**
    - Il reader rileva le minime variazioni nel segnale riflesso, lo demodula, verifica la correttezza tramite controllo di ridondanza ciclica (CRC) e invia i dati all'host/sistema applicativo.

**Esistono diversi tipi di sensori RFID:**
![[Pasted image 20261015181646.png|790]]

**Tipologie di Memoria nei Tag RFID**
- **Read-only (Solo Lettura):** L'identificativo (ID) viene scritto direttamente in fabbrica e non è modificabile (es. EM4100 con ID a 40 bit).
- **WORM (Write Once, Read Many):** Scrivibile una sola volta dall'utente, dopodiché viene bloccato in sola lettura.
- **Read/Write (Lettura/Scrittura):** Utilizza memoria EEPROM, supporta circa 100.000 cicli di scrittura e garantisce la ritenzione dei dati per circa 10 anni. Spesso è protetta da chiavi o password.
**Tipi di Identificativo e Capacità**
- **UID (Unique Identifier):** Ogni tag possiede un identificativo univoco che serve esclusivamente per la gestione dell'anti-collisione durante le letture; **non** è una credenziale di sicurezza

**Come funziona il protocollo**
![[Pasted image 20261016134654.png]]
1. **Inizializzazione (REQA / WUPA):**
    - Il Reader invia `REQA (0x26)` o `WUPA (0x52)` per svegliare le carte nel campo RF.
    - La Card risponde con **ATQA** (Answer To Request A, 2 byte), che indica la dimensione dell'UID e le funzionalità di anti-collisione.
2. **Loop di Anti-collisione (ANTICOLLISION / SELECT):**
    - Il Reader invia il comando `ANTICOLLISION (0x93 0x20)`.
    - La Card risponde fornendo i primi 4 byte del proprio **UID** e un byte di controllo integrità **BCC** (calcolato come XOR dei 4 byte dell'UID).
    - Il Reader invia `SELECT (0x93 0x70 + UID + BCC + CRC)` per selezionare specificamente quella carta.
3. **Identificazione della Carta (SAK - Select Acknowledge):**
    - La Card risponde con un byte di **SAK** (1 byte) che ne indica la tipologia:
        - **`0x08`**: MIFARE Classic 1K.
        - **`0x18`**: MIFARE Classic 4K.
        - **`0x00`**: MIFARE Ultralight / NTAG.
        - **`0x20`**: ISO 14443-4 (DESFire, carte bancarie, smartphone HCE).
4. **Operazioni e Chiusura Sessione:**
    - **Transazione:** Vengono eseguiti i comandi applicativi (`AUTH`, `READ`, `WRITE`, ecc.).
    - **Sleep:** Il Reader invia il comando `HLTA (0x50 0x00)` per mettere la carta in stato di riposo (_sleep_).

**Come è composta la memoria MIFARE**:
![[Pasted image 20261016135036.png|645]]
Abbiamo una memoria divisa in *Settori*, ognuno dei quali è scomposto in *blocchi*. Supponendo di avere a disposizione 1024B(yte), avremo 64 blocchi da 16B ciascuno. 
Nello specifico, ogni blocco 

Nel primo blocco (0) ci vanno le info di produzione quali UID, tipologia di RFID e chi lo ha fatto prodotto.

<<<<<<< HEAD
In ogni settore l'ultimo è il "trailer" e contiene alcune informazioni di "sicurezza" relative al settore stesso (come si può accedere e come si può modificare un blocco). 
In totale, se abbiamo 64 blocchi da 16 byte, di 1 kb ci rimangano 752 byte.
![[Pasted image 20261016135650.png]]
- **Key A (Byte 0 – 5):**
    - **6 byte** dedicati alla prima chiave di autenticazione segreta (Chiave A).
    - Il valore predefinito di fabbrica è `FF FF FF FF FF FF`.
    - Durante le operazioni di lettura standard, la chiave non viene mai restituita in chiaro per motivi di sicurezza.
- **Access Bits (Byte 6 – 8):**
    - **3 byte** che definiscono i **diritti di accesso** (lettura, scrittura, incremento, decremento) per tutti i blocchi dati del settore e per il trailer stesso.
    - Il valore di fabbrica `FF 07 80` configura il settore con i permessi standard (lettura/scrittura abilitata usando le chiavi di default).
- **GPB - General Purpose Byte (Byte 9):**
    - **1 byte** di uso generale. Può essere utilizzato dall'applicazione per memorizzare configurazioni specifiche o informazioni aggiuntive. Il valore di fabbrica tipico è `69`. (mai usati)
- **Key B (Byte 10 – 15):**
    - **6 byte** dedicati alla seconda chiave di autenticazione segreta (Chiave B).
    - Il valore predefinito di fabbrica è `FF FF FF FF FF FF`.
    - Può essere usata come *chiave alternativa per concedere livelli di accesso differenti* rispetto alla Key A (ad esempio: Key A solo lettura, Key B lettura e scrittura).


![[Pasted image 20261015183920.png]]
Ogni settore ha 4 blocchi (indicati con $b \in \{0, 1, 2, 3\}$), dove i blocchi 0-2 sono **dati** e il blocco 3 è il **trailer**.
- Per ciascun blocco $b$, i permessi sono determinati da una combinazione di **3 bit di controllo**: $\mathbf{C1_b, C2_b, C3_b}$.
- **Ridondanza e Inversione:** Per evitare che errori di memoria danneggino i permessi, ciascun bit viene salvato sia in forma diretta ($\text{C}$) sia in forma invertita/negata ($\neg\text{C}$).
- **Controllo di Integrità:** Se durante la lettura le copie dirette e quelle invertite non corrispondono, il chip rileva l'inconsistenza e **blocca il settore per sempre** (_sector is locked forever_).
![[Pasted image 20261016135919.png]]
Prima di poter accedere ai dati di un settore, il Reader e la Card eseguono un handshake di autenticazione basato sul cifrario proprietario **Crypto1** (chiave a 48 bit):
1. **Richiesta del Reader:** Il Reader invia il comando `AUTH Key A (0x60)` o `AUTH Key B (0x61)` specificando l'indirizzo del blocco a cui vuole accedere.
2. **Challenge della Card:** La Card genera e risponde con un valore casuale non ripetibile di 32 bit chiamato **`nT`** (_card nonce_).
3. **Risposta Cifrata del Reader:** Il Reader cifrerà e invierà un suo nonce **`nR`** e una risposta autenticata **`aR`** (`{nR, aR} encrypted`).
4. **Verifica della Card:** La Card verifica `aR` e risponde con una conferma cifrata **`aT`** (`{aT} encrypted`).

Dopo questo processo, l'intera sessione di comunicazione rimane cifrata con Crypto1.
- **Regola Chiave:** L'autenticazione è **per settore** (_per sector_). Per accedere ai dati di un settore diverso, occorre autenticarsi nuovamente utilizzando la chiave di quel nuovo settore.
### 2. Set di Comandi MIFARE Classic
Una volta autenticato il settore, il Reader può eseguire i seguenti comandi mediante i rispettivi codici opzionali (_opcode_):
- **`AUTH Key A / B` (`0x60` / `0x61`):** Inizia l'autenticazione fornendo l'indirizzo del blocco.
- **`READ` (`0x30`):** Legge un blocco completo e restituisce **16 Byte**.
- **`WRITE` (`0xA0`):** Scrive **16 Byte** in un blocco (procedura a 2 passaggi).
- **`INCREMENT` (`0xC1`):** Incrementa un valore numerico in un blocco di tipo valore memorizzandolo temporaneamente in un buffer interno.
- **`DECREMENT` (`0xC0`):** Decrementa un valore numerico memorizzandolo temporaneamente nel buffer.
- **`RESTORE` (`0xC2`):** Copia il contenuto di un blocco dati nel buffer interno.
- **`TRANSFER` (`0xB0`):** Scrive il contenuto memorizzato nel buffer interno direttamente all'interno di un blocco dati.
- **`HALT` (`0x50 0x00`):** Mette la carta nello stato di riposo

![[Pasted image 20261016140106.png]]
=======
Key A e Key B so 2 chiavi per gestire meglio i permessi di scrittura o lettura.
La chiave A non è mai leggibile, la chiave B si.
I bit di accesso ci dicono come possiamo accedere ai blocchi.
![[Pasted image 20261015183920.png]]
>>>>>>> 7b4e06b (Auto-sync: 2026-10-16 13:01:43)
