import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/espacio_targeta.dart';
import 'package:flutter/material.dart';

class EspaciosScreen extends StatefulWidget {
  const EspaciosScreen({super.key});
  @override
  State<EspaciosScreen> createState() => _EspaciosScreenState();
}

class _EspaciosScreenState extends State<EspaciosScreen> {
  late final List<Espacio> lista = _espacios.obtenerTodos();
  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: [],
    usuarios: [],
    comentarios: [],
    disponibilidad: [],
  );
  late final _espacios = EspaciosRepository(service: _service);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Espacios cercanos")),
      bottomNavigationBar: const SafeArea(top: false, child: Barranavegacion()),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final espacio = lista[index];
          return EspacioTargeta(id: espacio.id);
        },
      ),
    );
  }
}
