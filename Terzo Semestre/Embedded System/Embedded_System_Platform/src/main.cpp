#include "stm32_unict_lib.h"
#include <stdio.h>


void setup() {
    ClockConfig(); // setta correttamente il clock a 84 MHz
    CONSOLE_init(); // qui si può inizializzare la console di debug 
    DISPLAY_init(); // inizializzazione del display

    // devo inizializzare i tasti X, Y, Z, T in maniera tale da poter generare gli interrupt
    
    //Configurato il tasto X
    GPIO_config_input(GPIOB,10);
    GPIO_config_EXTI(GPIOB, EXTI10);
    EXTI_enable(EXTI10, FALLING_EDGE);

    //Configuro il tast Y
    GPIO_config_input(GPIOB,4);
    GPIO_config_EXTI(GPIOB, EXTI4);
    EXTI_enable(EXTI4, FALLING_EDGE);

    //Configuro il tasto Z
    GPIO_config_input(GPIOB,5);
    GPIO_config_EXTI(GPIOB, EXTI5);
    EXTI_enable(EXTI5, FALLING_EDGE);

    //Configuro il tasto T
    GPIO_config_input(GPIOB,6);
    GPIO_config_EXTI(GPIOB, EXTI6);
    EXTI_enable(EXTI6, FALLING_EDGE);
}


void loop() {


}


int main() {
    setup(); //eseguiamo la setup
    for(;;){ // facciamo partire il loop
        loop(); 
    }
    return 0;
}