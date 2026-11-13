import 'package:flutter/foundation.dart';

import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/usuario.dart';

class RegistroViewmodel extends ChangeNotifier {
  RegistroViewmodel({required this.usuariosRepository});

  final UsuariosRepository usuariosRepository;

  bool _ocultarContrasena = true;
  bool _aceptaTerminos = false;
  String? _error;

  bool get ocultarContrasena => _ocultarContrasena;
  bool get aceptaTerminos => _aceptaTerminos;
  String? get error => _error;

  String? validarNombre(String? valor) {
    final nombre = (valor ?? '').trim();
    if (nombre.isEmpty) {
      return 'El nombre es obligatorio.';
    }
    if (nombre.length < 2) {
      return 'Introduce al menos dos caracteres.';
    }
    return null;
  }

  String? validarCorreo(String? valor) {
    final correo = (valor ?? '').trim();
    if (correo.isEmpty) {
      return 'El correo es obligatorio.';
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(correo)) {
      return 'Introduce un correo con formato nombre@dominio.ext.';
    }
    return null;
  }

  String? validarContrasena(String? valor) {
    if ((valor ?? '').length < 8) {
      return 'Usa al menos 8 caracteres.';
    }
    return null;
  }

  String? validarConfirmacion(String? valor, String contrasena) {
    if (valor == null || valor.isEmpty) {
      return 'Confirma la contraseña.';
    }
    if (valor != contrasena) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }

  void alternarVisibilidadContrasena() {
    _ocultarContrasena = !_ocultarContrasena;
    notifyListeners();
  }

  void cambiarAceptacionTerminos(bool? aceptados) {
    _aceptaTerminos = aceptados ?? false;
    _limpiarError();
    notifyListeners();
  }

  void limpiarError() {
    if (_error == null) {
      return;
    }
    _error = null;
    notifyListeners();
  }

  Usuario? registrar({
    required String nombre,
    required String correo,
    required String contrasena,
    required String confirmarContrasena,
  }) {
    _error =
        validarNombre(nombre) ??
        validarCorreo(correo) ??
        validarContrasena(contrasena) ??
        validarConfirmacion(confirmarContrasena, contrasena);
    if (_error != null) {
      notifyListeners();
      return null;
    }

    if (!_aceptaTerminos) {
      _error = 'Acepta los términos y condiciones para continuar.';
      notifyListeners();
      return null;
    }

    final correoNormalizado = correo.trim().toLowerCase();
    final correoExiste = usuariosRepository.obtenerTodos().any(
      (usuario) => usuario.correo.trim().toLowerCase() == correoNormalizado,
    );
    if (correoExiste) {
      _error = 'Ya existe una cuenta con ese correo.';
      notifyListeners();
      return null;
    }

    _error = null;
    final usuario = Usuario(
      id: 'registro-demo-${DateTime.now().microsecondsSinceEpoch}',
      nombre: nombre.trim(),
      correo: correoNormalizado,
    );
    notifyListeners();
    return usuario;
  }

  void _limpiarError() {
    if (_error == null) {
      return;
    }
    _error = null;
  }
}
