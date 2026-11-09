import 'package:aplicacion_reserva_espacios/data/repositories/usuarios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/ui/homePantalla.dart';
import 'package:flutter/material.dart';

bool _ocultarTexto = true;
bool _terminos = false;

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _fromKey = GlobalKey<FormState>();
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
  void _limpiarError() {
    if (_error != null) {
      setState(() => _error = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pantalla de registro")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Form(
              key: _fromKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "Crea tu cuenta",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontFamily: "TimesNewRowan",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Tu próximo encuentro empieza aqui, Reúnete, crea y celebra",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre completo",
                      hintText: "Esteban Gutierrez",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: false,
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return "El nombre es obligatorio";
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
                      labelText: "Correo electrónico",
                      hintText: "esteban@gutierrez.com",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: false,
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
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
                  SizedBox(height: 10),
                  TextField(
                    obscureText: _ocultarTexto,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarTexto
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarTexto = !_ocultarTexto;
                          });
                        },
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: false,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: _ocultarTexto,
                    decoration: InputDecoration(
                      labelText: "Confirmar contraseña",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarTexto
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarTexto = !_ocultarTexto;
                          });
                        },
                      ),
                      helperText: "Usa almenos 8 caracteres.",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: false,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: Text(
                      'Aceptar términos y condiciones',
                      style: TextStyle(fontSize: 12),
                    ),

                    value: _terminos,
                    onChanged: (bool? value) {
                      setState(() {
                        _terminos = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, // checkbox a la izquierda
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => Homepantalla(),
                          ),
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                      ),
                      child: Text("Crear cuenta · Demo"),
                    ),
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
