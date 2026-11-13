import 'package:flutter/material.dart';

class ClaveDisponibilidad extends StatelessWidget {
  const ClaveDisponibilidad({
    super.key,
    required this.color,
    required this.etiqueta,
    this.borde,
  });

  final Color color;
  final String etiqueta;
  final Color? borde;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: borde == null ? null : Border.all(color: borde!),
          ),
        ),
        const SizedBox(width: 5),
        Text(etiqueta, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
