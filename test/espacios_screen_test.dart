import 'package:aplicacion_reserva_espacios/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('se puede navegar desde el acceso hasta la lista de espacios', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Entrar sin cuenta'));
    await tester.pumpAndSettle();
    expect(find.text('Ver todos ->'), findsOneWidget);

    await tester.tap(find.text('Ver todos ->'));
    await tester.pumpAndSettle();

    expect(find.text('Espacios cercanos'), findsOneWidget);
    expect(find.text('Sala Ágora'), findsOneWidget);
  });
}
