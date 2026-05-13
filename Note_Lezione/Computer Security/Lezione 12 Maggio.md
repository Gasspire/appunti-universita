#palle 
L'encoding è utile per diverse ragioni
- Inserimento in URL 
- Evasione di difese grazie al fatto che il payload modifica la sua forma
Non è una cifratura, cambia solo la forma del payload.

Shikata Ga Nai Encoder è un encoder che non viene quasi mai rilevato né da EDR né da antivirus

Questo funziona come segue:
1. Viene specificata una chiave di inizializzazione
2. In base a dove è caricato il payload, viene recuperato l'indirizzo che chiameremo *addr*
3. Comincia il loop per decodificare le istruzioni:
	1. Decodifica un'istruzione aggiugendo x ad addr e calcolando lo xor
	2. viene modificato l'addr con y
	3. si modifica la chiave
4. Finita la decodifica salta sullo shellcode decodificato
5. Si esegue il payload originale o fa un altro giro di SGN.

Metasploit da dei rank in termini di quando sono buoni:
![[Pasted image 20260512150336.png|612]]

MSF DB mostra delle informazioni raccolte precedentemente. Utilissimo in fase di reporting.

## Migrate

Quando otteniamo una shell meterpreter questo gira su un processo a sé stante. Potremmo voler spostare la shell su un altro processo che sta già girando all'interno del sistema. Fare questo comporta diversi vantaggi:
1. Andiamo su processi che hanno privilegi più alti
2. Essere più stealth.
3. Evitiamo che la shell venga chiusa

Utile per gli sticky key

## Trasporti
Possiamo anche cambiare protocollo di trasporto dopo che siamo entrati