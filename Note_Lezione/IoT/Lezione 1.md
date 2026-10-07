Mini-Challenge a gruppi + Progetto a gruppi -> progettare una soluzione IoT completa

Assegnazione del progetto il giorno dell'appello.

--- 
**Cosa è un sistema IoT**
Ecosistema dove qualcosa è in grado di comunicare informazioni. 

Gli è permesso **tenere e mandare (collect and send)** informazioni attraverso la rete.

**Frigorifero Smart**
Immaginiamo di dover produrre un frigo smart, Come lo famo?
Che tipo di sensori usiamo? Che cosa gli facciamo fare? Dove girano le cose che deve fare (sul server o in locale)? Quando e come informa l'utente?

Insomma, progettare una soluzione IoT completa è complicato.

**Da cosa è composto un dispositivo IoT**
Abbiamo:
- Sensori: per recepire il mondo esterno.
- Attuatori: per interagire con il mondo esterno.
- Controller: per scegliere come agire e cosa fare.
- Modulo di comunicazione: per comunicare con altri dispositivi IoT.

Ci sono un sacco di applicazioni dei dispositivi: 
- Smart Home per gestire la casa ecc.
- Smart City per la gestione della città attraverso sensori che magari attivano filtri per la pulizia dell'aria ecc.
- Smart Home per la smuovere il traffico e dirottarlo evitando traffico
- ecc.

**Architettura tipica IoT**
In genere abbiamo:
1. IoT End Device: che sono i dispositivi veri e propri.
2. Gateways: sono in genere i dispositivi che permettono il collegamento alla rete (possono essere anch'essi IoT)
3. UI app: banalmente le app di controllo (web o mobile)
4. Cloud Service: che sono in genere i server remoti che mandano aggiornamenti ecc.
5. Back end: i database banalmente
Esempio:
![[Pasted image 20261007115119.png]]

Schema generale:
![[Pasted image 20261007115146.png]]

**LoWPAN**:Low-Power Wireless Personal Area Network, serve a far sì che i dispositivi si colleghino al gateway che poi li collega alla rete.
