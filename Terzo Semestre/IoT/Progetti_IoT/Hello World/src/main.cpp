#include <iot_board.h>
#include <WiFi.h>

void setup()
{
    IoTBoard::init_serial();
    uint8_t mac[6];


    esp_read_mac(mac, ESP_MAC_WIFI_STA);
    Serial.print("Station MAC: ");
    for (int i = 0; i < 5; i++) {
        Serial.printf("%02X:", mac[i]);
    }
    Serial.printf("%02X\n", mac[5]);
    esp_read_mac(mac, ESP_MAC_WIFI_SOFTAP);
    Serial.print("SoftAP MAC: ");
    for (int i = 0; i < 5; i++) {
        Serial.printf("%02X:", mac[i]);
    }
    Serial.printf("%02X\n", mac[5]);
}

void loop()
{
    
}