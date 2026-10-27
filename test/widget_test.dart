import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrack/main.dart';
import 'package:ctrack/widgets/theme_mode_toggle_button.dart';

void main() {
  testWidgets('App smoke test loads Landing Page on open, tests spinning theme toggle, and enters AppShell', (tester) async {
    tester.view.physicalSize = const Size(1280, 850);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: CTrackApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial screen when opening app is Landing Page
    expect(find.textContaining('Master Your Daily Nutrition With Complete Confidence.'), findsOneWidget);
    expect(find.text('WHY CHOOSE CTRACK'), findsOneWidget);

    // Verify Sun theme toggle exists in light mode by default
    expect(find.byType(ThemeModeToggleButton), findsWidgets);
    expect(find.byKey(const ValueKey('sun_icon')), findsWidgets);

    // Tap Sun icon -> transitions to Moon icon (Dark Mode)
    await tester.tap(find.byKey(const ValueKey('sun_icon')).first);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('moon_icon')), findsWidgets);

    // Tap Moon icon -> transitions back to Sun icon (Light Mode)
    await tester.tap(find.byKey(const ValueKey('moon_icon')).first);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('sun_icon')), findsWidgets);

    // Enter app via "Open App" button on landing page
    final openAppBtn = find.text('Open App');
    expect(openAppBtn, findsOneWidget);
    await tester.tap(openAppBtn);
    await tester.pumpAndSettle();

    // Verify we are now in the app shell
    expect(find.text('CTrack Today'), findsOneWidget);
    expect(find.text('Today\'s Tracker'), findsOneWidget);

    // Landing Page is NOT a sidebar item once inside the app
    expect(find.text('Landing Page'), findsNothing);
  });
}
