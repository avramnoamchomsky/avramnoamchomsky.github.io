import 'package:chomsky_site/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('Homepage renders Hyprland sections and navigates to M3E Snake', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ChomskyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Low-level craft'), findsOneWidget);
    expect(find.text('Interactive Sub-Apps'), findsOneWidget);
    expect(find.text('M3E Snake'), findsWidgets);

    // Click the primary Hero CTA to enter the secondary Snake app.
    await tester.tap(find.text('Launch M3E Snake'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Material 3 Expressive Applet'), findsOneWidget);
    expect(find.text('Ready to Play'), findsOneWidget);
    expect(find.text('Wrap Walls'), findsOneWidget);

    // Navigate back to the homepage via the M3EAppBar back button.
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.textContaining('Low-level craft'), findsOneWidget);
  });

  testWidgets('Mobile layout renders Homepage and Snake without overflow', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ChomskyApp());
    await tester.pumpAndSettle();

    expect(find.text('Interactive Sub-Apps'), findsOneWidget);

    await tester.tap(find.text('Launch M3E Snake'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Material 3 Expressive Applet'), findsOneWidget);
    expect(find.text('Ready to Play'), findsOneWidget);
  });

  testWidgets('Sub-app card Open App navigates to Snake and M3E controls work', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ChomskyApp());
    await tester.pumpAndSettle();

    final openAppBtn = find.text('Open App');
    await tester.ensureVisible(openAppBtn);
    await tester.tap(openAppBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Material 3 Expressive Applet'), findsOneWidget);

    // Start game via M3E overlay button.
    await tester.tap(find.text('Start Game'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Ready to Play'), findsNothing);

    // Pause game via M3E toggle button.
    await tester.tap(find.text('Pause'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Game Paused'), findsOneWidget);

    // Switch speed to Turbo using M3ESegmentedButton.
    await tester.tap(find.text('Turbo'));
    await tester.pump(const Duration(milliseconds: 150));

    // Toggle Light/Dark theme via M3EIconButton.
    await tester.tap(find.byIcon(Icons.light_mode_rounded));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
  });
}
