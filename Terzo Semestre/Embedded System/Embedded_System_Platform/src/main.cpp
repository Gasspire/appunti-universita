#include "stm32_unict_lib.h"
#include <stdio.h>

int contatore = 0; 
volatile int centesimi = 0; 
bool is_running = false; 
bool lampeggio = false;

int array_mem[10] = {0};
int numero_salvati = 0;

bool save_mode = false;
bool mem_show_mode = false;

bool giallo_is_acceso = false;
int led_giallo_lampeggio = 0;

void setup() {
    ClockConfig(); 
    CONSOLE_init(); 
    DISPLAY_init(); 

    // Tasto X (PB10) - Start/Stop
    GPIO_config_input(GPIOB, 10);
    GPIO_config_EXTI(GPIOB, EXTI10);
    EXTI_enable(EXTI10, FALLING_EDGE);

    // Tasto Y (PB4) - Reset
    GPIO_config_input(GPIOB, 4);
    GPIO_config_EXTI(GPIOB, EXTI4);
    EXTI_enable(EXTI4, FALLING_EDGE);

    // Tasto Z (PB5) - Store Snapshot
    GPIO_config_input(GPIOB, 5);
    GPIO_config_EXTI(GPIOB, EXTI5);
    EXTI_enable(EXTI5, FALLING_EDGE);

    // Tasto T (PB6) - Show Memory
    GPIO_config_input(GPIOB, 6);
    GPIO_config_EXTI(GPIOB, EXTI6);
    EXTI_enable(EXTI6, FALLING_EDGE);

    // Due punti (PB8)
    GPIO_init(GPIOB);
    GPIO_config_output(GPIOB, 8);

    // LED ROSSO (PB0)
    GPIO_config_output(GPIOB, 0);

    // LED GIALLO (PC2)
    GPIO_init(GPIOC);
    GPIO_config_output(GPIOC, 2);
}

void EXTI15_10_IRQHandler(void) {
    if (EXTI_isset(EXTI10)) {
        is_running = !is_running;
        EXTI_clear(EXTI10);
    }
}

void EXTI4_IRQHandler(void) {
    if (EXTI_isset(EXTI4)) {
        if (!is_running) { // Azzeramento consigliato a timer fermo
            centesimi = 0;
            contatore = 0;
        }
        EXTI_clear(EXTI4);
    }
}

void EXTI9_5_IRQHandler(void) {
    if (EXTI_isset(EXTI5)) {
        if (is_running) {
            save_mode = true; 
        }
        EXTI_clear(EXTI5);
    }
    else if (EXTI_isset(EXTI6)) {
        if (!is_running) {
            mem_show_mode = true;
        }
        EXTI_clear(EXTI6);
    }
}

void loop() {
    // 1. Gestione Salvataggio Snapshot
    if (save_mode) {
        array_mem[numero_salvati % 10] = centesimi;
        numero_salvati++;
        
        GPIO_write(GPIOC, 2, 1); // Accende il LED giallo
        save_mode = false;
        led_giallo_lampeggio = 0;
        giallo_is_acceso = true;
    }

    // 2. Gestione Temporizzata LED Giallo (SPOSTATA FUORI DALL'IF IS_RUNNING)
    if (giallo_is_acceso) {
        led_giallo_lampeggio++;
        if (led_giallo_lampeggio >= 100) { // 100 iterazioni * 10 ms = 1 secondo
            GPIO_write(GPIOC, 2, 0); 
            giallo_is_acceso = false;
            led_giallo_lampeggio = 0;
        }
    }

    // 3. Modalità Visualizzazione Memoria
    if (mem_show_mode) {
        GPIO_write(GPIOB, 0, 1); // Accende il LED rosso 
        
        int limit = (numero_salvati > 10) ? 10 : numero_salvati;
        int start_index = (numero_salvati > 10) ? (numero_salvati % 10) : 0;

        for (int i = 0; i < limit; i++) {
            int idx = (start_index + i) % 10; // Calcola l'indice in ordine cronologico
            int curr_cent = array_mem[idx];

            int ss = curr_cent / 100;
            int cc = curr_cent % 100;

            char msg[10]; 
            sprintf(msg, "%02d%02d", ss, cc);
            DISPLAY_puts(0, msg); 
            delay_ms(1000);
        }
        
        GPIO_write(GPIOB, 0, 0); // Spegne il LED rosso
        mem_show_mode = false;
    }

    // 4. Avanzamento Timer e Display
    if (is_running) {
        delay_ms(10); 
        contatore++;
        centesimi++;

        if (contatore == 25) { // Periodo totale 500 ms (250 ms ON, 250 ms OFF)
            contatore = 0;
            lampeggio = !lampeggio;
        }

        int ss = centesimi / 100;
        int cc = centesimi % 100;

        char msg[10]; 
        sprintf(msg, "%02d%02d", ss, cc);
        DISPLAY_puts(0, msg); 

        GPIO_write(GPIOB, 8, lampeggio ? 1 : 0);
    }
    else {
        GPIO_write(GPIOB, 8, 0); // Spegne i due punti se il cronometro è fermo
        
        int ss = centesimi / 100;
        int cc = centesimi % 100;

        char msg[10]; 
        sprintf(msg, "%02d%02d", ss, cc);
        DISPLAY_puts(0, msg); 
    }
}

int main() {
    setup(); 
    for (;;) { 
        loop(); 
    }
    return 0;
}