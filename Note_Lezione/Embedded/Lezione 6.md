Ogni porta GPIOX ha 11 SFR:
- Moder: lo abbiamo visto per configurare i pin in termini di I/O etc. (vedi lezione 5)
- Otyper: Seleziona il tipo di output per i pin (0 push pull, 1 open drain)
- Ospeedr: Configura la velocità di commutazione.
- Pupdr: 2 bit per gestire le resistenze interne di pull (00 no pull up no pull down, 01 pull up, 10 pull down)
- IDR: contiene i livelli logici campionati sui pin d'ingresso (se sul pin non c'è nulla è undefined)
- ODR: contiene i valori che si vogliono mette sul pin di uscita.
- BSRR: permette di impostare singoli bit di ODR (vedi lezione 7)
- ...
---
## Transistor
Un **transistor** è un dispositivo semiconduttore a tre terminali utilizzato per controllare il flusso di corrente elettrica. Dal punto di vista funzionale, opera principalmente in due modalità fondamentali:
1. **Interruttore controllato (Commutazione / Switching):** Permette di aprire o chiudere un circuito elettrico ad alta velocità senza parti meccaniche in movimento. Un piccolo segnale sul terminale di controllo abilita o blocca il passaggio di corrente tra gli altri due terminali.
2. **Amplificatore:** Utilizza un piccolo segnale di ingresso variabile in corrente o tensione per controllare una corrente di ampiezza maggiore in uscita.

### Transistor MOSFET
Un **MOSFET** è un interruttore elettronico a tre terminali controllato in tensione.
A differenza di un interruttore meccanico (che si aziona con il dito), il MOSFET si apre o si chiude in base alla tensione applicata su un terminale di controllo, senza parti meccaniche e ad altissima velocità. Cioè questo lo possiamo gestire attraverso i bit logici degli SFR. 
Sono composti da 3 terminali:
- **Gate (G):** Il terminale di controllo (il "dito" che aziona l'interruttore).
- **Drain (D):** L'ingresso della corrente principale.
- **Source (S):** La uscita della corrente principale.

Ne esistono di due tipi:
- **NMOS**: Questo si accende (cioè chiude il circuito) quando la tensione è positiva. Questo è infatti collegato a Ground (funge da **pull-down**).
- **PMOS**: Questo si accende (cioè chiude il circuito) quando la tensione è 0. Questo è infatti collegato a VDD (funge da **pull-up**).
---
Il **Push-Pull** (chiamato anche _totem pole_) è la configurazione dello stadio di uscita di una porta GPIO composta da due transistor MOSFET disposti uno sopra l'altro:
- **MOSFET Superiore (PMOS):** Collegato all'alimentazione **$V_{DD}$** ($3.3\text{ V}$).
- **MOSFET Inferiore (NMOS):** Collegato a massa **$GND$** ($0\text{ V}$).
Viene chiamato _Push-Pull_ perché il circuito può spingere corrente verso l'esterno (_Push_, portando il pin a $V_{DD}$) oppure tirare corrente verso massa (_Pull_, portando il pin a $GND$).

![[Pasted image 20261026170024.png|308]]

La **Output Logic** è il circuito interno guidato dai registri della periferica (come `GPIOx_ODR`). In base al valore logico scritto nel registro, aziona i Gate dei due MOSFET nei due modi seguentI:
- **Caso 1: Scrittura di `1` nel registro (Output Logic = 1)**
    - Il MOSFET **superiore (PMOS)** si **CHIUDE**.
    - Il MOSFET **inferiore (NMOS)** si **APRE**.
    - **Risultato sul Pin:** Il pin è collegato a **$V_{DD}$** $\rightarrow$ Tensione = **$3.3\text{ V}$** (Stato logico HIGH / `1`).
- **Caso 2: Scrittura di `0` nel registro (Output Logic = 0)**
    - Il MOSFET **superiore (PMOS)** si **APRE**.
    - Il MOSFET **inferiore (NMOS)** si **CHIUDE**.
    - **Risultato sul Pin:** Il pin è collegato a **$GND$** $\rightarrow$ Tensione = **$0\text{ V}$** (Stato logico LOW / `0`).
    
**Chiusori di circuito controllati:** I due MOSFET lavorano come interruttori elettronici azionati in tensione senza parti meccaniche.
**Toccare i chiusori via registro:** Scrivere nel registro `ODR` modifica lo stato di conduzione dei due transistor.
**Collegamento a GND / Tensione:** Chiudendo il transistor inferiore ci si collega a massa ($0\text{ V} \rightarrow \text{stato } 0$), mentre chiudendo il transistor superiore ci si collega a tensione ($3.3\text{ V} \rightarrow \text{stato } 1$).

I due transistor **non devono mai essere chiusi contemporaneamente**.

Se entrambi i MOSFET si chiudessero nello stesso momento, si creerebbe un percorso a bassissima resistenza tra $V_{DD}$ e $GND$. Questo generebbe un **corto circuito diretto** interno che farebbe scorrere una corrente elevatissima, danneggiando o bruciando in modo permanente lo stadio GPIO dell'STM32. 

---
Nella modalità **Open-Drain**, lo stadio di uscita non usa il MOSFET superiore (PMOS) per portare il pin a $V_{DD}$. Viene attivato/utilizzato solo il **MOSFET inferiore (NMOS)** collegato a massa ($GND$).
Il funzionamento del pin d'uscita in base al registro è il seguente:
- **Se scrivi `0`:** La logica accende l'NMOS. Il pin viene collegato direttamente a **$GND$ ($0\text{ V}$)**.
- **Se scrivi `1`:** La logica spegne l'NMOS. L'interruttore si apre e il pin rimane **flottante (ad Alta Impedenza / High-Z)**, ovvero non è collegato né a $GND$ né a $V_{DD}$
![[Pasted image 20261026170700.png|310]]
A cosa serve? 
Se due dispositivi sono collegati sullo stesso filo e lavorano in **Push-Pull**:
1. Dispositivo 1 vuole inviare `1` $\rightarrow$ Chiude il PMOS e collega la linea a **$V_{DD}$** ($3.3\text{ V}$).
2. Dispositivo 2 vuole inviare `0` $\rightarrow$ Chiude l'NMOS e collega la linea a **$GND$** ($0\text{ V}$).

Si crea un canale a bassissima resistenza direttamente tra $V_{DD}$ del Dispositivo 1 e $GND$ del Dispositivo 2. Questo fa scorrere una corrente elevatissima (evidenziata in rosso nella foto con l'etichetta `ON` su entrambi i transistor dei due dispositivi differenti), la quale **brucia i MOSFET dei microcontrollori**.
Per collegare più dispositivi sulla stessa linea senza rischiare corto circuiti, si configura l'uscita in **Open-Drain** e si aggiunge una **resistenza di Pull-up esterna** collegata a $V_{DD}$, quando scriviamo 1, il MOS sotto si apre e quindi l'ouput pin poiché collegato a VDD dà 1. 
![[Pasted image 20261026171000.png|368]]
Se scriviamo 0, invece, grazie alla presenza della resistenza abbiamo che l'output pin è 0.
![[Pasted image 20261026171157.png|394]]

---

## Collegamento a matrice
Il **collegamento a matrice** è una tecnica circuitale usata per connettere un elevato numero di tasti a un microcontrollore riducendo drasticamente il numero di pin GPIO necessari.
#### 1. Il Principio di Funzionamento
I tasti sono disposti in una griglia formata da **Righe (Rows)** e **Colonne (Columns)**. Un pulsante si trova a ogni intersezione: quando viene premuto, chiude il contatto elettrico tra quella specifica riga e quella specifica colonna.
Per una matrice di $R$ righe e $C$ colonne:
- **Tasti gestibili:** $R \times C$
- **Pin GPIO richiesti:** $R + C$
    
![[Pasted image 20261026093204.png|399]]
_(Esempio: per una tastiera da 16 tasti disposti in 4 righe e 4 colonne servono solo $4 + 4 = 8$ pin GPIO, anziché 16)._
#### 2. La Tecnica dello Scansione (Scanning)
Poiché non possiamo leggere tutti i tasti contemporaneamente con segnali statici, la matrice viene letta in modo dinamico (**scansione sequenziale**):
1. **Configurazione dei Pin:**
    - Le **Righe** vengono configurate come **Output** in modalità **Open-Drain** (flottante) (oppure Push-Pull azionate una alla volta).
    - Le **Colonne** vengono configurate come **Input** con resistenze di **Pull-up** attive (quindi mantengono il valore logico `1` a riposo).
2. **Algoritmo di Scansione:**
    - La logica del microcontrollore porta **a livello LOW (`0`) UNA sola riga alla volta**, lasciando le altre ad alta impedenza (flottanti/HIGH).
    - Controlla lo stato logico di tutte le **Colonne**:
        - Se una colonna legge **`1`**: nessun tasto su quella riga è premuto.
        - Se una colonna legge **`0`**: il tasto all'intersezione tra la riga attualmente attiva (`0`) e quella colonna è **PREMUTO** (il contatto ha tirato a massa la colonna).
    - Ripete l'operazione in ciclo per tutte le righe successive a frequenza elevata (scansione continua).
#### 3. Il Problema del Corto Circuito su Tasti Multipli (Perché si usa Open-Drain)
Se un utente preme **più tasti contemporaneamente sulla stessa colonna** (es. Tasto R1-C1 e Tasto R2-C1):
- **Se le righe fossero in Push-Pull:** Quando Riga 1 è a `1` ($V_{DD}$) e Riga 2 è a `0` ($GND$), la pressione contemporanea collegherebbe fisicamente $V_{DD}$ a $GND$ attraverso i due pulsanti chiusi. Questo creerebbe un **corto circuito** che brucerebbe le uscite GPIO del microcontrollore.
- **Soluzione con Open-Drain + Pull-up:** Utilizzando la modalità Open-Drain sulle righe (dove `0` = collegato a GND, e `1` = aperto/flottante):
    - La riga inattiva non forza tensione positiva ($V_{DD}$), ma rimane semplicemente scollegata (flottante).
    - Premere più tasti collegherà semplicemente la colonna alla riga attiva a GND, **senza alcun rischio di corto circuito**.