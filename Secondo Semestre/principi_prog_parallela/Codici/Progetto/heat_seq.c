#define _POSIX_C_SOURCE 199309L //per evitare problemi con il CLOCK_MONOTONIC


//COMPILAZIONE: gcc heat_seq.c -O2 -Wall -lm -o heat_seq_1
//Se si vuole vedere l'aumento di prestazioni tra heat_seq e heat_seq_2 allora bisogna mettere O0.

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>


//Diversi N da testare:

//#define N 64
#define N 512
//#define N 1024
//#define N 2048

//Temperature ai lati
#define TOP 100
#define BOT 0
#define LEFT 75
#define RIGHT 25

#define EPS 1e-4 // Soglia di convergenza definita 0.0001  


/*
Fase 1: Creazione della matrice N x N a 0 e inizializzazione
Fase 2: Ciclo while al cui interno viene inserito il doppio ciclo for che effettua i calcoli finché la differenza tra le due matrici non è inferiore alla soglia di convergenza
Fase 3: Calcolo della Norma L2 tra due iterazioni diverse, se questa è inferiore alla soglia STOP altrimenti si riparte da 2.
*/






int main(int argc, char const *argv[])
{
    //Creazione e inizializzazione delle matrici
    double **u = (double **)calloc(N, sizeof(double *)); //Matrice iniziale 
    double **u_new = (double **)calloc(N, sizeof(double *)); // Matrice per il calcolo che poi verrà invertita 
    for (int i = 0; i < N; i++) {
        u[i] = (double *)calloc(N, sizeof(double)); // si inizializza tutto a 0
        u_new[i] = (double *)calloc(N, sizeof(double));
    }
    //inseriamo le condizioni ai bordi e ignoriamo gli angoli così da scegliere arbitrariamente quale valore assegnare dove
    for (int i = 1; i < N - 1; i++) {
        u[0][i] = u_new[0][i] = TOP;
        u[N-1][i] = u_new[N-1][i] = BOT;
        u[i][0] = u_new[i][0] = LEFT;
        u[i][N-1] = u_new[i][N-1] = RIGHT;
    }

    //Inseriamo i valori agli angoli 
    u[0][0] = u_new[0][0] = TOP;
    u[0][N-1] = u_new[0][N-1] = RIGHT;
    u[N-1][0] = u_new[N-1][0] = LEFT;
    u[N-1][N-1] = u_new[N-1][N-1] = BOT;
    
    
    //adesso possiamo fare i calcoli. Per farlo ho bisogno di una variabile per tenere conto della differenza
    double differenza = 0.0; // qui accumuleremo la somma dei quadrati delle differenze per la norma L2
    int iterazioni = 0; //qui teniamo conto del numero di iterazioni fatte dal While 



    struct timespec start, end;

    clock_gettime(CLOCK_MONOTONIC, &start); //timestamp di inizio
    do
    {
        differenza = 0.0; // ad ogni iterazione del while, la differenza va resettata a 0

        for (int i = 1; i < N-1; i++) //partiamo da 1 e arriviamo a N-1 così da non sovrascrivere i valori delle temperature ai bordi
        {
            for (int j = 1; j < N-1; j++)
            {
                u_new[i][j] = (u[i-1][j] + u[i+1][j] + u[i][j-1] + u[i][j+1])/4.0;


                double tmp = u_new[i][j] - u[i][j];
                differenza += (tmp * tmp);

            }
        }
        

        //invertiamo i puntatori di u_new e u così che per la prossima iterazione calcoleremo sulla base di quanto appena fatto
        double **tmp = u;
        u = u_new;
        u_new = tmp;


        iterazioni++; 

    } while (sqrt(differenza) > EPS); // controlliamo il superamento della soglia di convergenza definita
    
    clock_gettime(CLOCK_MONOTONIC, &end); //timestamp di fine

    // Calcolo del tempo trascorso in secondi
    double tempo_esecuzione = (end.tv_sec - start.tv_sec) +(end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Simulazione completata in %d iterazioni.\n", iterazioni);
    printf("Tempo di esecuzione: %f secondi.\n", tempo_esecuzione);
    //liberiamo tutta la memoria
    for (int i = 0; i < N; i++) {
        free(u[i]);
        free(u_new[i]);
    }
    free(u);
    free(u_new);
    
    return 0;
}
