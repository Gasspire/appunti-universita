#include "stm32_unict_lib.h"
#include <stdio.h>

volatile int period = 20;
volatile int ton = 10; 

// Varibili per la soluzione corretta
volatile int ton_temp = 10;

void setup(void)
{
    ClockConfig();
    CONSOLE_init();
    DISPLAY_init();

    GPIO_init(GPIOC); //Inizializzo il led verde
    GPIO_init(GPIOB); //inizializzo il led rosso

    // Led ROSSO
    GPIO_config_output(GPIOB, 0); // Configuro il led rosso come output
    // Led VERDE
    GPIO_config_output(GPIOC, 3); // Stessa cosa per il led verde

    // Pulssante Y
    GPIO_config_input(GPIOB, 4); // configuro come input il bottone 
    GPIO_config_EXTI(GPIOB, EXTI4); // collego la possibilità di interrupt
    EXTI_enable(EXTI4, FALLING_EDGE); //detecto falling edge

    // Pulsante X
    GPIO_config_input(GPIOB, 10); // esattamente come sopra
    GPIO_config_EXTI(GPIOB, EXTI10);
    EXTI_enable(EXTI10, FALLING_EDGE);

    DISPLAY_puts(0,"HELO ");
}

void EXTI15_10_IRQHandler(void)
{
    // Pulsante X
    if (EXTI_isset(EXTI10))
    {
        ton++; //aumento fino a massimo period
        if (ton > period)
        {
            ton = period;
        }
        printf("Premuto il tasto X, incremento di 1, nuovo valore : %d\n", ton);
        EXTI_clear(EXTI10);
    }
}

void EXTI4_IRQHandler(void)
{
    // Pulsante Y
    if (EXTI_isset(EXTI4))
    {
        ton--; //decremento la variabile ton fino a minimo 0
        if (ton < 0)
        {
            ton = 0;
        }
        printf("Premuto il tasto Y, decremento di 1, nuovo valore : %d\n", ton);
        EXTI_clear(EXTI4);
    }
}

// In questa definzione, che per noi va bene presenta un pericolo
// Se per caso in mezzo al ciclo di loop, viene premuto il tasto X o Y, il valore di ton potrebbe cambiare
// e quindi il led rosso potrebbe rimanere acceso per un tempo maggiore o minore di quello desiderato
void funzioneNonPerfetta()
{
    GPIO_write(GPIOB, 0, 1);
    delay_ms(ton); // ton tra riga 73 e 75 potrebbe cambiare a causa di interrupt vari
    GPIO_write(GPIOB, 0, 0); 
    delay_ms(period - ton);
}

void funzionePerfetta()
{
    // Copio il valore di ton in una variabile temporanea
    ton_temp = ton; //poiché l'ho salvato prima, non rischio nulla.
    GPIO_write(GPIOB, 0, 1);
    delay_ms(ton_temp);
    GPIO_write(GPIOB, 0, 0);
    delay_ms(period - ton_temp);
}

void loop()
{

    // Verione non perfetta, con possibili problemi se il tasto viene premuto durante l'esecuzione della funzione
    // funzioneNonPerfetta();
    // Versione perfetta, con copia del valore di ton in una variabile temporanea
    funzionePerfetta();
}

int main()
{
    setup();
    for (;;)
    {
        loop();
    }
}