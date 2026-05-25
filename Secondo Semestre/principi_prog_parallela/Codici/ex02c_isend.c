#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <string.h>
#include <unistd.h>
#define MAX 500

int main(int argc, char *argv[])
{
    
    int rank, size;
    char buffer_send[MAX];
    char buffer_recv[MAX];

    MPI_Init(&argc,&argv);
    
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    MPI_Request req;

    if(rank == 0){
        printf("[MASTER] Yoo wassuppp!\n");

        sprintf(buffer_send,"Ciaone my man!");
        fflush(stdout);
        sleep(10);
        MPI_Isend(buffer_send,strlen(buffer_send),MPI_CHAR,1,0,MPI_COMM_WORLD,&req);
        fflush(stdout);

        printf("[MASTER] Ho finito!\n");
        MPI_Wait(&req, MPI_STATUS_IGNORE);
    }
    else{
        printf("[P1] Hi, lake gang!\n[P1] Vado in sleep\n");

        MPI_Irecv(buffer_recv,MAX,MPI_CHAR,0,0,MPI_COMM_WORLD,&req);

        printf("[P1] Ho già fatto la recv!!\n");

        MPI_Wait(&req, MPI_STATUS_IGNORE);
        //Aspetto fino a quando non ottengo il messaggio
        printf("[P1] Ho ricevuto: %s\n",buffer_recv);

    }


    MPI_Finalize();
    return 0;
}
