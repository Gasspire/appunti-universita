#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <string.h>
#define MAX 500

int main(int argc, char *argv[])
{
    
    int rank, size;
    char buffer_send[MAX];
    char buffer_recv[MAX];

    MPI_Init(&argc,&argv);
    
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);


    if(rank == 0){
        printf("[MASTER] Yoo wassuppp!\n");
        sprintf(buffer_send,"Prove you'r gay");
        MPI_Sendrecv(
            buffer_send,strlen(buffer_send)+1,MPI_CHAR,1,0,
            buffer_recv, MAX,MPI_CHAR,1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE
        );
        printf("[MASTER] I received: %s\n",buffer_recv);
    }
    else{
        printf("[P1] Hi, lake gang!\n");
        sprintf(buffer_send,"I'm not gay");
        MPI_Sendrecv(
            buffer_send,strlen(buffer_send)+1,MPI_CHAR,0,0,
            buffer_recv, MAX,MPI_CHAR,0,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE
        );
        printf("[P1] I received: %s\n",buffer_recv);

    }


    MPI_Finalize();
    return 0;
}
