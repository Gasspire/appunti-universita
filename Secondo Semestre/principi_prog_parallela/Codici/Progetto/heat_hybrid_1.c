#define _POSIX_C_SOURCE 199309L
//COMPILAZIONE: mpicc heat_hybrid_1.c -O2 -Wall -fopenmp -o heat_hybrid
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>
#include <mpi.h>

//#define N 64
//#define N 512
#define N 1024
//#define N 2048

#define TOP 100
#define BOT 0
#define LEFT 75
#define RIGHT 25
#define EPS 1e-4 // Soglia di convergenza definita


/*
FASE 1: Inizializzazione di MPI e OpenMP
FASE 2: Allocazione della matrice fatta da P0
FASE 3: Il carico di lavoro viene suddiviso in base al numero di processi attivi, facendo quindi N/P con P = processi assicurando che se c'è resto banalmente l'ultimo ne prende qualcuna in più
FASE 4: Una volta che il carico è distribuito si scambiano le righe necessarie sotto e sopra: esempio il processo che sta in mezzo ha bisogno sia di quella sopra che di quella sotto e così via
FASE 5.1: Si inizia il lavoro e parallelizziamo il for interno con più thread facendo poi la somma su un TMP in modo da da poi calcolare la norma L2
FASE 5.2: Una volta finito tutto il lavoro si chiama la wait per ottenere le righe necessarie e poi si calcolano i bordi.  
FASE 6: Tutti chiamano la MPI_Allreduce per ottenere L2. Se si finisce si termina, altrimenti si invertono i puntatori u e u_new e si ricomincia
*/


int main(int argc, char  *argv[])
{
    int provided;
    MPI_Init_thread(&argc,&argv, MPI_THREAD_FUNNELED, &provided);
    //controllo che il livello sia quello proposto
    if(provided < MPI_THREAD_FUNNELED){
        printf("ERRORE: Richiesto il livello MPI_THREAD_FUNNELED\n");
        MPI_Abort(MPI_COMM_WORLD,EXIT_FAILURE);
    }

    int num_processi, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &num_processi);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    int dims[1] = {num_processi};
    int periods[1] = {0};
    int reorder = 1;

    MPI_Comm comm_cart;
    MPI_Cart_create(MPI_COMM_WORLD, 1, dims,periods,reorder, &comm_cart);

    MPI_Comm_rank(comm_cart, &rank);
    
    int rank_up, rank_down; //otteniamo i vicini sopra e sotto

    MPI_Cart_shift(comm_cart, 0,1,&rank_up,&rank_down);

    int righe_per_processo = N/ num_processi;
    int resto = N%num_processi; // se N non è esattamente divisibile per numero di processi, dobbiamo considerare queste righe e darle in più all'ultimo


    if(resto != 0 && rank == num_processi-1){
        righe_per_processo+=resto;
    }


    int dimensione_totale = (righe_per_processo +2) * N; // perché due sono quella sopra a quella sotto, N è la dimensione della riga.

    double *u = (double *) calloc(dimensione_totale, sizeof(double));
    double *u_new = (double *) calloc(dimensione_totale, sizeof(double));
    

    //adesso ogni processo dovrà inizializzare la sua parte di matrice.
    //Essendo la suddivisione fatta per riga, ognuno di questi dovrà allocare il valore a sinistra e a destra ma SOLO 0 e NUM-PROCESSI -1 dovranno allocare rispettivamente TOP e BOT
    if(rank == 0){ //inizializziamo il sopra sulla prima riga vera
        for (int i = 0; i < N; i++)
        {
            u[N + i] = u_new[N + i] = TOP;
        }
        // L'angolo in alto a destra scala di conseguenza sulla riga 1
        u[N + N - 1] = u_new[N + N - 1] = RIGHT;
    }

    if(rank == num_processi -1){ //inizializziamo il sotto
        for (int i = 0; i < N; i++)
        {
            u[(righe_per_processo * N)  + i] = u_new[(righe_per_processo * N)  + i] = BOT;
        }
    }
    
    //qui ognuno dovrà inizializzare sx e dx
    for (int i = 1; i <= righe_per_processo; i++) //la riga 0 è usata per l'hello nei casi diversi da P0 
    {
        u[i*N] = u_new[i*N] = LEFT;
        u[(i*N) + N-1] = u_new[(i*N) + N-1] = RIGHT;
    }

    //sistemiamo gli angoli per coerenza con la versione sequenziale
    if(rank == num_processi-1){
        u[(righe_per_processo * N)] = u_new[(righe_per_processo) * N] = LEFT; 
    }
    if(rank == 0){
        u[N-1] = u_new[N-1] = RIGHT;
    }


    double differenza = 0.0;  // qui accumuleremo la somma dei quadrati delle differenze per la norma L2
    int iterazioni = 0; //qui teniamo conto del numero di iterazioni fatte dal While


    double eps_sq = EPS * EPS;
    double differenza_globale;

    double start_time = 0.0, end_time = 0.0;
    MPI_Barrier(comm_cart); // Barriera prima di inizializzare il conto del tempo
    if (rank == 0) {
        start_time = MPI_Wtime();
    }

    do{
        //A questo punto cominciamo il processo di scambio delle righe sotto e sopra
        //Ci viene garantito grazie alla chiamata MPI_Cart_shift che se il vicino sopra/sotto non c'è (caso di rank 0 e rank num_p -1), allora poi con la Send/Recv, non succederà niente e non si verificheranno crash
        differenza = 0.0;
        MPI_Request req_send[2]; //richieste di send per halo
        MPI_Request req_recv[2]; //richieste di recv per halo

        //Quello che vogliamo mandare è la prima riga al processo sopra mentre a quello di sotto vogliamo mandare l'ultima (questo ci è permesso grazie al mapping dei processi dovuti a MPI_Cart_create)

        // Ci mettiamo in attesa tramite chiamate asincrone
        MPI_Irecv(&u[0], N, MPI_DOUBLE, rank_up, 0, comm_cart, &req_recv[0]);
        MPI_Irecv(&u[(righe_per_processo+1) * N], N, MPI_DOUBLE, rank_down, 0, comm_cart, &req_recv[1]);

    
        // Inviamo tramite righe asincrone
        MPI_Isend(&u[1* N], N,MPI_DOUBLE,rank_up, 0, comm_cart,&req_send[0]);
        MPI_Isend(&u[(righe_per_processo * N)], N,MPI_DOUBLE,rank_down, 0, comm_cart,&req_send[1]);

        
        // Parallelizziamo il ciclo tramite OMP stando attenti a non perdere somme su differenza che viene toccata da tutti i thread.
        #pragma omp parallel for reduction(+:differenza) schedule(static)
        for (int i = 2; i < righe_per_processo; i++) //Dobbiamo saltare le prime due righe che sono quella di exchange e quella da calcolare con l'exchange
        {
            for (int j = 1; j < N-1; j++) 
            {
                //Dobbiamo trovare adesso gli indici dx, sx, up,down
                int idx_sopra = ((i-1) * N) + j;
                int idx_sotto = ((i+1) * N) + j;
                int idx_sx = ((i * N) + j) - 1; 
                int idx_dx = ((i * N) + j) + 1; 

                u_new[(i*N)+j] = (u[idx_sopra] + u[idx_sotto] + u[idx_sx]+ u[idx_dx]) *0.25;

                double tmp = u_new[(i*N)+j] - u[(i*N)+j];
                differenza +=(tmp * tmp);
            }
        }
        MPI_Waitall(2,req_recv,MPI_STATUS_IGNORE);

        #pragma omp parallel for schedule(static) reduction(+:differenza)
        for (int i = 1; i < N-1; i++) //calcoliamo le ultime righe arrivate 
        {
            // Solo chi non è il primo processo calcola la prima riga dato che lui può effettivamente calcolarla a prescindere dato che non ha bisogno dello scambio
            if (rank != 0) {
                u_new[N+i] = (u[i] + u[N+i-1] + u[N+i+1]+u[(2*N)+i]) * 0.25; 
                double tmp_1 = u_new[N+i] - u[N+i];
                differenza += (tmp_1 * tmp_1);
            }
            
            // Solo chi non è l'ultimo processo calcola l'ultima riga per le stesse ragioni descritte sopra
            if (rank != num_processi - 1) {
                u_new[(righe_per_processo * N)+i] = (u[((righe_per_processo-1) * N)+i] + u[(righe_per_processo * N)+i -1 ] + u[(righe_per_processo * N)+i +1 ]+u[((righe_per_processo+1) * N)+i]) * 0.25; 
                double tmp_2 = u_new[(righe_per_processo * N)+i] - u[(righe_per_processo * N)+i];
                differenza += (tmp_2 * tmp_2);
            }
        }
        
        MPI_Waitall(2,req_send,MPI_STATUS_IGNORE); // aspettiamo che tutti abbiano terminato
        MPI_Allreduce(&differenza,&differenza_globale, 1, MPI_DOUBLE, MPI_SUM, comm_cart);

        double *tmp_swap = u;
        u = u_new;
        u_new = tmp_swap;

        iterazioni++;

    
    } while (differenza_globale > eps_sq);
    
    MPI_Barrier(comm_cart);  // barriera che ci garantisce che tutti abbiano finito prima di calcolare il tempo di fine
    if (rank == 0) {
        end_time = MPI_Wtime();
        double tempo_esecuzione = end_time - start_time;
        
        printf("Simulazione completata in %d iterazioni.\n", iterazioni);
        printf("Tempo di esecuzione ibrido: %f secondi.\n", tempo_esecuzione);
    }

    MPI_Finalize();

    return 0;
}
