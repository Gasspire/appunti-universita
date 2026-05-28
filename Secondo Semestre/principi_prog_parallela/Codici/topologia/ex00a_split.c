/*
 * Esercizio 00B  ·  MPI_Comm_split   
 *
 * PUNTO DI PARTENZA: ex00a_comm_split.c
 * ────────────────────────────────────
 * In 00A avete creato un communicator per RIGA e fatto
 * una Reduce per riga.
 *
 * VARIANTE: communicator per COLONNA
 * ────────────────────────────────────
 * Stessa griglia 2×4, ma ora create un communicator per
 * ogni colonna e fate la somma dei rank per colonna.
 *
 *   rank 0  rank 1  rank 2  rank 3   ← riga 0
 *   rank 4  rank 5  rank 6  rank 7   ← riga 1
 *     ↕       ↕       ↕       ↕
 *   col 0   col 1   col 2   col 3
 *
 * Output atteso:
 *   col 0: somma = 0+4 = 4
 *   col 1: somma = 1+5 = 6
 *   col 2: somma = 2+6 = 8
 *   col 3: somma = 3+7 = 10
 *
 * HINT
 * ────
 * In 00A: color=row, key=col  → raggruppa per riga
 * Ora:    color=col, key=row  → raggruppa per colonna
 *
 * COMPILARE:  mpicc -Wall -O2 -o comm_b ex00b_comm_split.c
 * ESEGUIRE:   mpirun -np 8 ./comm_b
 */

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define NCOLS 4

int main(int argc, char **argv)
{
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 8) {
        if (rank == 0) fprintf(stderr, "Servono 8 processi.\n");
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    int row = rank / NCOLS;
    int col = rank % NCOLS;


    MPI_Comm new_comm;
    /* TODO 1: MPI_Comm_split per creare un communicator per colonna.
     */
    MPI_Comm_split(MPI_COMM_WORLD, col, row, &new_comm);

    /* TODO 2: Ottenere col_rank e col_size 

     */
    int col_rank;
    int col_size;
    MPI_Comm_rank(new_comm,&col_rank);
    MPI_Comm_size(new_comm,&col_size);

    printf("[P-%d] il mio rank per new comm e' %d e la size e' %d \n",rank,col_rank, col_size);

    /* TODO 3: MPI_Reduce su col_comm per sommare i rank globali*/
    int sum=0;
    MPI_Reduce(&rank, &sum, 1,MPI_INT, MPI_SUM, 0, new_comm);

    if(col_rank == 0){
            printf("[ROOT-%d]somma: %d\n",rank, sum);        

    }
    /* TODO 4: MPI_Comm_free(&col_comm) */
    MPI_Comm_free(&new_comm);

    MPI_Finalize();
    return 0;
}