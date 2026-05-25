/*
 * Esercizio 02B  ·  Prodotto scalare  
 *
 * PUNTO DI PARTENZA: ex02a_reduce.c
 * ───────────────────────────────────
 * In 02A ogni processo aveva una somma locale e usava
 * MPI_Reduce per sommarle tutte sul root.
 *
 * VARIANTE: prodotto scalare parallelo
 * ─────────────────────────────────────
 * Ogni processo ha un chunk di due vettori A e B.
 * Calcola il contributo locale al prodotto scalare:
 *   local_dot = A[0]*B[0] + A[1]*B[1] + ... + A[chunk-1]*B[chunk-1]
 *
 * MPI_Allreduce somma i contributi locali → prodotto scalare globale.
 * Tutti i processi ricevono il risultato (Allreduce, non Reduce)
 * perché in un algoritmo iterativo tutti ne hanno bisogno.
 *
 * Inizializzazione:
 *   A[i] = (double)(rank * chunk + i)        → 0,1,2,...,N-1
 *   B[i] = (double)(size*chunk - rank*chunk - i - 1) → N-1,...,1,0
 *   (A e B sono uno il rovescio dell'altro)
 *
 * Prodotto scalare atteso: somma di i*(N-1-i) per i=0..N-1
 *
 * COMPILARE:  mpicc -Wall -O2 -o reduce_b ex02b_reduce.c
 * ESEGUIRE:   mpirun -np 4 ./reduce_b
 */

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define CHUNK 1000   /* elementi per processo */

int main(int argc, char **argv)
{
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    double tot_sum;
    int N = size * CHUNK;   /* dimensione totale dei vettori */

    /* TODO 1: Allocare A[CHUNK] e B[CHUNK].
     *   A[i] = (double)(rank * CHUNK + i)
     *   B[i] = (double)(N - rank * CHUNK - i - 1) */
    

    double *A =(double *) malloc(sizeof(double)*CHUNK);
    double *B =(double *) malloc(sizeof(double)*CHUNK);

    for (int i = 0; i < CHUNK; i++)
    {
        A[i] = (double) (rank*CHUNK+i);
        B[i] = (double) (N-rank * CHUNK - i -1);
    }
    
    double local_dot = 0;


    /* TODO 2: Calcolare il contributo locale al prodotto scalare.
     *   local_dot = somma di A[i]*B[i] per i=0..CHUNK-1 */

    for (int i = 0; i < N; i++)
    {
        local_dot += (A[i]*B[i]);
    }
    

    /* TODO 3: MPI_Allreduce con MPI_SUM per sommare i contributi. */

    MPI_Allreduce(&local_dot, &tot_sum, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

    /* TODO 4: Tutti i processi stampano il risultato. */

    printf("[P-%d] Somma totale %.2f\n", rank,tot_sum);

    MPI_Finalize();
    return 0;
}