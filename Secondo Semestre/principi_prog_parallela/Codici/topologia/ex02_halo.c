/*
* Esercizio 02B  ·  Somma dei vicini
 *
 * PUNTO DI PARTENZA: ex02a_halo.c
 * ────────────────────────────────
 * In 02A ogni processo scambiava il proprio rank con i vicini
 * e stampava i valori ricevuti.
 *
 * VARIANTE
 * ────────
 * Ogni processo ha un valore locale = proprio rank.
 * Dopo l'halo exchange, ogni processo calcola la somma
 * dei valori ricevuti dai vicini (escludendo i MPI_PROC_NULL,
 * cioè i -1).
 *
 * SCHEMA (griglia 2×3, bordi aperti):
 *
 *   P0  P1  P2
 *   P3  P4  P5
 *
 * P4 (centro): riceve da P1(su), P3(sin), P5(des), P7 non esiste
 *              → somma = 1+3+5 = 9   (ha 3 vicini + 1 bordo)
 * P0 (angolo): riceve da P1(des), P3(giu)
 *              → somma = 1+3 = 4     (ha 2 vicini + 2 bordi)
 *
 * OUTPUT ATTESO (6 processi):
 *   rank 0 (0,0): somma vicini = 4   (riceve da P1 e P3... aspettate: griglia 2x3)
 *   ...
 *   (calcolate voi il valore atteso per ogni rank)
 *
 * COMPILARE:  mpicc -Wall -O2 -o halo_b ex02b_halo.c
 * ESEGUIRE:   mpirun -np 6 ./halo_b
 *             mpirun -np 12 ./halo_b
 */

#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    /* TODO 1: MPI_Dims_create per dimensionare la griglia. */

    int dims[2] = {0,0};
    MPI_Dims_create(size,2,dims);

    if(rank == 0) printf("[ROOT] La griglia e' %d x %d", dims[0],dims[1]);

    /* TODO 2: MPI_Cart_create con periods={0,0} (bordi aperti). */

    MPI_Comm new_comm;
    int periods[2] = {0,0};
    MPI_Cart_create(MPI_COMM_WORLD, 2, dims,periods,1,&new_comm);

    /* TODO 3: MPI_Cart_coords e MPI_Cart_shift per trovare
     *   up, down, left, right. */

    int left, right;
    int up, down;

    MPI_Cart_shift(new_comm,0,+1,&up,&down);
    MPI_Cart_shift(new_comm,1,+1,&left,&right);



    /* TODO 4: Halo exchange con tutti e 4 i vicini usando
     *   MPI_Sendrecv. Inizializzare i buffer di ricezione a -1
     *   come sentinella per MPI_PROC_NULL.
     */
    int recv_up = -1, recv_down = -1, recv_left = -1, recv_right = -1;
    MPI_Sendrecv(&rank, 1, MPI_INT, up,    0, &recv_up,    1, MPI_INT, up,    0, new_comm, MPI_STATUS_IGNORE);
    MPI_Sendrecv(&rank, 1, MPI_INT, down,  0, &recv_down,  1, MPI_INT, down,  0, new_comm, MPI_STATUS_IGNORE);
    MPI_Sendrecv(&rank, 1, MPI_INT, left,  0, &recv_left,  1, MPI_INT, left,  0, new_comm, MPI_STATUS_IGNORE);
    MPI_Sendrecv(&rank, 1, MPI_INT, right, 0, &recv_right, 1, MPI_INT, right, 0, new_comm, MPI_STATUS_IGNORE);


    /* TODO 5: Calcolare la somma dei valori ricevuti,
     *   escludendo i -1 (bordi aperti senza vicino).
     */

    int somma = 0;
    if (recv_up    != -1) somma += recv_up;
    if (recv_down  != -1) somma += recv_down;
    if (recv_left  != -1) somma += recv_left;
    if (recv_right != -1) somma += recv_right;

    printf("[P-%d] Somma vicini = %d (Su:%d, Giu:%d, Sx:%d, Dx:%d)\n", 
           rank, somma, recv_up, recv_down, recv_left, recv_right);
    /* TODO 6: MPI_Comm_free */

    MPI_Comm_free(&new_comm);
    MPI_Finalize();
    return 0;
}