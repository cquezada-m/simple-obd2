import 'package:flutter_test/flutter_test.dart';
import 'package:simple_obd2/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const OBD2App());
    expect(find.text('OBD2 Scanner'), findsOneWidget);
    expect(find.text('Conectar'), findsOneWidget);
  });
}
