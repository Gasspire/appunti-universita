#define _POSIX_C_SOURCE 199309L
//COMPILAZIONE: gcc heat_seq.c -O2 -Wall -lm -o heat_seq_1
//Se si vuole vedere l'aumento di prestazioni tra heat_seq e heat_seq_2 allora bisogna mettere O0.
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 64
//#define N 512
//#define N 1024
//#define N 2048

#define TOP 100
#define BOT 0
#define LEFT 75
#define RIGHT 25
#define EPS 1e-4 // Soglia di convergenza definita


/*
FASE 1: Inizializzazione di MPI e OpenMP
*/


int main(int argc, char const *argv[])
{
    /* code */
    return 0;
}
