/*
 * Esercizio 01B  ·  Scatter + Gather
 * PUNTO DI PARTENZA: ex01a_scatter_gather.c
 * ──────────────────────────────────────────
 * In 01A ogni processo calcolava la somma del proprio chunk
 * e il root raccoglieva le somme parziali con Gather.
 *
 * VARIANTE
 * ────────
 * Stessa struttura, ma ogni processo calcola il MASSIMO
 * del proprio chunk invece della somma. Il root raccoglie
 * i massimi parziali e trova il massimo globale.
 *
 * Array inizializzato con valori casuali (srand(42) + rand()).
 *
 * OUTPUT ATTESO (4 processi, N=16):
 *   rank 0: max locale = X.XX
 *   rank 1: max locale = X.XX
 *   rank 2: max locale = X.XX
 *   rank 3: max locale = X.XX
 *   Root: massimo globale = X.XX
 *
 * COMPILARE:  mpicc -Wall -O2 -o sg_b ex01b_scatter_gather.c
 * ESEGUIRE:   mpirun -np 4 ./sg_b
 */

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define N 16

int main(int argc, char **argv)
{
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (N % size != 0) {
        if (rank == 0) fprintf(stderr, "N non divisibile per %d\n", size);
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    int chunk = N / size;
    double *array = NULL;
    double *local = malloc(chunk * sizeof(double));
    double *maxes = NULL;


    /* TODO 1: Root alloca array[N] e lo inizializza con
     *   srand(42) e valori (double)rand()/RAND_MAX
     *   Root alloca anche maxes[size] per raccogliere i massimi */

    srand(42);
    if(rank == 0){
        array = (double *)malloc(sizeof(double)*N);
        printf("[ROOT] ");
        for (int i = 0; i < N; i++)
        {
            array[i] = (double) rand()/RAND_MAX;
            printf("[%.2f] ", array[i]);
        }
        printf("\n");
        maxes = (double *)malloc(sizeof(double)*size);
    }

    /* TODO 2: MPI_Scatter per distribuire i chunk. */

    MPI_Scatter(array,chunk, MPI_DOUBLE, local, chunk, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    /* TODO 3: Ogni processo calcola il massimo del proprio chunk. */
    double max = -1;
    for (int i = 0; i < chunk; i++)
    {
        max = (local[i] > max ? local[i]:max);
    }
    printf("[P-%d] il mio massimo e' %.2f\n", rank, max);

    /* TODO 4: MPI_Gather per raccogliere i massimi parziali. */
    
    MPI_Gather(&max, 1, MPI_DOUBLE, maxes, 1,MPI_DOUBLE, 0, MPI_COMM_WORLD);


    /* TODO 5: Root trova il massimo globale tra maxes[] e stampa */
    if (rank == 0){
        double maxtmp = 0;
        for (int i = 0; i < size; i++){
            maxtmp = (maxes[i] > maxtmp ? maxes[i]:maxtmp);
        }
        printf("[ROOT] Il massimo globale e' %.2f\n", maxtmp);
    }


    free(local);
    MPI_Finalize();
    return 0;
}