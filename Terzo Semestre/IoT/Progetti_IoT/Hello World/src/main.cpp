#include <iot_board.h>
#include <WiFi.h>
#include <lwip/sockets.h>

const char *ssid = "ARSLab-IoT_2G";
const char *password = "arslabiot";

void onMesh(const EspMeshEvent &e){

}

void setup(){
    IoTBoard::init_serial();
    IoTBoard::init_leds();
    IoTBoard::init_espmesh();


}


void loop(){

}