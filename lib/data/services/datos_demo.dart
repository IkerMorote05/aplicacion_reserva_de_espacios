import 'package:aplicacion_reserva_espacios/data/models/reserva_dto.dart';
import 'package:aplicacion_reserva_espacios/data/models/servicio_contratado_dto.dart';

const reservaDemo = ReservaDto(
  id: 'r1',
  espacioId: 'e1',
  usuarioId: 'u1',
  actividad: 'Reunion',
  inicioIso: '2026-11-12T10:00:00',
  finIso: '2026-11-12T12:00:00',
  asistentes: 12,
  codigoEstado: CodigoEstado.CONF,
  tarifaHoraCentimos: 3000,
  precioTotalCentimos: 7500,
  moneda: 'EUR',
  serviciosContratados: [
    ServicioContratadoDto(
      servicioId: 'e1_limpieza',
      nombre: 'Limpieza final',
      precioCentimos: 1500,
    ),
  ],
);
