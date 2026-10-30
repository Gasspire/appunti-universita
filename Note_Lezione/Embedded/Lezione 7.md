Un timer è un circuito in grado di dare al software la conoscenza del tempo.

è una variabile globale che si aumenta in base alla fonte di clock. Può essere scritta e letta dal software e può generare **interrupt**.

Un timer può essere usato come **circuito slave** che genera segnali periodici.

![[Pasted image 20261030112044.png]]
Un timer ha diversi SFR e delle variabili globali note come TIMX che puntano agli SFR

![[Pasted image 20261030112346.png]]

La sorgente di clock può essere:
- Interna (clock che deriva dal clock di sistema) Timer clock from RCC (?)
- Esterna (tipo un conta pezzi)
- Esterno QEI -> più avanti. Gli encoder sono dei sensori che permettono di misurare una rotazione e ogni impulso è una "frazione di grado" (senso orario o antiorario). Il timer conta gli impulsi come quello conta i pezzi.

Stabilita la sorgente di clock abbiamo:
![[Pasted image 20261030112900.png]]

Se gli impulsi sono troppo veloci posso usare PSC. 

Auto reload scatena update quando il cnt arriva al massimo -> questo causa due eventi:
- CNT si azzera
- Può generare un interrupt
Le nostre librerie fanno:
- Nella init configura il circuito della periferica per utilizzare la configurazione interna.
- Config time base da i parametri per dividere e quello da mettere nell'autoreload (?)
- utilizzo banalmente on off.

Possiamo utilizzare:
 - get per leggere il valore di counter
 - Set setta
 - update check (is set)
 - update clear (isclear per evento del update del timer)
Utilizziamo 84 MHz per il nostro clock.

![[Pasted image 20261030113537.png]]

Abbiamo una frequenza di $84\cdot10^6$ Hz.
Dobbiamo tenere conto del periodo, cioè: $\frac{1}{84} \cdot 10^{-6}$. Se non facciamo nulla il timer si aggiorna 84 milioni di volte al secondo. Dobbiamo utilizzare il giusto fattore di divisione.

Se vogliamo un tempo di incremento ( $T_{inc}$ )pari a  1 mS, abbiamo bisogno di un presclaer di 84000.

Se ragioniamo in termini di frequenza di incremento avremo che $f_{inc} = 1 / T_{inc} = 10$ Hz

84000 non va in 16 bit, quindi dobbiamo dividere 