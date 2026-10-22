#include <WiFi.h>
#include <iot_board.h>

void setup() {
    Serial.begin(115200);
    WiFi.mode(WIFI_AP);
    // ssid, password, channel, hidden, max clients
    WiFi.softAP("Prof_Riccobene_aiuto", "provaprovaprovaprovaprova", 6, 0, 4);
    Serial.print("AP address: ");
    Serial.println(WiFi.softAPIP());
    // 192.168.4.1
}

void loop() {
    Serial.printf("Clients: %d\n", WiFi.softAPgetStationNum());
    delay(5000);
}