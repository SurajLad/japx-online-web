import 'package:flutter_test/flutter_test.dart';
import 'package:jpax_online/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const JpaxApp());
    // Verify the app renders
    expect(find.text('JSON API Parser'), findsOneWidget);
  });
}
