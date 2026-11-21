import 'package:flutter/material.dart';

// import 'tema_app.dart'; // Ajusta el import a la ruta real de tu archivo

/// Botón principal reutilizable con borde tallado y resplandor cálido (estilo brasa/ámbar)[cite: 5, 6]
class BotonRunicoPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final Color colorBrillo;
  final Color colorBorde;

  const BotonRunicoPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.colorBrillo = const Color(
      0xfff59e0b,
    ), // Ajustado al tono ámbar de TemaApp[cite: 5]
    this.colorBorde = const Color(0xffffb74d),
  });

  @override
  Widget build(BuildContext context) {
    final bool habilitado = onPressed != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: habilitado
            ? [
                BoxShadow(
                  color: colorBrillo.withValues(alpha: 0.35),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: colorBrillo.withValues(alpha: 0.16),
                  blurRadius: 28,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: habilitado
                ? colorBorde.withValues(alpha: 0.85)
                : const Color(
                    0xff3a4350,
                  ), // Coincide con el borde base del tema[cite: 5]
            width: 1.4,
          ),
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            shape: const StadiumBorder(),
            backgroundColor: habilitado
                ? const Color(
                    0xfff59e0b,
                  ) // Mismo tono cálido que el botón destacado[cite: 5, 6]
                : const Color(0xff252c35),
            foregroundColor: habilitado
                ? const Color(0xff141008)
                : const Color(0xff9aa5b4),
          ),
          child: icono == null
              ? Text(texto)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icono, size: 20),
                    const SizedBox(width: 8),
                    Text(texto),
                  ],
                ),
        ),
      ),
    );
  }
}
