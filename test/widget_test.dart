import 'package:chomsky_site/app/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('Homepage matches hypr.land structure and navigates to M3E Snake', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ChomskyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Low-level craft'), findsOneWidget);
    expect(find.text('with the looks'), findsOneWidget);
    expect(find.text('Sub-Apps'), findsWidgets);
    expect(find.text('M3E Snake'), findsOneWidget);

    // Click primary hero CTA to enter secondary M3E Snake app.
    await tester.tap(find.text('Play Snake'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Material 3 Expressive Applet'), findsOneWidget);
    expect(find.text('Ready to Play'), findsOneWidget);
    expect(find.text('12×12'), findsWidgets);
    expect(find.text('Wrap Walls'), findsOneWidget);

    // Navigate back to homepage via M3EAppBar back button.
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Low-level craft'), findsOneWidget);
  });

  testWidgets('Mobile layout renders Homepage and Snake without overflow', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ChomskyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Low-level craft'), findsOneWidget);

    await tester.ensureVisible(find.text('Play Snake'));
    await tester.tap(find.text('Play Snake'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Material 3 Expressive Applet'), findsOneWidget);
    expect(find.text('Ready to Play'), findsOneWidget);
  });

  testWidgets('Snake supports WASD/Arrow keys and web immersive mode toggle', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ChomskyApp(initialLocation: '/apps/snake'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Ready to Play'), findsOneWidget);

    // Press W to steer up and start the game via HardwareKeyboard.
    await tester.sendKeyEvent(LogicalKeyboardKey.keyW);
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Ready to Play'), findsNothing);

    // Press Space to pause, then ArrowRight + Space to resume.
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Game Paused'), findsOneWidget);

    // Press F to enter Web Immersive Mode.
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.byIcon(Icons.fullscreen_exit_rounded), findsOneWidget);
    expect(find.text('Material 3 Expressive Applet'), findsNothing);

    // Press Escape to exit Web Immersive Mode.
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Material 3 Expressive Applet'), findsOneWidget);
  });
}
