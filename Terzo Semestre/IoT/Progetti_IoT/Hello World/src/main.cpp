#include <iot_board.h>
#include <lwip/sockets.h>
#include <IPAddress.h>

const char *ssid = "ARSLab-IoT_2G";
const char *password = "arslabiot";
float temp = 0.0;

IPAddress serverIP;


void onMesh(const EspMeshEvent &e)
{
    switch (e.type)
    {
    case EspMeshEventType::Connected:
        digitalWrite(LED_GREEN, HIGH);
        break;
    case EspMeshEventType::Disconnected:
        digitalWrite(LED_GREEN, LOW);
        digitalWrite(LED_YELLOW, LOW);
        break;
    case EspMeshEventType::BecameRoot:
        digitalWrite(LED_YELLOW, HIGH);
        break;
    case EspMeshEventType::Message:
        display->clearDisplay();
        display->setCursor(0, 0);
        display->printf("From " MACSTR "\n",
                        MAC2STR(e.from));
        display->println((char *)e.data);
        display->display();
        break;
    default:
        break;
    }
}

void setup()
{
    IoTBoard::init_serial();
    IoTBoard::init_leds();
    IoTBoard::init_display();

    serverIP.fromString("192.168.1.5");

    EspMeshConfig configMesh;
    configMesh.router_ssid = ssid;
    configMesh.router_pass = password;
    configMesh.on_event = onMesh;
    configMesh.forward_ip = serverIP;
    configMesh.forward_port = 5000;
    IoTBoard::init_espmesh(configMesh);

}

void loop()
{
    espmesh->update();
    temp = temperatureRead();

    if(IoTBoard::runEvery(3000)){
        String msg = "Prof Riccobene bastaaaa \n";
        //espmesh->sendToRoot(msg.c_str(), msg.length());
        espmesh->sendToServer(serverIP, 5000, msg.c_str(),msg.length());
    }
}