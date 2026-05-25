/*
 * Esercizio 00B  ·  MPI_Bcast 
 * PUNTO DI PARTENZA: ex00a_bcast.c
 * ────────────────────────────────
 * In 00A il root distribuiva un intero N a tutti i processi.
 *
 * VARIANTE
 * ────────
 * Il root genera un array di N double (con valori casuali
 * tramite rand()) e lo distribuisce a tutti con MPI_Bcast.
 * Ogni processo verifica che il primo e l'ultimo elemento
 * dell'array coincidano con quelli del root.
 *
 * SCHEMA:
 *   Root: genera array[N] con valori rand()
 *         distribuisce array a tutti con MPI_Bcast
 *   Tutti: stampano array[0] e array[N-1]
 *          (devono essere identici su tutti i processi)
 *
 * HINT
 * ────
 * MPI_Bcast può distribuire non solo scalari ma anche array:
 *   MPI_Bcast(array, N, MPI_DOUBLE, 0, MPI_COMM_WORLD)
 * Prima di chiamare MPI_Bcast, tutti i processi devono aver
 * allocato il buffer di dimensione N.
 *
 * COMPILARE:  mpicc -Wall -O2 -o bcast_b ex00b_bcast.c
 * ESEGUIRE:   mpirun -np 4 ./bcast_b
 */

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define N 10

int main(int argc, char **argv)
{
    int rank, size;
    double array[N];
    srand(42);

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    /* TODO 1: Solo il root (rank==0) inizializza array[]
     *   with valori rand() / RAND_MAX
     *  suggerimento: srand(42) prima della rand() per avere valori deterministici */

    if(rank == 0){
        printf("[ROOT] ");
        for (int i = 0; i < N; i++)
        {
            array[i] = (double) rand()/RAND_MAX;
            printf("[%.2f] ", array[i]);
        }
        printf("\n");
    }


    /* TODO 2: MPI_Bcast per distribuire array[] a tutti. */
    MPI_Bcast(array, N,MPI_DOUBLE, 0,MPI_COMM_WORLD);

    /* TODO 3: Tutti i processi stampano array[0] e array[N-1].
     *   I valori devono essere identici su tutti i processi. */

    
    printf("[P-%d]: array[0] = %.2f   array[N-1] = %.2f\n",rank,array[0],array[N-1]);

    MPI_Finalize();
    return 0;
}