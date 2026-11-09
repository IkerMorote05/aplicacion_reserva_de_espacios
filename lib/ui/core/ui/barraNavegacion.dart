import 'package:flutter/material.dart';

class Barranavegacion extends StatelessWidget {
  Row barra() {
    return Row(
      children: [
        FilledButton.icon(
          onPressed: () {},
          label: Text("Buscar"),
          icon: Icon(Icons.search),
        ),
        FilledButton.icon(
          onPressed: () {},
          label: Text("Reservar"),
          icon: Icon(Icons.add),
        ),
        FilledButton.icon(
          onPressed: () {},
          label: Text("Mis reservas"),
          icon: Icon(Icons.calendar_month),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return barra();
  }
}
