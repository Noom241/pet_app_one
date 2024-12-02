import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/login_screen.dart';  // Importa la pantalla de login
import 'package:pet_app_one/screen/HomeScreen.dart';  // Importa la pantalla Home
import 'package:pet_app_one/auth/user_provider.dart'; // Importa el provider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),  // Proveer el UserProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Definir rutas
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
      initialRoute: '/login', // La primera pantalla será el login
    );
  }
}
