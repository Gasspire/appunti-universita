#include "HardwareSerial.h"
#include <cstdint>
#include <iot_board.h>
#include <sys/types.h>

// Identificativo univoco del vostro gruppo
#define ID_GRUPPO 0x05

// Numero totale di board nel gruppo (1 Root + 3 Station)
#define NUM_BOARD 4

#define MAC_0 "34:85:18:7B:1F:68" // Antonio - ROOT (Gruppo 0)
#define MAC_1 "34:85:18:7A:B7:00" // Diletta       (Gruppo 1)
#define MAC_2 "34:85:18:7A:FA:14" // Marco         (Gruppo 0)
#define MAC_3 "34:85:18:7B:0A:0C" // Dave          (Gruppo 1)

enum STATI { SYNC, ROSSO, VERDE, GIALLO };

uint8_t turno = 0;
uint8_t gruppo = 0;
uint8_t myMac[6];
int numNodi = 0;
bool SONO_ROOT = false;
STATI stato = SYNC;

// Funzione di utilità per aggiornare lo stato in base al turno e al gruppo di appartenenza
void applicaTurno(uint8_t t) {
  turno = t;
  if (gruppo == turno) {
    stato = VERDE;
  } else {
    stato = ROSSO;
  }
}

void onMesh(const EspMeshEvent &e) {
  switch (e.type) {
  case EspMeshEventType::Connected:
    Serial.printf("[" MACSTR "] Connesso alla rete mesh!\n", MAC2STR(e.from));
    stato = SYNC;
    break;

  case EspMeshEventType::Disconnected:
    if (!SONO_ROOT) {
      stato = SYNC; // Torno nello stato di sincronizzazione/attesa
      Serial.printf("[" MACSTR "] Disconnesso dalla rete mesh!\n", MAC2STR(e.from));
    }
    break;

  case EspMeshEventType::ChildJoined:
    Serial.printf("[ROOT] Nodo connesso: " MACSTR "\n", MAC2STR(e.from));
    break;

  case EspMeshEventType::ChildLeft:
    Serial.printf("[ROOT] Nodo caduto/scollegato: " MACSTR "\n", MAC2STR(e.from));
    if (SONO_ROOT) {
      stato = SYNC;
      String cmd = "CMD:SYNC";
      espmesh->broadcast(cmd.c_str(), cmd.length());
      Serial.println("[ROOT] Inviato broadcast immediato CMD:SYNC!");
    }
    break;

  case EspMeshEventType::Message:
    // Ignoro il messaggio se è l'eco del mio stesso broadcast
    if (memcmp(e.from, myMac, 6) == 0)
      return;

    // Se sono una Station, ascolto i comandi inviati dal Root
    if (!SONO_ROOT) {
      if (strstr((char *)e.data, "CMD:SYNC") != nullptr) {
        stato = SYNC;
        Serial.println("[CMD dal Root] Manca qualche nodo -> STATO = SYNC");
      } else if (strstr((char *)e.data, "CMD:TURNO:0") != nullptr) {
        applicaTurno(0);
        Serial.printf("[CMD dal Root] Turno 0 -> Gruppo %d, Stato: %s\n",
                      gruppo, (stato == VERDE ? "VERDE" : "ROSSO"));
      } else if (strstr((char *)e.data, "CMD:TURNO:1") != nullptr) {
        applicaTurno(1);
        Serial.printf("[CMD dal Root] Turno 1 -> Gruppo %d, Stato: %s\n",
                      gruppo, (stato == VERDE ? "VERDE" : "ROSSO"));
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

  // Inizializza display
  display->clearDisplay();
  display->setCursor(0, 0);

  // Legge il MAC address hardware
  esp_read_mac(myMac, ESP_MAC_WIFI_STA);

  // Confronta il MAC per determinare il ruolo e il gruppo automaticamente
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02X:%02X:%02X:%02X:%02X:%02X",
           myMac[0], myMac[1], myMac[2], myMac[3], myMac[4], myMac[5]);

  if (strcmp(macStr, MAC_0) == 0) {
    SONO_ROOT = true;
    turno = 0;
  }

  if (strcmp(macStr, MAC_0) == 0 || strcmp(macStr, MAC_2) == 0) {
    gruppo = 0;
  } else if (strcmp(macStr, MAC_1) == 0 || strcmp(macStr, MAC_3) == 0) {
    gruppo = 1;
  } else {
    Serial.println("Errore - MAC non riconosciuto!");
  }

  EspMeshConfig config;
  config.router_ssid = "";       // Vuoto perché standalone senza AP
  config.on_event = onMesh;      // Callback eventi mesh
  config.channel = 11;           // Stesso canale per tutte le board
  config.mesh_id[5] = ID_GRUPPO; // Stesso ID gruppo per tutte le board
  config.role = SONO_ROOT ? EspMeshRole::Root : EspMeshRole::Node;

  if (IoTBoard::init_espmesh(config)) {
    if (SONO_ROOT) {
      esp_mesh_set_ap_assoc_expire(1); // Rileva disconnessioni entro 1 secondo
    }

    display->println("Mesh pronta!");
    display->printf("MAC: %s\n", macStr);
    display->printf("Ruolo: %s (G%d)\n", SONO_ROOT ? "ROOT" : "NODO", gruppo);
  } else {
    display->println("Errore avvio Mesh");
  }
  display->display();
}

void loop() {
  espmesh->update();

  // Controllo periodico della topologia (ogni 500ms, solo sul Root)
  if (IoTBoard::runEvery(500, 2)) {
    if (SONO_ROOT) {
      uint8_t nodes[10][6];
      numNodi = espmesh->getNodes(nodes, 10);

      // CASO 1: Tutte le board connesse e siamo ancora in attesa (SYNC)
      if (numNodi == NUM_BOARD && stato == SYNC) {
        Serial.printf("[ROOT] Rete completa (%d/%d)! Avvio semafori al turno %d\n",
                      numNodi, NUM_BOARD, turno);
        applicaTurno(turno);
        String cmd = (turno == 0) ? "CMD:TURNO:0" : "CMD:TURNO:1";
        espmesh->broadcast(cmd.c_str(), cmd.length());
      }
      // CASO 2: Manca qualche board ed eravamo operativi
      else if (numNodi < NUM_BOARD && stato != SYNC) {
        Serial.printf("[ROOT] Mancano nodi (%d/%d)! Passaggio a STATO = SYNC\n",
                      numNodi, NUM_BOARD);
        stato = SYNC;
        String cmd = "CMD:SYNC";
        espmesh->broadcast(cmd.c_str(), cmd.length());
      }
    }
  }

  // Cambio turno semaforico ogni 5 secondi (solo Root e solo se la rete è al completo)
  if (IoTBoard::runEvery(5000, 0)) {
    if (SONO_ROOT && numNodi == NUM_BOARD && stato != SYNC) {
      turno = (turno == 0) ? 1 : 0;
      applicaTurno(turno);
      String cmd = (turno == 0) ? "CMD:TURNO:0" : "CMD:TURNO:1";
      espmesh->broadcast(cmd.c_str(), cmd.length());
      Serial.printf("[ROOT] Cambio turno -> %d (Gruppo 0: %s, Gruppo 1: %s)\n",
                    turno, (turno == 0 ? "VERDE" : "ROSSO"), (turno == 1 ? "VERDE" : "ROSSO"));
    }
  }

  // GESTIONE CENTRALIZZATA DEI LED IN BASE ALLO STATO
  switch (stato) {
  case SYNC:
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_RED, LOW);
    // Lampeggio giallo ogni 500ms
    if (IoTBoard::runEvery(500, 1)) {
      digitalWrite(LED_YELLOW, !digitalRead(LED_YELLOW));
    }
    break;

  case VERDE:
    digitalWrite(LED_YELLOW, LOW);
    digitalWrite(LED_RED, LOW);
    digitalWrite(LED_GREEN, HIGH);
    break;

  case GIALLO:
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_RED, LOW);
    digitalWrite(LED_YELLOW, HIGH);
    break;

  case ROSSO:
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_YELLOW, LOW);
    digitalWrite(LED_RED, HIGH);
    break;
  }
}