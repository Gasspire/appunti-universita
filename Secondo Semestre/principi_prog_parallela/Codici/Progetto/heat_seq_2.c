#define _POSIX_C_SOURCE 199309L
//COMPILAZIONE: gcc heat_seq_2.c -O2 -Wall -o heat_seq_2
//Se si vuole vedere l'aumento di prestazioni tra heat_seq e heat_seq_2 allora bisogna mettere O0.
#include <stdio.h>
#include <stdlib.h>
#include <time.h>


#define N 64
//#define N 128
//#define N 512
//#define N 1024
//#define N 2048
#define TOP 100
#define BOT 0
#define LEFT 75
#define RIGHT 25
#define EPS 1e-4 // Soglia di convergenza definita

/*
In questa versione del codice si vogliono aggiungere delle ottimizzazioni viste a lezione per quanto riguarda il codice single-core:
1. Posso eliminare SQRT se calcolo il quadrato di EPS e controllo la differenza al quadrato con EPS al quadrato
2. Posso fare la moltiplicazione invece della divisione
*/




int main(int argc, char const *argv[])
{
    double **u = (double **)calloc(N, sizeof(double *));
    double **u_new = (double **)calloc(N, sizeof(double *));
    for (int i = 0; i < N; i++) {
        u[i] = (double *)calloc(N, sizeof(double));
        u_new[i] = (double *)calloc(N, sizeof(double));
    }
    for (int i = 1; i < N - 1; i++) {
        u[0][i] = u_new[0][i] = TOP;
        u[N-1][i] = u_new[N-1][i] = BOT;
        u[i][0] = u_new[i][0] = LEFT;
        u[i][N-1] = u_new[i][N-1] = RIGHT;
    }
    u[0][0] = u_new[0][0] = TOP;
    u[0][N-1] = u_new[0][N-1] = RIGHT;
    u[N-1][0] = u_new[N-1][0] = LEFT;
    u[N-1][N-1] = u_new[N-1][N-1] = BOT;
    
    
    double differenza = 0.0;
    int iterazioni = 0; 

    //per evitare di calcolare la radice quadrata, consideriamo la soglia al quadrato così da non richiamare funzioni di librerie esterne
    double eps_sq = EPS * EPS; //lo calcoliamo fuori dato che non cambia durante il ciclo





    struct timespec start, end;

    clock_gettime(CLOCK_MONOTONIC, &start);


    do
    {
        differenza = 0.0;

        for (int i = 1; i < N-1; i++)
        {
            for (int j = 1; j < N-1; j++)
            {
                u_new[i][j] = (u[i-1][j] + u[i+1][j] + u[i][j-1] + u[i][j+1]) * 0.25; //utilizziamo la moltiplicazione anziché la divisione che risulta più leggera per il compilatore


                double tmp = u_new[i][j] - u[i][j];
                differenza += (tmp * tmp);

            }
        }
        

        double **tmp = u;
        u = u_new;
        u_new = tmp;


        iterazioni++; 

    } while (differenza > eps_sq);// controllo senza l'uso della radice quadrata
    
    clock_gettime(CLOCK_MONOTONIC, &end);

    double tempo_esecuzione = (end.tv_sec - start.tv_sec) +(end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Simulazione completata in %d iterazioni.\n", iterazioni);
    printf("Tempo di esecuzione: %f secondi.\n", tempo_esecuzione);

    for (int i = 0; i < N; i++) {
        free(u[i]);
        free(u_new[i]);
    }
    free(u);
    free(u_new);
    
    return 0;
}
