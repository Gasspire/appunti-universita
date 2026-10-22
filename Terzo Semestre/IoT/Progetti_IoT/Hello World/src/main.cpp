#include <iot_board.h>
#include <WiFi.h>

const char *ssid ="ARSLab-IoT_2G";
const char *password ="arslabiot";

void onWiFi(WiFiEvent_t event, WiFiEventInfo_t info) {
    display->clearDisplay();
    display->setCursor(0,0);
    switch (event) {
        case ARDUINO_EVENT_WIFI_STA_CONNECTED:
            display->println("Associated to the AP");
            break;
        case ARDUINO_EVENT_WIFI_STA_GOT_IP:
            display->print("IP: ");
            display->println(IPAddress(info.got_ip.ip_info.ip.addr));
            break;
        case ARDUINO_EVENT_WIFI_STA_DISCONNECTED:
            display->printf("Link lost, reason %d\n",
            info.wifi_sta_disconnected.reason);
            break;
        // auto-reconnect is on
        default:
            break;
    }
    display->display();
}



void setup(){
    IoTBoard::init_serial();
    IoTBoard::init_display();
    IoTBoard::init_leds();

    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);

    display->printf("Connessione in corso a: \n %s\n",ssid);
    display->display();

    WiFi.onEvent(onWiFi);
    WiFi.begin(ssid, password);

    /*while(WiFi.status() != WL_CONNECTED){
        //mi sto collegnado
        sleep(1);
        display->printf(".");
        display->display();
    }
    */
    //mi sono collegato
    display->println();
    display->display();
    display->println("Connessione riuscita");
    display->println(WiFi.localIP().toString().c_str());
    display->display();
}

void loop(){

}