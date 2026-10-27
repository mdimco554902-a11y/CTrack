import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrack/screens/app_shell.dart';

void main() {
  testWidgets('Logging a meal returns to Dashboard and never navigates to Landing Page', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AppShell(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify we are on Dashboard
    expect(find.text('CTrack Today'), findsOneWidget);

    // Tap "Log Meal" FAB
    final logMealFab = find.widgetWithText(FloatingActionButton, 'Log Meal');
    expect(logMealFab, findsOneWidget);
    await tester.tap(logMealFab);
    await tester.pumpAndSettle();

    // Verify we are on SearchScreen ("Add Food")
    expect(find.text('Add Food'), findsOneWidget);

    // Pick first food item (Chicken Breast)
    final foodTile = find.text('Chicken Breast (Grilled)');
    expect(foodTile, findsOneWidget);
    await tester.tap(foodTile);
    await tester.pumpAndSettle();

    // Verify we are on PortionScreen ("Portion Calculator")
    expect(find.text('Portion Calculator'), findsOneWidget);

    // Tap "Log ... kcal to Lunch" button at bottom
    final logConfirmBtn = find.textContaining('Log ');
    expect(logConfirmBtn, findsWidgets);
    await tester.tap(logConfirmBtn.last);
    await tester.pumpAndSettle();

    // VERIFY CRITICAL BEHAVIOR:
    // We must be back on the Dashboard ("CTrack Today")
    expect(find.text('CTrack Today'), findsOneWidget);

    // We must NOT be on Landing Page!
    expect(find.text('Master Your Daily Nutrition With Complete Confidence.'), findsNothing);
    expect(find.text('SIMPLE 3-STEP PROCESS'), findsNothing);

    // Verify success snackbar notification appeared
    expect(find.textContaining('Logged 100g of Chicken Breast (Grilled) to Lunch'), findsOneWidget);
  });
}
