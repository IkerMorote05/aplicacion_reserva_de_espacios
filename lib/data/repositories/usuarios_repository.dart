import 'package:aplicacion_reserva_espacios/data/models/usuario_dto.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/usuario.dart';

class UsuariosRepository {
  UsuariosRepository({required DatosSimuladosService service}) {
    final datos = service.leerUsuarios();
    final ids = datos.map((usuario) => usuario.id).toSet();
    if (ids.length != datos.length) {
      throw StateError("No puede haber ids repetidos");
    }

    _usuarios = List<Usuario>.unmodifiable(datos.map(_aDominio));
  }

  late final List<Usuario> _usuarios;
  List<Usuario> obtenerTodos() => _usuarios;

  static Usuario _aDominio(UsuarioDto dto) {
    return Usuario(nombre: dto.nombre, correo: dto.correo, id: dto.id);
  }

  Usuario? obtenerPorId(String id) {
    List<Usuario> usuarios = _usuarios;
    for (int i = 0; i < usuarios.length; i++) {
      Usuario act = usuarios[i];
      if (act.id == id) {
        return act;
      }
    }
    return null;
  }

  Usuario? obtenerUsuario(String nombre, String correo) {
    List<Usuario> usuarios = _usuarios;
    for (int i = 0; i < usuarios.length; i++) {
      Usuario act = usuarios[i];
      if (act.nombre == nombre && act.correo == correo) {
        return act;
      }
    }
    return null;
  }
}
