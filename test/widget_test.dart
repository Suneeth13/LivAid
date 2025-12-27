// Basic widget test for the LiveAid application.
//
// This test ensures that the onboarding screen loads correctly
// and displays all required UI elements. WidgetTester is used
// to build the widget tree, locate widgets, and verify text content.

import 'package:flutter_test/flutter_test.dart';

import 'package:livaid/main.dart';

void main() {
  testWidgets('Onboarding screen UI verification', (WidgetTester tester) async {
    // Render the LiveAid app
    await tester.pumpWidget(LiveAidApp());

    // Validate onboarding screen elements
    expect(find.text('Welcome to LiveAid'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
