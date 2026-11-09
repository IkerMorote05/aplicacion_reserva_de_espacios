import 'package:aplicacion_reserva_espacios/data/models/franja_disponibilidad_dto.dart';

class DisponibilidadDiaDto {
  final String espacioId;
  final DateTime fecha;
  final List<FranjaDisponibilidadDto> franja;

  const DisponibilidadDiaDto({
    required this.espacioId,
    required this.fecha,
    required this.franja,
  });
}
