import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/hypr_tokens.dart';
import 'snake_engine.dart';
import 'widgets/snake_board.dart';

/// Material 3 Expressive Snake sub-app demonstrating dynamic M3E theming,
/// spring-physics controls, responsive layout, and keyboard/touch gameplay.
class SnakeAppPage extends StatefulWidget {
  const SnakeAppPage({super.key});

  @override
  State<SnakeAppPage> createState() => _SnakeAppPageState();
}

class _SnakeAppPageState extends State<SnakeAppPage> {
  static const List<({String name, Color seed})> _paletteSeeds = [
    (name: 'Cyan', seed: Color(0xFF33CCFF)),
    (name: 'Mint', seed: Color(0xFF00E5A3)),
    (name: 'Violet', seed: Color(0xFF8B7BFF)),
    (name: 'Coral', seed: Color(0xFFFF7A6B)),
  ];

  late final SnakeEngine _engine;
  late final FocusNode _keyboardFocus;
  Brightness _brightness = Brightness.dark;
  Color _seedColor = const Color(0xFF33CCFF);
  int _lastNotifiedBest = 0;

  @override
  void initState() {
    super.initState();
    _engine = SnakeEngine()..addListener(_onEngineChanged);
    _keyboardFocus = FocusNode();
  }

  void _onEngineChanged() {
    if (!mounted) return;
    if (_engine.status == SnakeStatus.gameOver &&
        _engine.bestScore > _lastNotifiedBest &&
        _engine.bestScore > 0) {
      _lastNotifiedBest = _engine.bestScore;
      M3ESnackbar.show(
        context,
        message: 'New personal best: ${_engine.bestScore} points!',
      );
    }
  }

  @override
  void dispose() {
    _engine.removeListener(_onEngineChanged);
    _engine.dispose();
    _keyboardFocus.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      _engine.steer(SnakeDirection.up);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
      _engine.steer(SnakeDirection.down);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
      _engine.steer(SnakeDirection.left);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
      _engine.steer(SnakeDirection.right);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.space && event is KeyDownEvent) {
      _engine.togglePlayPause();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.keyR && event is KeyDownEvent) {
      _engine.restart(autoStart: false);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _showHelpDialog(BuildContext context) {
    M3EDialog.show<void>(
      context,
      dialog: M3EDialog(
        title: 'M3E Snake Controls',
        icon: const Icon(Icons.sports_esports_rounded),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Keyboard: Arrow keys or WASD to steer'),
            SizedBox(height: 6),
            Text('• Space: Start / Pause / Resume'),
            SizedBox(height: 6),
            Text('• R: Reset board'),
            SizedBox(height: 6),
            Text('• Touch / Mobile: Swipe on the board or use the D-pad'),
          ],
        ),
        actions: [
          M3EButton.filled(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m3eData = buildDefaultM3ETheme(
      seedColor: _seedColor,
      brightness: _brightness,
    );
    final materialTheme = m3eData.toThemeData();

    return Theme(
      data: materialTheme,
      child: M3ETheme(
        data: m3eData,
        child: Builder(
          builder: (context) {
            final theme = M3ETheme.of(context);
            final scheme = theme.colorScheme;

            return Focus(
              focusNode: _keyboardFocus,
              autofocus: true,
              onKeyEvent: _handleKeyEvent,
              child: GestureDetector(
                onTap: () {
                  if (!_keyboardFocus.hasFocus) {
                    _keyboardFocus.requestFocus();
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: Scaffold(
                  backgroundColor: scheme.surface,
                  appBar: M3EAppBar.top(
                    titleText: 'M3E Snake',
                    subtitleText: 'Material 3 Expressive Applet',
                    leading: M3EIconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Back to Home',
                      variant: M3EIconButtonVariant.tonal,
                      onPressed: () => context.go('/'),
                    ),
                    actions: [
                      M3EIconButton(
                        icon: Icon(
                          _brightness == Brightness.dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                        ),
                        tooltip: 'Toggle Light / Dark M3E Theme',
                        variant: M3EIconButtonVariant.standard,
                        onPressed: () {
                          setState(() {
                            _brightness = _brightness == Brightness.dark
                                ? Brightness.light
                                : Brightness.dark;
                          });
                        },
                      ),
                      const SizedBox(width: 4),
                      M3EIconButton(
                        icon: const Icon(Icons.help_outline_rounded),
                        tooltip: 'Controls & Shortcuts',
                        variant: M3EIconButtonVariant.standard,
                        onPressed: () => _showHelpDialog(context),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: AnimatedBuilder(
                      animation: _engine,
                      builder: (context, _) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 900;
                            if (isWide) {
                              return Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1120,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Center(
                                            child: ConstrainedBox(
                                              constraints:
                                                  const BoxConstraints(
                                                    maxWidth: 540,
                                                    maxHeight: 540,
                                                  ),
                                              child: SnakeBoard(
                                                engine: _engine,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 28),
                                        Expanded(
                                          flex: 5,
                                          child: SingleChildScrollView(
                                            child: _ControlDeck(
                                              engine: _engine,
                                              selectedSeed: _seedColor,
                                              paletteSeeds: _paletteSeeds,
                                              onSeedSelected: (color) =>
                                                  setState(
                                                    () => _seedColor = color,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                28,
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 520,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _ScoreStrip(engine: _engine),
                                      const SizedBox(height: 16),
                                      SnakeBoard(engine: _engine),
                                      const SizedBox(height: 18),
                                      _DPad(engine: _engine),
                                      const SizedBox(height: 18),
                                      _ControlDeck(
                                        engine: _engine,
                                        selectedSeed: _seedColor,
                                        paletteSeeds: _paletteSeeds,
                                        onSeedSelected: (color) => setState(
                                          () => _seedColor = color,
                                        ),
                                        compact: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScoreStrip extends StatelessWidget {
  const _ScoreStrip({required this.engine});

  final SnakeEngine engine;

  @override
  Widget build(BuildContext context) {
    final m3e = M3ETheme.of(context);
    final scheme = m3e.colorScheme;
    final type = m3e.typography;

    return M3ECard(
      variant: M3ECardVariant.filled,
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MetricItem(
            label: 'SCORE',
            value: '${engine.score}',
            valueColor: scheme.primary,
            type: type,
            scheme: scheme,
          ),
          _MetricItem(
            label: 'BEST',
            value: '${engine.bestScore}',
            valueColor: scheme.tertiary,
            type: type,
            scheme: scheme,
          ),
          _MetricItem(
            label: 'LENGTH',
            value: '${engine.snake.length}',
            valueColor: scheme.secondary,
            type: type,
            scheme: scheme,
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.type,
    required this.scheme,
  });

  final String label;
  final String value;
  final Color valueColor;
  final M3ETypography type;
  final M3EColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: type.baseline.labelSmall.copyWith(
            color: scheme.onSurfaceVariant,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: type.emphasized.headlineSmall.copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _ControlDeck extends StatelessWidget {
  const _ControlDeck({
    required this.engine,
    required this.selectedSeed,
    required this.paletteSeeds,
    required this.onSeedSelected,
    this.compact = false,
  });

  final SnakeEngine engine;
  final Color selectedSeed;
  final List<({String name, Color seed})> paletteSeeds;
  final ValueChanged<Color> onSeedSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final m3e = M3ETheme.of(context);
    final scheme = m3e.colorScheme;
    final type = m3e.typography;
    final isRunning = engine.status == SnakeStatus.running;

    final gridSizes = const [14, 18, 22];
    final selectedGridIdx = gridSizes.indexOf(engine.gridSize);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!compact) ...[
          _ScoreStrip(engine: engine),
          const SizedBox(height: 14),
        ],

        // Primary M3E action bar
        M3ECard(
          variant: M3ECardVariant.outlined,
          borderRadius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: M3EButton.filled(
                      onPressed: engine.togglePlayPause,
                      size: M3EButtonSize.md,
                      isSelected: isRunning,
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      selectedIcon: const Icon(Icons.pause_rounded, size: 20),
                      label: Text(
                        engine.status == SnakeStatus.gameOver ||
                                engine.status == SnakeStatus.won
                            ? 'Restart'
                            : 'Play',
                      ),
                      selectedLabel: const Text('Pause'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  M3EButton.tonal(
                    onPressed: () => engine.restart(autoStart: false),
                    size: M3EButtonSize.md,
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              if (!compact) ...[
                const SizedBox(height: 18),
                const M3EDivider(),
                const SizedBox(height: 16),
                _DPad(engine: engine),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // M3E Gameplay Tuning
        M3ECard(
          variant: M3ECardVariant.outlined,
          borderRadius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Speed',
                style: type.emphasized.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              M3ESegmentedButton<SnakeSpeed>(
                segments: [
                  for (final s in SnakeSpeed.values)
                    M3ESegment<SnakeSpeed>(value: s, label: s.label),
                ],
                selected: <SnakeSpeed>{engine.speed},
                onSelectionChanged: (sel) {
                  if (sel.isNotEmpty) {
                    engine.setSpeed(sel.first);
                  }
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Grid Size',
                style: type.emphasized.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              M3EButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                selectionRequired: true,
                selectedIndex: selectedGridIdx < 0 ? 1 : selectedGridIdx,
                onSelectedIndexChanged: (index) {
                  if (index != null) {
                    engine.setGridSize(gridSizes[index]);
                  }
                },
                actions: [
                  for (final size in gridSizes)
                    M3EButtonGroupAction(label: Text('$size×$size')),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wrap Walls',
                          style: type.baseline.titleSmall.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        Text(
                          'Pass through edges to the opposite side',
                          style: type.baseline.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  M3ESwitch(
                    value: engine.wrapWalls,
                    selectedIcon: const Icon(Icons.check_rounded, size: 16),
                    onChanged: engine.setWrapWalls,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Show Grid',
                          style: type.baseline.titleSmall.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        Text(
                          'Subtle coordinate lines on board',
                          style: type.baseline.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  M3ESwitch(
                    value: engine.showGrid,
                    selectedIcon: const Icon(Icons.check_rounded, size: 16),
                    onChanged: engine.setShowGrid,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Dynamic M3E Seed Palette Card
        M3ECard(
          variant: M3ECardVariant.filled,
          borderRadius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'M3E Seed Palette',
                style: type.emphasized.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Spring-animated Material 3 Expressive color theme',
                style: type.baseline.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final entry in paletteSeeds)
                    M3EChip(
                      label: entry.name,
                      type: M3EChipType.filter,
                      selected: selectedSeed == entry.seed,
                      leading: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: entry.seed,
                        ),
                      ),
                      onPressed: () => onSeedSelected(entry.seed),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DPad extends StatelessWidget {
  const _DPad({required this.engine});

  final SnakeEngine engine;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        M3EIconButton(
          icon: const Icon(Icons.keyboard_arrow_up_rounded),
          tooltip: 'Up (W / ↑)',
          variant: M3EIconButtonVariant.tonal,
          size: M3EIconButtonSize.md,
          shape: M3EIconButtonShapeVariant.square,
          onPressed: () => engine.steer(SnakeDirection.up),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            M3EIconButton(
              icon: const Icon(Icons.keyboard_arrow_left_rounded),
              tooltip: 'Left (A / ←)',
              variant: M3EIconButtonVariant.tonal,
              size: M3EIconButtonSize.md,
              shape: M3EIconButtonShapeVariant.square,
              onPressed: () => engine.steer(SnakeDirection.left),
            ),
            const SizedBox(width: 6),
            M3EIconButton(
              icon: Icon(
                engine.status == SnakeStatus.running
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
              tooltip: 'Play / Pause (Space)',
              variant: M3EIconButtonVariant.filled,
              size: M3EIconButtonSize.md,
              onPressed: engine.togglePlayPause,
            ),
            const SizedBox(height: 6),
            M3EIconButton(
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
              tooltip: 'Right (D / →)',
              variant: M3EIconButtonVariant.tonal,
              size: M3EIconButtonSize.md,
              shape: M3EIconButtonShapeVariant.square,
              onPressed: () => engine.steer(SnakeDirection.right),
            ),
          ],
        ),
        const SizedBox(height: 6),
        M3EIconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          tooltip: 'Down (S / ↓)',
          variant: M3EIconButtonVariant.tonal,
          size: M3EIconButtonSize.md,
          shape: M3EIconButtonShapeVariant.square,
          onPressed: () => engine.steer(SnakeDirection.down),
        ),
      ],
    );
  }
}
