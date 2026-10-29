#include <iot_board.h>
#include <WiFi.h>
#include <esp_now.h>

uint8_t peer_broadcast_address[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
// _t perché è indipendente dall'architettura

typedef struct __attribute__((packed))
{
  uint8_t board;
  uint8_t length;
  char text[];
} Msg;

void setup()
{
  IoTBoard::init_display();
  IoTBoard::init_leds();
  IoTBoard::init_buttons();

  display->clearDisplay();
  display->setCursor(0, 0);

  WiFi.mode(WIFI_STA);
  esp_now_init();

  esp_now_peer_info_t peerBroadcast = {};

  memcpy(peerBroadcast.peer_addr, peer_broadcast_address, 6);
  peerBroadcast.channel = 6;
  peerBroadcast.encrypt = false;
}

void loop()
{
}