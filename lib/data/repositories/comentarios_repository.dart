import 'package:aplicacion_reserva_espacios/data/models/comentario_dto.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/comentario.dart';

class ComentariosRepository {
  ComentariosRepository({
    required DatosSimuladosService service,
    required UsuariosRepository usuariosRepository,
  }) {
    final datos = service.leerComentarios();
    final ids = datos.map((act) => act.id).toSet();
    if (ids.length != datos.length) {
      throw StateError("No puede haber ids repetidos");
    }

    _comentarios = List.unmodifiable(
      datos.map((dto) => _aDominio(dto, usuariosRepository)),
    );
  }
  late final List<Comentario> _comentarios;
  List<Comentario> obtenerTodos() => _comentarios;

  static Comentario _aDominio(ComentarioDto dto, UsuariosRepository ur) {
    return Comentario(
      id: dto.id,
      espacioId: dto.espacioId,
      autor: ur.obtenerPorId(dto.autorId),
      puntuacion: dto.puntuacion,
      texto: dto.texto,
      fecha: DateTime.parse(dto.fechaIso),
    );
  }

  List<Comentario> obtenerPorEspacio(String espacioid) {
    return List.unmodifiable(
      _comentarios.map((act) => act.espacioId == espacioid),
    );
  }

  double? obtenerMedia(String espacioId) {
    final comentarios = obtenerPorEspacio(espacioId);
    if (comentarios.isEmpty) return null;
    final suma = comentarios.fold<int>(0, (total, c) => total + c.puntuacion);
    return suma / comentarios.length;
  }
}
