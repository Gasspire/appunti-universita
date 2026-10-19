#include <iot_board.h>

void Button1Pressed(uint8_t pinBtn){ //funzione che verrà richiamata
  display->clearDisplay();
  display->println("Antonio è puppos");
  display->display();
}


//programmare bottoni e schermino
void setup(){
    IoTBoard::init_serial();
    IoTBoard::init_buttons();

    IoTBoard::init_display(); //inizializzo il display
    IoTBoard::init_leds(); // led
    display->clearDisplay(); //lo pulisco
    digitalWrite(LED_RED, LOW);
    digitalWrite(LED_GREEN, LOW);


    display->println("Pulsanti configurati"); //metto in coda il "disegno"
    display->display(); //lo mostro
    display->println("Board pronta");
    display->display();
    display->clearDisplay();


    buttons->onBtn1Release(Button1Pressed); //linka la release del pulsante alla funzione che ho craftato
}

void loop(){
    buttons->update(); // Fa pooling, hanno sbagliato condensatore e quindi non se po' fa 
}