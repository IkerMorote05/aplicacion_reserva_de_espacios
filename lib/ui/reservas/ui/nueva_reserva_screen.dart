import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/disponibilidad_repository.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/disponibilidad_dia.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/domain/models/franja_disponibilidad.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_accion_inferior.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_dia.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_franja.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/clave_disponibilidad.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/mensaje_vacio.dart';
import 'package:flutter/material.dart';

class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({super.key});

  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  static const _morado = TemaApp.acento;
  static const _fondoSuave = TemaApp.superficieAtenuada;

  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _espacios = EspaciosRepository(service: _service).obtenerTodos();
  late final _disponibilidadRepository = DisponibilidadRepository(
    service: _service,
  );

  Espacio? _espacioSeleccionado;
  DateTime? _diaSeleccionado;
  FranjaDisponibilidad? _franjaSeleccionada;
  int _paso = 0;

  @override
  void initState() {
    super.initState();
    if (_espacios.isNotEmpty) {
      _espacioSeleccionado = _espacios.first;
      final dias = _diasDelEspacio(_espacioSeleccionado!);
      if (dias.isNotEmpty) {
        _diaSeleccionado = DateUtils.dateOnly(dias.first.fecha);
        _franjaSeleccionada = _primeraFranjaDisponible(dias.first);
      }
    }
  }

  List<DisponibilidadDia> _diasDelEspacio(Espacio espacio) {
    return _disponibilidadRepository.obtenerSieteDias(
      espacio.id,
      DateTime.now(),
    );
  }

  DisponibilidadDia? _diaActual(Espacio espacio) {
    for (final dia in _diasDelEspacio(espacio)) {
      if (_diaSeleccionado != null &&
          DateUtils.isSameDay(dia.fecha, _diaSeleccionado)) {
        return dia;
      }
    }
    return null;
  }

  FranjaDisponibilidad? _primeraFranjaDisponible(DisponibilidadDia dia) {
    for (final franja in dia.franja) {
      if (franja.disponible) {
        return franja;
      }
    }
    return null;
  }

  void _seleccionarEspacio(Espacio espacio) {
    final dias = _diasDelEspacio(espacio);
    final diaConDisponibilidad = dias.cast<DisponibilidadDia?>().firstWhere(
      (dia) => dia!.franja.any((franja) => franja.disponible),
      orElse: () => null,
    );
    setState(() {
      _espacioSeleccionado = espacio;
      _diaSeleccionado = diaConDisponibilidad == null
          ? (dias.isEmpty ? null : DateUtils.dateOnly(dias.first.fecha))
          : DateUtils.dateOnly(diaConDisponibilidad.fecha);
      _franjaSeleccionada = diaConDisponibilidad == null
          ? null
          : _primeraFranjaDisponible(diaConDisponibilidad);
    });
  }

  void _seleccionarDia(DisponibilidadDia dia) {
    setState(() {
      _diaSeleccionado = DateUtils.dateOnly(dia.fecha);
      _franjaSeleccionada = _primeraFranjaDisponible(dia);
    });
  }

  void _avanzar() {
    if (_paso == 0 && _espacioSeleccionado != null) {
      setState(() => _paso = 1);
    } else if (_paso == 1 && _franjaSeleccionada != null) {
      setState(() => _paso = 2);
    }
  }

  void _volver() {
    if (_paso > 0) {
      setState(() => _paso -= 1);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  String _precio(int centimos) =>
      '${(centimos / 100).toStringAsFixed(2).replaceAll('.', ',')} €';

  String _hora(DateTime fecha) =>
      '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';

  String _fechaCorta(DateTime fecha) {
    const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return '${dias[fecha.weekday - 1]} ${fecha.day}';
  }

  String _fechaLarga(DateTime fecha) {
    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${dias[fecha.weekday - 1]}, ${fecha.day} de '
        '${meses[fecha.month - 1]} de ${fecha.year}';
  }

  int _duracionEnHoras(FranjaDisponibilidad franja) =>
      franja.fin.difference(franja.inicio).inMinutes ~/ 60;

  int _totalCentimos(Espacio espacio, FranjaDisponibilidad franja) =>
      espacio.precioHoraCentimos *
      franja.fin.difference(franja.inicio).inMinutes ~/
      60;

  @override
  Widget build(BuildContext context) {
    final espacio = _espacioSeleccionado;
    final habilitarAccion = switch (_paso) {
      0 => espacio != null,
      1 => _franjaSeleccionada != null,
      _ => false,
    };

    return Scaffold(
      backgroundColor: TemaApp.fondo,
      appBar: AppBar(
        backgroundColor: TemaApp.fondo,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: _volver,
          icon: const Icon(Icons.arrow_back_ios_new, size: 19),
        ),
        title: Text(
          _paso == 1
              ? 'Día y hora'
              : _paso == 2
              ? 'Revisa tu reserva'
              : 'Nueva reserva',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          _IndicadorPasos(pasoActual: _paso),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: switch (_paso) {
                0 => _contenidoEspacios(),
                1 => _contenidoHorario(espacio),
                _ => _contenidoResumen(espacio),
              },
            ),
          ),
          BotonAccionInferior(
            habilitado: habilitarAccion,
            texto: switch (_paso) {
              0 => 'Elegir día y hora',
              1 => 'Revisar reserva',
              _ => 'Continuar · No disponible',
            },
            onPressed: _avanzar,
          ),
        ],
      ),
    );
  }

  Widget _contenidoEspacios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Elige tu sala',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Selecciona el espacio que mejor encaja con tu plan.',
          style: TextStyle(color: TemaApp.textoSecundario),
        ),
        const SizedBox(height: 18),
        if (_espacios.isEmpty)
          const MensajeVacio(
            icono: Icons.meeting_room_outlined,
            mensaje: 'No hay espacios disponibles para reservar.',
          )
        else
          ..._espacios.map(_tarjetaEspacio),
      ],
    );
  }

  Widget _tarjetaEspacio(Espacio espacio) {
    final seleccionado = espacio.id == _espacioSeleccionado?.id;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: seleccionado ? const Color(0xFFF2EEFB) : _fondoSuave,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: seleccionado ? _morado : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _seleccionarEspacio(espacio),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                seleccionado
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: seleccionado ? _morado : TemaApp.textoSecundario,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      espacio.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Hasta ${espacio.aforo} personas · '
                      '${espacio.actividades.join(' · ')}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: TemaApp.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_precio(espacio.precioHoraCentimos)} / hora',
                      style: const TextStyle(
                        color: _morado,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenidoHorario(Espacio? espacio) {
    if (espacio == null) {
      return const MensajeVacio(
        icono: Icons.meeting_room_outlined,
        mensaje: 'Elige un espacio para consultar sus horarios.',
      );
    }

    final dias = _diasDelEspacio(espacio);
    final dia = _diaSeleccionado == null ? null : _diaActual(espacio);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${espacio.nombre} · Hasta ${espacio.aforo} personas',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '${_precio(espacio.precioHoraCentimos)} por hora',
          style: const TextStyle(color: TemaApp.textoSecundario, fontSize: 13),
        ),
        const SizedBox(height: 20),
        const Text(
          'Elige día y hora',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 18),
        if (dias.isEmpty)
          const MensajeVacio(
            icono: Icons.calendar_month_outlined,
            mensaje: 'Todavía no hay fechas disponibles para este espacio.',
          )
        else ...[
          Text(
            _mesYAnyo(dias.first.fecha),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 66,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dias.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final fecha = dias[index];
                final seleccionado =
                    _diaSeleccionado != null &&
                    DateUtils.isSameDay(fecha.fecha, _diaSeleccionado);
                final tieneDisponibilidad = fecha.franja.any(
                  (franja) => franja.disponible,
                );
                return BotonDia(
                  etiqueta: _fechaCorta(fecha.fecha),
                  seleccionado: seleccionado,
                  disponible: tieneDisponibilidad,
                  onPressed: () => _seleccionarDia(fecha),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Franjas disponibles',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (dia == null || dia.franja.isEmpty)
            const MensajeVacio(
              icono: Icons.schedule_outlined,
              mensaje: 'No hay franjas cargadas para este día.',
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: dia.franja
                  .map((franja) => _botonFranja(franja))
                  .toList(),
            ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ClaveDisponibilidad(
                color: Colors.white,
                borde: Color(0xFFE5E3E8),
                etiqueta: 'Libre',
              ),
              ClaveDisponibilidad(
                color: Color(0xFFF1F0F2),
                etiqueta: 'Ocupada',
              ),
              ClaveDisponibilidad(color: _morado, etiqueta: 'Seleccionada'),
            ],
          ),
        ],
      ],
    );
  }

  String _mesYAnyo(DateTime fecha) {
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${meses[fecha.month - 1]} ${fecha.year}';
  }

  Widget _botonFranja(FranjaDisponibilidad franja) {
    final seleccionada = identical(franja, _franjaSeleccionada);
    final etiqueta = '${_hora(franja.inicio)}–${_hora(franja.fin)}';

    return BotonFranja(
      ancho: (MediaQuery.sizeOf(context).width - 50) / 2,
      etiqueta: etiqueta,
      seleccionada: seleccionada,
      disponible: franja.disponible,
      onPressed: () => setState(() => _franjaSeleccionada = franja),
    );
  }

  Widget _contenidoResumen(Espacio? espacio) {
    final franja = _franjaSeleccionada;
    final dia = _diaSeleccionado;
    if (espacio == null || franja == null || dia == null) {
      return const MensajeVacio(
        icono: Icons.event_busy_outlined,
        mensaje: 'Selecciona un espacio y un horario disponible.',
      );
    }

    final horas = _duracionEnHoras(franja);
    final total = _totalCentimos(espacio, franja);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paso 3 de 3 · Resumen de demostración',
          style: TextStyle(color: TemaApp.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 14),
        const _IlustracionReserva(),
        const SizedBox(height: 16),
        const Text(
          'Tu reserva, de un vistazo.',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 22),
        Text(
          espacio.nombre,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          _fechaLarga(dia),
          style: const TextStyle(color: TemaApp.textoSecundario),
        ),
        const SizedBox(height: 12),
        Text(
          '${_hora(franja.inicio)}–${_hora(franja.fin)} · $horas '
          '${horas == 1 ? 'hora' : 'horas'}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 7),
        Text(
          'Hasta ${espacio.aforo} personas · ${espacio.actividades.join(' · ')}',
          style: const TextStyle(color: TemaApp.textoSecundario, fontSize: 13),
        ),
        const SizedBox(height: 22),
        _filaPrecio(
          'Uso del espacio · $horas ${horas == 1 ? 'hora' : 'horas'}',
          _precio(total),
        ),
        const Divider(height: 24),
        _filaPrecio('Total', _precio(total), negrita: true),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _fondoSuave,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta reserva es una vista previa.',
                style: TextStyle(color: _morado, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Text(
                'No se creará una reserva ni se realizará ningún cobro.',
                style: TextStyle(color: TemaApp.textoSecundario, fontSize: 12),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(() => _paso = 1),
            child: const Text('Cambiar fecha u horario'),
          ),
        ),
      ],
    );
  }

  Widget _filaPrecio(String etiqueta, String precio, {bool negrita = false}) {
    final estilo = TextStyle(
      fontWeight: negrita ? FontWeight.w700 : FontWeight.w400,
      fontSize: negrita ? 16 : 14,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(etiqueta, style: estilo)),
        const SizedBox(width: 12),
        Text(precio, style: estilo),
      ],
    );
  }
}

class _IndicadorPasos extends StatelessWidget {
  const _IndicadorPasos({required this.pasoActual});

  final int pasoActual;

  @override
  Widget build(BuildContext context) {
    const etiquetas = ['Sala', 'Horario', 'Resumen'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: [
          for (var i = 0; i < etiquetas.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 1,
                  color: i <= pasoActual
                      ? _NuevaReservaScreenState._morado
                      : TemaApp.borde,
                ),
              ),
            _PasoEtiqueta(
              etiqueta: '${i + 1}. ${etiquetas[i]}',
              activo: i == pasoActual,
              completado: i < pasoActual,
            ),
          ],
        ],
      ),
    );
  }
}

class _PasoEtiqueta extends StatelessWidget {
  const _PasoEtiqueta({
    required this.etiqueta,
    required this.activo,
    required this.completado,
  });

  final String etiqueta;
  final bool activo;
  final bool completado;

  @override
  Widget build(BuildContext context) {
    final color = activo || completado
        ? _NuevaReservaScreenState._morado
        : TemaApp.textoSecundario;
    return Text(
      etiqueta,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: activo ? FontWeight.w700 : FontWeight.w400,
      ),
    );
  }
}

class _IlustracionReserva extends StatelessWidget {
  const _IlustracionReserva();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ilustración decorativa de una sala reservada',
      child: Container(
        height: 128,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF1EEE8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 28,
              top: 15,
              child: Container(
                width: 58,
                height: 94,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2DCF2),
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: const Icon(
                  Icons.window_outlined,
                  color: Color(0xFF927CC6),
                  size: 42,
                ),
              ),
            ),
            const Positioned(
              right: 68,
              top: 20,
              child: Icon(
                Icons.landscape_outlined,
                size: 72,
                color: Color(0xFFC9C6AE),
              ),
            ),
            Positioned(
              bottom: 17,
              child: Container(
                width: 128,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF786F64),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Positioned(
              right: 28,
              bottom: 20,
              child: Icon(
                Icons.spa_outlined,
                size: 43,
                color: Color(0xFF7C9479),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
