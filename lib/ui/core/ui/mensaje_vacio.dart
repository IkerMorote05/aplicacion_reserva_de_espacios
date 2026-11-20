import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:flutter/material.dart';

class MensajeVacio extends StatelessWidget {
  const MensajeVacio({super.key, required this.icono, required this.mensaje});

  final IconData icono;
  final String mensaje;

  static const _fondoSuave = TemaApp.superficieAtenuada;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _fondoSuave,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icono, color: TemaApp.textoSecundario, size: 30),
          const SizedBox(height: 8),
          Text(mensaje, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
