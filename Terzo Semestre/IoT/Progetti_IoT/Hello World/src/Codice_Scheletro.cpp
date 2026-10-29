#include <cstdint>
#include <iot_board.h>
#include <sys/types.h>
// Identificativo univoco del vostro gruppo
#define ID_GRUPPO 0x05

// Numero totale di board nel gruppo (1 Root + 3 Station)
#define NUM_BOARD 4

#define MAC_0 "34:85:18:7B:1F:68" // Antonio - ROOT
#define MAC_3 "34:85:18:7B:0A:0C" // Dave
#define MAC_1 "34:85:18:7A:B7:00" // Diletta
#define MAC_2 "34:85:18:7A:FA:14" // Marco

enum STATI { SYNC, ROSSO, VERDE, GIALLO };

uint8_t turno;
uint8_t gruppo;
uint8_t myMac[6];
int numNodi = 0;
bool SONO_ROOT = false;
STATI stato = SYNC;

void onMesh(const EspMeshEvent &e) {
  switch (e.type) {
  case EspMeshEventType::Connected:
    Serial.printf("[" MACSTR "] Connesso alla rete mesh!", MAC2STR(e.from));
    stato = SYNC;
    break;

  case EspMeshEventType::Disconnected:
    if (!SONO_ROOT) {
      stato = SYNC; // Torno nello stato di sincronizzazione/attesa
      Serial.printf("[" MACSTR "] Disconnesso dalla rete mesh!",MAC2STR(e.from));
    }
    break;

  // FATTO SOLO DA ROOT
  case EspMeshEventType::ChildJoined:
    Serial.printf("[ROOT] Nodo connesso: " MACSTR "\n", MAC2STR(e.from));
    break;
    
  // FATTO SOLO DA ROOT
  case EspMeshEventType::ChildLeft:
    Serial.printf("[ROOT] Nodo caduto/scollegato: " MACSTR "\n",MAC2STR(e.from));
    // QUI DOBBIAMO AGGIUNGERE L'AVVISO AI VARI NODI
    break;

  case EspMeshEventType::Message:
    // Ignoro il messaggio se e' l'eco del mio stesso broadcast
    if (memcmp(e.from, myMac, 6) == 0) return;

    // Ascolto i messaggi della ROOT e gestisco i miei stati
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
  snprintf(macStr, sizeof(macStr), "%02X:%02X:%02X:%02X:%02X:%02X", myMac[0],
           myMac[1], myMac[2], myMac[3], myMac[4], myMac[5]);

  if (strcmp(macStr, MAC_0) == 0) {
    SONO_ROOT = true;
    turno = 0;
  }

  EspMeshConfig config;
  config.router_ssid = "";       // vuoto perché senza AP
  config.on_event = onMesh;      // quando accade un evento, gestito da onMesh
  config.channel = 11;           // Stesso canale per tutte le board
  config.mesh_id[5] = ID_GRUPPO; // Stesso ID gruppo per tutte le board
  config.role = SONO_ROOT ? EspMeshRole::Root : EspMeshRole::Node; // forzo a essere non root

  if (IoTBoard::init_espmesh(config)) {
    if (SONO_ROOT) {
      esp_mesh_set_ap_assoc_expire(1); // Se non rispondi entro 1 second, ti considero offline
    }

    display->println("Mesh pronta!");
    display->printf("MAC: %s \n", macStr);
    display->println(SONO_ROOT ? "Ruolo: ROOT" : "Ruolo: NODO");
  } else {
    display->println("Errore avvio Mesh");
  }
  display->display();

  if (strcmp(macStr, MAC_0) == 0 || strcmp(macStr, MAC_2) == 0) {
    gruppo = 0;
  } else if (strcmp(macStr, MAC_1) == 0 || strcmp(macStr, MAC_3) == 0) {
    gruppo = 1;
  } else {
    Serial.println("Errore - MAC non riconosciuto");
  }
}

void loop() {
  espmesh->update();
  // Ogni 500ms controllo se sono connesso a tutti i nodi (solo sul Root)
  if (IoTBoard::runEvery(500, 2)) {
    // Se sono il Root, verifico se sono connessi tutti i nodi (compreso il Root stesso)
    if (SONO_ROOT) {
      uint8_t nodes[10][6];
      numNodi = espmesh->getNodes(nodes, 10);

      // Verifico se sono connesse tutte le board
      if (numNodi == NUM_BOARD && stato == SYNC) { // Tutte le board si sono appena riconnesse
        if (turno == 0) {
          // avviso i membri del gruppo 0 di andare a verde e quelli del gruppo
          // 1 di andare a rosso
        } else {
          // avviso i membri del gruppo 1 di andare a verde e quelli del gruppo
          // 0 di andare a rosso
        }
      } else if (numNodi < NUM_BOARD && stato != SYNC) { 
        // eravamo connessi e qualcuno si è disconnesso
        // mandiamo un messaggio a tutti (broadcast) dicendo che d'ora in avanti saranno in sync
      }
    }
  }
  
  
  
  // DA AGGIUNGERE: Devo rendermi conto se non sono root se in qualche modo è morto
 





  // Lampeggio del LED Giallo se manca qualcuno (sia su Root che su Station)
  if (stato == SYNC) {
    if (IoTBoard::runEvery(500, 1)) {
      digitalWrite(LED_YELLOW, !digitalRead(LED_YELLOW));
    }
  }

  // Ogni x  secondi logica di controllo / invio
  if (IoTBoard::runEvery(3000, 0)) {
    if (SONO_ROOT) {
      //gestisco la logica del cambiamento di stato da rosso a verde ogni x secondi + giallo 
    }
  }

  // attivo il mio led dello stato 

}
