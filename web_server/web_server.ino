#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

// Configurações de rede
const char* ssid = "brisa-2723772";
const char* password = "qjhzra0p";

// Configurações de IP fixo
IPAddress local_IP(192, 168, 0, 200);
IPAddress gateway(192, 168, 0, 1);
IPAddress subnet(255, 255, 255, 0);

// Inicializa o servidor web na porta 80
ESP8266WebServer server(80);

// Definindo o pino do LED (relé)
const int ledPin = 0;

// Função para acionar o relé
void handleToggleActionGate() {
  digitalWrite(ledPin, LOW); // Liga o relé
  delay(1000);                // Aguarda 100 ms
  digitalWrite(ledPin, HIGH); // Desliga o relé
  server.send(200, "text/plain", "Acionado");
}

void setup() {
  // Inicializa o pino do relé
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH); // Desliga o relé inicialmente

  // Conectando ao Wi-Fi com IP fixo
  Serial.begin(115200);
  WiFi.config(local_IP, gateway, subnet);
  WiFi.begin(ssid, password);
  Serial.print("Conectando");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConectado ao Wi-Fi");
  Serial.println("IP: " + WiFi.localIP().toString());

  // Configurações do servidor
  server.on("/toggle", handleToggleActionGate);
  server.begin();
  Serial.println("Servidor iniciado");
}

void loop() {
  server.handleClient();
}
