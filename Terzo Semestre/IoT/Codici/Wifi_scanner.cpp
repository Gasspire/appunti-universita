#include <iot_board.h>
#include <WiFi.h>

void setup() {
    Serial.begin(115200);
    WiFi.mode(WIFI_STA);
    WiFi.disconnect();
}
// scan only, do not join
void loop() {
    int n = WiFi.scanNetworks();
    // active scan, all channels
    Serial.printf("%d networks\n", n);
    for (int i = 0; i < n; i++) {
        Serial.printf("%-20s ch %2d %4d dBm %s\n",
        WiFi.SSID(i).c_str(), (int)WiFi.channel(i),
        (int)WiFi.RSSI(i),
        WiFi.encryptionType(i) == WIFI_AUTH_OPEN ? "open" : "secured");
    }
    WiFi.scanDelete();
    delay(10000);
}

