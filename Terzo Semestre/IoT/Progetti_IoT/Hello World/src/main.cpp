#include <cstdint>
#include <iot_board.h>
#include <sys/types.h>
// Identificativo univoco del vostro gruppo
#define ID_GRUPPO 0x05

// Numero totale di board nel gruppo (1 Root + 3 Station)
#define NUM_BOARD 4

// Tempi del semaforo (ms)
#define DURATA_VERDE 5000
#define DURATA_GIALLO 3000
#define TIMEOUT_CONFERME 2000 // margine oltre il giallo per ricevere le CONFERMA
#define PERIODO_PING 1000     // ogni quanto la root dice "sono viva"
#define TIMEOUT_ROOT 3000     // se un nodo non sente la root per 3 s va in SYNC

// Messaggio + lunghezza calcolata in automatico (compreso il '\0' finale)
#define TXT(s) s, sizeof(s)

// Inidirizzi MAC in byte
const uint8_t MAC_0[6] = {0x34, 0x85, 0x18, 0x7B, 0x1F, 0x68}; // Antonio - ROOT
const uint8_t MAC_3[6] = {0x34, 0x85, 0x18, 0x7B, 0x0A, 0x0C}; // Dave
const uint8_t MAC_1[6] = {0x34, 0x85, 0x18, 0x7A, 0xB7, 0x00}; // Diletta
const uint8_t MAC_2[6] = {0x34, 0x85, 0x18, 0x7A, 0xFA, 0x14}; // Marco

const uint8_t GRUPPO_0[6] = {0x01, 0x00, 0x5E, 0x00, 0x00, 0x00}; // Antonio + Marco
const uint8_t GRUPPO_1[6] = {0x01, 0x00, 0x5E, 0x00, 0x00, 0x01}; // Diletta + Dave

enum STATI
{
  SYNC,
  ROSSO,
  VERDE,
  GIALLO
};

uint8_t turno = 0;
uint8_t gruppo;
uint8_t myMac[6];
int numNodi = 0;
bool SONO_ROOT = false;
STATI stato = SYNC;

// Usate solo dalla root
bool cicloAttivo = false; // true quando tutte le board sono collegate e il semaforo gira
bool attesa_conferme = false;
uint8_t numeroConferme = 0;
unsigned long inizioVerde = 0;
unsigned long inizioAttesa = 0;

// Usate da tutte le board
unsigned long inizioGiallo = 0;
unsigned long ultimoMsgRoot = 0;

// Esegue un comando ricevuto (o che la root manda al proprio gruppo)
void applica(const char *cmd)
{
  if (strcmp(cmd, "VERDE") == 0)
  {
    stato = VERDE;
  }
  else if (strcmp(cmd, "ROSSO") == 0)
  {
    stato = ROSSO;
  }
  else if (strcmp(cmd, "GIALLO") == 0)
  {
    stato = GIALLO;
    inizioGiallo = millis();
  }
  else if (strcmp(cmd, "SYNC") == 0)
  {
    stato = SYNC;
  }
}

// Manda un comando a un gruppo; se la root fa parte di quel gruppo lo esegue subito anche lei
void comandoGruppo(uint8_t g, const char *cmd, size_t len)
{
  espmesh->sendToGroup(g == 0 ? GRUPPO_0 : GRUPPO_1, cmd, len);
  if (SONO_ROOT && gruppo == g)
  {
    applica(cmd);
  }
}

// Root: ferma il semaforo e porta tutti in SYNC
void vaiInSync()
{
  espmesh->broadcast(TXT("SYNC"));
  stato = SYNC;
  cicloAttivo = false;
  attesa_conferme = false;
  numeroConferme = 0;
}

void onMesh(const EspMeshEvent &e)
{
  switch (e.type)
  {
  case EspMeshEventType::Connected:
    Serial.println("Connesso alla rete mesh!");
    stato = SYNC;
    break;

  case EspMeshEventType::Disconnected:
    if (!SONO_ROOT)
    {
      stato = SYNC; // Torno nello stato di sincronizzazione/attesa
      Serial.println("Disconnesso dalla rete mesh!");
    }
    break;

  // FATTO SOLO DA ROOT
  case EspMeshEventType::ChildJoined:
    Serial.printf("[ROOT] Nodo connesso: " MACSTR "\n", MAC2STR(e.from));
    break;

  // FATTO SOLO DA ROOT (l'avviso ai nodi lo gestisce il controllo con getNodes nel loop)
  case EspMeshEventType::ChildLeft:
    Serial.printf("[ROOT] Nodo caduto/scollegato: " MACSTR "\n", MAC2STR(e.from));
    break;

  case EspMeshEventType::Message:
  {
    // Ignoro l'eco dei miei stessi messaggi
    if (memcmp(e.from, myMac, 6) == 0)
    {
      break;
    }
    // Ogni messaggio della root dimostra che e' viva
    if (memcmp(e.from, MAC_0, 6) == 0)
    {
      ultimoMsgRoot = millis();
    }

    const char *msg = (const char *)e.data;
    if (strcmp(msg, "CONFERMA") == 0)
    {
      if (SONO_ROOT && attesa_conferme)
      {
        numeroConferme++;
      }
    }
    else
    {
      applica(msg);
    }
    break;
  }

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

  // Stringa del MAC, solo per il display
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02X:%02X:%02X:%02X:%02X:%02X", myMac[0],
           myMac[1], myMac[2], myMac[3], myMac[4], myMac[5]);

  // Confronta il MAC per determinare il ruolo automaticamente
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
  config.role = SONO_ROOT ? EspMeshRole::Root : EspMeshRole::Node; // root fissa, gli altri nodi

  if (IoTBoard::init_espmesh(config))
  {
    // Mi iscrivo al mio gruppo, altrimenti i messaggi sendToGroup vengono scartati
    // (dentro l'if: se la mesh non parte, espmesh non va usato)
    espmesh->joinGroup(gruppo == 0 ? GRUPPO_0 : GRUPPO_1);

    if (SONO_ROOT)
    {
      esp_mesh_set_ap_assoc_expire(3); // Se non rispondi entro 3 secondi, ti considero offline
    }

    display->println("Mesh pronta!");
    display->printf("MAC: %s \n", macStr);
    display->println(SONO_ROOT ? "Ruolo: ROOT" : "Ruolo: NODO");
    display->printf("Gruppo: %d\n", gruppo);
  }
  else
  {
    display->println("Errore avvio Mesh");
  }
  display->display();
}

void loop()
{
  espmesh->update();

  // ---------------- ROOT: controllo delle board e gestione del semaforo ----------------
  if (SONO_ROOT)
  {
    // Ogni 500 ms controllo se sono collegate tutte le board (compresa la root)
    if (IoTBoard::runEvery(500, 2))
    {
      uint8_t nodes[10][6];
      numNodi = espmesh->getNodes(nodes, 10);

      if (numNodi == NUM_BOARD && !cicloAttivo)
      {
        // Tutte le board collegate: (ri)parto. Il gruppo di turno va a verde, l'altro a rosso
        comandoGruppo(turno, TXT("VERDE"));
        comandoGruppo(1 - turno, TXT("ROSSO"));
        cicloAttivo = true;
        attesa_conferme = false;
        numeroConferme = 0;
        inizioVerde = millis();
      }
      else if (numNodi < NUM_BOARD && cicloAttivo)
      {
        // Qualcuno si e' scollegato: tutti in SYNC
        Serial.println("[ROOT] Manca una board, risincronizzo");
        vaiInSync();
      }
    }

    // Ogni secondo dico ai nodi che sono viva.
    // In SYNC ripeto "SYNC", cosi' chi ha perso il messaggio si allinea comunque.
    if (IoTBoard::runEvery(PERIODO_PING, 3))
    {
      if (cicloAttivo)
        espmesh->broadcast(TXT("PING"));
      else
        espmesh->broadcast(TXT("SYNC"));
    }

    if (cicloAttivo)
    {
      if (!attesa_conferme && millis() - inizioVerde >= DURATA_VERDE)
      {
        // Fine del verde: il gruppo di turno passa a giallo
        comandoGruppo(turno, TXT("GIALLO"));
        attesa_conferme = true;
        numeroConferme = 0;
        inizioAttesa = millis();
      }
      else if (attesa_conferme && numeroConferme >= 2)
      {
        // Entrambe le board del gruppo sono passate a rosso: verde all'altro gruppo
        attesa_conferme = false;
        numeroConferme = 0;
        turno = 1 - turno;
        comandoGruppo(turno, TXT("VERDE"));
        inizioVerde = millis();
      }
      else if (attesa_conferme && millis() - inizioAttesa >= DURATA_GIALLO + TIMEOUT_CONFERME)
      {
        // Una CONFERMA non e' arrivata in tempo: per sicurezza torno in SYNC e riparto
        Serial.println("[ROOT] Conferme mancanti, risincronizzo");
        vaiInSync();
      }
    }
  }

  // ---------------- TUTTE LE BOARD ----------------

  // Fine del giallo: passo a rosso e lo confermo alla root
  if (stato == GIALLO && millis() - inizioGiallo >= DURATA_GIALLO)
  {
    stato = ROSSO;
    if (SONO_ROOT)
      numeroConferme++; // la root conferma a se' stessa senza mandare messaggi
    else
      espmesh->sendTo(MAC_0, TXT("CONFERMA"));
  }

  // Nodo: se la root non si fa sentire da troppo tempo, vado in SYNC
  if (!SONO_ROOT && stato != SYNC && millis() - ultimoMsgRoot > TIMEOUT_ROOT)
  {
    Serial.println("Root non raggiungibile, vado in SYNC");
    stato = SYNC;
  }

  // Lampeggio del LED giallo quando sono in SYNC (sia su Root che su Station)
  if (stato == SYNC && IoTBoard::runEvery(500, 1))
  {
    digitalWrite(LED_YELLOW, !digitalRead(LED_YELLOW));
  }

  // Attivo i LED del mio stato
  switch (stato)
  {
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
  case SYNC:
    // il giallo NON va spento qui: lo gestisce il lampeggio qui sopra
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_RED, LOW);
    break;
  }
}
