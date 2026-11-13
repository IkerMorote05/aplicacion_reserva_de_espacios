import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/domain/models/usuario.dart';
import 'package:aplicacion_reserva_espacios/ui/acceso/view_models/home_viewmodel.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/boton_seleccion.dart';
import 'package:aplicacion_reserva_espacios/ui/espacios/ui/espacios_screen.dart';
import 'package:flutter/material.dart';

class Homepantalla extends StatefulWidget {
  const Homepantalla({super.key, this.usuario});

  final Usuario? usuario;

  @override
  State<Homepantalla> createState() => _HomePantallaState();
}

class _HomePantallaState extends State<Homepantalla> {
  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _espaciosRepository = EspaciosRepository(service: _service);
  late final _viewModel = HomeViewmodel(
    espaciosRepository: _espaciosRepository,
    usuario: widget.usuario,
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final espacios = _viewModel.espaciosFiltrados;
        return Scaffold(
          appBar: AppBar(title: const Text("Home")),
          bottomNavigationBar: const SafeArea(
            top: false,
            child: Barranavegacion(),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Encuentro",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    child: Text(_inicialesUsuario),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _viewModel.mensajeBienvenida,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SearchBar(
                leading: const Icon(Icons.search),
                hintText: "Busca en València",
                onChanged: _viewModel.actualizarBusqueda,
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BotonSeleccion(
                      seleccionado:
                          _viewModel.categoriaSeleccionada ==
                          CategoriaEspacio.reuniones,
                      onPressed: () => _viewModel.seleccionarCategoria(
                        CategoriaEspacio.reuniones,
                      ),
                      ancho: 105,
                      child: const Text(
                        "Reuniones",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    BotonSeleccion(
                      seleccionado:
                          _viewModel.categoriaSeleccionada ==
                          CategoriaEspacio.talleres,
                      onPressed: () => _viewModel.seleccionarCategoria(
                        CategoriaEspacio.talleres,
                      ),
                      ancho: 105,
                      child: const Text(
                        "Talleres",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    BotonSeleccion(
                      seleccionado:
                          _viewModel.categoriaSeleccionada ==
                          CategoriaEspacio.celebraciones,
                      onPressed: () => _viewModel.seleccionarCategoria(
                        CategoriaEspacio.celebraciones,
                      ),
                      ancho: 105,
                      child: const Text(
                        "Celebraciones",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Cerca de ti",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                    child: const Text("Ver todos ->"),
                  ),
                ],
              ),
              if (espacios.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text("No hay espacios para esos criterios."),
                  ),
                )
              else
                for (final espacio in espacios)
                  _tarjetaEspacio(context, espacio),
            ],
          ),
        );
      },
    );
  }

  String get _inicialesUsuario {
    final nombre = widget.usuario?.nombre.trim();
    if (nombre == null || nombre.isEmpty) {
      return 'UI';
    }
    final partes = nombre.split(RegExp(r'\s+'));
    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }
    return '${partes.first.substring(0, 1)}${partes.last.substring(0, 1)}'
        .toUpperCase();
  }

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
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
}
