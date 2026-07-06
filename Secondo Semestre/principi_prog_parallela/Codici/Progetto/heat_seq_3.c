#define _POSIX_C_SOURCE 199309L
//COMPILAZIONE: gcc heat_seq_3.c -O2 -Wall -o heat_seq_3
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//#define N 64
//#define N 512
//#define N 1024
#define N 2048
#define TOP 100
#define BOT 0
#define LEFT 75
#define RIGHT 25
#define EPS 1e-4 

/* In questa versione del codice sequenziale si vuole testare il miglioramento delle prestazioni evitando l'utilizzo di una matrice bensì utilizzando un unico grande array da "scorrere come una matrice" così da ottimizzare l'utilizzo della cache e velocizzare gli accessi tramite aritmetica dei puntatori.
*/

int main(int argc, char const *argv[])
{
    double *u = (double *)calloc(N * N, sizeof(double));
    double *u_new = (double *)calloc(N * N, sizeof(double));

    for (int i = 1; i < N - 1; i++) {
        u[0 * N + i] = u_new[0 * N + i] = TOP;               // Riga 0
        u[(N - 1) * N + i] = u_new[(N - 1) * N + i] = BOT;   // Ultima riga
        u[i * N + 0] = u_new[i * N + 0] = LEFT;              // Prima colonna
        u[i * N + (N - 1)] = u_new[i * N + (N - 1)] = RIGHT; // Ultima colonna
    }

    u[0 * N + 0] = u_new[0 * N + 0] = TOP;                               // Alto-sinistra
    u[0 * N + (N - 1)] = u_new[0 * N + (N - 1)] = RIGHT;                 // Alto-destra
    u[(N - 1) * N + 0] = u_new[(N - 1) * N + 0] = LEFT;                  // Basso-sinistra
    u[(N - 1) * N + (N - 1)] = u_new[(N - 1) * N + (N - 1)] = BOT;       // Basso-destra
    
    double differenza = 0.0; 
    int iterazioni = 0; 
    
    double eps_sq = EPS * EPS; 

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    do
    {
        differenza = 0.0;

        for (int i = 1; i < N-1; i++) 
        {
            for (int j = 1; j < N-1; j++)
            {
                int idx_sopra = ((i-1) * N) + j;
                int idx_sotto = ((i+1) * N) + j;
                int idx_sx = ((i * N) + j) - 1; 
                int idx_dx = ((i * N) + j) + 1; 

                u_new[(i*N)+j] = (u[idx_sopra] + u[idx_sotto] + u[idx_sx] + u[idx_dx]) * 0.25;

                double tmp_val = u_new[(i*N)+j] - u[(i*N)+j];
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
    printf("Tempo di esecuzione: %f secondi.\n", tempo_esecuzione);
    
    free(u);
    free(u_new);
    
    return 0;
}