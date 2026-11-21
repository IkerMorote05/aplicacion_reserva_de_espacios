import 'package:flutter/material.dart';

// import 'tema_app.dart'; // Ajusta el import según la ruta de tu proyecto

/// Botón secundario reutilizable con marco rúnico sutil e icono opcional
class BotonSecundarioRunico extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final Color colorBrillo;
  final Color colorFondo;
  final Color colorBorde;

  const BotonSecundarioRunico({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.colorBrillo = const Color(
      0xff5bc0eb,
    ), // Azul rúnico de referencia[cite: 4, 6]
    this.colorFondo = const Color(
      0xff1b2027,
    ), // Superficie oscura del tema[cite: 5]
    this.colorBorde = const Color(
      0xff3a4350,
    ), // Borde tipo piedra/metal del tema[cite: 5]
  });

  @override
  Widget build(BuildContext context) {
    final bool activo = onPressed != null;
    final Color detalle = activo ? colorBrillo : const Color(0xff6e635b);

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: activo
            ? [
                BoxShadow(
                  color: colorBrillo.withValues(alpha: 0.14),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
          splashColor: colorBrillo.withValues(alpha: 0.16),
          child: CustomPaint(
            painter: _MarcoSecundarioRunicoPainter(
              colorBorde: activo ? colorBorde : const Color(0xff252c35),
              colorAcento: activo
                  ? colorBrillo.withValues(alpha: 0.45)
                  : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RunaPequena(color: detalle, derecha: false),
                  if (icono != null) ...[
                    const SizedBox(width: 10),
                    Icon(
                      icono,
                      size: 18,
                      color: activo ? detalle : const Color(0xff9aa5b4),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      texto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: activo
                            ? const Color(0xffe9edf2)
                            : const Color(0xff9aa5b4),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RunaPequena(color: detalle, derecha: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RunaPequena extends StatelessWidget {
  final Color color;
  final bool derecha;

  const _RunaPequena({required this.color, required this.derecha});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 18,
      child: CustomPaint(
        painter: _TrazoRunaSecundaria(color: color, derecha: derecha),
      ),
    );
  }
}

class _TrazoRunaSecundaria extends CustomPainter {
  final Color color;
  final bool derecha;

  _TrazoRunaSecundaria({required this.color, required this.derecha});

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final w = size.width;
    final h = size.height;

    if (!derecha) {
      // Trazo tipo Algiz estilizado a la izquierda
      path.moveTo(w * 0.5, h - 2);
      path.lineTo(w * 0.5, 2);
      path.moveTo(w * 0.5, h * 0.55);
      path.lineTo(2, 3);
      path.moveTo(w * 0.5, h * 0.55);
      path.lineTo(w - 2, 3);
    } else {
      // Trazo tipo Tiwaz estilizado a la derecha
      path.moveTo(w * 0.5, h - 2);
      path.lineTo(w * 0.5, 2);
      path.moveTo(2, h * 0.45);
      path.lineTo(w * 0.5, 2);
      path.lineTo(w - 2, h * 0.45);
    }

    canvas.drawPath(path, glow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrazoRunaSecundaria oldDelegate) {
    return oldDelegate.color != color || oldDelegate.derecha != derecha;
  }
}

class _MarcoSecundarioRunicoPainter extends CustomPainter {
  final Color colorBorde;
  final Color colorAcento;

  _MarcoSecundarioRunicoPainter({
    required this.colorBorde,
    required this.colorAcento,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrectExterno = RRect.fromRectAndRadius(
      rect.deflate(0.8),
      const Radius.circular(14),
    );
    final rrectInterno = RRect.fromRectAndRadius(
      rect.deflate(3.5),
      const Radius.circular(11.5),
    );

    final bordePrincipal = Paint()
      ..color = colorBorde
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final lineaSutil = Paint()
      ..color = colorAcento
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    canvas.drawRRect(rrectExterno, bordePrincipal);
    canvas.drawRRect(rrectInterno, lineaSutil);
  }

  @override
  bool shouldRepaint(covariant _MarcoSecundarioRunicoPainter oldDelegate) {
    return oldDelegate.colorBorde != colorBorde ||
        oldDelegate.colorAcento != colorAcento;
  }
}
