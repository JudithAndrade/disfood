import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Importa el archivo de opciones de Firebase
import 'grafica.dart'; // Importa el archivo de la gráfica

Future<void> main() async {
  // Asegurarse de que el binding de Flutter esté inicializado antes de Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase con las opciones de configuración
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ejecutar la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Gráfica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegación a la pantalla de gráficas
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GraficaScreen()), // Asegúrate de que GraficaScreen esté correctamente definida
            );
          },
          child: const Text('Ver Gráfica'),
        ),
      ),
    );
  }
}
