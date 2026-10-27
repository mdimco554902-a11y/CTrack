import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrack/screens/app_shell.dart';
import 'package:ctrack/widgets/app_sidebar.dart';

void main() {
  testWidgets('AppShell shows permanent collapsible sidebar without hamburger icon and switches tabs', (tester) async {
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

    // Verify Title and elements
    expect(find.text('CTrack Today'), findsOneWidget);
    expect(find.text("Today's Meals"), findsOneWidget);
    expect(find.text('Log Meal'), findsOneWidget);

    // Verify Sidebar is shown directly (NOT a hamburger drawer)
    expect(find.byType(AppSidebar), findsOneWidget);
    expect(find.text('Today\'s Tracker'), findsOneWidget);
    expect(find.text('Account & TDEE'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('How to Use'), findsOneWidget);
    // Landing page is NOT inside the sidebar after opening/logging in
    expect(find.text('Landing Page'), findsNothing);

    // Verify Collapse button exists and collapses the sidebar
    final collapseBtn = find.byTooltip('Collapse sidebar');
    expect(collapseBtn, findsOneWidget);

    await tester.tap(collapseBtn);
    await tester.pumpAndSettle();

    // In collapsed mode, the text label is hidden and expand tooltip appears
    expect(find.byTooltip('Expand sidebar'), findsOneWidget);

    // Tap expand button to restore sidebar
    await tester.tap(find.byTooltip('Expand sidebar'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Collapse sidebar'), findsOneWidget);
    expect(find.text('Today\'s Tracker'), findsOneWidget);

    // Switch to Account tab
    await tester.tap(find.text('Account & TDEE'));
    await tester.pumpAndSettle();

    expect(find.text('Account Profile'), findsOneWidget);
    expect(find.text('Energy Expenditure (Mifflin-St Jeor)'), findsOneWidget);

    // Switch to How to Use tab
    await tester.tap(find.text('How to Use'));
    await tester.pumpAndSettle();

    expect(find.text('How to Use CTrack'), findsOneWidget);

    // Switch back to Today's Tracker
    await tester.tap(find.text('Today\'s Tracker'));
    await tester.pumpAndSettle();

    expect(find.text('CTrack Today'), findsOneWidget);
  });

  testWidgets('AppShell switches to bottom navigation in mobile view and hides sidebar', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
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

    // Verify sidebar is completely hidden on mobile
    expect(find.byType(AppSidebar), findsNothing);

    // Verify bottom navigation items are displayed
    expect(find.text('Tracker'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('How to Use'), findsOneWidget);

    // Switch tabs via bottom nav
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Nutrition & Calorie Targets'), findsOneWidget);

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('Account Profile'), findsOneWidget);

    await tester.tap(find.text('Tracker'));
    await tester.pumpAndSettle();
    expect(find.text('CTrack Today'), findsOneWidget);
  });
}
