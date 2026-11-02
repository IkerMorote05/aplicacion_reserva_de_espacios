import 'package:aplicacion_reserva_espacios/domain/models/franja_disponibilidad.dart';

class DisponibilidadDia {
  final String espacioId;
  final DateTime fecha;
  final List<FranjaDisponibilidad> franja;

  DisponibilidadDia({
    required this.espacioId,
    required this.fecha,
    required this.franja,
  });
}
