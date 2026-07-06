#define _POSIX_C_SOURCE 199309L
// COMPILAZIONE: gcc heat_omp.c -O2 -Wall -fopenmp -o heat_omp
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

#define N 512
#define TOP 100
#define BOT 0
#define LEFT 75
#define RIGHT 25

#define EPS 1e-4 

int main(int argc, char const *argv[])
{
    double *u = (double *)calloc(N * N, sizeof(double));
    double *u_new = (double *)calloc(N * N, sizeof(double));

    #pragma omp parallel for schedule(static)
    for (int i = 1; i < N - 1; i++) {
        u[0 * N + i] = u_new[0 * N + i] = TOP;               
        u[(N - 1) * N + i] = u_new[(N - 1) * N + i] = BOT;   
        u[i * N + 0] = u_new[i * N + 0] = LEFT;              
        u[i * N + (N - 1)] = u_new[i * N + (N - 1)] = RIGHT; 
    }

    u[0 * N + 0] = u_new[0 * N + 0] = TOP;                               
    u[0 * N + (N - 1)] = u_new[0 * N + (N - 1)] = RIGHT;                 
    u[(N - 1) * N + 0] = u_new[(N - 1) * N + 0] = LEFT;                  
    u[(N - 1) * N + (N - 1)] = u_new[(N - 1) * N + (N - 1)] = BOT;       
    
    double differenza = 0.0; 
    int iterazioni = 0; 
    double eps_sq = EPS * EPS; 

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    do {
        differenza = 0.0;

        #pragma omp parallel for schedule(static) collapse(2) reduction(+:differenza)
        for (int i = 1; i < N-1; i++) 
        {
            for (int j = 1; j < N-1; j++)
            {
                int centro = (i * N) + j;
                int sopra  = ((i - 1) * N) + j;
                int sotto  = ((i + 1) * N) + j;
                int sx     = (i * N) + (j - 1);
                int dx     = (i * N) + (j + 1);

                u_new[centro] = (u[sopra] + u[sotto] + u[sx] + u[dx]) * 0.25;

                double tmp_val = u_new[centro] - u[centro];
                differenza += (tmp_val * tmp_val);
            }
        }
        
        double *tmp_ptr = u;
        u = u_new;
        u_new = tmp_ptr;

        iterazioni++; 

    } while (differenza > eps_sq);
    
    clock_gettime(CLOCK_MONOTONIC, &end);

    double tempo_esecuzione = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Simulazione completata in %d iterazioni.\n", iterazioni);
    printf("Tempo di esecuzione OpenMP: %f secondi.\n", tempo_esecuzione);
    
    free(u);
    free(u_new);
    
    return 0;
}