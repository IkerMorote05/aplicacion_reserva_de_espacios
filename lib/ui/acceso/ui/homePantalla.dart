import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/domain/models/usuario.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/view_models/home_viewmodel.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';

import 'package:aplicacion_reserva_espacios/ui/core/ui/decoracion_runica_espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/espacio_targeta.dart';

import 'package:aplicacion_reserva_espacios/ui/espacios/ui/espacios_screen.dart';
import 'package:flutter/material.dart';

class Homepantalla extends StatefulWidget {
  const Homepantalla({super.key, this.usuario});

  final Usuario? usuario;

  @override
  State<Homepantalla> createState() => _HomePantallaState();
}

class _HomePantallaState extends State<Homepantalla> {
  late final TextEditingController _buscadorController;
  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _espaciosRepository = EspaciosRepository(service: _service);
  late var _viewModel = HomeViewModel(
    repository: _espaciosRepository,
    usuario: widget.usuario,
  );

  @override
  void initState() {
    super.initState();
    _buscadorController = TextEditingController();
    _viewModel = HomeViewModel()..addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _buscadorController.dispose();
    super.dispose();
  }

  void _irATodosLosEspacios() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const EspaciosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final espacios = _viewModel.espaciosFiltrados;
    return Scaffold(
      backgroundColor: TemaApp.fondoOscuro,
      bottomNavigationBar: const SafeArea(top: false, child: Barranavegacion()),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [TemaApp.fondoSuperior, TemaApp.fondoOscuro],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool escritorio = constraints.maxWidth >= 720;
              final bool dosColumnas = constraints.maxWidth >= 820;
              final double paddingH = escritorio ? 28 : 16;

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(paddingH, 16, paddingH, 12),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabecera superior: Encuentro + emblema de usuario
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  InsigniaRunicaEspacio(
                                    color: TemaApp.azul,
                                    esTiwaz: false,
                                    tamano: 24,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Encuentro',
                                    style: TextStyle(
                                      fontFamily: TemaApp.fuente,
                                      color: TemaApp.tinta,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: TemaApp.superficie,
                                  border: Border.all(
                                    color: TemaApp.azul.withValues(alpha: 0.75),
                                    width: 1.4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TemaApp.azul.withValues(
                                        alpha: 0.20,
                                      ),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'UI',
                                    style: TextStyle(
                                      color: TemaApp.azul,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Titular principal reutilizando el estilo rúnico del tema
                          Text(
                            'Tu próximo espacio, más cerca.',
                            style: TemaApp.tituloSeccionRunico.copyWith(
                              fontSize: escritorio ? 30 : 25,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Buscador con marco y acento del tema
                          Container(
                            decoration: BoxDecoration(
                              color: TemaApp.superficie,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: TemaApp.borde,
                                width: 1.3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: TemaApp.azul.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                const InsigniaRunicaEspacio(
                                  color: TemaApp.azul,
                                  esTiwaz: false,
                                  tamano: 20,
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.search,
                                  color: TemaApp.textoSecundario,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _buscadorController,
                                    onChanged: _viewModel.actualizarConsulta,
                                    cursorColor: TemaApp.azul,
                                    style: const TextStyle(
                                      fontFamily: TemaApp.fuente,
                                      color: TemaApp.tinta,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Busca en València',
                                      hintStyle: TextStyle(
                                        color: TemaApp.textoSecundario,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_viewModel.consulta.isNotEmpty)
                                  IconButton(
                                    onPressed: () {
                                      _buscadorController.clear();
                                      _viewModel.actualizarConsulta('');
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: TemaApp.textoSecundario,
                                      size: 18,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Filtros de categoría (Reuniones, Talleres, Celebraciones)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final cat in HomeViewModel.categorias) ...[
                                  _ChipCategoriaTema(
                                    etiqueta: cat,
                                    seleccionado:
                                        _viewModel.categoriaSeleccionada == cat,
                                    onTap: () =>
                                        _viewModel.seleccionarCategoria(cat),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Sección "Cerca de ti" + "Ver todos ->"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Cerca de ti',
                                style: TextStyle(
                                  fontFamily: TemaApp.fuente,
                                  color: TemaApp.tinta,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              InkWell(
                                onTap: _irATodosLosEspacios,
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    'Ver todos ->',
                                    style: TextStyle(
                                      fontFamily: TemaApp.fuente,
                                      color: TemaApp.azul,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      shadows: [
                                        Shadow(
                                          color: TemaApp.azul.withValues(
                                            alpha: 0.35,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (espacios.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'No se encontraron espacios para "${_viewModel.consulta}".',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: TemaApp.textoSecundario,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (!dosColumnas)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(paddingH, 4, paddingH, 24),
                      sliver: SliverList.separated(
                        itemCount: espacios.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          return EspacioTargeta(id: espacios[index].id);
                        },
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(paddingH, 4, paddingH, 28),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 380,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return EspacioTargeta(id: espacios[index].id);
                        }, childCount: espacios.length),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChipCategoriaTema extends StatelessWidget {
  const _ChipCategoriaTema({
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
  });

  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: seleccionado
          ? TemaApp.azul.withValues(alpha: 0.18)
          : TemaApp.superficie,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: TemaApp.azul.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: seleccionado ? TemaApp.azul : TemaApp.borde,
              width: seleccionado ? 1.5 : 1.2,
            ),
            boxShadow: seleccionado
                ? [
                    BoxShadow(
                      color: TemaApp.azul.withValues(alpha: 0.22),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InsigniaRunicaEspacio(
                color: seleccionado ? TemaApp.ambar : TemaApp.azul,
                esTiwaz: seleccionado,
                tamano: 16,
              ),
              const SizedBox(width: 8),
              Text(
                etiqueta,
                style: TextStyle(
                  fontFamily: TemaApp.fuente,
                  color: seleccionado ? TemaApp.tinta : TemaApp.textoSecundario,
                  fontSize: 13.5,
                  fontWeight: seleccionado ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     final espacios = _viewModel.espaciosFiltrados;
//     return Scaffold(
//       backgroundColor: _fondoOscuro,
//       bottomNavigationBar: const SafeArea(top: false, child: Barranavegacion()),
//       body: DecoratedBox(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [_fondoSuperior, _fondoOscuro],
//           ),
//         ),
//         child: SafeArea(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final bool escritorio = constraints.maxWidth >= 720;
//               final bool dosColumnas = constraints.maxWidth >= 820;
//               final double paddingH = escritorio ? 28 : 16;

//               return CustomScrollView(
//                 slivers: [
//                   SliverPadding(
//                     padding: EdgeInsets.fromLTRB(paddingH, 16, paddingH, 12),
//                     sliver: SliverToBoxAdapter(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Cabecera: Encuentro + emblema de usuario rúnico
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: const [
//                                   InsigniaRunicaEspacio(
//                                     color: _azulRunico,
//                                     esTiwaz: false,
//                                     tamano: 24,
//                                   ),
//                                   SizedBox(width: 10),
//                                   Text(
//                                     'Encuentro',
//                                     style: TextStyle(
//                                       color: _textoPrincipal,
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.w800,
//                                       letterSpacing: 0.4,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Container(
//                                 width: 42,
//                                 height: 42,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: _superficie,
//                                   border: Border.all(
//                                     color: _azulRunico.withValues(alpha: 0.75),
//                                     width: 1.4,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: _azulRunico.withValues(
//                                         alpha: 0.20,
//                                       ),
//                                       blurRadius: 12,
//                                     ),
//                                   ],
//                                 ),
//                                 child: const Center(
//                                   child: Text(
//                                     'UI',
//                                     style: TextStyle(
//                                       color: _azulRunico,
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: 13.5,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 18),

//                           // Titular principal
//                           Text(
//                             'Tu próximo espacio, más cerca.',
//                             style: TextStyle(
//                               color: _textoPrincipal,
//                               fontSize: escritorio ? 30 : 25,
//                               fontWeight: FontWeight.w900,
//                               height: 1.15,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // Buscador con marco rúnico y acento azul
//                           Container(
//                             decoration: BoxDecoration(
//                               color: _superficie,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(color: _borde, width: 1.3),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: _azulRunico.withValues(alpha: 0.08),
//                                   blurRadius: 12,
//                                 ),
//                               ],
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 4,
//                             ),
//                             child: Row(
//                               children: [
//                                 const InsigniaRunicaEspacio(
//                                   color: _azulRunico,
//                                   esTiwaz: false,
//                                   tamano: 20,
//                                 ),
//                                 const SizedBox(width: 10),
//                                 const Icon(
//                                   Icons.search,
//                                   color: _textoSecundario,
//                                   size: 20,
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: TextField(
//                                     controller: _buscadorController,
//                                     onChanged: _viewModel.actualizarConsulta,
//                                     cursorColor: _azulRunico,
//                                     style: const TextStyle(
//                                       color: _textoPrincipal,
//                                       fontSize: 14.5,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     decoration: const InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Busca en València',
//                                       hintStyle: TextStyle(
//                                         color: _textoSecundario,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 if (_viewModel.consulta.isNotEmpty)
//                                   IconButton(
//                                     onPressed: () {
//                                       _buscadorController.clear();
//                                       _viewModel.actualizarConsulta('');
//                                     },
//                                     icon: const Icon(
//                                       Icons.close,
//                                       color: _textoSecundario,
//                                       size: 18,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 14),

//                           // Chips de categorías (Reuniones, Talleres, Celebraciones)
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: [
//                                 for (final cat in HomeViewmodel.categorias) ...[
//                                   _ChipCategoriaRunico(
//                                     etiqueta: cat,
//                                     seleccionado:
//                                         _viewModel.categoriaSeleccionada == cat,
//                                     onTap: () =>
//                                         _viewModel.seleccionarCategoria(cat),
//                                   ),
//                                   const SizedBox(width: 10),
//                                 ],
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 22),

//                           // Cabecera de sección "Cerca de ti" + "Ver todos ->"
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Cerca de ti',
//                                 style: TextStyle(
//                                   color: _textoPrincipal,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: _irATodosLosEspacios,
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 6,
//                                     vertical: 4,
//                                   ),
//                                   child: Text(
//                                     'Ver todos ->',
//                                     style: TextStyle(
//                                       color: _azulRunico,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w700,
//                                       shadows: [
//                                         Shadow(
//                                           color: _azulRunico.withValues(
//                                             alpha: 0.35,
//                                           ),
//                                           blurRadius: 8,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Lista o cuadrícula de tarjetas de espacios
//                   if (espacios.isEmpty)
//                     SliverFillRemaining(
//                       hasScrollBody: false,
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(24),
//                           child: Text(
//                             'No se encontraron espacios para "${_viewModel.consulta}".',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(color: _textoSecundario),
//                           ),
//                         ),
//                       ),
//                     )
//                   else if (!dosColumnas)
//                     SliverPadding(
//                       padding: EdgeInsets.fromLTRB(paddingH, 4, paddingH, 24),
//                       sliver: SliverList.separated(
//                         itemCount: espacios.length,
//                         separatorBuilder: (_, __) => const SizedBox(height: 14),
//                         itemBuilder: (context, index) {
//                           return EspacioTargeta(id: espacios[index].id);
//                         },
//                       ),
//                     )
//                   else
//                     SliverPadding(
//                       padding: EdgeInsets.fromLTRB(paddingH, 4, paddingH, 28),
//                       sliver: SliverGrid(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 16,
//                               mainAxisSpacing: 16,
//                               mainAxisExtent: 380,
//                             ),
//                         delegate: SliverChildBuilderDelegate((context, index) {
//                           return EspacioTargeta(id: espacios[index].id);
//                         }, childCount: espacios.length),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// String get _inicialesUsuario {
//   final nombre = widget.usuario?.nombre.trim();
//   if (nombre == null || nombre.isEmpty) {
//     return 'UI';
//   }
//   final partes = nombre.split(RegExp(r'\s+'));
//   if (partes.length == 1) {
//     return partes.first.substring(0, 1).toUpperCase();
//   }
//   return '${partes.first.substring(0, 1)}${partes.last.substring(0, 1)}'
//       .toUpperCase();
// }

Widget _tarjetaEspacio(BuildContext context, Espacio espacio) {
  final precio = espacio.precioHoraCentimos % 100 == 0
      ? (espacio.precioHoraCentimos / 100).toStringAsFixed(0)
      : (espacio.precioHoraCentimos / 100).toStringAsFixed(2);

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 2.6,
          child: Image.asset(
            espacio.imagenAsset,
            fit: BoxFit.cover,
            semanticLabel: espacio.nombre,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/salonPrueba3.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                espacio.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${espacio.ubicacion} · ${espacio.actividades.join(' · ')} · "
                "Hasta ${espacio.aforo} personas",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: TemaApp.textoSecundario,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  Text(
                    "Desde $precio€/franja",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const EspaciosScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    child: const Text("Ver salas →"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// return AnimatedBuilder(
//       animation: _viewModel,
//       builder: (context, _) {
//         final espacios = _viewModel.espaciosFiltrados;
//         return Scaffold(
//           appBar: AppBar(title: const Text("Home")),
//           bottomNavigationBar: const SafeArea(
//             top: false,
//             child: Barranavegacion(),
//           ),
//           body: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Expanded(
//                     child: Text(
//                       "Encuentro",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundColor: TemaApp.acento,
//                     foregroundColor: TemaApp.superficie,
//                     child: Text(_inicialesUsuario),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TituloLoginRunico(titulo: _viewModel.mensajeBienvenida),
//               const SizedBox(height: 10),
//               SearchBar(
//                 leading: const Icon(Icons.search),
//                 hintText: "Busca en València",
//                 onChanged: _viewModel.actualizarConsulta,
//               ),
//               const SizedBox(height: 16),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     BotonSeleccion(
//                       seleccionado:
//                           _viewModel.categoriaSeleccionada ==
//                           CategoriaEspacio.reuniones,
//                       onPressed: () => _viewModel.actualizarConsulta(
//                         CategoriaEspacio.reuniones as String,
//                       ),
//                       ancho: 105,
//                       child: const Text(
//                         "Reuniones",
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     BotonSeleccion(
//                       seleccionado:
//                           _viewModel.categoriaSeleccionada ==
//                           CategoriaEspacio.talleres,
//                       onPressed: () => _viewModel.seleccionarCategoria(
//                         CategoriaEspacio.talleres,
//                       ),
//                       ancho: 105,
//                       child: const Text(
//                         "Talleres",
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     BotonSeleccion(
//                       seleccionado:
//                           _viewModel.categoriaSeleccionada ==
//                           CategoriaEspacio.celebraciones,
//                       onPressed: () => _viewModel.seleccionarCategoria(
//                         CategoriaEspacio.celebraciones,
//                       ),
//                       ancho: 105,
//                       child: const Text(
//                         "Celebraciones",
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Expanded(
//                     child: Text(
//                       "Cerca de ti",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).push<void>(
//                         MaterialPageRoute<void>(
//                           builder: (_) => const EspaciosScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text("Ver todos ->"),
//                   ),
//                 ],
//               ),
//               if (espacios.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 32),
//                   child: Center(
//                     child: Text("No hay espacios para esos criterios."),
//                   ),
//                 )
//               else
//                 for (final espacio in espacios)
//                   _tarjetaEspacio(context, espacio),
//             ],
//           ),
//         );
//       },
//     );
