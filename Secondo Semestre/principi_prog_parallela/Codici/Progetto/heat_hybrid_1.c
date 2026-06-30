#define _POSIX_C_SOURCE 199309L
//COMPILAZIONE: gcc heat_seq.c -O2 -Wall -lm -o heat_seq_1
//Se si vuole vedere l'aumento di prestazioni tra heat_seq e heat_seq_2 allora bisogna mettere O0.
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>
#include <mpi.h>

#define N 64
//#define N 512
//#define N 1024
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
FASE 5: Si inizia il lavoro e parallelizziamo il for interno con più thread facendo poi la somma su un TMP in modo da da poi calcolare la norma L2
FASE 5.2: Una volta finito tutto il lavoro si chiama la wait per ottenere le righe necessarie e poi si calcolano i bordi.  
FASE 6: Tutti chiamano la MPI_Allreduce per ottenere L2. Se si finisce si termina, altrimenti si invertono i puntatori u e u_new e si ricomincia
*/


int main(int argc, char const *argv[])
{
    int provided;
    MPI_Init_thread(argc,argv, MPI_THREAD_FUNNELED, &provided);
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


    




    MPI_Finalize();

    return 0;
}
