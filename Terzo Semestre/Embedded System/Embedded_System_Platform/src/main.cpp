#include "stm32_unict_lib.h"
#include <stdio.h>

int contatore = 0; // conto i periodi
volatile int centesimi = 0; //conto i centesimi
//conto i secondi come centesimi / 100, es. 104 / 100 -> prendendo l'intero è 1 sec. e per mostrare i centesimi mi basta fare centesimi mod 100 così ottengo ad esempio solo il 4.
bool is_running = false; //gestisco l'avvio del timer
bool lampeggio = false;

int array_mem[10] = {0};
int numero_salvati = 0;
int numero_mostrati = 0;

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

    //Configuro i due punti (?)
    GPIO_init(GPIOB);
    GPIO_config_output(GPIOB, 8);

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
        is_running = !is_running;
        EXTI_clear(EXTI10);
    }
}
//Azzera il cronometro
void EXTI4_IRQHandler(void) {
    if (EXTI_isset(EXTI4)){
        centesimi = 0;
        contatore = 0;
        EXTI_clear(EXTI4);
    }
}

void EXTI9_5_IRQHandler(void) {
    if (EXTI_isset(EXTI5)){ //Se è stato premuto il tasto 5
        //Premuto questo facciamo lo "snapshot" cioè salva il risultato attuale del cronometro.
        
        array_mem[numero_salvati%10] = centesimi;
        numero_salvati++;//vengono mostrati solo gli ultimi 10 salvati non in ordine
        
        GPIO_write(GPIOC,2,1); //accendo il led rosso
        delay_ms(1000); //aspetto un secondo e lo spengo
        GPIO_write(GPIOB,2,0);

        EXTI_clear(EXTI5);
    }
    else if(EXTI_isset(EXTI6)){
        // Se tengo premuto questo tasto, il led rosso si accende e viene mostrato il valore di ogni snapshot per 1 secondo. Quando vengono mostrati tutti si ritorna al funzionamento normale
        if(!is_running){
            GPIO_write(GPIOB,0,1);
            int limit = (numero_salvati > 10? 10: numero_salvati);
            for (int i = 0; i < limit; i++)
            {
                int curr_cent = array_mem[i];

                int ss = curr_cent/100;
                int cc = curr_cent%100;

                char msg[10]; 
                sprintf(msg,"%02d%02d",ss,cc);
                DISPLAY_puts(0,msg); 
                delay_ms(1000);
            }
            GPIO_write(GPIOB,0,0);
        }
        EXTI_clear(EXTI6);
    }
}
 
void loop() {
    if(is_running) {
        delay_ms(10); //aspetto 10 ms per aggiornare i centesimi di secondo
        contatore++;
        centesimi++;
        if(contatore == 50) { //devo fare lampeggiare i due punti
            //printo con lampeggio
            contatore = 0;
            lampeggio = !lampeggio;
        }
        
        int ss = centesimi/100;
        int cc = centesimi%100;

        char msg[10]; 
        sprintf(msg,"%02d%02d",ss,cc);
        DISPLAY_puts(0,msg); //primo parametro 0 è la posizione di partenza, msg è la stringa da mostrare di 4 caratteri presumibilmente

        if(lampeggio){
            GPIO_write(GPIOB,8,1);
        }
        else{
            GPIO_write(GPIOB,8,0);
        }
    }
    else{ //se siamo qui il timere è fermo e stampiamo e basta
        int ss = centesimi/100;
        int cc = centesimi%100;

        char msg[10]; 
        sprintf(msg,"%02d%02d",ss,cc);
        DISPLAY_puts(0,msg); 
    }

}


int main() {
    setup(); //eseguiamo la setup
    for(;;){ // facciamo partire il loop
        loop(); 
    }
    return 0;
}