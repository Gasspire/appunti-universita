/*
 *  Esercizio 01B  ·  Cart_shift + Sendrecv   
 *
 * PUNTO DI PARTENZA: ex01a_cart.c
 * ────────────────────────────────
 * In 01A avete creato la griglia e trovato i vicini con
 * MPI_Cart_shift. Ora usate quei vicini per comunicare.
 *
 * VARIANTE: scambio con i vicini lungo la riga
 * ─────────────────────────────────────────────
 * Ogni processo invia il proprio rank al vicino DESTRO
 * e riceve dal vicino SINISTRO, usando MPI_Sendrecv.
 *
 * È lo stesso ring exchange di Lab Sessione 2 esercizio 00A,
 * ma ora i vicini vengono calcolati automaticamente da
 * MPI_Cart_shift invece che con (rank+1)%size.
 *
 * SCHEMA (griglia 2×3, solo la riga 0):
 *
 *   P0 ──► P1 ──► P2
 *    ▲               │
 *    └───────────────┘   (periodica → P2 invia a P0)
 *
 * Ogni processo verifica che il valore ricevuto sia
 * uguale al rank del vicino sinistro.
 *
 * COMPILARE:  mpicc -Wall -O2 -o cart_b ex01b_cart.c
 * ESEGUIRE:   mpirun -np 6 ./cart_b
 */

#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 6) {
        if (rank == 0) fprintf(stderr, "Servono 6 processi.\n");
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    /* TODO 1: Creare la topologia cartesiana 2×3.
    */

    int dims[2] = {2,3};
    int periods[2] = {1,1};
    MPI_Comm new_comm;
    MPI_Cart_create(MPI_COMM_WORLD,2,dims,periods,1,&new_comm);

    /* TODO 2: Ottenere le proprie coordinate con MPI_Cart_coords.
     */
    int p_cords[2];
    int c_rank;
    int c_size;
    MPI_Comm_rank(new_comm,&c_rank);
    MPI_Comm_size(new_comm,&c_size);
    MPI_Cart_coords(new_comm,c_rank,2,p_cords);
    printf("[P-%d] Le mie coordinate sono: [%d][%d]\n",rank, p_cords[0],p_cords[1]);


    /* TODO 3: Trovare i vicini SINISTRA e DESTRA con MPI_Cart_shift
     *   sulla dimensione 1 (colonne), spostamento +1.*/

    int left, right;

    MPI_Cart_shift(new_comm,1,+1, &left, &right);
    //printf("[P-%d] I miei vicini sono: left %d e right %d \n",rank, left, right);




    /* TODO 4: MPI_Sendrecv per scambiare il proprio rank.
     *   Inviare rank a right, ricevere recv_val da left.
     */
    int recv_from_left;
    MPI_Sendrecv(&rank, 1, MPI_INT, right, 1, &recv_from_left, 1, MPI_INT, left, 1, new_comm,MPI_STATUS_IGNORE);

    /* TODO 5: Stampare e verificare.
     *   Il valore ricevuto deve essere uguale al rank del
     *   vicino sinistro (left).
     */

    printf("[P-%d] ho ricevuto %d da sx\n",rank, recv_from_left);

    /* TODO 6: MPI_Comm_free(&cart_comm) */

    MPI_Comm_free(&new_comm);

    MPI_Finalize();
    return 0;
}