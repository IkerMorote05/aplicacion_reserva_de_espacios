import 'package:flutter/material.dart';

class InsigniaRunicaEspacio extends StatelessWidget {
  const InsigniaRunicaEspacio({
    super.key,
    required this.color,
    required this.esTiwaz,
    this.tamano = 24,
  });

  final Color color;
  final bool esTiwaz;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: const Color(0xff0f1216).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
      ),
      child: CustomPaint(
        painter: TrazoRunaEspacioPainter(color: color, esTiwaz: esTiwaz),
      ),
    );
  }
}

class TrazoRunaEspacioPainter extends CustomPainter {
  const TrazoRunaEspacioPainter({required this.color, required this.esTiwaz});

  final Color color;
  final bool esTiwaz;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final halo = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final trazo = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (!esTiwaz) {
      // Runa tipo Algiz
      path.moveTo(w * 0.5, h * 0.82);
      path.lineTo(w * 0.5, h * 0.18);
      path.moveTo(w * 0.5, h * 0.56);
      path.lineTo(w * 0.24, h * 0.22);
      path.moveTo(w * 0.5, h * 0.56);
      path.lineTo(w * 0.76, h * 0.22);
    } else {
      // Runa tipo Tiwaz
      path.moveTo(w * 0.5, h * 0.82);
      path.lineTo(w * 0.5, h * 0.18);
      path.moveTo(w * 0.25, h * 0.44);
      path.lineTo(w * 0.5, h * 0.18);
      path.lineTo(w * 0.75, h * 0.44);
    }

    canvas.drawPath(path, halo);
    canvas.drawPath(path, trazo);
  }

  @override
  bool shouldRepaint(covariant TrazoRunaEspacioPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.esTiwaz != esTiwaz;
  }
}

class MarcoTarjetaRunicoPainter extends CustomPainter {
  const MarcoTarjetaRunicoPainter({
    required this.radio,
    required this.colorBorde,
    required this.colorAcento,
  });

  final double radio;
  final Color colorBorde;
  final Color colorAcento;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrectExterno = RRect.fromRectAndRadius(
      rect.deflate(0.8),
      Radius.circular(radio),
    );
    final rrectInterno = RRect.fromRectAndRadius(
      rect.deflate(3.8),
      Radius.circular((radio - 3).clamp(4, 20)),
    );

    final bordeExterno = Paint()
      ..color = colorBorde
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35;

    final bordeInterno = Paint()
      ..color = colorAcento.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    canvas.drawRRect(rrectExterno, bordeExterno);
    canvas.drawRRect(rrectInterno, bordeInterno);
  }

  @override
  bool shouldRepaint(covariant MarcoTarjetaRunicoPainter oldDelegate) {
    return oldDelegate.radio != radio ||
        oldDelegate.colorBorde != colorBorde ||
        oldDelegate.colorAcento != colorAcento;
  }
}
