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

