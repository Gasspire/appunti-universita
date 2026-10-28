#include <iot_board.h>

#define SONO_ROOT 0

// Identificativo univoco del vostro gruppo (per non interferire con altri gruppi in aula)
#define ID_GRUPPO 0x05

float temp;
uint8_t myMac[6];

void onMesh(const EspMeshEvent &e) {
  switch (e.type) {
  case EspMeshEventType::Connected:
    digitalWrite(LED_GREEN, HIGH);
    Serial.println("[MESH] Connesso alla rete mesh!");
    break;
  case EspMeshEventType::Disconnected:
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_YELLOW, LOW);
    Serial.println("[MESH] Disconnesso!");
    break;
  case EspMeshEventType::BecameRoot:
    digitalWrite(LED_YELLOW, HIGH);
    Serial.println("[MESH] Ruolo: ROOT");
    break;
  case EspMeshEventType::ChildJoined:
    Serial.printf("[MESH] Nodo connesso: " MACSTR "\n", MAC2STR(e.from));
    break;
  case EspMeshEventType::Message:
    // Stampa il messaggio ricevuto sul Serial Monitor e sul Display
    Serial.printf("[RX da " MACSTR "]: %s\n", MAC2STR(e.from), (char *)e.data);
    display->clearDisplay();
    display->setCursor(0, 0);
    display->printf("Da " MACSTR "\n", MAC2STR(e.from));
    display->printf("%s\n", (char *)e.data);
    display->display();
    break;
  default:
    break;
  }
}

void setup() {
  IoTBoard::init_serial();
  IoTBoard::init_leds();
  IoTBoard::init_display();

  display->clearDisplay();
  display->setCursor(0, 0);
  display->setTextSize(1);
  display->setTextColor(SSD1306_WHITE);

  EspMeshConfig config;
  config.router_ssid = ""; // Nome fittizio: nessun router richiesto
  config.on_event = onMesh;
  config.channel = 11;            // Stesso canale radio per tutte le 4 schede
  config.mesh_id[5] = ID_GRUPPO;  // Stesso ID mesh per il vostro gruppo
  config.role = SONO_ROOT ? EspMeshRole::Root : EspMeshRole::Node;

  if (IoTBoard::init_espmesh(config)) {
    espmesh->getMac(myMac);
    display->println("Mesh pronta!");
    display->printf("MAC: " MACSTR "\n", MAC2STR(myMac));
    display->println(SONO_ROOT ? "Ruolo: ROOT" : "Ruolo: NODO");
  } else {
    display->println("Errore avvio Mesh");
  }
  display->display();
}

void loop() {
  espmesh->update(); // Processa la ricezione e chiama onMesh

  // Ogni 4 secondi invia la temperatura in broadcast
  if (IoTBoard::runEvery(4000)) {
    // Il Root trasmette sempre; i nodi solo dopo essersi collegati
    if (espmesh->isRoot() || espmesh->isConnected()) {
      temp = temperatureRead();
      String s = (SONO_ROOT ? "Root: " : "Node: ") + String(temp, 1) + " C";
      
      espmesh->broadcast(s.c_str(), s.length());
      Serial.println("[TX broadcast] " + s);
    }
  }
}