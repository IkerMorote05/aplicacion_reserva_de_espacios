import 'package:flutter/material.dart';

class BotonSeleccion extends StatelessWidget {
  const BotonSeleccion({
    super.key,
    required this.seleccionado,
    required this.onPressed,
    required this.child,
    this.ancho,
  });

  final bool seleccionado;
  final VoidCallback onPressed;
  final Widget child;
  final double? ancho;

  static const colorSeleccionado = Color(0xFF6847C7);
  static const colorNoSeleccionado = Color(0xFFF6F5F8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: seleccionado
              ? colorSeleccionado
              : colorNoSeleccionado,
          foregroundColor: seleccionado ? Colors.white : Colors.black87,
          side: BorderSide(
            color: seleccionado ? colorSeleccionado : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: child,
      ),
    );
  }
}
