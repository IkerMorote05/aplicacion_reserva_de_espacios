import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/domain/models/servicio_contratado.dart';
import 'package:aplicacion_reserva_espacios/domain/models/usuario.dart';

enum EstadoReserva { confirmada, pendiente, cancelada }

class Reserva {
  final String id;
  final Espacio espacio;
  final Usuario usuario;
  final String actividad;
  final DateTime inicio;
  final DateTime fin;
  final int asistentes;
  final EstadoReserva estado;
  final List<ServicioContratado> serviciosContratados;
  final int tarifaHoraCentimos;
  final int precioTotalCentimos;
  final String moneda;

  Reserva({
    required this.id,
    required this.espacio,
    required this.usuario,
    required this.actividad,
    required this.inicio,
    required this.fin,
    required this.asistentes,
    this.estado = EstadoReserva.confirmada,
    required this.serviciosContratados,
    required this.tarifaHoraCentimos,
    required this.precioTotalCentimos,
    required this.moneda,
  });
  Duration get duracion => fin.difference(inicio);
  int get totalServiciosCentimos => serviciosContratados.fold<int>(
    0,
    (total, servicio) => total + servicio.precioCentimos,
  );
}
