import 'package:flutter/foundation.dart';

import '../../../domain/models/usuario.dart';
import '../../../data/repositories/usuarios_repository.dart';

class LoginViewmodel extends ChangeNotifier {
  LoginViewmodel({required UsuariosRepository service})
    : service = service,
      usuarios = List.unmodifiable(service.obtenerTodos());
  final UsuariosRepository service;
  final List<Usuario> usuarios;

  String _nombre = '';
  String _correo = '';
  String? _error;
  String get nombre => _nombre;
  String get correo => _correo;
  String? get error => _error;

  String? validarNombre(String? valor) => (valor ?? '').trim().length < 2
      ? 'Introduce al menos dos caracteres'
      : null;
  String? validarCorreo(String? valor) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch((valor ?? '').trim())
      ? null
      : 'Introduce un correo con formato nombre@dominio.ext';

  Usuario? login() {
    if (validarNombre(_nombre) != null || validarCorreo(_correo) != null) {
      _error = "Revisa el nombre o el correo";
      notifyListeners();
      return null;
    }
    final usuario = service.obtenerUsuario(_nombre, _correo);
    if (usuario == null) {
      _error = 'No hay un usuario de ejemplo con ese nombre y correo';
      notifyListeners();
      return null;
    }
  }
}
