import 'package:flutter/material.dart';

class BotonFranja extends StatelessWidget {
  const BotonFranja({
    super.key,
    required this.ancho,
    required this.etiqueta,
    required this.seleccionada,
    required this.disponible,
    required this.onPressed,
  });

  final double ancho;
  final String etiqueta;
  final bool seleccionada;
  final bool disponible;
  final VoidCallback onPressed;

  static const _morado = Color(0xFF6847C7);
  static const _fondoSuave = Color(0xFFF6F5F8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      child: OutlinedButton(
        onPressed: disponible ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: seleccionada
              ? _morado
              : disponible
              ? _fondoSuave
              : const Color(0xFFF1F0F2),
          foregroundColor: seleccionada ? Colors.white : Colors.black87,
          disabledForegroundColor: Colors.black38,
          side: BorderSide(color: seleccionada ? _morado : Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (!disponible) ...[
              const SizedBox(height: 3),
              const Text('Ocupada', style: TextStyle(fontSize: 11)),
            ],
          ],
        ),
      ),
    );
  }
}
