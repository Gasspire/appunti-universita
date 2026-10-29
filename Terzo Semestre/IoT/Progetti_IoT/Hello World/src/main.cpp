#include <painlessMesh.h>
#include <iot_board.h>
#define MESH_PREFIX   "iotMesh"     // mesh SSID, same on all nodes
#define MESH_PASSWORD "meshPass123" // WPA2 key of the mesh links
#define MESH_PORT     5555          // TCP port between nodes
 
Scheduler userScheduler;            // TaskScheduler, shared with mesh
painlessMesh mesh;
 
void sendMessage();
Task taskSendMessage(TASK_SECOND * 1, TASK_FOREVER, &sendMessage);
 
void sendMessage() {
  String msg = "Hi from node " + String(mesh.getNodeId());
  mesh.sendBroadcast(msg);
  taskSendMessage.setInterval(random(TASK_SECOND, TASK_SECOND * 5));
}
 
void receivedCallback(uint32_t from, String &msg) {
  Serial.printf("From %u: %s\n", from, msg.c_str());
}
void newConnectionCallback(uint32_t nodeId) {
  Serial.printf("New connection: %u\n", nodeId);
}
void changedConnectionCallback() {
  Serial.println("Topology changed");
}
void nodeTimeAdjustedCallback(int32_t offset) {
  Serial.printf("Time %u, offset %d\n", mesh.getNodeTime(), offset);
}
 
void setup() {
  Serial.begin(115200);
  IoTBoard::init_display();
  display->clearDisplay();
  
  mesh.setDebugMsgTypes(ERROR | STARTUP);    // before init()
  mesh.init(MESH_PREFIX, MESH_PASSWORD, &userScheduler, MESH_PORT);
  mesh.onReceive(&receivedCallback);
  mesh.onNewConnection(&newConnectionCallback);
  mesh.onChangedConnections(&changedConnectionCallback);
  mesh.onNodeTimeAdjusted(&nodeTimeAdjustedCallback);
  userScheduler.addTask(taskSendMessage);
  taskSendMessage.enable();
}
void loop() { mesh.update(); }