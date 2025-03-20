import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> toogleActionOfGate() async {
    try {
      // Usar o IP do seu WebServer com ESP-01 conhecido como ESP
      var url = Uri.http('192.168.0.200:80', '/toggle');
      await http.get(url);
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Center(
              child: IconButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: const CircleBorder(),
            ),
            onPressed: toogleActionOfGate,
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 200,
            ),
          )),
        ));
  }
}
