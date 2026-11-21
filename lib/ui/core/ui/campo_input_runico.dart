import 'package:flutter/material.dart';

class CampoInputRunico extends StatefulWidget {
  final String? etiqueta;
  final String? pista;
  final IconData? icono;
  final Widget? sufijo;
  final TextEditingController? controlador;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType? teclado;
  final int maxLineas;
  final String? Function(String?)? validador;
  final ValueChanged<String>? onChanged;
  final Color colorAcento;
  final Color colorFondo;
  final Color colorBorde;

  const CampoInputRunico({
    super.key,
    this.etiqueta,
    this.pista,
    this.icono,
    this.sufijo,
    this.controlador,
    this.focusNode,
    this.obscureText = false,
    this.teclado,
    this.maxLineas = 1,
    this.validador,
    this.onChanged,
    this.colorAcento = const Color(0xff5bc0eb),
    this.colorFondo = const Color(0xff1b2027),
    this.colorBorde = const Color(0xff3a4350),
  });

  @override
  State<CampoInputRunico> createState() => _CampoInputRunicoState();
}

class _CampoInputRunicoState extends State<CampoInputRunico> {
  late final FocusNode _focusNode;
  bool _externoFocus = false;
  bool _tieneFoco = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _externoFocus = true;
    } else {
      _focusNode = FocusNode();
    }
    _tieneFoco = _focusNode.hasFocus;
    _focusNode.addListener(_alCambiarFoco);
  }

  void _alCambiarFoco() {
    if (_tieneFoco != _focusNode.hasFocus) {
      setState(() => _tieneFoco = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_alCambiarFoco);
    if (!_externoFocus) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool multilinea = widget.maxLineas > 1;
    final Color colorActivo = _tieneFoco
        ? widget.colorAcento
        : const Color(0xff9aa5b4);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double ancho = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final bool escritorio = ancho >= 600;
        final bool compacto = ancho < 240;

        final double radio = escritorio ? 15 : 13;
        final double paddingH = compacto ? 10 : (escritorio ? 18 : 14);
        final double paddingV = multilinea
            ? (escritorio ? 16 : 12)
            : (escritorio ? 15 : 12);
        final double tamanoTexto = escritorio ? 15.5 : 14.5;
        final double tamanoIcono = escritorio ? 20 : 18;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.etiqueta != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6),
                child: Text(
                  widget.etiqueta!.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _tieneFoco
                        ? widget.colorAcento
                        : const Color(0xff9aa5b4),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radio),
                boxShadow: _tieneFoco
                    ? [
                        BoxShadow(
                          color: widget.colorAcento.withValues(alpha: 0.22),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
              ),
              child: CustomPaint(
                painter: _MarcoInputRunicoPainter(
                  radio: radio,
                  colorBorde: widget.colorBorde,
                  colorAcento: widget.colorAcento,
                  enfocado: _tieneFoco,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingH,
                    vertical: paddingV,
                  ),
                  child: Row(
                    crossAxisAlignment: multilinea
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      if (!compacto) ...[
                        Padding(
                          padding: EdgeInsets.only(top: multilinea ? 2 : 0),
                          child: _RunaInputLateral(
                            color: colorActivo,
                            enfocado: _tieneFoco,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (widget.icono != null) ...[
                        Padding(
                          padding: EdgeInsets.only(top: multilinea ? 2 : 0),
                          child: Icon(
                            widget.icono,
                            size: tamanoIcono,
                            color: colorActivo,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: TextFormField(
                          controller: widget.controlador,
                          focusNode: _focusNode,
                          obscureText: widget.obscureText,
                          keyboardType: widget.teclado,
                          maxLines: widget.maxLineas,
                          validator: widget.validador,
                          onChanged: widget.onChanged,
                          cursorColor: widget.colorAcento,
                          style: TextStyle(
                            color: const Color(0xffe9edf2),
                            fontSize: tamanoTexto,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            filled: false,
                            hintText: widget.pista,
                            hintStyle: const TextStyle(
                              color: Color(0xff9aa5b4),
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: const TextStyle(
                              color: Color(0xffef4444),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (widget.sufijo != null) ...[
                        const SizedBox(width: 8),
                        widget.sufijo!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RunaInputLateral extends StatelessWidget {
  final Color color;
  final bool enfocado;

  const _RunaInputLateral({required this.color, required this.enfocado});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 18,
      child: CustomPaint(
        painter: _TrazoRunaInputPainter(color: color, enfocado: enfocado),
      ),
    );
  }
}

class _TrazoRunaInputPainter extends CustomPainter {
  final Color color;
  final bool enfocado;

  _TrazoRunaInputPainter({required this.color, required this.enfocado});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    if (enfocado) {
      final glow = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

      final pathGlow = Path()
        ..moveTo(w * 0.45, h - 2)
        ..lineTo(w * 0.45, 2)
        ..moveTo(w * 0.45, h * 0.55)
        ..lineTo(2, 3)
        ..moveTo(w * 0.45, h * 0.55)
        ..lineTo(w - 2, 3);
      canvas.drawPath(pathGlow, glow);
    }

    final trazo = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Runa estilizada tipo Algiz
    final path = Path()
      ..moveTo(w * 0.45, h - 2)
      ..lineTo(w * 0.45, 2)
      ..moveTo(w * 0.45, h * 0.55)
      ..lineTo(2, 3)
      ..moveTo(w * 0.45, h * 0.55)
      ..lineTo(w - 2, 3);

    canvas.drawPath(path, trazo);
  }

  @override
  bool shouldRepaint(covariant _TrazoRunaInputPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.enfocado != enfocado;
  }
}

class _MarcoInputRunicoPainter extends CustomPainter {
  final double radio;
  final Color colorBorde;
  final Color colorAcento;
  final bool enfocado;

  _MarcoInputRunicoPainter({
    required this.radio,
    required this.colorBorde,
    required this.colorAcento,
    required this.enfocado,
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

    final fondo = Paint()
      ..color = const Color(0xff1b2027)
      ..style = PaintingStyle.fill;

    final bordeExterno = Paint()
      ..color = enfocado ? colorAcento : colorBorde
      ..style = PaintingStyle.stroke
      ..strokeWidth = enfocado ? 1.6 : 1.3;

    final bordeInterno = Paint()
      ..color = enfocado
          ? colorAcento.withValues(alpha: 0.45)
          : const Color(0xff252c35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    canvas.drawRRect(rrectExterno, fondo);
    canvas.drawRRect(rrectExterno, bordeExterno);
    canvas.drawRRect(rrectInterno, bordeInterno);
  }

  @override
  bool shouldRepaint(covariant _MarcoInputRunicoPainter oldDelegate) {
    return oldDelegate.radio != radio ||
        oldDelegate.colorBorde != colorBorde ||
        oldDelegate.colorAcento != colorAcento ||
        oldDelegate.enfocado != enfocado;
  }
}
