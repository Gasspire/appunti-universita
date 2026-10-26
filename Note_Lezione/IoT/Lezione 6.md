![[Pasted image 20261022171928.png]]


Il processo di connessione ad una rete Wi-Fi (Joining) si suddivide in 4 fasi principali:
1. **Discovery:** Individuazione dell'AP tramite ascolto dei _Beacon_ periodici (~100 ms) trasmessi dall'AP (**Passive Scan**) oppure tramite l'invio di _Probe Request_ e ricezione di _Probe Response_ (**Active Scan**). (banalmente il WiFi ogni tanto dice "io esisto, sono tizio ecc.")
2. **Auth + Association:** Negoziazione a livello 2 (MAC layer). Si effettua una prima autenticazione formale (_Open System_) e poi l'associazione finale (_Association Request/Response_), in cui l'AP assegna un **AID (Association ID)** al client.
3. **Key Handshake:** Esecuzione del **4-way handshake (EAPOL)** per WPA2/WPA3. Permette di derivare le chiavi di cifratura di sessione temporanee. L'AP comincia a inoltrare il traffico dati del client solo dopo il successo di questa fase.
4. **IP Configuration:** Scambio di pacchetti **DHCP** per ottenere l'indirizzo IP, la subnet mask, il default gateway e i server DNS. Completato questo step, la connettività TCP/IP (Layer 3+) è attiva.

![[Pasted image 20261022172402.png]]


#### 1. Vantaggi e Architettura di Rete
- **Integrazione Nativa TCP/IP:** Il principale vantaggio del Wi-Fi è la piena compatibilità immediata con lo stack di rete **TCP/IP** e con le infrastrutture internet già esistenti (router, server, cloud), senza la necessità di gateway di traduzione intermedi.
- **Modalità SoftAP (Provisioning della rete):** I microcontrollori IoT (es. ESP32) possono essere configurati in modalità **SoftAP** (Access Point software). Il dispositivo crea una propria rete Wi-Fi locale ed eroga un piccolo **Web Server**: l'utente si connette a questa rete e inserisce le credenziali (SSID e Password) del Wi-Fi di casa tramite una pagina web.
- **Metodi Alternativi di Provisioning:** In alternativa al Web Server via SoftAP, l'invio sicuro delle credenziali al microcontrollore può avvenire tramite **Bluetooth (BLE)**, scansione di un **QR Code**, utilizzo di tag/chiavette **RFID/NFC**, o tramite **WPS**.
#### 2. Limiti Tecnici dell'Infrastruttura Wi-Fi
- **Consumo Energetico Elevato:** Rispetto a protocolli IoT a basso consumo (es. BLE, ZigBee), il Wi-Fi richiede una quantità di energia significativamente maggiore durante l'ascolto e la trasmissione radio, rendendolo critico per dispositivi alimentati a batteria.
- **Capacità e Scalabilità degli AP:** Ogni Access Point fisicamente può gestire un **numero limitato di dispositivi connessi contemporaneamente** (vincolo legato alla memoria dell'AP e ai moduli radio/antenne disponibili).
- **Gestione delle Credenziali:** Trasmettere SSID e password in chiaro durante la fase di prima configurazione espone il dispositivo a rischi di intercettazione se non si adottano canali cifrati (es. WPA2/WPA3 o sessioni HTTPS/BLE cifrate durante il provisioning).
#### 3. Strategie di Risparmio Energetico (Power Management)
- **Deep Sleep (Sospensione Profonda):** Per ovviare all'alto consumo del Wi-Fi, il microcontrollore (MCU) spegne la quasi totalità dei suoi blocchi interni (incluso il modulo radio Wi-Fi). Il chip entra in uno stato di consumo minimo (pochi microampere) e si risveglia solo:
    - Alla scadenza di un **timer interno** (es. ogni 15 minuti per inviare le letture dei sensori).
    - Al verificarsi di un **evento esterno** su un pin di interrupt (es. la pressione di un pulsante o l'attivazione di un sensore di movimento).
- **TWT (Target Wake Time) in Wi-Fi 6 (802.11ax):** Con l'introduzione dello standard **Wi-Fi 6**, è stata integrata la funzionalità **TWT**. Questa permette all'Access Point e al dispositivo IoT di negoziare orari precisi in cui il chip radio può dormire e svegliarsi per scambiare pacchetti, eliminando la necessità di rimanere costantemente in ascolto e riducendo drasticamente il consumo a batteria senza disconnettersi dalla rete.

![[Pasted image 20261022174324.png|694]]

---
#### Esempi di codici

![[Pasted image 20261025184720.png]]
Il codice configura il microcontrollore in modalità **client Wi-Fi (Station)** per tentare la connessione a una rete locale (in questo caso denominata `"IoT-Lab"`).
1. **Inizializzazione delle periferiche:** Avvia l'interfaccia seriale e lo schermo OLED integrato sulla scheda.
2. **Avvio del processo di connessione:** Imposta la modalità **Station** ed esegue in background la sequenza di autenticazione e associazione alla rete Wi-Fi tramite le credenziali fornite.
3. **Gestione del timeout:** Invece di attendere all'infinito, il programma controlla lo stato della connessione per un tempo massimo di 15 secondi.
4. **Visualizzazione dei risultati su display:**
    - Se la connessione ha successo, mostra a schermo l'**indirizzo IP** assegnato al dispositivo via DHCP, la potenza del segnale (**RSSI**) e il **canale radio** in uso.
    - Se la connessione fallisce entro il tempo limite, notifica l'errore sullo schermo.

![[Pasted image 20261025184831.png]]- **Configurazione iniziale (`setup`):** Avvia la porta seriale, imposta la modalità **Station** e disconnette il dispositivo da eventuali reti preesistenti per dedicare il modulo radio unicamente alla scansione passiva/attiva.
- **Scansione delle reti (`scanNetworks`):** Nel ciclo principale, scansiona tutti i canali radio Wi-Fi e restituisce il numero totale `n` di reti individuate.
- **Stampa delle informazioni:** Per ciascuna rete trovata, stampa sulla porta seriale:
    - Il nome della rete (**SSID**).
    - Il **canale radio** su cui trasmette.
    - La potenza del segnale (**RSSI**) espressa in dBm.
    - Il tipo di sicurezza (se la rete è **aperta** o **protetta da password**).
- **Liberazione della memoria e pausa:** Cancella dalla RAM la lista dei risultati della scansione (`scanDelete`) e attende 10 secondi prima di ripetere il processo.
![[Pasted image 20261025184913.png]]