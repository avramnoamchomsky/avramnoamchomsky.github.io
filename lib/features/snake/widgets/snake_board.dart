import 'dart:math' as math;

import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../snake_engine.dart';

/// Expressive interactive Snake canvas supporting swipe gestures and M3E overlays.
class SnakeBoard extends StatefulWidget {
  const SnakeBoard({
    super.key,
    required this.engine,
  });

  final SnakeEngine engine;

  @override
  State<SnakeBoard> createState() => _SnakeBoardState();
}

class _SnakeBoardState extends State<SnakeBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Offset _panAccum = Offset.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    if (disableMotion) {
      _pulseController.stop();
    } else if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _panAccum += details.delta;
    const threshold = 22.0;
    if (_panAccum.distance < threshold) return;

    if (_panAccum.dx.abs() > _panAccum.dy.abs()) {
      widget.engine.steer(
        _panAccum.dx > 0 ? SnakeDirection.right : SnakeDirection.left,
      );
    } else {
      widget.engine.steer(
        _panAccum.dy > 0 ? SnakeDirection.down : SnakeDirection.up,
      );
    }
    _panAccum = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    final m3e = M3ETheme.of(context);
    final scheme = m3e.colorScheme;
    final disableMotion = MediaQuery.disableAnimationsOf(context);

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onPanStart: (_) => _panAccum = Offset.zero,
        onPanUpdate: _handlePanUpdate,
        onTap: () {
          if (widget.engine.status == SnakeStatus.ready ||
              widget.engine.status == SnakeStatus.paused) {
            widget.engine.startOrResume();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: widget.engine.status == SnakeStatus.gameOver
                  ? scheme.error.withValues(alpha: 0.7)
                  : scheme.outlineVariant,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.08),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([
                  widget.engine,
                  if (!disableMotion) _pulseController,
                ]),
                builder: (context, _) {
                  return CustomPaint(
                    painter: _SnakeBoardPainter(
                      engine: widget.engine,
                      scheme: scheme,
                      foodPulse: disableMotion ? 0.5 : _pulseController.value,
                    ),
                  );
                },
              ),
              if (widget.engine.status != SnakeStatus.running)
                _StatusOverlay(engine: widget.engine),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusOverlay extends StatelessWidget {
  const _StatusOverlay({required this.engine});

  final SnakeEngine engine;

  @override
  Widget build(BuildContext context) {
    final m3e = M3ETheme.of(context);
    final scheme = m3e.colorScheme;
    final type = m3e.typography;

    final (title, subtitle, ctaLabel, icon) = switch (engine.status) {
      SnakeStatus.ready => (
        'Ready to Play',
        'Press Space, Arrow/WASD keys, or swipe to launch.',
        'Start Game',
        Icons.play_arrow_rounded,
      ),
      SnakeStatus.paused => (
        'Game Paused',
        'Take a breather — press Space or tap Resume.',
        'Resume',
        Icons.play_arrow_rounded,
      ),
      SnakeStatus.gameOver => (
        'Game Over',
        'Score: ${engine.score}  •  Best: ${engine.bestScore}',
        'Play Again',
        Icons.replay_rounded,
      ),
      SnakeStatus.won => (
        'Board Cleared!',
        'Perfect run — ${engine.score} points!',
        'Play Again',
        Icons.emoji_events_rounded,
      ),
      SnakeStatus.running => ('', '', '', Icons.play_arrow_rounded),
    };

    return ColoredBox(
      color: scheme.surface.withValues(alpha: 0.78),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: M3ECard(
              variant: M3ECardVariant.elevated,
              borderRadius: BorderRadius.circular(24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 248,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 32,
                        color: engine.status == SnakeStatus.gameOver
                            ? scheme.error
                            : scheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: type.emphasized.headlineSmall.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: type.baseline.bodyMedium.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      M3EButton.filled(
                        onPressed: engine.startOrResume,
                        size: M3EButtonSize.md,
                        shape: M3EButtonShape.round,
                        icon: Icon(icon, size: 20),
                        label: Text(ctaLabel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SnakeBoardPainter extends CustomPainter {
  const _SnakeBoardPainter({
    required this.engine,
    required this.scheme,
    required this.foodPulse,
  });

  final SnakeEngine engine;
  final M3EColorScheme scheme;
  final double foodPulse;

  @override
  void paint(Canvas canvas, Size size) {
    final n = engine.gridSize;
    final cellW = size.width / n;
    final cellH = size.height / n;

    // Optional subtle expressive grid lines
    if (engine.showGrid) {
      final gridPaint = Paint()
        ..color = scheme.outlineVariant.withValues(alpha: 0.25)
        ..strokeWidth = 1.0;

      for (var i = 1; i < n; i++) {
        final x = i * cellW;
        final y = i * cellH;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // Draw clean single-hue food orb
    final food = engine.food;
    final foodCenter = Offset(
      (food.x + 0.5) * cellW,
      (food.y + 0.5) * cellH,
    );
    final baseRadius = math.min(cellW, cellH) * 0.34;
    final foodColor = scheme.brightness == Brightness.dark
        ? const Color(0xFFF43F5E)
        : const Color(0xFFE11D48);

    final ringPaint = Paint()
      ..color = foodColor.withValues(alpha: 0.35 + 0.25 * foodPulse)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(
      foodCenter,
      baseRadius * (1.22 + 0.14 * foodPulse),
      ringPaint,
    );

    final foodPaint = Paint()..color = foodColor;
    canvas.drawCircle(
      foodCenter,
      baseRadius * (0.94 + 0.08 * foodPulse),
      foodPaint,
    );

    // Draw snake body from tail to head using clean single-hue opacity steps
    final snake = engine.snake;
    final total = snake.length;
    for (var i = total - 1; i >= 0; i--) {
      final pt = snake[i];
      final t = total <= 1 ? 0.0 : i / (total - 1);
      final inset = math.min(cellW, cellH) * (i == 0 ? 0.06 : 0.11);
      final rect = Rect.fromLTWH(
        pt.x * cellW + inset,
        pt.y * cellH + inset,
        cellW - inset * 2,
        cellH - inset * 2,
      );
      final radius = Radius.circular(
        i == 0 ? math.min(cellW, cellH) * 0.34 : math.min(cellW, cellH) * 0.28,
      );

      final segmentColor = i == 0
          ? scheme.primary
          : scheme.primary.withValues(alpha: (0.82 - t * 0.48).clamp(0.32, 0.85));

      final paint = Paint()..color = segmentColor;
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);

      if (i == 0) {
        _drawHeadEyes(canvas, rect, engine.direction, scheme.onPrimary);
      }
    }
  }

  void _drawHeadEyes(
    Canvas canvas,
    Rect headRect,
    SnakeDirection dir,
    Color eyeColor,
  ) {
    final eyePaint = Paint()..color = eyeColor;
    final r = math.max(1.8, headRect.width * 0.11);
    final cx = headRect.center.dx;
    final cy = headRect.center.dy;
    final forward = headRect.width * 0.18;
    final side = headRect.width * 0.20;

    final (eyeA, eyeB) = switch (dir) {
      SnakeDirection.right => (
        Offset(cx + forward, cy - side),
        Offset(cx + forward, cy + side),
      ),
      SnakeDirection.left => (
        Offset(cx - forward, cy - side),
        Offset(cx - forward, cy + side),
      ),
      SnakeDirection.up => (
        Offset(cx - side, cy - forward),
        Offset(cx + side, cy - forward),
      ),
      SnakeDirection.down => (
        Offset(cx - side, cy + forward),
        Offset(cx + side, cy + forward),
      ),
    };

    canvas.drawCircle(eyeA, r, eyePaint);
    canvas.drawCircle(eyeB, r, eyePaint);
  }

  @override
  bool shouldRepaint(covariant _SnakeBoardPainter oldDelegate) => true;
}
