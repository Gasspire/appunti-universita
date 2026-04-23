Isabelle, Nededham Schroder simmetrico.

Siamo nella situazione in cui l'ultimo non si chiude e quindi **potrebbe** essere presente un attacco. 

*Vediamo l'attacco di Lowe a causa del sub goal*

L'ultimo lemma che non riusciamo a dimostrare è:

Says B A {$Crypt(pubEKA) \{Nonce\quad NA, Nonce\quad NB\}$}, $B \notin bad, A \notin bad$

Per dimostrare questo ultimo subgoal che per essere dimostrato deve essere falso (perché falso implica falso è vero), vogliamo dimostrare che le precondizioni sono false (cioè assurde).

Quando non riusciamo a trovare la soluzione di un subgoal, dobbiamo andare a considerare ulteriori casi o vedere se abbiamo sbagliato a scrive qualcosa nel lemma o nel protocollo stesso.

Il subgoal ci mette davanti a una situazione più generica in cui A comincia con un attaccante diverso da quello che fa la regola.

I bad possono solo condividere i loro segreti con la spia **MA NON POSSONO USARE LA REGOLA FAKE**. 

Per modellare segretezza diciamo che $Nb \notin analz((spies \quad evs))$ cioè, poiché spies contiene tutti i messaggi, allora diciamo che Nb non è conosciuta dalla spia in nessun messaggio della traccia.

Specifichiamo i nomi per capire a quale specifica nonce facciamo riferimento.

Per quello che riguarda l'autenticazione di un agente, invece, è avere tra le precondizioni un certo gets di un messaggio dimostrando che l'agente che ha prodotto un quel messaggio è un certo X. 
MPair(m1)(m2) = {m1,m2}
## Dimostrazioni in Isabelle
