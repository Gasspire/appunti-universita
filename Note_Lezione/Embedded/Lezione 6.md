Ogni porta X ha 11 SFR:
- Moder: lo abbiamo visto per configurare i pin in termini di I/O etc. (vedi lezione 5)


Cose.. 

---
 **Trasistor MOSFET**

è sostanzialmente un interruttore controllato (?)

2 tipi.

N type (si chiude con gate a tensione positiva) e P type (al contrario): (guarda disegni)
![[Pasted image 20261026082957.png]]


![[Pasted image 20261026083231.png]]


Questi funzionano come dei chiusori di circuito controllati. Quando scriviamo sul registro tocchiamo questi.

Se collego a ground = 0, se collego alla tensione vado a 1.
![[Pasted image 20261026084346.png]]
![[Pasted image 20261026084256.png]]In questo caso se è a 0 nessun problema perché si collega a ground.
Se è output logic è a 1 l'output pin è flottante.

Questi uno sopra l'altro possono simulare un MCU out/input per comunicare. Se uno è a 1 e l'altro a 0, allora genera errore (cortocircuito - I MOS si bruciano) //VEDI FOTO TELEFONO


Come si risolve questo tipo di cosa? Escludiamo banalmente il MOS sopra e ho solo lo 0  o undefined quando sono entrambi 1. Per risolvere, aggiungiamo un riferimento a VDD tramite quella che è una resistenza di Pull-up.

Grazie a questi posso configurare open drain:
![[Pasted image 20261026090203.png]]

Output speed register.

Pull up pull down register

Ci sono altri registri vedremo dopo.

---

## Collegamento a matrice
![[Pasted image 20261026093204.png]]


Tecnica di scansione:: prendo le linee e le collego a 4 output di un micro e 4 di in. 

Ogni volta attivo una riga e poi faccio la scansione delle colonne per vedere quale ho attivato continuamente.

La conversione da tasto ad ASCII lo fa il driver. Quello che viene generato è lo *scan code*.

What if premo due contemporaneamente? Utilizzare un push pull crea un conflitto in questo caso (si brucia) -> open drain e pull up così no problem.

Cosa succede in In se il tasto non è premuto? è flottante -> metto le pull up qui (e non in Out) questo fa si che se il tasto non è premuto è 1, devo far sì che gli out siano pure gli out funzionino così e metto 1.

Abbiamo bisogno di un ritardo che facciamo con le NOP
