
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment_getway/core/app_providers.dart';

void main() {
  // A test to verify that the app starts and shows the LandingScreen.
  testWidgets('App starts and displays landing screen smoke test', (WidgetTester tester) async {
    // 1. Build the app using AppProviders. It needs no arguments.
    await tester.pumpWidget(const AppProviders());

    // 2. Wait for all animations and async operations to settle.
    await tester.pumpAndSettle();

    // 3. Verify that the LandingScreen is present.
    //    Let's assume your LandingScreen has a title or some introductory text.
    //    We'll look for the text 'Razorpay Payment Gateway App' which is the app's title.
    //    You could also look for a specific widget like `find.byType(LandingScreen)`.
    expect(find.text('Razorpay Payment Gateway App'), findsOneWidget);

    // 4. Verify that elements from the old counter test are NOT present.
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.text('0'), findsNothing);
  });
}
