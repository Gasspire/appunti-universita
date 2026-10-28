
#include <iot_board.h> // + -DESPMESH_ENABLED
#include <lwip/sockets.h>

#define SONO_ROOT 0 // 1 su UNA sola board, 0 sulle altre

const char *ssid = "Pixel 9 Pro";
const char *pwd = "ciaociao";

int sent = 0;
float temp;

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
    
    if (IoTBoard::init_espmesh(ssid, pwd, onMesh))
        display->println("EspMesh enabled");
    else
        display->println("EspMesh error");
    display->display();
}
void loop()
{
    espmesh->update();
    // runs the callback
    if (!IoTBoard::runEvery(5000))
        return;
    if (espmesh->isRoot() || !espmesh->isConnected())
        return;
    // the root only listens
    String s = "Hello " + String(sent++) +
               " layer " + String(espmesh->getLayer());
    espmesh->sendToRoot(s.c_str(), s.length());
}