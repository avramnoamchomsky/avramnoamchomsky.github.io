import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

/// Clean obsidian hero backdrop with subtle 30px architectural grid, understated
/// top tint, and crisp monochrome wireframe tiling wings on wide screens.
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
        ColoredBox(color: tokens.black),

        // Subtle 30px architectural grid
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _HyprGridPainter(tokens: tokens)),
          ),
        ),

        // 3D perspective wireframe tiling wings in restrained slate/cyan
        if (showWings)
          Positioned.fill(child: _PerspectiveTilingWings(tokens: tokens)),

        // Clean center vignette for effortless text contrast
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    tokens.black.withValues(alpha: 0.84),
                    tokens.black.withValues(alpha: 0.40),
                    const Color(0x00090B0C),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Subtle single-hue top ambient light (no multi-color wash)
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -1.1),
                  radius: 1.1,
                  colors: [
                    tokens.primary.withValues(alpha: 0.14),
                    const Color(0x00090B0C),
                  ],
                  stops: const [0.0, 0.75],
                ),
              ),
            ),
          ),
        ),

        // Clean fade into page body
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 140,
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
      ..color = tokens.slate400.withValues(alpha: 0.045)
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
    final wireIdle = tokens.slate700.withValues(alpha: 0.55);
    final wireAccent = tokens.primary.withValues(alpha: 0.25);

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
                idleColor: wireIdle,
                accentColor: wireAccent,
                hoverColor: tokens.primary,
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
                idleColor: wireIdle,
                accentColor: wireAccent,
                hoverColor: tokens.primary,
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
    required this.idleColor,
    required this.accentColor,
    required this.hoverColor,
  });

  final Color idleColor;
  final Color accentColor;
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _WireTile(idleColor: accentColor, hoverColor: hoverColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _WireTile(
                        idleColor: idleColor,
                        hoverColor: hoverColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _WireTile(
                        idleColor: accentColor,
                        hoverColor: hoverColor,
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
                      child: _WireTile(
                        idleColor: idleColor,
                        hoverColor: hoverColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _WireTile(
                        idleColor: accentColor,
                        hoverColor: hoverColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: _WireTile(idleColor: idleColor, hoverColor: hoverColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WireTile extends StatefulWidget {
  const _WireTile({
    required this.idleColor,
    required this.hoverColor,
  });

  final Color idleColor;
  final Color hoverColor;

  @override
  State<_WireTile> createState() => _WireTileState();
}

class _WireTileState extends State<_WireTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    return MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: (_hovered && !disableMotion) ? 1.015 : 1.0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _hovered
                ? widget.hoverColor.withValues(alpha: 0.08)
                : const Color(0x00000000),
            border: Border.all(
              color: _hovered ? widget.hoverColor : widget.idleColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Clean matte dark page wrapper without rainbow pointer gradients.
class HyprPageCanvas extends StatelessWidget {
  const HyprPageCanvas({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;

    return ColoredBox(color: tokens.black, child: child);
  }
}
