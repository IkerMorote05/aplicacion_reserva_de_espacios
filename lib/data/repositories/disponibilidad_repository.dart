import 'package:aplicacion_reserva_espacios/data/models/disponibilidad_dia_dto.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/disponibilidad_dia.dart';
import 'package:aplicacion_reserva_espacios/domain/models/franja_disponibilidad.dart';

class DisponibilidadRepository {
  DisponibilidadRepository({required DatosSimuladosService service}) {
    final datos = service.leerDisponibilidad();
    final ids = datos.map((act) => act.espacioId).toSet();
    if (ids.length != datos.length) {
      throw StateError("No puede haber ids repetidos");
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
            ),
          )
          .toList(),
    );
  }

  List<DisponibilidadDia> obtenerSieteDias(String espacioId, DateTime desde) {
    List<DisponibilidadDia> lista = List.empty();
    DateTime fechaMax = desde;
    for (int i = 0; i < _disponibilidad.length; i++) {
      if (_disponibilidad[i].fecha.day == desde &&
          _disponibilidad[i].espacioId == espacioId) {
        lista.add(_disponibilidad[i]);
        fechaMax.add(const Duration(days: 1));
      }

      if (desde.difference(fechaMax).inDays <= 7 &&
          _disponibilidad[i].fecha.day == fechaMax &&
          _disponibilidad[i].espacioId == espacioId) {
        lista.add(_disponibilidad[i]);
        fechaMax.add(const Duration(days: 1));
      }
    }
    return lista;
  }
}
