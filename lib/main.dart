import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/ui/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EspaciosASaco',
      theme: TemaApp.crear(),

      home: const LoginScreen(),
    );
  }
}
