import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/decoracion_runica_espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/espacios/ui/espacio_detalle_screen.dart';
import 'package:flutter/material.dart';

class EspacioTargeta extends StatefulWidget {
  const EspacioTargeta({super.key, required this.id});

  final String id;

  @override
  State<EspacioTargeta> createState() => _EspacioTargetaState();
}

class _EspacioTargetaState extends State<EspacioTargeta> {
  static const Color _fondoOscuro = Color(0xff0f1216);
  static const Color _superficie = Color(0xff1b2027);
  static const Color _borde = Color(0xff3a4350);
  static const Color _azulRunico = Color(0xff5bc0eb);
  static const Color _ambarCalido = Color(0xfff59e0b);
  static const Color _textoPrincipal = Color(0xffe9edf2);
  static const Color _textoSecundario = Color(0xff9aa5b4);

  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _espacios = EspaciosRepository(service: _service);

  void _abrirDetalle(Espacio espacio) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => EspacioDetalleScreen(espacio)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Espacio? espacio = _espacios.obtenerPorId(widget.id);
    if (espacio == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _superficie,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borde, width: 1.2),
        ),
        child: const Row(
          children: [
            InsigniaRunicaEspacio(color: _ambarCalido, esTiwaz: true),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No se encontró el espacio',
                style: TextStyle(
                  color: _textoSecundario,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final precioEuros = espacio.precioHoraCentimos / 100;
    final precioFormateado = precioEuros == precioEuros.roundToDouble()
        ? precioEuros.toInt().toString()
        : precioEuros.toStringAsFixed(2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double ancho = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final bool compacto = ancho < 360;
        final bool escritorio = ancho >= 640;

        final double radio = escritorio ? 18 : 16;
        final double paddingInterno = escritorio ? 18 : 14;
        final double altoImagen = escritorio ? 190 : (compacto ? 145 : 165);

        return Container(
          decoration: BoxDecoration(
            color: _superficie,
            borderRadius: BorderRadius.circular(radio),
            boxShadow: [
              const BoxShadow(
                color: Color(0x99000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
              BoxShadow(
                color: _azulRunico.withValues(alpha: 0.12),
                blurRadius: 14,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radio),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _abrirDetalle(espacio),
              splashColor: _azulRunico.withValues(alpha: 0.14),
              child: CustomPaint(
                foregroundPainter: MarcoTarjetaRunicoPainter(
                  radio: radio,
                  colorBorde: _borde,
                  colorAcento: _azulRunico,
                ),
                child: Padding(
                  padding: EdgeInsets.all(paddingInterno),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: altoImagen,
                        decoration: BoxDecoration(
                          color: _fondoOscuro,
                          borderRadius: BorderRadius.circular(radio - 4),
                          border: Border.all(
                            color: _borde.withValues(alpha: 0.8),
                            width: 1.1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              espacio.imagenAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 44,
                                      color: _textoSecundario,
                                    ),
                                  ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    _fondoOscuro.withValues(alpha: 0.35),
                                    Colors.transparent,
                                    _fondoOscuro.withValues(alpha: 0.65),
                                  ],
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 10,
                              left: 10,
                              child: InsigniaRunicaEspacio(
                                color: _azulRunico,
                                esTiwaz: false,
                              ),
                            ),
                            const Positioned(
                              top: 10,
                              right: 10,
                              child: InsigniaRunicaEspacio(
                                color: _ambarCalido,
                                esTiwaz: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const InsigniaRunicaEspacio(
                            color: _azulRunico,
                            esTiwaz: false,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              espacio.nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _textoPrincipal,
                                fontSize: escritorio ? 21 : 18.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${espacio.ubicacion} · Hasta ${espacio.aforo} personas',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _textoSecundario,
                          fontSize: escritorio ? 14 : 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              _azulRunico.withValues(alpha: 0.45),
                              _borde,
                              _ambarCalido.withValues(alpha: 0.45),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _BotonAccionEspacio(
                              etiqueta: 'Desde $precioFormateado€ franja',
                              colorAcento: _ambarCalido,
                              rellenoFuerte: true,
                              compacto: compacto,
                              onPressed: () => _abrirDetalle(espacio),
                            ),
                          ),
                          SizedBox(width: compacto ? 8 : 10),
                          Expanded(
                            child: _BotonAccionEspacio(
                              etiqueta: 'Ver Detalles ->',
                              colorAcento: _azulRunico,
                              rellenoFuerte: false,
                              compacto: compacto,
                              onPressed: () => _abrirDetalle(espacio),
                            ),
                          ),
                        ],
                      ),
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

class _BotonAccionEspacio extends StatelessWidget {
  const _BotonAccionEspacio({
    required this.etiqueta,
    required this.colorAcento,
    required this.rellenoFuerte,
    required this.compacto,
    required this.onPressed,
  });

  final String etiqueta;
  final Color colorAcento;
  final bool rellenoFuerte;
  final bool compacto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compacto ? 40 : 44,
      child: Material(
        color: rellenoFuerte
            ? colorAcento.withValues(alpha: 0.18)
            : const Color(0xff14181e),
        borderRadius: BorderRadius.circular(11),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: colorAcento.withValues(alpha: 0.2),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: compacto ? 8 : 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: colorAcento.withValues(
                  alpha: rellenoFuerte ? 0.85 : 0.65,
                ),
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorAcento.withValues(
                    alpha: rellenoFuerte ? 0.20 : 0.10,
                  ),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                etiqueta,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: rellenoFuerte ? const Color(0xffe9edf2) : colorAcento,
                  fontSize: compacto ? 11.5 : 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
