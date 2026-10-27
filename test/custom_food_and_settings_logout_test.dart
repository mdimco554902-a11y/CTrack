import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrack/screens/app_shell.dart';
import 'package:ctrack/screens/search_screen.dart';

void main() {
  testWidgets('Create Custom Food dialog has identical UI to Quick Add and creates food item', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SearchScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Search Screen loads
    expect(find.text('Add Food'), findsOneWidget);

    // Tap "Create Custom Food" (+) icon in the AppBar
    final addCustomFoodBtn = find.byTooltip('Create Custom Food');
    expect(addCustomFoodBtn, findsOneWidget);
    await tester.tap(addCustomFoodBtn);
    await tester.pumpAndSettle();

    // Verify Dialog UI matches Quick Add:
    // 1. Header with title and close 'X' button
    expect(find.text('Create Custom Food'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // 2. Category pills (Proteins, Carbs, Fats & Dairy, etc.)
    expect(find.text('Proteins'), findsWidgets);
    expect(find.text('Carbs'), findsWidgets);

    // 3. Labels and Inputs
    expect(find.text('Food Name *'), findsOneWidget);
    expect(find.text('Base Serving'), findsOneWidget);
    expect(find.text('Calories (kcal) *'), findsOneWidget);
    expect(find.text('Macros (Optional)'), findsOneWidget);

    // 4. Full-width primary "Create Food" button
    final createBtn = find.widgetWithText(ElevatedButton, 'Create Food');
    expect(createBtn, findsOneWidget);

    // Enter food details into dialog fields
    final nameField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'e.g. Grandma\'s Chicken Soup',
    );
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, 'Homemade Granola Bar');

    final calsField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.suffixText == 'kcal',
    );
    expect(calsField, findsOneWidget);
    await tester.enterText(calsField, '185');

    // Tap "Create Food"
    await tester.tap(createBtn);
    await tester.pumpAndSettle();

    // Dialog should dismiss and show snackbar notification
    expect(find.text('Create Custom Food'), findsNothing);
    expect(find.textContaining('Added "Homemade Granola Bar" to your food database!'), findsOneWidget);
  });

  testWidgets('Settings screen contains Log Out / Sign Out button that returns to Landing Page', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AppShell(initialIndex: 2), // Start directly on Settings (index 2)
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify we are on Settings screen
    expect(find.text('Nutrition & Calorie Targets'), findsOneWidget);
    expect(find.text('Account & Session'), findsOneWidget);

    // Find Log Out / Sign Out button inside Settings
    final logoutBtn = find.text('Log Out / Sign Out');
    expect(logoutBtn, findsOneWidget);

    // Ensure button is scrolled into view before tapping
    await tester.ensureVisible(logoutBtn);
    await tester.pumpAndSettle();

    // Tap Log Out / Sign Out
    await tester.tap(logoutBtn);
    await tester.pumpAndSettle();

    // Verify confirmation dialog appeared
    expect(find.text('Log Out of CTrack'), findsOneWidget);
    expect(find.text('Are you sure you want to log out? You will be returned to the landing page.'), findsOneWidget);

    // Tap Log Out confirmation button in dialog
    final confirmLogoutBtn = find.widgetWithText(ElevatedButton, 'Log Out');
    expect(confirmLogoutBtn, findsOneWidget);
    await tester.tap(confirmLogoutBtn);
    await tester.pumpAndSettle();

    // Verify user is returned to Landing Page!
    expect(find.textContaining('Master Your Daily Nutrition With Complete Confidence.'), findsOneWidget);
    expect(find.text('WHY CHOOSE CTRACK'), findsOneWidget);
  });
}
