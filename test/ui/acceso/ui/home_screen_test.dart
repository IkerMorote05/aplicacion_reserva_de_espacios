import 'package:aplicacion_reserva_espacios/ui/acceso/ui/homePantalla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home muestra tarjetas y actualiza resultados por categoría', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(242, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: Homepantalla()));
    await tester.pumpAndSettle();

    expect(find.text('Sala Ágora'), findsOneWidget);
    expect(find.textContaining('Hasta 20 personas'), findsOneWidget);
    expect(find.text('Ver salas →'), findsWidgets);

    await tester.ensureVisible(find.text('Celebraciones'));
    await tester.tap(find.text('Celebraciones'));
    await tester.pumpAndSettle();

    expect(find.text('Patio Llum'), findsOneWidget);
    expect(find.text('Sala Ágora'), findsNothing);
  });
}
