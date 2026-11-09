import 'package:aplicacion_reserva_espacios/data/models/servicio_contratado_dto.dart';

enum CodigoEstado { PEND, CONF, CAND }

class ReservaDto {
  final String id;
  final String espacioId;
  final String usuarioId;
  final String actividad;
  final String inicioIso;
  final String finIso;
  final int asistentes;
  final CodigoEstado codigoEstado;
  final int tarifaHoraCentimos;
  final int precioTotalCentimos;
  final List<ServicioContratadoDto> serviciosContratados;
  final String moneda;

  const ReservaDto({
    required this.id,
    required this.espacioId,
    required this.usuarioId,
    required this.actividad,
    required this.inicioIso,
    required this.finIso,
    required this.asistentes,
    required this.codigoEstado,
    required this.tarifaHoraCentimos,
    required this.precioTotalCentimos,
    required this.serviciosContratados,
    required this.moneda,
  });
}
