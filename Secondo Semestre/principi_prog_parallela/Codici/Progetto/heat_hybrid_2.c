#define _POSIX_C_SOURCE 199309L
//COMPILAZIONE: mpicc heat_hybrid_1.c -O2 -Wall -fopenmp -o heat_hybrid
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>
#include <mpi.h>

//#define N 64
//#define N 128
#define N 256
//#define N 512
//#define N 1024

#define TOP 100
#define BOT 0
#define LEFT 75
#define RIGHT 25
#define EPS 1e-4 // Soglia di convergenza definita

int main(int argc, char  *argv[])
{
    int provided;
    MPI_Init_thread(&argc,&argv, MPI_THREAD_FUNNELED, &provided);
    
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
    
    int rank_up, rank_down;
    MPI_Cart_shift(comm_cart, 0,1,&rank_up,&rank_down);

    int righe_per_processo = N / num_processi;
    int resto = N % num_processi;

    if(resto != 0 && rank == num_processi-1){
        righe_per_processo += resto;
    }

    int dimensione_totale = (righe_per_processo + 2) * N;

    double *u = (double *) malloc(dimensione_totale * sizeof(double));
    double *u_new = (double *) malloc(dimensione_totale * sizeof(double));
    
    #pragma omp parallel for schedule(static)
    for (int i = 0; i < righe_per_processo + 2; i++) {
        for (int j = 0; j < N; j++) {
            u[(i * N) + j] = 0.0;
            u_new[(i * N) + j] = 0.0;
        }
    }

    if(rank == 0){ 
        for (int i = 0; i < N; i++)
        {
            u[N + i] = u_new[N + i] = TOP;
        }
        u[N + N - 1] = u_new[N + N - 1] = RIGHT;
    }

    if(rank == num_processi -1){ 
        for (int i = 0; i < N; i++)
        {
            u[(righe_per_processo * N)  + i] = u_new[(righe_per_processo * N)  + i] = BOT;
        }
    }
    
    for (int i = 1; i <= righe_per_processo; i++) 
    {
        u[i*N] = u_new[i*N] = LEFT;
        u[(i*N) + N-1] = u_new[(i*N) + N-1] = RIGHT;
    }

    if(rank == num_processi-1){
        u[(righe_per_processo * N)] = u_new[(righe_per_processo) * N] = LEFT; 
    }
    if(rank == 0){
        u[N-1] = u_new[N-1] = RIGHT;
    }

    double differenza = 0.0; 
    int iterazioni = 0; 

    double eps_sq = EPS * EPS;
    double differenza_globale;

    double start_time = 0.0, end_time = 0.0;
    MPI_Barrier(comm_cart); 
    if (rank == 0) {
        start_time = MPI_Wtime();
    }

    do{
        differenza = 0.0;
        MPI_Request req_send[2]; 
        MPI_Request req_recv[2]; 

        MPI_Irecv(&u[0], N, MPI_DOUBLE, rank_up, 0, comm_cart, &req_recv[0]);
        MPI_Irecv(&u[(righe_per_processo+1) * N], N, MPI_DOUBLE, rank_down, 0, comm_cart, &req_recv[1]);
    
        MPI_Isend(&u[1* N], N,MPI_DOUBLE,rank_up, 0, comm_cart,&req_send[0]);
        MPI_Isend(&u[(righe_per_processo * N)], N,MPI_DOUBLE,rank_down, 0, comm_cart,&req_send[1]);
        
        #pragma omp parallel for reduction(+:differenza) schedule(static)
        for (int i = 2; i < righe_per_processo; i++) 
        {
            for (int j = 1; j < N-1; j++) 
            {
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
        for (int i = 1; i < N-1; i++) 
        {
            if (rank != 0) {
                u_new[N+i] = (u[i] + u[N+i-1] + u[N+i+1]+u[(2*N)+i]) * 0.25; 
                double tmp_1 = u_new[N+i] - u[N+i];
                differenza += (tmp_1 * tmp_1);
            }
            
            if (rank != num_processi - 1) {
                u_new[(righe_per_processo * N)+i] = (u[((righe_per_processo-1) * N)+i] + u[(righe_per_processo * N)+i -1 ] + u[(righe_per_processo * N)+i +1 ]+u[((righe_per_processo+1) * N)+i]) * 0.25; 
                double tmp_2 = u_new[(righe_per_processo * N)+i] - u[(righe_per_processo * N)+i];
                differenza += (tmp_2 * tmp_2);
            }
        }
        
        MPI_Waitall(2,req_send,MPI_STATUS_IGNORE); 
        MPI_Allreduce(&differenza,&differenza_globale, 1, MPI_DOUBLE, MPI_SUM, comm_cart);

        double *tmp_swap = u;
        u = u_new;
        u_new = tmp_swap;

        iterazioni++;
    
    } while (differenza_globale > eps_sq);
    
    MPI_Barrier(comm_cart); 
    if (rank == 0) {
        end_time = MPI_Wtime();
        double tempo_esecuzione = end_time - start_time;
        
        printf("Simulazione completata in %d iterazioni.\n", iterazioni);
        printf("Tempo di esecuzione ibrido: %f secondi.\n", tempo_esecuzione);
    }

    MPI_Finalize();

    return 0;
}