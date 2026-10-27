#include <iot_board.h>
#include <lwip/sockets.h>

const char *ssid = "ARSLab-IoT_2G";
const char *password = "arslabiot";
float temp = 0.0;

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
    IoTBoard::init_espmesh(ssid, password, onMesh);
    IoTBoard::init_display();
}

void loop()
{
    espmesh->update();
    temp = temperatureRead();

    if(IoTBoard::runEvery(3000)){
        String msg = "Dave " + String(temp) + " \n";
        espmesh->sendToRoot(msg.c_str(), msg.length());
    }
}