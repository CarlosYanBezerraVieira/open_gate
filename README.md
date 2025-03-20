# Open Gate

Open Gate é um projeto de automação residencial que utiliza um web server rodando em um ESP-01 (ESP8266) para abrir e fechar o portão da garagem. O projeto consiste em um dispositivo controlado por Wi-Fi que se comunica com um aplicativo desenvolvido em Flutter para enviar comandos ao portão.

## 🗂️ Sumário
- [Componentes Necessários](#⚙️-componentes-necessários)
- [Bibliotecas Necessárias](#🛠️-bibliotecas-necessárias)
- [Código do Servidor Web (ESP-01)](#🚀-código-do-servidor-web-esp-01)
- [Código do Aplicativo Flutter](#📱-código-do-aplicativo-flutter)
- [Como Rodar o Projeto Flutter](#💻-como-rodar-o-projeto-flutter)
- [Licença](#📝-licença)

## ⚙️ Componentes Necessários

1. **ESP-01 Wifi ESP8266**
2. **Adaptador USB Serial CH340G**
3. **Relé Wifi**
4. **Fonte de alimentação compatível com ESP-01**

## 🛠️ Bibliotecas Necessárias

### Para o ESP-01 (ESP8266)
- **ESP8266WiFi.h**: Para gerenciar a conexão Wi-Fi.
- **ESP8266WebServer.h**: Para criar o servidor HTTP.

### Para o Flutter
- **http**: Para realizar requisições HTTP ao servidor web.

## 🚀 Código do Servidor Web (ESP-01)

```cpp
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

// Configurações de rede
const char* ssid = "****";
const char* password = "****";

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
  digitalWrite(ledPin, LOW);
  delay(1000);
  digitalWrite(ledPin, HIGH);
  server.send(200, "text/plain", "Acionado");
}

void setup() {
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  Serial.begin(115200);
  WiFi.config(local_IP, gateway, subnet);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConectado ao Wi-Fi");
  Serial.println("IP: " + WiFi.localIP().toString());

  server.on("/toggle", handleToggleActionGate);
  server.begin();
}

void loop() {
  server.handleClient();
}
```
## Imagem do circuito do Servidor Web + relé e controle do portão

![CicuritoFinal](https://github.com/user-attachments/assets/b234006e-4b96-4cbe-833f-19dd2e5b8a86)

## 📱 Código do Aplicativo Flutter

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> toogleActionOfGate() async {
    try {
      var url = Uri.http('192.168.0.200:80', '/toggle');
      await http.get(url);
    } catch (e) {
      throw Exception('Error: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: IconButton(
            icon: Icon(Icons.power_settings_new, size: 200, color: Colors.indigo),
            onPressed: toogleActionOfGate,
          ),
        ),
      ),
    );
  }
}
```

## Vídeo demostrativo.

https://github.com/user-attachments/assets/caecb805-21f8-4496-b324-08cae64737d4



## 💻 Como Rodar o Projeto Flutter

### Pré-requisitos
- Flutter instalado: [Guia de Instalação do Flutter](https://docs.flutter.dev/get-started/install)
- ADB instalado: Pode ser feito pelo Android Studio

### Rodando Localmente
1. Clone o repositório:
   ```bash
   git clone https://github.com/CarlosYanBezerraVieira/open_gate.git
   cd open_gate
   flutter pub get
   ```
2. Conecte seu dispositivo Android via ADB:
   ```bash
   adb pair IP:porta
   ```
3. Verifique se o dispositivo está conectado:
   ```bash
   adb devices
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```

## 📝 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
