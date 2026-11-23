import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:flutter/material.dart';

class EspaciosViewModel extends ChangeNotifier {
  final EspaciosRepository _repository;

  EspaciosViewModel({EspaciosRepository? repository})
    : _repository =
          repository ??
          EspaciosRepository(
            service: DatosSimuladosService(
              espacios: espaciosDemo,
              reservas: reservasDemo,
              usuarios: usuariosDemo,
              comentarios: comentariosDemo,
              disponibilidad: disponibilidadDemo,
            ),
          ) {
    cargarEspacios();
  }

  List<Espacio> _espacios = const [];
  bool _cargando = false;
  String? _error;

  List<Espacio> get espacios => _espacios;
  bool get cargando => _cargando;
  String? get error => _error;

  void cargarEspacios() {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _espacios = _repository.obtenerTodos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
