import 'package:aplicacion_reserva_espacios/ui/acceso/view_models/espacios_viewmodel.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/decoracion_runica_espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/espacio_targeta.dart';
import 'package:flutter/material.dart';

class EspaciosScreen extends StatefulWidget {
  const EspaciosScreen({super.key});

  @override
  State<EspaciosScreen> createState() => _EspaciosScreenState();
}

class _EspaciosScreenState extends State<EspaciosScreen> {
  late final EspaciosViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EspaciosViewModel()..addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lista = _viewModel.espacios;

    return Scaffold(
      backgroundColor: const Color(0xff0f1216),
      appBar: AppBar(
        backgroundColor: const Color(0xff0f1216),
        foregroundColor: const Color(0xffe9edf2),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InsigniaRunicaEspacio(
              color: Color(0xff5bc0eb),
              esTiwaz: false,
              tamano: 22,
            ),
            SizedBox(width: 10),
            Text(
              'ESPACIOS CERCANOS',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(top: false, child: Barranavegacion()),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff161b22), Color(0xff0f1216)],
          ),
        ),
        child: _buildContenido(context, lista),
      ),
    );
  }

  Widget _buildContenido(BuildContext context, List espacios) {
    if (_viewModel.cargando && espacios.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff5bc0eb)),
      );
    }

    if (_viewModel.error != null && espacios.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _viewModel.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xff9aa5b4)),
          ),
        ),
      );
    }

    if (espacios.isEmpty) {
      return const Center(
        child: Text(
          'No hay espacios disponibles',
          style: TextStyle(color: Color(0xff9aa5b4)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool dosColumnas = constraints.maxWidth >= 720;
        final double paddingHorizontal = constraints.maxWidth >= 600 ? 24 : 14;
        const double separacion = 14;

        if (!dosColumnas) {
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              paddingHorizontal,
              14,
              paddingHorizontal,
              20,
            ),
            itemCount: espacios.length,
            separatorBuilder: (_, _) => const SizedBox(height: separacion),
            itemBuilder: (context, index) {
              final espacio = espacios[index];
              return EspacioTargeta(id: espacio.id);
            },
          );
        }

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(
            paddingHorizontal,
            16,
            paddingHorizontal,
            24,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: separacion,
            mainAxisSpacing: separacion,
            mainAxisExtent: 380,
          ),
          itemCount: espacios.length,
          itemBuilder: (context, index) {
            final espacio = espacios[index];
            return EspacioTargeta(id: espacio.id);
          },
        );
      },
    );
  }
}
