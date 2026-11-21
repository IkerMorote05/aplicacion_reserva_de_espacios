import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:flutter/material.dart';

// import 'tema_app.dart'; // Ajusta el import según la ruta de tu proyecto

class TituloLoginRunico extends StatelessWidget {
  final String titulo;
  final String? subtitulo;

  const TituloLoginRunico({super.key, required this.titulo, this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _OrnamentoRunicoLateral(izquierda: true),
            const SizedBox(width: 10),
            Flexible(
              child: Stack(
                children: [
                  // Capa 1: Contorno oscuro tallado en piedra[cite: 4, 6]
                  Text(
                    titulo.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: TemaApp.fuente,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.0,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3.2
                        ..color = const Color(0xff0b0e12),
                      shadows: const [
                        Shadow(color: Color(0x995bc0eb), blurRadius: 16),
                      ],
                    ),
                  ),
                  // Capa 2: Relleno metálico con brillo frío[cite: 4, 6]
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xfff1f5f9), // Filo superior iluminado
                        Color(0xff94a3b8), // Cuerpo metálico/piedra
                        Color(
                          0xff5bc0eb,
                        ), // Reflejo rúnico inferior[cite: 4, 6]
                      ],
                      stops: [0.0, 0.62, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      titulo.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: TemaApp.fuente,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const _OrnamentoRunicoLateral(izquierda: false),
          ],
        ),
        if (subtitulo != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitulo!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TemaApp.textoSecundario,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

class _OrnamentoRunicoLateral extends StatelessWidget {
  final bool izquierda;
  const _OrnamentoRunicoLateral({required this.izquierda});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: TemaApp.superficie,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TemaApp.borde, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: TemaApp.azul.withValues(alpha: 0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        izquierda ? 'ᚠ\nᚻ\nᚲ' : 'ᚱ\nᚴ\nᚱ',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          height: 1.15,
          fontWeight: FontWeight.bold,
          color: TemaApp.azul,
        ),
      ),
    );
  }
}
