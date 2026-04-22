
Ogni thread lavora al suo task ma il thread 0 è il **Thread Master**. Gli **IP e SP** si moltiplicano per ogni thread. Tutte le variabili istanziate all'interno della regione parallela sono locali del thread mentre quelle del processo padre sono condivise da tutte. 

Il **Thread Master** ha delle caratteristiche in più rispetto agli altri. 

La chiamate malloc vanno comunque nello **Heap** quindi tutti li possono vedere

OMP_STACKSIZE dice quanto è grande lo stack di un thread. 

Possiamo scegliere il numero di thread massimi che può generare un processo.
Dobbiamo stare attenti al numero di thread che creiamo e con quanta memoria poiché altrimenti rischiamo di andare in fault.

Creazione della sezione parallela
```
#pragma omp parallel{
	int id = omp_get_thread_num();
	#pragma single //
	int nthread = omp_the_num_threads();
	#pragma barrier 
	printf("Hello from thread!");	

}
```

Possiamo anche usare un if dopo parallel per andare a creare la sezione parallela solo al verificarsi di certe condizioni.

Possiamo anche  specificare dopo parallel **num_threads(n)** per creare specificatamente n threads.

Esiste un'altra clausola che è **proe_bind(keyword)** che vediamo dopo.

**Barrier** fa' sì che tutti i thread si fermano fino a quando non sono arrivati allo stesso punto. Naturalmente, rischiamo di perdere efficienza poiché mettiamo realmente i thread in attesa.

---
## Come gestire la memoria

OpenMP permette anche di gestire la memoria attraverso alcuni attributi o metodi specifici.

La regola di base la conosciamo, tutto quello che è prima della sezione parallela è **Condiviso** mentre ciò che sta dentro la sezione parallela è **privata** del singolo thread. 

Possiamo definire tramite la clausola **private(var1, var2, ..., n)** che le variabili var saranno *private* per ogni thread, cioè, ognuno si fa una copia della variabile var e ognuno ha il suo.

Se definiamo un indirizzo private rischiamo *anomalie*.

Meglio dichiarare direttamente le variabili all'interno della regione condivisa.

Altri tag da vedere dalle slide.

