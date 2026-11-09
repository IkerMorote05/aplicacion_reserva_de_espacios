import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';

class EspaciosRepository {
  EspaciosRepository({required DatosSimuladosService service}) {
    final datos = service.leerEspacios();
  }
}
