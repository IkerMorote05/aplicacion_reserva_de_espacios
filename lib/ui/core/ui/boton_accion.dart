import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:flutter/material.dart';

class BotonAccion extends StatelessWidget {
  const BotonAccion({
    super.key,
    required this.icono,
    required this.habilitado,
    required this.texto,
    required this.onPressed,
  });
  final Icon icono;
  final bool habilitado;
  final String texto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 14),
        child: SizedBox(
          width: 150,
          height: 40,
          child: FilledButton.icon(
            onPressed: habilitado ? onPressed : null,
            icon: icono,
            style: FilledButton.styleFrom(
              backgroundColor: TemaApp.tinta,
              disabledBackgroundColor: TemaApp.textoSecundario,
              foregroundColor: TemaApp.superficie,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            label: Text(texto),
          ),
        ),
      ),
    );
  }
}
