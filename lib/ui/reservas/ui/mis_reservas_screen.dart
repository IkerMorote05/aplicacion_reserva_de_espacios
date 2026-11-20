import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/reservas_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/reserva.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_seleccion.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/reserva_tarjeta.dart';
import 'package:flutter/material.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});
  @override
  State<MisReservasScreen> createState() => _MisReservasScreemState();
}

class _MisReservasScreemState extends State<MisReservasScreen> {
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
  late final List<Reserva> lista = _reservas.obtenerTodos();
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
            style: TextStyle(color: TemaApp.textoSecundario, fontSize: 14),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BotonSeleccion(
                seleccionado: true,
                onPressed: () {},
                ancho: 150,
                child: Text("Próximas · ${lista.length}"),
              ),
              SizedBox(width: 16),
              BotonSeleccion(
                seleccionado: false,
                onPressed: () {},
                ancho: 150,
                child: Text("Historial"),
              ),
            ],
          ),
          SizedBox(height: 10),
          ...lista.map((reserva) => ReservaTarjeta(id: reserva.id)),
        ],
      ),
    );
  }
}
