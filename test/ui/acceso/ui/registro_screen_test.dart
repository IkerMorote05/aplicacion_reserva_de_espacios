import 'package:aplicacion_reserva_espacios/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('registra una sesión demo y la muestra en Home', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Dana Soler');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'dana@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'clave-segura');
    await tester.enterText(find.byType(TextFormField).at(3), 'clave-segura');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.ensureVisible(find.text('Crear cuenta · Demo'));
    await tester.tap(find.text('Crear cuenta · Demo'));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Dana Soler.'), findsOneWidget);
  });
}
