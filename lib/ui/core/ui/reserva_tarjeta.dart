import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/reservas_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/reserva.dart';
import 'package:flutter/material.dart';

class ReservaTarjeta extends StatefulWidget {
  const ReservaTarjeta({super.key, required this.id});

  final String id;

  @override
  State<ReservaTarjeta> createState() => _ReservaTarjetaState();
}

class _ReservaTarjetaState extends State<ReservaTarjeta> {
  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _reservas = ReservasRepository(
    service: _service,
    ur: _usuarios,
    er: _espacios,
  );
  late final _espacios = EspaciosRepository(service: _service);
  late final _usuarios = UsuariosRepository(service: _service);
  @override
  Widget build(BuildContext context) {
    final Reserva? reserva = _reservas.obtenerPorId(widget.id);
    final String color = reserva?.estado != EstadoReserva.confirmada
        ? "red"
        : "green";
    if (reserva == null) {
      return const Card(
        child: ListTile(title: Text("No se encontró la reserva")),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "${reserva.estado} · DEMO",
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              reserva.espacio?.nombre ?? 'Sin espacio',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(reserva.espacio?.ubicacion ?? 'Sin ubicacion'),
            SizedBox(height: 5),
            Row(
              children: [
                Text("${reserva.inicio}-${reserva.fin}"),
                Text("${reserva.precioTotalCentimos / 100}€"),
              ],
            ),
            SizedBox(height: 5),
            FilledButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Text(
                "Ver detalle ->",
                style: TextStyle(fontSize: 12, color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
