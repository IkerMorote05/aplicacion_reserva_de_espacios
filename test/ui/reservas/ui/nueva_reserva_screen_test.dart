import 'package:aplicacion_reserva_espacios/ui/reservas/ui/nueva_reserva_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('permite elegir espacio y horario y muestra el resumen', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: NuevaReservaScreen()));

    expect(find.text('Elige tu sala'), findsOneWidget);
    expect(find.text('Sala Ágora'), findsOneWidget);

    await tester.tap(find.text('Elegir día y hora'));
    await tester.pumpAndSettle();

    expect(find.text('Franjas disponibles'), findsOneWidget);
    expect(find.text('10:00–12:00'), findsOneWidget);
    expect(find.text('Ocupada'), findsWidgets);

    await tester.tap(find.text('13:00–15:00'));
    await tester.pump();
    await tester.tap(find.text('Revisar reserva'));
    await tester.pumpAndSettle();

    expect(find.text('Tu reserva, de un vistazo.'), findsOneWidget);
    expect(find.text('60,00 €'), findsNWidgets(2));
    expect(
      find.text('No se creará una reserva ni se realizará ningún cobro.'),
      findsOneWidget,
    );
    expect(find.text('Continuar · No disponible'), findsOneWidget);
  });
}
