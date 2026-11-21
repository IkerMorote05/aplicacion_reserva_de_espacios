import 'package:aplicacion_reserva_espacios/config/tema_app.dart';
import 'package:aplicacion_reserva_espacios/domain/models/espacio.dart';
import 'package:aplicacion_reserva_espacios/ui/core/ui/barraNavegacion.dart';

import 'package:flutter/material.dart';

class EspacioDetalleScreen extends StatefulWidget {
  final Espacio espacioRec;

  const EspacioDetalleScreen(this.espacioRec, {super.key});
  @override
  State<EspacioDetalleScreen> createState() => _EspacioDetallesScreenState();
}

class _EspacioDetallesScreenState extends State<EspacioDetalleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalles: ${widget.espacioRec.nombre}")),
      bottomNavigationBar: const SafeArea(top: false, child: Barranavegacion()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(height: 16),
          Center(
            child: Image.asset(
              widget.espacioRec.imagenAsset,
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
          SizedBox(height: 16),
          Text(
            widget.espacioRec.nombre,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            widget.espacioRec.ubicacion,
            style: const TextStyle(
              color: TemaApp.textoSecundario,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 16),
          Text(widget.espacioRec.descripcion),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: []),
          ),
        ],
      ),
    );
  }
}
