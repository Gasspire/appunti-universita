// Prova di esame 16/04/2025
//
#include "stm32_unict_lib.h"
#include <stdio.h>

int speed = 5; // 5cm al secondo la velocità
int ms_per_cm;

int current_position, target_position;

void setup(void)
{
    ClockConfig(); //setuppa il clock
    CONSOLE_init(); // console di debug credo
    DISPLAY_init(); //inizializza il display

    //inizializzo i led
    GPIO_init(GPIOC);
    GPIO_init(GPIOB);

    // Led ROSSO
    GPIO_config_output(GPIOB, 0); // configurati per output
    // Led VERDE
    GPIO_config_output(GPIOC, 3);

    // Pulssante Y
    GPIO_config_input(GPIOB, 4); //configuro per input, interrupt 
    GPIO_config_EXTI(GPIOB, EXTI4);
    EXTI_enable(EXTI4, FALLING_EDGE);

    // Pulsante X
    GPIO_config_input(GPIOB, 10); //same
    GPIO_config_EXTI(GPIOB, EXTI10);
    EXTI_enable(EXTI10, FALLING_EDGE);

    // Pulsante  Z
    GPIO_config_input(GPIOB, 5);
    GPIO_config_EXTI(GPIOB, EXTI5);
    EXTI_enable(EXTI5, FALLING_EDGE); //same

    ms_per_cm = 1000 / speed; // Calcolo dei millisecondi per centimetro (determino quanti cm faccio in un ms)
    current_position = 0;     // Inizializzo la posizione corrente a 0
    target_position = 0;      // Inizializzo la posizione target a 0
}

void EXTI9_5_IRQHandler(void)
{
    // Pulsante Z
    if (EXTI_isset(EXTI5))
    {
        if (target_position >= 5)
        {
            target_position -= 5;
            printf("Pulsante Y premuto: decremento la posizione target a %d\n", target_position);
        }
        else
        {
            printf("Pulsante Y premuto: posizione target già a 0, non posso decrementare\n");
        }

        EXTI_clear(EXTI5);
    }
}

void EXTI15_10_IRQHandler(void)
{
    // Pulsante X
    if (EXTI_isset(EXTI10))
    {

        EXTI_clear(EXTI10);
    }
}

void EXTI4_IRQHandler(void)
{
    // Pulsante Y
    if (EXTI_isset(EXTI4))
    {
        if (target_position <= 94)
        {
            target_position += 5;
            printf("Pulsante Y premuto: incremento la posizione target a %d\n", target_position);
        }
        else
        {
            printf("Pulsante Y premuto: posizione target già a 100, non posso incrementare\n");
        }

        EXTI_clear(EXTI4);
    }
}

void loop()
{
    char message[10];
    int diff = target_position - current_position;
    delay_ms(ms_per_cm/2); // Attendo il tempo necessario per muovermi di 1 cm
    if (diff !=0){
        GPIO_toggle(GPIOB, 0); 
    }else{
        GPIO_write(GPIOB, 0, 0); // Spengo il LED se non mi muovo
    }
    delay_ms(ms_per_cm/2); // Attendo il tempo necessario per muovermi di 1 cm
    if (diff > 0)
    {
        current_position++;
        printf("Mi muovo in avanti, posizione corrente: %d\n", current_position);
    }
    else if (diff < 0)
    {
        current_position--;
        printf("Mi muovo indietro, posizione corrente: %d\n", current_position);
    }
    else
    {
        // Non faccio nulla se sono già alla posizione target
    }
    sprintf(message, "%2d%2d", current_position,target_position);
    DISPLAY_puts(0, message);
}

int main()
{
    setup();
    for (;;)
    {
        loop();
    }
}