import 'package:flutter/material.dart';

import 'boton_seleccion.dart';

class BotonDia extends StatelessWidget {
  const BotonDia({
    super.key,
    required this.etiqueta,
    required this.seleccionado,
    required this.disponible,
    required this.onPressed,
    this.ancho = 62,
  });

  final String etiqueta;
  final bool seleccionado;
  final bool disponible;
  final VoidCallback onPressed;
  final double ancho;

  @override
  Widget build(BuildContext context) {
    return BotonSeleccion(
      ancho: ancho,
      seleccionado: seleccionado,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Icon(
            disponible ? Icons.circle : Icons.circle_outlined,
            size: 7,
            color: seleccionado
                ? Colors.white
                : BotonSeleccion.colorSeleccionado,
          ),
        ],
      ),
    );
  }
}
