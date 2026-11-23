import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/espacios_repository.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/usuario.dart';

enum CategoriaEspacio { reuniones, talleres, celebraciones }

class HomeViewModel extends ChangeNotifier {
  final EspaciosRepository _repository;
  final Usuario? usuario;
  HomeViewModel({EspaciosRepository? repository, this.usuario})
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
    cargar();
  }
  static const List<String> categorias = [
    'Reuniones',
    'Talleres',
    'Celebraciones',
  ];

  List<Espacio> _todos = const [];
  String _consulta = '';
  String _categoriaSeleccionada = 'Reuniones';

  String get consulta => _consulta;
  String get categoriaSeleccionada => _categoriaSeleccionada;

  void cargar() {
    _todos = _repository.obtenerTodos();
    notifyListeners();
  }

  void actualizarConsulta(String valor) {
    if (_consulta == valor) return;
    _consulta = valor;
    notifyListeners();
  }

  void seleccionarCategoria(String categoria) {
    if (_categoriaSeleccionada == categoria) return;
    _categoriaSeleccionada = categoria;
    notifyListeners();
  }

  List<Espacio> get espaciosFiltrados {
    final q = _consulta.trim().toLowerCase();
    final cat = _categoriaSeleccionada.toLowerCase();
    final catSingular = cat.endsWith('s')
        ? cat.substring(0, cat.length - 1)
        : cat;

    return _todos.where((espacio) {
      final coincideTexto =
          q.isEmpty ||
          espacio.nombre.toLowerCase().contains(q) ||
          espacio.ubicacion.toLowerCase().contains(q);

      if (!coincideTexto) return false;

      // Si el modelo o descripción/ubicación menciona la categoría, filtramos;
      // si no hay campo de categorías explícito, mantenemos los espacios disponibles.
      final textoEspacio = '${espacio.nombre} ${espacio.ubicacion}'
          .toLowerCase();
      if (textoEspacio.contains(cat) || textoEspacio.contains(catSingular)) {
        return true;
      }
      return true;
    }).toList();
  }
}
