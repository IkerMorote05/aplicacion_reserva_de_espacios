import 'dart:ui';

import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/reservas_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/domain/models/reserva.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/reserva_tarjeta.dart';
import 'package:flutter/material.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});
  @override
  State<MisReservasScreen> createState() => _MisReservasScreemState();
}

class _MisReservasScreemState extends State<MisReservasScreen> {
  late final List<Reserva> lista = _reservas.obtenerTodos();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Reservas")),
      bottomNavigationBar: const SafeArea(top: false, child: Barranavegacion()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Tus próximos encuentros, en un solo lugar.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  maximumSize: WidgetStatePropertyAll(Size(500, 48)),
                  minimumSize: WidgetStatePropertyAll(Size(160, 48)),
                ),
                child: Text("Próximas · ${lista.length}"),
              ),
              SizedBox(width: 16),
              FilledButton(
                onPressed: () {},
                style: const ButtonStyle(
                  maximumSize: WidgetStatePropertyAll(Size(500, 48)),
                  minimumSize: WidgetStatePropertyAll(Size(160, 48)),
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 216, 216, 216),
                  ),
                  shadowColor: WidgetStatePropertyAll(Colors.black),
                ),
                child: Text("Historial", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final reserva = lista[index];
              return ReservaTarjeta(id: reserva.id);
            },
          ),
        ],
      ),
    );
  }
}
