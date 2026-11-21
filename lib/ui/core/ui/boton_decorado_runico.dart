import 'package:flutter/material.dart';

/// Botón reutilizable con marco tallado y runas integradas como decorado[cite: 6]
class BotonDecoradoRunico extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final Color colorAcento;
  final Color colorFondo;

  const BotonDecoradoRunico({
    super.key,
    required this.texto,
    required this.onPressed,
    this.colorAcento = const Color(
      0xfff59e0b,
    ), // Ámbar/brasa de TemaApp[cite: 5]
    this.colorFondo = const Color(0xff1b2027), // Superficie oscura[cite: 5]
  });

  @override
  Widget build(BuildContext context) {
    final bool activo = onPressed != null;
    final Color brillo = activo ? colorAcento : const Color(0xff3a4350);

    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: activo
            ? [
                BoxShadow(
                  color: colorAcento.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: colorFondo,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: colorAcento.withValues(alpha: 0.18),
          child: CustomPaint(
            painter: _DecoradoMarcoRunicoPainter(
              colorBrillo: brillo,
              activo: activo,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Runas decorativas izquierda
                  _GrupoRunasLateral(color: brillo, invertido: false),

                  // Texto central del botón
                  Flexible(
                    child: Text(
                      texto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: activo
                            ? const Color(0xffe9edf2)
                            : const Color(0xff9aa5b4),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),

                  // Runas decorativas derecha
                  _GrupoRunasLateral(color: brillo, invertido: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dibuja las runas talladas a ambos lados del texto dentro del botón
class _GrupoRunasLateral extends StatelessWidget {
  final Color color;
  final bool invertido;

  const _GrupoRunasLateral({required this.color, required this.invertido});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 26,
      child: CustomPaint(
        painter: _RunasLateralesPainter(color: color, invertido: invertido),
      ),
    );
  }
}

class _RunasLateralesPainter extends CustomPainter {
  final Color color;
  final bool invertido;

  _RunasLateralesPainter({required this.color, required this.invertido});

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final stroke = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (!invertido) {
      // Runa 1 (estilo Fehu)
      path.moveTo(4, size.height - 3);
      path.lineTo(4, 3);
      path.moveTo(4, 8);
      path.lineTo(12, 3);
      path.moveTo(4, 15);
      path.lineTo(12, 10);

      // Runa 2 (estilo Ansuz / entrelazado)
      path.moveTo(20, size.height - 3);
      path.lineTo(20, 3);
      path.moveTo(20, 6);
      path.lineTo(29, 11);
      path.moveTo(20, 13);
      path.lineTo(29, 18);
    } else {
      // Runa 3 (estilo Algiz)
      path.moveTo(10, size.height - 3);
      path.lineTo(10, 3);
      path.moveTo(10, 12);
      path.lineTo(4, 4);
      path.moveTo(10, 12);
      path.lineTo(16, 4);

      // Runa 4 (estilo Othala / rombo tallado)
      path.moveTo(26, 3);
      path.lineTo(21, 10);
      path.lineTo(26, 17);
      path.lineTo(31, 10);
      path.close();
      path.moveTo(23, 15);
      path.lineTo(20, size.height - 3);
      path.moveTo(29, 15);
      path.lineTo(32, size.height - 3);
    }

    canvas.drawPath(path, glow);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _RunasLateralesPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.invertido != invertido;
  }
}

/// Dibuja el borde doble biselado y remaches de esquina alrededor del botón
class _DecoradoMarcoRunicoPainter extends CustomPainter {
  final Color colorBrillo;
  final bool activo;

  _DecoradoMarcoRunicoPainter({
    required this.colorBrillo,
    required this.activo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rectExterior = Offset.zero & size;
    final rrectExterior = RRect.fromRectAndRadius(
      rectExterior.deflate(1),
      const Radius.circular(14),
    );
    final rrectInterior = RRect.fromRectAndRadius(
      rectExterior.deflate(4.5),
      const Radius.circular(10),
    );

    final bordeExterior = Paint()
      ..color = colorBrillo.withValues(alpha: activo ? 0.85 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final bordeInterior = Paint()
      ..color = const Color(0xff3a4350)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(rrectExterior, bordeExterior);
    canvas.drawRRect(rrectInterior, bordeInterior);
  }

  @override
  bool shouldRepaint(covariant _DecoradoMarcoRunicoPainter oldDelegate) {
    return oldDelegate.colorBrillo != colorBrillo ||
        oldDelegate.activo != activo;
  }
}
