#include <Arduino.h>

void setup() {
  Serial.begin(115200);

  sleep(2);
  Serial.println("Configurazione ultimata!");
  Serial.println("Avvio del loop!");
}

void loop() {
  Serial.println("Lol");
  sleep(60);
}
