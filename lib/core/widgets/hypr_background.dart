import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

/// Official hypr.land `HeroBackground` port:
/// - Top radial cyan/sky spotlight flood (`.top-light`)
/// - 30px subtle square grid pattern (`PatternBackground`)
/// - Left and right 3D perspective wings of outlined tiling windows in
///   blue-500 / cyan-400 / sky-500 that glow brightly when hovered.
class HyprHeroBackdrop extends StatelessWidget {
  const HyprHeroBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final width = MediaQuery.sizeOf(context).width;
    final showWings = width >= 640;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Base deep obsidian #090B0C
        ColoredBox(color: tokens.black),

        // 30px subtle grid pattern faded toward bottom (PatternBackground.svelte)
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _HyprGridPainter(tokens: tokens),
            ),
          ),
        ),

        // 3D perspective tiling window wings on desktop/tablet
        if (showWings)
          Positioned.fill(
            child: _PerspectiveTilingWings(tokens: tokens),
          ),

        // Center dark radial vignette so hero text remains crisp over wings
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    tokens.black.withValues(alpha: 0.78),
                    tokens.black.withValues(alpha: 0.32),
                    const Color(0x00090B0C),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Top spotlight radial flood (.top-light in HeroBackground.svelte)
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -1.05),
                  radius: 1.25,
                  colors: [
                    tokens.cyan500.withValues(alpha: 0.45),
                    tokens.sky500.withValues(alpha: 0.18),
                    const Color(0x00090B0C),
                  ],
                  stops: const [0.0, 0.48, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Bottom fade into #090B0C page body
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 150,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    tokens.black.withValues(alpha: 0),
                    tokens.black,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HyprGridPainter extends CustomPainter {
  const _HyprGridPainter({required this.tokens});

  final HyprTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 30.0;
    final paint = Paint()
      ..color = tokens.slate400.withValues(alpha: 0.055)
      ..strokeWidth = 1.0;

    for (double x = 0.5; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0.5; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HyprGridPainter oldDelegate) => false;
}

class _PerspectiveTilingWings extends StatelessWidget {
  const _PerspectiveTilingWings({required this.tokens});

  final HyprTokens tokens;

  @override
  Widget build(BuildContext context) {
    final blue = tokens.blue500;
    const cyan400 = Color(0xFF22D3EE);
    final sky = tokens.sky500;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 48, 10, 28),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0016)
                ..rotateY(0.24),
              child: _TilingColumnCluster(
                palette: [cyan400, blue, sky],
                seedOffset: 0,
              ),
            ),
          ),
          const Spacer(flex: 2),
          Expanded(
            flex: 3,
            child: Transform(
              alignment: Alignment.centerRight,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0016)
                ..rotateY(-0.24),
              child: _TilingColumnCluster(
                palette: [sky, cyan400, blue],
                seedOffset: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TilingColumnCluster extends StatelessWidget {
  const _TilingColumnCluster({
    required this.palette,
    required this.seedOffset,
  });

  final List<Color> palette;
  final int seedOffset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _NeonWireTile(
                  color: palette[(0 + seedOffset) % palette.length],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _NeonWireTile(
                        color: palette[(1 + seedOffset) % palette.length],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _NeonWireTile(
                        color: palette[(2 + seedOffset) % palette.length],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _NeonWireTile(
                        color: palette[(2 + seedOffset) % palette.length],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _NeonWireTile(
                        color: palette[(0 + seedOffset) % palette.length],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: _NeonWireTile(
                  color: palette[(1 + seedOffset) % palette.length],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NeonWireTile extends StatefulWidget {
  const _NeonWireTile({required this.color});

  final Color color;

  @override
  State<_NeonWireTile> createState() => _NeonWireTileState();
}

class _NeonWireTileState extends State<_NeonWireTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    return MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: (_hovered && !disableMotion) ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _hovered
                ? widget.color.withValues(alpha: 0.22)
                : const Color(0x00000000),
            border: Border.all(
              color: widget.color.withValues(alpha: _hovered ? 1.0 : 0.45),
              width: 2,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.7),
                      blurRadius: 12,
                    ),
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.45),
                      blurRadius: 36,
                    ),
                  ]
                : const [],
          ),
        ),
      ),
    );
  }
}

/// Page-wide subtle pointer glow + 30px pattern background matching `PatternBackground.svelte`.
class HyprPageCanvas extends StatefulWidget {
  const HyprPageCanvas({super.key, required this.child});

  final Widget child;

  @override
  State<HyprPageCanvas> createState() => _HyprPageCanvasState();
}

class _HyprPageCanvasState extends State<HyprPageCanvas> {
  Offset? _pointerPos;

  void _onHover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    setState(() => _pointerPos = event.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final disableMotion = MediaQuery.disableAnimationsOf(context);

    return ColoredBox(
      color: tokens.black,
      child: MouseRegion(
        opaque: false,
        onHover: disableMotion ? null : _onHover,
        onExit: (_) => setState(() => _pointerPos = null),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_pointerPos != null && !disableMotion)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _PointerAuraPainter(
                      pointerPos: _pointerPos!,
                      tokens: tokens,
                    ),
                  ),
                ),
              ),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _PointerAuraPainter extends CustomPainter {
  const _PointerAuraPainter({
    required this.pointerPos,
    required this.tokens,
  });

  final Offset pointerPos;
  final HyprTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final align = Alignment(
      (pointerPos.dx / math.max(1, size.width)) * 2 - 1,
      (pointerPos.dy / math.max(1, size.height)) * 2 - 1,
    );
    final paint = Paint()
      ..shader = RadialGradient(
        center: align,
        radius: 0.42,
        colors: [
          tokens.cyan300.withValues(alpha: 0.08),
          tokens.blue500.withValues(alpha: 0.03),
          const Color(0x00000000),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _PointerAuraPainter oldDelegate) =>
      oldDelegate.pointerPos != pointerPos;
}
