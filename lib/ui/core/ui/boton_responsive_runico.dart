import 'package:flutter/material.dart';

enum VarianteBotonRunico { primario, secundario }

class BotonRunicoResponsive extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final VarianteBotonRunico variante;
  final Color? colorBrillo;
  final Color colorFondo;
  final Color colorBorde;

  const BotonRunicoResponsive({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.variante = VarianteBotonRunico.secundario,
    this.colorBrillo,
    this.colorFondo = const Color(0xff1b2027),
    this.colorBorde = const Color(0xff3a4350),
  });

  Color get _brilloEfectivo {
    if (colorBrillo != null) return colorBrillo!;
    return variante == VarianteBotonRunico.primario
        ? const Color(0xfff59e0b)
        : const Color(0xff5bc0eb);
  }

  @override
  Widget build(BuildContext context) {
    final bool activo = onPressed != null;
    final bool esPrimario = variante == VarianteBotonRunico.primario;
    final Color brillo = activo ? _brilloEfectivo : const Color(0xff6e635b);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double ancho = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        // Compacto para columnas estrechas (ej. 2 botones en móvil), más amplio en escritorio
        final bool muyEstrecho = ancho < 175;
        final bool escritorio = ancho >= 260;

        final double alto = escritorio ? 58 : (muyEstrecho ? 48 : 52);
        final double radio = escritorio ? 15 : 13;
        final double paddingH = muyEstrecho ? 8 : (escritorio ? 20 : 14);
        final double tamanoTexto = escritorio
            ? 15.5
            : (muyEstrecho ? 12.5 : 14);
        final double tamanoIcono = escritorio ? 19 : (muyEstrecho ? 15 : 17);
        final double anchoRuna = escritorio ? 24 : (muyEstrecho ? 12 : 18);
        final double altoRuna = escritorio ? 22 : (muyEstrecho ? 16 : 18);

        final Color fondoReal = esPrimario && activo
            ? brillo.withValues(alpha: 0.16)
            : colorFondo;

        return Container(
          height: alto,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radio),
            boxShadow: activo
                ? [
                    BoxShadow(
                      color: brillo.withValues(alpha: esPrimario ? 0.28 : 0.14),
                      blurRadius: escritorio ? 18 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: fondoReal,
            borderRadius: BorderRadius.circular(radio),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              splashColor: brillo.withValues(alpha: 0.18),
              child: CustomPaint(
                painter: _MarcoRunicoResponsivePainter(
                  radio: radio,
                  esPrimario: esPrimario,
                  colorBorde: activo ? colorBorde : const Color(0xff252c35),
                  colorBrillo: activo
                      ? brillo.withValues(alpha: esPrimario ? 0.85 : 0.45)
                      : Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingH),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!muyEstrecho) ...[
                        _RunaLateralResponsive(
                          ancho: anchoRuna,
                          alto: altoRuna,
                          color: brillo,
                          derecha: false,
                        ),
                        SizedBox(width: muyEstrecho ? 4 : 8),
                      ],
                      if (icono != null) ...[
                        Icon(
                          icono,
                          size: tamanoIcono,
                          color: activo ? brillo : const Color(0xff9aa5b4),
                        ),
                        SizedBox(width: muyEstrecho ? 5 : 8),
                      ],
                      Flexible(
                        child: Text(
                          texto,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: activo
                                ? const Color(0xffe9edf2)
                                : const Color(0xff9aa5b4),
                            fontSize: tamanoTexto,
                            fontWeight: FontWeight.w700,
                            letterSpacing: muyEstrecho ? 0.2 : 0.5,
                          ),
                        ),
                      ),
                      if (!muyEstrecho) ...[
                        SizedBox(width: muyEstrecho ? 4 : 8),
                        _RunaLateralResponsive(
                          ancho: anchoRuna,
                          alto: altoRuna,
                          color: brillo,
                          derecha: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RunaLateralResponsive extends StatelessWidget {
  final double ancho;
  final double alto;
  final Color color;
  final bool derecha;

  const _RunaLateralResponsive({
    required this.ancho,
    required this.alto,
    required this.color,
    required this.derecha,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      height: alto,
      child: CustomPaint(
        painter: _TrazoRunaResponsivePainter(color: color, derecha: derecha),
      ),
    );
  }
}

class _TrazoRunaResponsivePainter extends CustomPainter {
  final Color color;
  final bool derecha;

  _TrazoRunaResponsivePainter({required this.color, required this.derecha});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final glow = Paint()
      ..color = color.withValues(alpha: 0.32)
      ..strokeWidth = 3.2
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

    if (!derecha) {
      // Runa tipo Algiz estilizada
      path.moveTo(w * 0.5, h - 2);
      path.lineTo(w * 0.5, 2);
      path.moveTo(w * 0.5, h * 0.55);
      path.lineTo(2, 3);
      path.moveTo(w * 0.5, h * 0.55);
      path.lineTo(w - 2, 3);
    } else {
      // Runa tipo Tiwaz estilizada
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
  bool shouldRepaint(covariant _TrazoRunaResponsivePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.derecha != derecha;
  }
}

class _MarcoRunicoResponsivePainter extends CustomPainter {
  final double radio;
  final bool esPrimario;
  final Color colorBorde;
  final Color colorBrillo;

  _MarcoRunicoResponsivePainter({
    required this.radio,
    required this.esPrimario,
    required this.colorBorde,
    required this.colorBrillo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrectExterno = RRect.fromRectAndRadius(
      rect.deflate(0.8),
      Radius.circular(radio),
    );
    final rrectInterno = RRect.fromRectAndRadius(
      rect.deflate(3.5),
      Radius.circular((radio - 2.5).clamp(4, 20)),
    );

    final bordePrincipal = Paint()
      ..color = esPrimario ? colorBrillo : colorBorde
      ..style = PaintingStyle.stroke
      ..strokeWidth = esPrimario ? 1.5 : 1.3;

    final lineaSutil = Paint()
      ..color = esPrimario ? colorBorde : colorBrillo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    canvas.drawRRect(rrectExterno, bordePrincipal);
    canvas.drawRRect(rrectInterno, lineaSutil);
  }

  @override
  bool shouldRepaint(covariant _MarcoRunicoResponsivePainter oldDelegate) {
    return oldDelegate.radio != radio ||
        oldDelegate.esPrimario != esPrimario ||
        oldDelegate.colorBorde != colorBorde ||
        oldDelegate.colorBrillo != colorBrillo;
  }
}
