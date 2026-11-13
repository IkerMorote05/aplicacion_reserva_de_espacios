import 'package:aplicacion_reserva_espacios/ui/acceso/ui/homePantalla.dart';
import 'package:aplicacion_reserva_espacios/ui/reservas/ui/nueva_reserva_screen.dart';
import 'package:flutter/material.dart';

class Barranavegacion extends StatelessWidget {
  const Barranavegacion({super.key});

  Row barra(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(builder: (_) => Homepantalla()),
              );
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search),
                SizedBox(height: 4),
                Text("Buscar"),
              ],
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const NuevaReservaScreen(),
                ),
              );
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(height: 4),
                Text("Reservar"),
              ],
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {},
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_month),
                SizedBox(height: 4),
                Text("Mis reservas"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return barra(context);
  }
}
