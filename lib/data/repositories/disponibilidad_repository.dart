import 'package:aplicacion_reserva_espacios/data/models/disponibilidad_dia_dto.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/disponibilidad_dia.dart';
import 'package:aplicacion_reserva_espacios/domain/models/franja_disponibilidad.dart';

class DisponibilidadRepository {
  DisponibilidadRepository({required DatosSimuladosService service}) {
    final datos = service.leerDisponibilidad();
    final claves = datos
        .map(
          (dia) =>
              '${dia.espacioId}:${dia.fecha.year}-'
              '${dia.fecha.month}-${dia.fecha.day}',
        )
        .toSet();
    if (claves.length != datos.length) {
      throw StateError("No puede haber días repetidos por espacio");
    }

    _disponibilidad = List.unmodifiable(datos.map(_aDominio));
  }
  late final List<DisponibilidadDia> _disponibilidad;
  List<DisponibilidadDia> obtenerTodos() => _disponibilidad;

  static DisponibilidadDia _aDominio(DisponibilidadDiaDto dto) {
    return DisponibilidadDia(
      espacioId: dto.espacioId,
      fecha: dto.fecha,
      franja: dto.franja
          .map(
            (franja) => FranjaDisponibilidad(
              inicio: DateTime.parse(franja.inicioIso),
              fin: DateTime.parse(franja.finIso),
              disponible: franja.disponible,
            ),
          )
          .toList(),
    );
  }

  List<DisponibilidadDia> obtenerSieteDias(String espacioId, DateTime desde) {
    final inicio = DateTime(desde.year, desde.month, desde.day);
    final fin = inicio.add(const Duration(days: 7));
    final dias =
        _disponibilidad
            .where(
              (dia) =>
                  dia.espacioId == espacioId &&
                  !dia.fecha.isBefore(inicio) &&
                  dia.fecha.isBefore(fin),
            )
            .toList()
          ..sort((a, b) => a.fecha.compareTo(b.fecha));
    return List.unmodifiable(dias);
  }
}
