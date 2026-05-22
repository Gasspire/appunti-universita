#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <omp.h>


int main(int argc, char const *argv[])
{
    #pragma omp parallel num_threads(5)
    {
        #pragma omp master
            printf("Ciao, sono il master!\n");
        
        int get_my_id = omp_get_thread_num();
        printf("Ciao sono il thread %d\n",get_my_id);
        #pragma omp master
        {
            printf("Mi addummisciu %d \n", get_my_id);
        }
        printf("Siamo svegli %d!\n", get_my_id);
    }
    printf("Fine prima parte!\n");

    printf("----------------------------------------\n");

    printf("Esercizio: Stampa in con #pragma omp for\n");
    

    #pragma omp parallel for ordered num_threads(5) schedule(static,2)
        for (int i = 0; i < 20; i++)
        {
            #pragma omp ordered
            printf("[T-%d] sto eseguendo il passo %d\n", omp_get_thread_num(), i);
        }



    printf("----------------------------------------\n");

    return 0;
}
