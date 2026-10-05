I circuiti del MCU sono connessi tramite i registri (indirizzi).
![[Pasted image 20261005082744.png]]
Registro del contatore di pezzi alla memoria 0x80c000. Questo registro è collegato da un bus. Per leggere e scrivere il valore in quell'indirizzo basta lavorare dunque con il puntatore:
![[Pasted image 20261005082844.png]]

Qui abbiamo che il puntatore ha un solo significato, cioè tutto è un numero. 
Possiamo avere anche registri i cui singoli bit hanno significati diversi:
![[Pasted image 20261005083029.png]]
 
Si controlla solo il bit di controllo che ci interessa, gli altri potrebbero avere significati diversi. 
Il multiplexer sceglie dove mandare il segnale. Per modificare il singolo bit si fa attraverso le classiche operazioni di AND o OR con delle operazioni tramite **Bit Masking**. (rivedile)

---
#### Digital I/O interface

Può fornire o ricevere corrente facendo input o output.
Stati logici 0 e 1 in base alla corrente che riceve. 

L'interfaccia completa è composta da varie porte GPIOA, GPIOB, ecc. 

Ognuna ha 16 pin elettrici e, dunque, 16 bit.
I Pin sono definiti chiamati con Pxy dove x intende la porta (Che è numerata in lettere A, B ecc.) e y indica il pin (0 a 15)

