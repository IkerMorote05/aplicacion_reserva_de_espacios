import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:flutter/material.dart';

class BotonAccionInferior extends StatelessWidget {
  const BotonAccionInferior({
    super.key,
    required this.habilitado,
    required this.texto,
    required this.onPressed,
  });

  final bool habilitado;
  final String texto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: habilitado ? onPressed : null,
            style: FilledButton.styleFrom(
              backgroundColor: TemaApp.tinta,
              disabledBackgroundColor: TemaApp.textoSecundario,
              foregroundColor: TemaApp.superficie,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(texto),
          ),
        ),
      ),
    );
  }
}
