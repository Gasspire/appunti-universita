#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <string.h>
#define MAX 500

int main(int argc, char *argv[])
{
    
    int rank, size;
    char buffer[MAX];

    MPI_Init(&argc,&argv);
    
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);


    if(rank == 0){
        printf("[MASTER] Yoo wassuppp!\n");
        sprintf(buffer,"Hi, how are you my mann!");
        MPI_Send(buffer,strlen(buffer)+1,MPI_CHAR,1,0,MPI_COMM_WORLD);
        MPI_Recv(buffer,MAX,MPI_CHAR,1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
        printf("[MASTER] P1 says: \"%s\"\n",buffer);

    }
    else{
        printf("[P1] Hi, lake gang!\n");

        MPI_Recv(buffer,MAX,MPI_CHAR,0,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
        printf("[P1] Master says: \"%s\"\n",buffer);

        sprintf(buffer,"[P1] Oi, Hughiee!");
        MPI_Send(buffer,strlen(buffer)+1,MPI_CHAR,0,0,MPI_COMM_WORLD);
    }


    MPI_Finalize();
    return 0;
}
