#include <iot_board.h>
// Identificativo univoco del vostro gruppo
#define ID_GRUPPO 0x05

// Numero totale di board nel gruppo (1 Root + 3 Station)
#define NUM_BOARD 4

#define MAC_0 "34:85:18:7B:1F:68" // Antonio - ROOT
#define MAC_3 "34:85:18:7B:0A:0C" // Dave
#define MAC_1 "34:85:18:7A:B7:00" // Diletta
#define MAC_2 "34:85:18:7A:FA:14" // Marco

float temp;
uint8_t myMac[6];
bool allarmeMancanza = true; // true se manca qualcuno -> Verde OFF, Giallo LAMPEGGIA
int numNodi = 0;
bool SONO_ROOT = false;

void onMesh(const EspMeshEvent &e) {
  switch (e.type) {
  case EspMeshEventType::Connected:
    Serial.println("[MESH] Connesso alla rete mesh!");
    break;

  case EspMeshEventType::Disconnected:
    if (!SONO_ROOT) {
      allarmeMancanza = true;
      digitalWrite(LED_GREEN, LOW);
      Serial.println("[MESH] Disconnesso!");
    }
    break;

  case EspMeshEventType::ChildJoined:
    Serial.printf("[MESH] Nodo connesso: " MACSTR "\n", MAC2STR(e.from));
    break;

  // Rilevamento immediato della caduta di un nodo
  case EspMeshEventType::ChildLeft:
    Serial.printf("[MESH] ⚠️ Nodo caduto/scollegato: " MACSTR "\n", MAC2STR(e.from));
    if (SONO_ROOT) {
      allarmeMancanza = true;
      digitalWrite(LED_GREEN, LOW);
      String cmd = "CMD:MISSING";
      espmesh->broadcast(cmd.c_str(), cmd.length());
      Serial.println("[ROOT] Inviato allarme immediato CMD:MISSING!");
    }
    break;

  case EspMeshEventType::Message:
    // Ignoro il messaggio se e' l'eco del mio stesso broadcast
    if (memcmp(e.from, myMac, 6) == 0)
      return;

    // Se sono una Station, ascolto i comandi inviati dal Root
    if (!SONO_ROOT) {
      if (strstr((char *)e.data, "CMD:ALL_OK") != nullptr) {
        allarmeMancanza = false;
        digitalWrite(LED_GREEN, HIGH);
        digitalWrite(LED_YELLOW, LOW);
        Serial.println("[CMD dal Root] Tutti connessi -> Verde ON, Giallo OFF");
      } else if (strstr((char *)e.data, "CMD:MISSING") != nullptr) {
        allarmeMancanza = true;
        digitalWrite(LED_GREEN, LOW);
        Serial.println("[CMD dal Root] Manca qualcuno -> Verde OFF, Giallo LAMPEGGIA");
      }
    }

    // Mostro il messaggio ricevuto su Seriale e Display
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
  // Inizializzazione seriale, led, display
  IoTBoard::init_serial();
  IoTBoard::init_leds();
  IoTBoard::init_display();
  // inizializza display
  display->clearDisplay();
  display->setCursor(0, 0);

  // Legge il MAC address hardware 
  esp_read_mac(myMac, ESP_MAC_WIFI_STA);

  // Confronta il MAC per determinare il ruolo automaticamente
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02X:%02X:%02X:%02X:%02X:%02X", myMac[0], myMac[1], myMac[2], myMac[3], myMac[4], myMac[5]);

  if (strcmp(macStr, MAC_0) == 0) { // Confronto con mac 0 per vedere se sono root
    SONO_ROOT = true;
  }


  EspMeshConfig config;
  config.router_ssid = ""; // vuoto perché senza AP
  config.on_event = onMesh; //quando accade un evento, gestito da onMesh
  config.channel = 11;           // Stesso canale per tutte le board
  config.mesh_id[5] = ID_GRUPPO; // Stesso ID gruppo per tutte le board
  config.role = SONO_ROOT ? EspMeshRole::Root : EspMeshRole::Node; 


  if (IoTBoard::init_espmesh(config)) {
    if (SONO_ROOT) {
      esp_mesh_set_ap_assoc_expire(1); // Se non rispondi entro 1 secondo, ti considero offline
    }

    display->println("Mesh pronta!");
    display->println("MAC: " MACSTR "\n", MAC2STR(myMac));
    display->println(SONO_ROOT ? "Ruolo: ROOT" : "Ruolo: NODO");
  } else {
    display->println("Errore avvio Mesh");
  }
  display->display();
}

void loop() {
  espmesh->update();

  // Lampeggio del LED Giallo se manca qualcuno (sia su Root che su Station)
  if (allarmeMancanza) {
    digitalWrite(LED_GREEN, LOW);
    if (IoTBoard::runEvery(500, 1)) {
      digitalWrite(LED_YELLOW, !digitalRead(LED_YELLOW));
    }
  }

  // Ogni 2 secondi: controllo topologia (Root) o trasmissione temperatura (Station)
  if (IoTBoard::runEvery(2000, 0)) {
    if (SONO_ROOT) {
      uint8_t nodes[10][6];
      numNodi = espmesh->getNodes(nodes, 10);

      // Verifico se sono connesse tutte le 4 board
      if (numNodi >= NUM_BOARD) {
        allarmeMancanza = false;
        digitalWrite(LED_YELLOW, LOW);
        digitalWrite(LED_GREEN, HIGH);

        String cmd = "CMD:ALL_OK";
        espmesh->broadcast(cmd.c_str(), cmd.length());
        Serial.printf("[ROOT] %d/%d connessi. Inviato CMD:ALL_OK (Verde ON, Giallo OFF)\n", 
                      numNodi, NUM_BOARD);
      } else {
        allarmeMancanza = true;
        digitalWrite(LED_GREEN, LOW);

        String cmd = "CMD:MISSING";
        espmesh->broadcast(cmd.c_str(), cmd.length());
        Serial.printf("[ROOT] Mancano nodi (%d/%d). Inviato CMD:MISSING (Verde OFF, Giallo BLINK)\n", 
                      numNodi, NUM_BOARD);
      }
    } else {
      // Le Station trasmettono la loro temperatura ogni 2 secondi
      if (espmesh->isConnected()) {
        temp = temperatureRead();
        String s = "Temp: " + String(temp, 1) + " C";
        espmesh->broadcast(s.c_str(), s.length());
        Serial.println("[TX broadcast] " + s);
      }
    }
  }
}

