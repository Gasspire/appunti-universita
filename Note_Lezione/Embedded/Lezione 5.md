## Bit masking
MODER è un registro che ha 32 bit raggruppati a coppie e ognuna rappresenta la modalità di programmazione di quella GPIO. Le possibili sono:
- 00 Input
- 01 Output
- 10 Alternate function: si collega ad una periferica 
- 11 Analog: Permette di convertire da analogico a digitale (li usiamo per i trimmer)

Quando scriviamo GPIO_config_output(GPIO, B,3) -> Prendiamo il registro MODER e lo modifichiamo impostando b6 = 1 e b7 = 0.
Per fare questa roba si fa bit masking.

Come facciamo?
La somma logica ha la **proprietà del massimo** -> Se $X \in [0,1] \rightarrow x + 1 = 1 \leftrightarrow X \text{ OR } 1 = 1$.
Ma anche la **proprietà dell'elemento neutro** -> Se $X \in [0,1] \rightarrow x + 0 = 1 \leftrightarrow X \text{ OR } 0 = X$.

In C abbiamo *&* per l'and logico bit wise e *|* per l'or logico bit wise. Quindi eg. se voglio che il bit 7 viene modificato basta fare:
XXXXXXXX | 01000000 = X1XXXXXX  

Si può scrivere anche spezzando i bit in due quindi 0100 0000 -> 0x40 

Se invece vogliamo mettere un bit a 0 allora possiamo fare così:
XXXXXXXX & 10111111 = X0XXXXXX  

