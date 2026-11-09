import 'package:aplicacion_reserva_espacios/data/models/reserva_dto.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/reserva.dart';
import 'package:aplicacion_reserva_espacios/domain/models/servicio_contratado.dart';

class ReservasRepository {
  ReservasRepository({
    required DatosSimuladosService service,
    required UsuariosRepository ur,
    required EspaciosRepository er,
  }) {
    final datos = service.leerReservas();
    final ids = datos.map((reserva) => reserva.id).toSet();

    if (ids.length != datos.length) {
      throw StateError("No puede haber más reservas que ids");
    }
    _reservas = List<Reserva>.unmodifiable(
      datos.map((reserva) => _aDominio(reserva, ur, er)),
    );
  }

  late final List<Reserva> _reservas;
  List<Reserva> obtenerTodos() => _reservas;

  static Reserva _aDominio(
    ReservaDto dto,
    UsuariosRepository ur,
    EspaciosRepository er,
  ) {
    return Reserva(
      id: dto.id,
      espacio: er.obtenerPorId(dto.espacioId),
      usuario: ur.obtenerPorId(dto.usuarioId),
      actividad: dto.actividad,
      inicio: DateTime.parse(dto.inicioIso),
      fin: DateTime.parse(dto.finIso),
      estado: obtenerEstado(dto.codigoEstado),
      asistentes: dto.asistentes,
      serviciosContratados: dto.serviciosContratados
          .map(
            (servicio) => ServicioContratado(
              nombre: servicio.nombre,
              servicioId: servicio.servicioId,
              precioCentimos: servicio.precioCentimos,
            ),
          )
          .toList(),
      tarifaHoraCentimos: dto.tarifaHoraCentimos,
      precioTotalCentimos: dto.precioTotalCentimos,
      moneda: dto.moneda,
    );
  }

  static EstadoReserva obtenerEstado(CodigoEstado c) {
    if (c == 'CONF') {
      return EstadoReserva.confirmada;
    }
    if (c == 'PEND') {
      return EstadoReserva.pendiente;
    }
    return EstadoReserva.cancelada;
  }

  List<Reserva> obtenerPorUsuario(String id) {
    List<Reserva> reservas = List.empty();
    for (int i = 0; i < _reservas.length; i++) {
      if (_reservas[i].usuario?.id == id) {
        reservas.add(_reservas[i]);
      }
    }
    return reservas;
  }

  Reserva? obtenerPorId(String id) {
    for (int i = 0; i < _reservas.length; i++) {
      if (_reservas[i].id == id) {
        return _reservas[i];
      }
    }
    return null;
  }
}
