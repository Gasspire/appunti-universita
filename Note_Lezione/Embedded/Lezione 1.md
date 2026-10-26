**Cosa sono i sistemi embedded?**
Un sistema embedded è un **computer designato per specifiche applicazioni**.

All'interno di un microcontrollore **c'è un mini computer** a tutti gli effetti con una cpu, un oscillatore interno, una flash memory, una RAM e I/O.

Un microprocessore contiene solamente la CPU e nient'altro. Per funzionare si affida completamente ad altri componenti integrati sulla stessa scheda madre.

Per quanto riguarda il microcontrollore, questo invece non fa altro se non comunicare con le sue periferiche I/O collegate attraverso dei PIN.

**Come funzionano Software?**
Il software gira si dice sul  **metallo**, cioè, lo carichiamo nel microcontrollore e **parte direttamente il main.** 
Siamo a diretto contatto con l'hardware e **non c'è il SO che interagisce come intermediario** salvo rari casi (e.g. FreeRTOS)
Tipico *design pattern*:
![[Pasted image 20261002112708.png]]

**Come lo programmiamo?**
Abbiamo un ambiente di sviluppo e compilatore per l'architettura target del microcontrollore. Principalmente utilizzeremo il linguaggio C.

Il **circuit debugger programmer** consente l'upload del binario.

STM32F401RE f4 è la famiglia, 01 quantità di memoria il resto è il package cioè come sono disposti i pin
![[Pasted image 20261002113659.png]]

Micro Controller Unit

**Come si programmano le periferiche?**
**C'è una zona di memoria per le periferiche al di fuori di quelle standard**. Ogni indirizzo di memoria rappresenta una periferica su cui posso "scrivere il programma". I **Special Function Registers sono registri hardware e ognuno ha funzioni diverse nel microcontrollore.**

Come scrivo nel SFR? Uso i puntatori C se voglio lavorare a basso livello. Le librerie ci aiutano con delle variabili globali che indicheranno quell'indirizzo.

Ci sarà una libreria fatta dal prof. 

**Strumenti**
- VSCode con PlatformIO extension
- Emulatore di terminale
- Librerie del prof
- Manuale del microcontrollore

**Hardware**
- Scheda 

**Esame**
Pratico + orale
Pratico = software per scheda 
Orale = classico

**Basi**
STM32 è a 3.3V 

Multiplexer

Contatori, Registri e Flip-Flop

#### Segnali logici
Un pulsante premuto è un cambiamento di stato. Ci serve capirlo per agganciarci un interrupt.

Sono di due tipi:
1. **Failing Edge: cerchio + triangolo da 1 a 0.**
2. **Rising Edge: triangolo da 0 a 1.**

Spesso dobbiamo gestire dei segnali periodici:
1. **Periodo: distanza tra due fronti dello stesso tipo (discesa o picco). Si misura in secondi.**
2. **Frequenza: periodi al secondo in Hertz.**

Possono essere simmetrici o asimmetrici:
1. Simmetrici tempo degli stati 1 è uguale a tempi di 0
2. Asimmetrici no
Asimmetricità si può misurare in percentuale o in secondi di entrambi.
*Duty cicle*: possiamo modularla per modulare l'asimmetria.
Può servire per modulare la luminosità della luce. PWM 