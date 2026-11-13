import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/view_models/home_viewmodel.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/view_models/registro_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

DatosSimuladosService _crearServicioDemo() => DatosSimuladosService(
  espacios: espaciosDemo,
  reservas: reservasDemo,
  usuarios: usuariosDemo,
  comentarios: comentariosDemo,
  disponibilidad: disponibilidadDemo,
);

void main() {
  group('RegistroViewmodel', () {
    late RegistroViewmodel viewModel;

    setUp(() {
      viewModel = RegistroViewmodel(
        usuariosRepository: UsuariosRepository(service: _crearServicioDemo()),
      );
    });

    tearDown(() => viewModel.dispose());

    test('rechaza el registro si no se aceptan los términos', () {
      final usuario = viewModel.registrar(
        nombre: 'Dana Soler',
        correo: 'dana@example.com',
        contrasena: 'clave-segura',
        confirmarContrasena: 'clave-segura',
      );

      expect(usuario, isNull);
      expect(viewModel.error, contains('términos'));
    });

    test('crea una sesión demo y normaliza los datos', () {
      viewModel.cambiarAceptacionTerminos(true);

      final usuario = viewModel.registrar(
        nombre: '  Dana Soler ',
        correo: ' DANA@Example.com ',
        contrasena: 'clave-segura',
        confirmarContrasena: 'clave-segura',
      );

      expect(usuario, isNotNull);
      expect(usuario!.nombre, 'Dana Soler');
      expect(usuario.correo, 'dana@example.com');
      expect(usuario.id, startsWith('registro-demo-'));
      expect(viewModel.error, isNull);
    });

    test('rechaza un correo ya usado aunque cambie mayúsculas', () {
      viewModel.cambiarAceptacionTerminos(true);

      final usuario = viewModel.registrar(
        nombre: 'Alex Lopez',
        correo: 'ALEX@EXAMPLE.COM',
        contrasena: 'clave-segura',
        confirmarContrasena: 'clave-segura',
      );

      expect(usuario, isNull);
      expect(viewModel.error, contains('Ya existe'));
    });
  });

  group('HomeViewmodel', () {
    late HomeViewmodel viewModel;

    setUp(() {
      final service = _crearServicioDemo();
      viewModel = HomeViewmodel(
        espaciosRepository: EspaciosRepository(service: service),
      );
    });

    tearDown(() => viewModel.dispose());

    test('filtra los espacios por categoría y búsqueda', () {
      viewModel.seleccionarCategoria(CategoriaEspacio.celebraciones);
      expect(
        viewModel.espaciosFiltrados.map((espacio) => espacio.nombre),
        containsAll(['Patio Llum', 'Salon Nexo', 'Jardin Brisa']),
      );

      viewModel.actualizarBusqueda('jardin');
      expect(viewModel.espaciosFiltrados.map((espacio) => espacio.nombre), [
        'Jardin Brisa',
      ]);
    });

    test('muestra la lista vacía cuando no hay coincidencias', () {
      viewModel.actualizarBusqueda('espacio inexistente');

      expect(viewModel.espaciosFiltrados, isEmpty);
    });
  });
}
