## Bit masking

Per effettuare operazioni su SFR (special function register), dobbiamo **manipolare i singoli bit** attraverso operazioni quali:
- Imposta un bit specifico a 0 o a 1.
- Testa il quello specifico bit.
Per fare queste operazioni si utilizza il **bit masking**.

Il **GPIO MODER** è un registro che ha 32 bit raggruppati a coppie e ognuna rappresenta la modalità di programmazione di quella GPIO (porta e.g. dove si collega un pin, un bottone ecc.). Le possibili sono:
- 00 Input
- 01 Output
- 10 Alternate function: si collega ad una periferica 
- 11 Analog: Permette di convertire da analogico a digitale (li usiamo per i trimmer)
![[Pasted image 20261025171125.png]]

Quando scriviamo **GPIO_config_output(GPIO, B,3)** -> Prendiamo il registro MODER e **lo modifichiamo impostando b7 = 0 e b6 = 1.**

**Come facciamo a livello "hardware**
La somma logica ha la **proprietà del massimo** -> Se $X \in [0,1] \rightarrow x + 1 = 1 \leftrightarrow X \text{ OR } 1 = 1$.
Ma anche la **proprietà dell'elemento neutro** -> Se $X \in [0,1] \rightarrow x + 0 = 1 \leftrightarrow X \text{ OR } 0 = X$.

In C abbiamo ***&* per l'and logico bit wise e *|* per l'or logico bit wise.** 
Quindi eg. se voglio che il bit 7 venga posto a 1, basta fare:
$$XXXXXXXX | 01000000 = X1XXXXXX  $$

**Si può scrivere anche spezzando i bit in due quindi** **0100 0000 -> 0x40** 

Se invece vogliamo mettere un bit a 0 allora possiamo fare così:
$$XXXXXXXX \text{  } \& \text{  }10111111 = X0XXXXXX  $$

Possiamo anche scrivere 1 << 6 che vuol dire letteralmente **1 shiftato 6 volte**, cioè **00100000**

Per modificare un singolo pin tramite il registro `ODR` (_Output Data Register_), occorre leggere il valore attuale del registro, applicare una maschera logica (`|` per impostare a 1, `& ~` per azzerare) e riscrivere il valore completo:
- **Per accendere (impostare a 1):** `GPIOC->ODR = GPIOC->ODR | (1 << 3);`
- **Per spegnere (impostare a 0):** `GPIOC->ODR = GPIOC->ODR & ~(1 << 3);`
Questo approccio richiede più istruzioni di macchina e non è atomico (può essere interrotto da un'interruzione hardware durante il ciclo di lettura-modifica-scrittura).

Il registro **BSRR** elimina la necessità di leggere lo stato attuale del registro prima di scriverlo. È un registro a **32 bit** suddiviso in due sezioni da 16 bit:
1. **Bit 0–15 (Sezione SET):** Scrivere `1` in uno di questi bit forza il pin corrispondente a **1 (HIGH)**.
2. **Bit 16–31 (Sezione RESET):** Scrivere `1` in uno di questi bit forza il pin corrispondente a **0 (LOW)**.
Scrivere `0` su un qualsiasi bit del registro `BSRR` viene ignorato e **non modifica** lo stato del pin relativo.
Quindi:
- GPIOC -> BSRR = 1 << 3 Accende perché mette 1 sul pin di accensione.
- GPIOC->BSRR = 1 << 16+3 Spegne perché metto 1 sul pin di spegnimento.

Per verificare lo stato di un singolo bit all'interno di un registro (operazione di **mascheramento**):
1. **Applicazione della maschera (AND bit a bit):** Si esegue l'operazione `REGISTRO & (1 << n)`. Questo azzera tutti i bit tranne il bit $n$-esimo di interesse, isolandolo.
2. **Valutazione del risultato:**
    - Se il risultato è diverso da $0$ (nello specifico, pari a $2^n$), il bit era **1 (HIGH)**.
    - Se il risultato è uguale a $0$, il bit era **0 (LOW)**.
```
// Isola il bit 4 del registro GPIOB->IDR (o ODR)
if ((GPIOB->IDR & (1 << 4)) != 0) {
    // Il bit PB4 è a 1 (HIGH)
} else {
    // Il bit PB4 è a 0 (LOW)
}
```