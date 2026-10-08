## Componentistica IoT

Standard:
![[Pasted image 20261008171148.png|897]]

Sensore: dispositivo che può percepire cambiamenti nell'ambiente. Devi tenere conto di:
1. Quanto è sensibile al fenomeno.
2. Se è sensibile ad altri fenomeni.
3. Non deve modificare con il suo funzionamento la misura che deve fare.

Ogni sensore ha:
- Un certo range di minimo e massimo di misura
- Quanto riesce a capire la variazione 36 -> 37
- Quanto è preciso 36.4

Possono essere:
- Passivo o Attivo (in termini di richiesta di energia esterna)
- Metodo per percepire la misura richiesta.
- Analogico (segnale continuo) o Digitale (segnale discreto).

Batteria Iphone vita in base alla massima capacità di assorbimento *attuale*. (ci mostra il 100% però in realtà non sono più i 4.7 perché lo stato di vita della batteria è meno quindi ha capacità minore?)

Micro-controllore: è un computer con tutti i suoi componenti integrati che può essere programmato. L'unica cosa che si mette in output/input sono le sue periferiche. (es. non puoi togliere le ram e cambiarle ecc. è single-purpose)

Micro-processore:  ha le funzionalità di una CPU in un solo circuito integrato.

Il MAC non è un computer perché non ci sono i bus e c'è una memoria unificata.

![[Pasted image 20261008173501.png]]

Slide:

Watchdog timer: sistema di sicurezza che si accorge se qualche microprocessore si è bloccato. In tal caso lo azzera. (non lo usiamo)

Interfacce seriali: protocolli di comunicazione seriale (sincrono o asincrono). Ci servono per far comunicare i micro controllori tra loro.

STM 32 due parti: uno per programmare e l'altra per il microcontrollore vero e proprio.
