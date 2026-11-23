import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/ui/homePantalla.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_decorado_runico.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/campo_input_runico.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/titulo_login_runico.dart';
import 'package:flutter/material.dart';

import '../view_models/registro_viewmodel.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarContrasenaController = TextEditingController();

  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _viewModel = RegistroViewmodel(
    usuariosRepository: UsuariosRepository(service: _service),
  );

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarContrasenaController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _registrar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = _viewModel.registrar(
      nombre: _nombreController.text,
      correo: _correoController.text,
      contrasena: _contrasenaController.text,
      confirmarContrasena: _confirmarContrasenaController.text,
    );
    if (usuario == null) {
      return;
    }

    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(builder: (_) => Homepantalla(usuario: usuario)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text("Pantalla de registro")),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TituloLoginRunico(
                      titulo: "Crea tu cuenta",
                      subtitulo: "Tu próximo encuentro empieza aqui. Reúnete, crea y celebra",
                    ),
                    SizedBox(height: 10),
                    CampoInputRunico(
                      controlador: _nombreController,
                      etiqueta: "Nombre completo",
                      pista: "Esteban Gutierrez",
                      icono: Icons.person,
                      validador: _viewModel.validarNombre,
                      onChanged: (_) => _viewModel.limpiarError(),
                      teclado: TextInputType.name,
                    ),
                    // TextFormField(
                    //   controller: _nombreController,
                    //   decoration: const InputDecoration(
                    //     labelText: "Nombre completo",
                    //     hintText: "Esteban Gutierrez",
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     filled: false,
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   textCapitalization: TextCapitalization.words,
                    //   validator: _viewModel.validarNombre,
                    //   onChanged: (_) => _viewModel.limpiarError(),
                    // ),
                    const SizedBox(height: 16),
                    CampoInputRunico(
                      controlador: _correoController,
                      etiqueta: "Correo electrónico",
                      pista: "esteban@gutierrez.com",
                      icono: Icons.mail,
                      validador: _viewModel.validarCorreo,
                      onChanged: (_) => _viewModel.limpiarError(),
                      teclado: TextInputType.emailAddress,
                    ),
                    if (_viewModel.error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _viewModel.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    // TextFormField(
                    //   controller: _correoController,
                    //   decoration: const InputDecoration(
                    //     labelText: "Correo electrónico",
                    //     hintText: "esteban@gutierrez.com",
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     filled: false,
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   keyboardType: TextInputType.emailAddress,
                    //   validator: _viewModel.validarCorreo,
                    //   onChanged: (_) => _viewModel.limpiarError(),
                    // ),
                    // if (_viewModel.error != null) ...[
                    //   const SizedBox(height: 16),
                    //   Text(
                    //     _viewModel.error!,
                    //     style: TextStyle(
                    //       color: Theme.of(context).colorScheme.error,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ],
                    SizedBox(height: 10),
                    CampoInputRunico(
                      controlador: _contrasenaController,
                      etiqueta: "Contraseña",
                      pista: "",
                      icono: Icons.password,
                      validador: _viewModel.validarContrasena,
                      onChanged: (_) => _viewModel.limpiarError(),
                      obscureText: _viewModel.ocultarContrasena,
                      sufijo: IconButton(
                        icon: Icon(
                          _viewModel.ocultarContrasena
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        tooltip: 'Mostrar u ocultar contraseña',
                        onPressed: _viewModel.alternarVisibilidadContrasena,
                      ),
                    ),
                    // TextFormField(
                    //   controller: _contrasenaController,
                    //   obscureText: _viewModel.ocultarContrasena,
                    //   decoration: InputDecoration(
                    //     labelText: "Contraseña",
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         _viewModel.ocultarContrasena
                    //             ? Icons.visibility_off
                    //             : Icons.visibility,
                    //       ),
                    //       tooltip: 'Mostrar u ocultar contraseña',
                    //       onPressed: _viewModel.alternarVisibilidadContrasena,
                    //     ),
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     filled: false,
                    //     border: const OutlineInputBorder(),
                    //   ),
                    //   validator: _viewModel.validarContrasena,
                    //   onChanged: (_) => _viewModel.limpiarError(),
                    // ),
                    SizedBox(height: 10),
                    CampoInputRunico(
                      controlador: _confirmarContrasenaController,
                      etiqueta: "Confirmar contraseña",
                      pista: "",
                      icono: Icons.password,
                      validador: (valor) => _viewModel.validarConfirmacion(
                        valor,
                        _contrasenaController.text,
                      ),

                      onChanged: (_) => _viewModel.limpiarError(),
                      obscureText: _viewModel.ocultarContrasena,
                      sufijo: IconButton(
                        icon: Icon(
                          _viewModel.ocultarContrasena
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        tooltip: 'Mostrar u ocultar contraseña',
                        onPressed: _viewModel.alternarVisibilidadContrasena,
                      ),
                    ),
                    // TextFormField(
                    //   controller: _confirmarContrasenaController,
                    //   obscureText: _viewModel.ocultarContrasena,
                    //   decoration: InputDecoration(
                    //     labelText: "Confirmar contraseña",
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         _viewModel.ocultarContrasena
                    //             ? Icons.visibility_off
                    //             : Icons.visibility,
                    //       ),
                    //       tooltip: 'Mostrar u ocultar contraseña',
                    //       onPressed: _viewModel.alternarVisibilidadContrasena,
                    //     ),
                    //     helperText: "Usa al menos 8 caracteres.",
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     filled: false,
                    //     border: const OutlineInputBorder(),
                    //   ),
                    //   validator: (valor) => _viewModel.validarConfirmacion(
                    //     valor,
                    //     _contrasenaController.text,
                    //   ),
                    //   onChanged: (_) => _viewModel.limpiarError(),
                    // ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(
                        'Aceptar términos y condiciones',
                        style: TextStyle(fontSize: 12),
                      ),

                      value: _viewModel.aceptaTerminos,
                      onChanged: _viewModel.cambiarAceptacionTerminos,
                      controlAffinity: ListTileControlAffinity
                          .leading, // checkbox a la izquierda
                    ),
                    const SizedBox(height: 24),
                    BotonDecoradoRunico(
                      texto: "Crear cuenta · Demo",
                      onPressed: _registrar,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
