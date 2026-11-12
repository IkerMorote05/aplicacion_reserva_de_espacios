import 'package:aplicacion_reserva_espacios/data/repositories/comentarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/reservas_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';
import 'package:aplicacion_reserva_espacios/ui/espacios/ui/espacios_screen.dart';
import 'package:flutter/material.dart';

class Homepantalla extends StatefulWidget {
  const Homepantalla({super.key});
  @override
  State<Homepantalla> createState() => _HomePantallaState();
}

class _HomePantallaState extends State<Homepantalla> {
  final _fromKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  String? _error;
  late final List<Espacio> lista = _espacios.obtenerTodos();
  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _usuario = UsuariosRepository(service: _service);
  late final _espacios = EspaciosRepository(service: _service);
  late final _reservas = ReservasRepository(
    service: _service,
    ur: _usuario,
    er: _espacios,
  );
  late final _comentarios = ComentariosRepository(
    service: _service,
    usuariosRepository: _usuario,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      bottomNavigationBar: const SafeArea(top: false, child: Barranavegacion()),
      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Encuentro",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                child: Text('UI'),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Tu próximo espacio, más cerca.",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          SearchBar(
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            hintText: "Busca en València",
          ),
          SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll<Size?>(
                    Size(100, 45),
                  ),
                  maximumSize: const WidgetStatePropertyAll<Size?>(
                    Size(105, 60),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                child: Text("Reuniones", style: TextStyle(fontSize: 12)),
              ),
              FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll<Size?>(
                    Size(80, 45),
                  ),
                  maximumSize: const WidgetStatePropertyAll<Size?>(
                    Size(100, 60),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey),
                ),
                child: Text("Talleres", style: TextStyle(fontSize: 12)),
              ),
              FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll<Size?>(
                    Size(100, 45),
                  ),
                  maximumSize: const WidgetStatePropertyAll<Size?>(
                    Size(130, 60),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey),
                ),
                child: Text("Celebraciones", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cerca de ti", style: TextStyle(fontSize: 22)),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(builder: (_) => EspaciosScreen()),
                  );
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color?>(Colors.white),
                  foregroundColor: WidgetStatePropertyAll<Color?>(
                    Colors.indigo,
                  ),
                ),
                child: Text("Ver todos ->"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Image.asset(
              'assets/images/salonPrueba3.png',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(lista[1].nombre, style: TextStyle(fontSize: 22))],
          ),
        ],
      ),
    );
  }
}
