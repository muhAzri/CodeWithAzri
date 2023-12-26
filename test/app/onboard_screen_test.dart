import 'package:code_with_azri/modules/app/lib/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_app.dart';

void main() {
  testWidgets('Test Onboard Screen Widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const TestApp(home: OnboardScreen()));

    // Wait for the widget to load and animations to complete
    await tester.pumpAndSettle();

    // Verify if widgets are present on the screen
    expect(find.byType(OnboardLogo), findsOneWidget);
    expect(find.byType(TagLine), findsOneWidget);
    expect(find.byType(DescriptionSection), findsOneWidget);
    expect(find.byType(CreateNewAccountButton), findsOneWidget);
    expect(find.byType(GoToSignInButton), findsOneWidget);
  });
}
