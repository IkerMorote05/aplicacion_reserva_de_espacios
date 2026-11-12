import 'package:aplicacion_reserva_espacios/data/repositories/espacios_repository.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_demo.dart';
import 'package:aplicacion_reserva_espacios/data/services/datos_simulados_service.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/espacios/ui/espacio_detalle_screen.dart';
import 'package:flutter/material.dart';

class EspacioTargeta extends StatefulWidget {
  const EspacioTargeta({super.key, required this.id});

  final String id;

  @override
  State<EspacioTargeta> createState() => _EspacioTargetaState();
}

class _EspacioTargetaState extends State<EspacioTargeta> {
  late final _service = DatosSimuladosService(
    espacios: espaciosDemo,
    reservas: reservasDemo,
    usuarios: usuariosDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  late final _espacios = EspaciosRepository(service: _service);

  @override
  Widget build(BuildContext context) {
    final Espacio? espacio = _espacios.obtenerPorId(widget.id);
    if (espacio == null) {
      return const Card(
        child: ListTile(title: Text("No se encontró el espacio")),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                espacio.imagenAsset,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 150,
                  height: 150,
                  child: Icon(Icons.image_not_supported_outlined, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              espacio.nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("${espacio.ubicacion} · Hasta ${espacio.aforo} personas"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  onPressed: () {},
                  child: Text(
                    "Desde ${espacio.precioHoraCentimos / 100}€ franja ",
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => EspacioDetalleScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Desde ${espacio.precioHoraCentimos / 100}€ franja ",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
