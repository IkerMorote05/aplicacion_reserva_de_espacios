import 'package:aplicacion_reserva_espacios/data/models/contacto_local_dto.dart';
import 'package:aplicacion_reserva_espacios/data/models/espacio_dto.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/contacto_local.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';

class EspaciosRepository {
  EspaciosRepository({required DatosSimuladosService service}) {
    final datos = service.leerEspacios();
    final ids = datos.map((espacio) => espacio.id).toSet();
    if (ids.length != datos.length) {
      throw StateError("No puede haber ids repetidos");
    }
    _espacios = List<Espacio>.unmodifiable(datos.map(_aDominio));
  }
  late final List<Espacio> _espacios;
  List<Espacio> obtenerTodos() => _espacios;

  static Espacio _aDominio(EspacioDto dto) {
    return Espacio(
      id: dto.id,
      nombre: dto.nombre,
      descripcion: dto.descripcion,
      ubicacion: dto.ubicacion,
      horario: dto.horario,
      condicionesUso: dto.condicionesUso,
      aforo: dto.aforo,
      imagenAsset: dto.imagenAsset,
      actividades: dto.actividades,
      equipamiento: dto.equipamiento,
      precioHoraCentimos: dto.precioHoraCentimos,
      moneda: dto.moneda,
      contacto: _convertirContacto(dto.contacto),
      imagenesAssets: [],
      serviciosDisponibles: [],
    );
  }

  Espacio? obtenerPorId(String id) {
    List<Espacio> espacios = _espacios;
    for (int i = 0; i < espacios.length; i++) {
      Espacio act = espacios[i];
      if (act.id == id) {
        return act;
      }
    }
    return null;
  }

  static ContactoLocal _convertirContacto(ContactoLocalDto dto) {
    return ContactoLocal(
      id: dto.id,
      nombre: dto.nombre,
      telefono: dto.telefono,
      correo: dto.correo,
    );
  }
}
