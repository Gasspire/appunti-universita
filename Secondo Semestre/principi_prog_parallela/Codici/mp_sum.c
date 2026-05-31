#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>



int main(int argc, char const *argv[])
{
    int array[10];
    for (int i = 0; i < 10; i++)
    {
        array[i] = i;
    }

    int sum = 0;
    #pragma omp parallel 
    {
        #pragma omp for
        for (int i = 0; i < 10; i++)
        {
            #pragma omp atomic //NO, rende il ciclo sequenza
            sum+=array[i];
        }
        
    }
    printf("La somma e': %d \n",sum);
    return 0;
}
