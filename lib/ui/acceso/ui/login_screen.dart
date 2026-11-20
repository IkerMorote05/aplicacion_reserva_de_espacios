import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/ui/homePantalla.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/ui/registro_screen.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_accion.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_accion_inferior.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  String? _error;

  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _usuarios = UsuariosRepository(service: _service);

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = _usuarios.obtenerUsuario(
      _nombreController.text,
      _correoController.text.trim(),
    );

    setState(() {
      _error = usuario == null
          ? 'El nombre y el correo no coinciden con ningún usuario de prueba.'
          : null;
    });

    if (usuario != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inicio de sesión correcto. Hola, ${usuario.nombre}.'),
        ),
      );
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (context) => Homepantalla(usuario: usuario),
        ),
      );
    }
  }

  void _limpiarError() {
    if (_error != null) {
      setState(() => _error = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inicio de sesión',
          style: TextStyle(fontWeight: FontWeight.bold, color: TemaApp.tinta),
          textAlign: TextAlign.center,
        ),
        backgroundColor: TemaApp.fondo,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight = constraints.maxHeight < 600
                ? 120.0
                : constraints.maxHeight < 720
                ? 160.0
                : 220.0;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/loginImagen.webp',
                      width: 200,
                      height: imageHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Tu espacio. \nTu momento.",
                    style: TextStyle(
                      color: TemaApp.tinta,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Encuentra tu lugar para disfrutar",
                    style: TextStyle(
                      fontSize: 16,
                      color: TemaApp.textoSecundario,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.person_outline),
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'El nombre es obligatorio.';
                      }
                      if (valor.trim().length < 2) {
                        return 'Introduce al menos dos caracteres.';
                      }
                      return null;
                    },
                    onChanged: (_) => _limpiarError(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (valor) {
                      final correo = (valor ?? '').trim();
                      if (correo.isEmpty) {
                        return 'El correo es obligatorio.';
                      }
                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                          .hasMatch(correo)) {
                        return 'Introduce un correo con formato nombre@dominio.ext.';
                      }
                      return null;
                    },
                    onChanged: (_) => _limpiarError(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,

                    child: BotonAccionInferior(
                      habilitado: true,
                      texto: "Iniciar Sesión",
                      onPressed: _iniciarSesion,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BotonAccion(
                        icono: Icon(Icons.person_add),
                        habilitado: true,
                        texto: "Crear cuenta",
                        onPressed: () {
                          Navigator.of(context).pushReplacement<void, void>(
                            MaterialPageRoute<void>(
                              builder: (context) => RegistroScreen(),
                            ),
                          );
                        },
                      ),
                      BotonAccion(
                        icono: Icon(Icons.person_outline),
                        habilitado: true,
                        texto: "Inicio sin cuenta",
                        onPressed: () {
                          Navigator.of(context).pushReplacement<void, void>(
                            MaterialPageRoute<void>(
                              builder: (context) => Homepantalla(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
