## Codici MAC
1 Dave:
Station MAC: 34:85:18:7B:0A:0C
SoftAP MAC: 36:85:18:7B:0A:0C
2 Diletta:
Station MAC: 34:85:18:7A:B7:00
SoftAP MAC: 36:85:18:7A:B7:00
3 Marco:
Station MAC: 34:85:18:7A:FA:14
SoftAP MAC: 36:85:18:7A:FA:14
4 Antonio:
Station MAC: 34:85:18:7B:1F:68
SoftAP MAC: 36:85:18:7B:1F:68

---
## Prima fase: Sync dei semafori tra loro
Root/Sem 0, Sem 1, Sem 2, Sem 3

Sem 1,2,3,4 si collegano -> Vanno rossi
Sem 0 se vede 3 -> Okay si inizia

## Seconda fase: Si lavora
Dentro loop se x/3 con x != 3 -> manda segnale a tutti "NOT WORKING!"

int turno  = 0/1 -> Se 0 parte gruppo 0, altrimenti parte gruppo 1
Root: 
- Faccio delay green -> mando segnale diventa giallo 

