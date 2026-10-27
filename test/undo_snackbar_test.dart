import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrack/screens/dashboard_screen.dart';

void main() {
  testWidgets('Deleting meal shows UNDO snackbar with close icon and undoing restores meal', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial seed meals exist
    expect(find.text('Rolled Oats'), findsOneWidget);

    // Find delete buttons
    final deleteButtons = find.byIcon(Icons.delete_outline_rounded);
    expect(deleteButtons, findsWidgets);

    // Ensure first delete button is visible and tap it
    await tester.ensureVisible(deleteButtons.first);
    await tester.tap(deleteButtons.first);
    await tester.pump(); // trigger snackbar
    await tester.pump(const Duration(milliseconds: 300)); // allow enter animation

    // Verify UNDO notification appeared
    expect(find.text('UNDO'), findsOneWidget);
    expect(find.textContaining('Removed Rolled Oats'), findsOneWidget);

    // Tap UNDO
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    // Verify meal is restored and snackbar is dismissed
    expect(find.text('Rolled Oats'), findsOneWidget);
    expect(find.text('UNDO'), findsNothing);
  });
}
