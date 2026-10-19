#include "stm32_unict_lib.h"
#include <stdio.h>


volatile int centesimi = 0; //conto i centesimi
volatile int secondi = 0; //conto i secondi 
bool is_running = false; //gestisco l'avvio del timer

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

    //Inizializzo il LED ROSSO
    GPIO_init(GPIOB);
    GPIO_config_output(GPIOB,0);

    //Inizializzo il LED GIALLO
    GPIO_init(GPIOC);
    GPIO_config_output(GPIOB,2);
}


//Avvia/Ferma il cronometro
void EXTI15_10_IRQHandler(void) {
    if (EXTI_isset(EXTI10)){


        EXTI_clear(EXTI10);
    }
}
//Azzera il cronometro
void EXTI4_IRQHandler(void) {
    if (EXTI_isset(EXTI4)){


        EXTI_clear(EXTI4);
    }
}

void EXTI9_5_IRQHandler(void) {
    if (EXTI_isset(EXTI5)){ //Se è stato premuto il tasto 5
        //Premuto questo facciamo lo "snapshot" cioè salva il risultato attuale del cronometro.


        EXTI_clear(EXTI5);
    }
    else if(EXTI_isset(EXTI6)){
        // Se tengo premuto questo tasto, il led rosso si accende e viene mostrato il valore di ogni snapshot per 1 secondo. Quando vengono mostrati tutti si ritorna al funzionamento normale

        EXTI_clear(EXTI6);
    }
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