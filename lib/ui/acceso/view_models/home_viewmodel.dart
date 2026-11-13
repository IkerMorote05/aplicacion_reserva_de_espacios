import 'package:flutter/foundation.dart';

import '../../../data/repositories/espacios_repository.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/usuario.dart';

enum CategoriaEspacio { reuniones, talleres, celebraciones }

class HomeViewmodel extends ChangeNotifier {
  HomeViewmodel({required EspaciosRepository espaciosRepository, this.usuario})
    : _espacios = List.unmodifiable(espaciosRepository.obtenerTodos());

  final List<Espacio> _espacios;
  final Usuario? usuario;

  CategoriaEspacio _categoriaSeleccionada = CategoriaEspacio.reuniones;
  String _busqueda = '';

  CategoriaEspacio get categoriaSeleccionada => _categoriaSeleccionada;
  String get busqueda => _busqueda;
  String get mensajeBienvenida => usuario == null
      ? 'Tu próximo espacio, más cerca.'
      : 'Hola, ${usuario!.nombre}.';

  List<Espacio> get espaciosFiltrados {
    final actividad = switch (_categoriaSeleccionada) {
      CategoriaEspacio.reuniones => 'reunion',
      CategoriaEspacio.talleres => 'taller',
      CategoriaEspacio.celebraciones => 'celebracion',
    };
    final consulta = _busqueda.trim().toLowerCase();

    return List.unmodifiable(
      _espacios.where((espacio) {
        final coincideCategoria = espacio.actividades.any(
          (valor) => valor.toLowerCase() == actividad,
        );
        if (!coincideCategoria) {
          return false;
        }
        if (consulta.isEmpty) {
          return true;
        }
        return [
          espacio.nombre,
          espacio.descripcion,
          espacio.ubicacion,
          ...espacio.actividades,
        ].any((valor) => valor.toLowerCase().contains(consulta));
      }),
    );
  }

  void seleccionarCategoria(CategoriaEspacio categoria) {
    if (_categoriaSeleccionada == categoria) {
      return;
    }
    _categoriaSeleccionada = categoria;
    notifyListeners();
  }

  void actualizarBusqueda(String consulta) {
    if (_busqueda == consulta) {
      return;
    }
    _busqueda = consulta;
    notifyListeners();
  }
}
