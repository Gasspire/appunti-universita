#include <cstdint>
#include <iot_board.h>
#include <sys/types.h>
// Identificativo univoco del vostro gruppo
#define ID_GRUPPO 0x05

// Numero totale di board nel gruppo (1 Root + 3 Station)
#define NUM_BOARD 4

// Inidirizzi MAC in byte
const uint8_t MAC_0[6] = {0x34, 0x85, 0x18, 0x7B, 0x1F, 0x68}; // Antonio - ROOT
const uint8_t MAC_3[6] = {0x34, 0x85, 0x18, 0x7B, 0x0A, 0x0C}; // Dave
const uint8_t MAC_1[6] = {0x34, 0x85, 0x18, 0x7A, 0xB7, 0x00}; // Diletta
const uint8_t MAC_2[6] = {0x34, 0x85, 0x18, 0x7A, 0xFA, 0x14}; // Marco

const uint8_t GRUPPO_0[6] = {0x01, 0x00, 0x5E, 0x00, 0x00, 0x00}; // Antonio + Marco
const uint8_t GRUPPO_1[6] = {0x01, 0x00, 0x5E, 0x00, 0x00, 0x01}; // Diletta + Dave


uint8_t numeroConferme;
bool attesa_conferme = false;
enum STATI
{
  SYNC,
  ROSSO,
  VERDE,
  GIALLO
};

uint8_t turno;
uint8_t gruppo;
uint8_t myMac[6];
int numNodi = 0;
bool SONO_ROOT = false;
STATI stato = SYNC;

void onMesh(const EspMeshEvent &e)
{
  switch (e.type)
  {
  case EspMeshEventType::Connected:
    Serial.printf("[" MACSTR "] Connesso alla rete mesh!", MAC2STR(e.from));
    stato = SYNC;
    break;

  case EspMeshEventType::Disconnected:
    if (!SONO_ROOT)
    {
      stato = SYNC; // Torno nello stato di sincronizzazione/attesa
      Serial.printf("[" MACSTR "] Disconnesso dalla rete mesh!", MAC2STR(e.from));
    }
    break;

  // FATTO SOLO DA ROOT
  case EspMeshEventType::ChildJoined:
    Serial.printf("[ROOT] Nodo connesso: " MACSTR "\n", MAC2STR(e.from));
    break;

  // FATTO SOLO DA ROOT
  case EspMeshEventType::ChildLeft:
    Serial.printf("[ROOT] Nodo caduto/scollegato: " MACSTR "\n", MAC2STR(e.from));
    // QUI DOBBIAMO AGGIUNGERE L'AVVISO AI VARI NODI
    break;

  case EspMeshEventType::Message:
    if (strcmp((char *)e.data, "VERDE") == 0)
    {
      stato = VERDE;
    }
    else if (strcmp((char *)e.data, "GIALLO") == 0)
    {
      stato = GIALLO;
    }
    else if (strcmp((char *)e.data, "SYNC") == 0)
    {
      stato = SYNC;
    }else if (strcmp((char *)e.data, "ROSSI") == 0)
    {
      stato = ROSSO;
    }else if (strcmp((char *)e.data, "CONFERMA") == 0)
    {
      numeroConferme++;
    }
    
    break;

  default:
    break;
  }
}

void setup()
{
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

  if (memcmp(myMac, MAC_0, 6) == 0)
  {
    SONO_ROOT = true;
    turno = 0;
  }
  if (memcmp(myMac, MAC_0, 6) == 0 || memcmp(myMac, MAC_2, 6) == 0)
    gruppo = 0;
  else if (memcmp(myMac, MAC_1, 6) == 0 || memcmp(myMac, MAC_3, 6) == 0)
    gruppo = 1;
  // Configuro la rete mesh con i parametri richiesti
  EspMeshConfig config;
  config.router_ssid = "";                                         // vuoto perché senza AP
  config.on_event = onMesh;                                        // quando accade un evento, gestito da onMesh
  config.channel = 11;                                             // Stesso canale per tutte le board
  config.mesh_id[5] = ID_GRUPPO;                                   // Stesso ID gruppo per tutte le board
  config.role = SONO_ROOT ? EspMeshRole::Root : EspMeshRole::Node; // forzo a essere non root
  
  if (IoTBoard::init_espmesh(config))
  {
    if (SONO_ROOT)
    {
      esp_mesh_set_ap_assoc_expire(1); // Se non rispondi entro 1 second, ti considero offline
    }

    display->println("Mesh pronta!");
    display->printf("MAC: %s \n", macStr);
    display->println(SONO_ROOT ? "Ruolo: ROOT" : "Ruolo: NODO");
  }
  else
  {
    display->println("Errore avvio Mesh");
  }
  //Configuro il gruppo a cui appartengo
  espmesh->joinGroup(gruppo == 0 ? GRUPPO_0 : GRUPPO_1);
  display->display();
}

void loop()
{
  espmesh->update();

  // Ogni 500ms controllo se sono connesso a tutti i nodi (solo sul Root)
  if (IoTBoard::runEvery(500, 2))
  {
    // Se sono il Root, verifico se sono connessi tutti i nodi (compreso il Root stesso)
    if (SONO_ROOT)
    {
      uint8_t nodes[10][6];
      numNodi = espmesh->getNodes(nodes, 10);

      // Verifico se sono connesse tutte le board
      if (numNodi == NUM_BOARD && stato == SYNC)
      { // Tutte le board si sono appena riconnesse
        if (turno == 0)
        {
          espmesh->sendToGroup(GRUPPO_0, "VERDE", 6);
          espmesh->sendToGroup(GRUPPO_1, "ROSSI", 6);
        }
        else
        {
          espmesh->sendToGroup(GRUPPO_1, "VERDE", 6);
          espmesh->sendToGroup(GRUPPO_0, "ROSSI", 6);
        }
      }
      else if (numNodi < NUM_BOARD && stato != SYNC)
      {
        // eravamo connessi e qualcuno si è disconness
        // mandiamo un messaggio a tutti (broadcast) dicendo che d'ora in avanti saranno in sync
        espmesh->broadcast("SYNC", 5);
      }
    }
  }

  // DA AGGIUNGERE: Devo rendermi conto se non sono root se in qualche modo è morto

  // Lampeggio del LED Giallo se manca qualcuno (sia su Root che su Station)
  if (stato == SYNC)
  {
    if (IoTBoard::runEvery(500, 1))
    {
      digitalWrite(LED_YELLOW, !digitalRead(LED_YELLOW));
    }
  }

  // Ogni x  secondi logica di controllo / invio
  if (IoTBoard::runEvery(5000, 0) && attesa_conferme == false)
  {
    // POSSIBILE DELAY DEL TIMER
    if (SONO_ROOT)
    {
      // gestisco la logica del cambiamento di stato da rosso a verde ogni x secondi + giallo
      if (turno == 0)
      { 
        espmesh->sendToGroup(GRUPPO_0, "GIALLO", 6);
      }
      else
      {
        espmesh->sendToGroup(GRUPPO_1, "GIALLO", 6);
      }
      attesa_conferme = true;
    }
  }

  if(attesa_conferme == true && numeroConferme == 2 && SONO_ROOT){
    attesa_conferme = false;
    numeroConferme = 0;
    
    turno = !turno;
    if (turno == 0)
    {
      espmesh->sendToGroup(GRUPPO_0, "VERDE", 6);
    }
    else
    {
      espmesh->sendToGroup(GRUPPO_1, "VERDE", 6);
    }
  }

  if (IoTBoard::runEvery(3000,5) && stato == GIALLO){
    stato = ROSSO;
    espmesh->sendTo(MAC_0, "CONFERMA", 9);
  }

  switch(stato){
    case VERDE:
      digitalWrite(LED_GREEN, HIGH);
      digitalWrite(LED_RED, LOW);
      digitalWrite(LED_YELLOW, LOW);
      break;
    case ROSSO:
      digitalWrite(LED_GREEN, LOW);
      digitalWrite(LED_RED, HIGH);
      digitalWrite(LED_YELLOW, LOW);
      break;
    case GIALLO:
      digitalWrite(LED_GREEN, LOW);
      digitalWrite(LED_RED, LOW);
      digitalWrite(LED_YELLOW, HIGH);
      break;
  }
}
