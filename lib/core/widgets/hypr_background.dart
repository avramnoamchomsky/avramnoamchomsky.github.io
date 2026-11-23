import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

/// Ambient Hyprland-inspired background with deep radial auroras, subtle dot grid,
/// and pointer-tracking spotlight on mouse devices.
class HyprBackground extends StatefulWidget {
  const HyprBackground({super.key, required this.child});

  final Widget child;

  @override
  State<HyprBackground> createState() => _HyprBackgroundState();
}

class _HyprBackgroundState extends State<HyprBackground> {
  Offset? _pointerPos;

  void _handlePointerHover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    setState(() => _pointerPos = event.localPosition);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (_pointerPos != null) {
      setState(() => _pointerPos = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HyprTokens>() ?? HyprTokens.dark;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return ColoredBox(
      color: tokens.canvasBg,
      child: MouseRegion(
        opaque: false,
        onHover: disableAnimations ? null : _handlePointerHover,
        onExit: disableAnimations ? null : _handlePointerExit,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _HyprBackdropPainter(
                    tokens: tokens,
                    pointerPos: disableAnimations ? null : _pointerPos,
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

class _HyprBackdropPainter extends CustomPainter {
  const _HyprBackdropPainter({
    required this.tokens,
    required this.pointerPos,
  });

  final HyprTokens tokens;
  final Offset? pointerPos;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Top-left cyan aura
    final cyanAura = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.82, -0.88),
        radius: 1.05,
        colors: [
          tokens.cyan.withValues(alpha: 0.14),
          tokens.cyan.withValues(alpha: 0.03),
          const Color(0x00000000),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, cyanAura);

    // Top-right violet/indigo aura
    final indigoAura = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.88, -0.55),
        radius: 0.95,
        colors: [
          tokens.indigo.withValues(alpha: 0.11),
          const Color(0x00000000),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, indigoAura);

    // Bottom mint glow
    final mintAura = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.25, 0.95),
        radius: 0.95,
        colors: [
          tokens.mint.withValues(alpha: 0.08),
          const Color(0x00000000),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, mintAura);

    // Subtle crisp dot matrix (Wayland compositor workspace texture)
    const spacing = 44.0;
    final dotPaint = Paint()
      ..color = const Color(0x1690B8E8)
      ..style = PaintingStyle.fill;
    final maxY = size.height;
    final maxX = size.width;
    for (double y = spacing / 2; y < maxY; y += spacing) {
      for (double x = spacing / 2; x < maxX; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }

    // Pointer-following soft cyan glow
    final pos = pointerPos;
    if (pos != null) {
      final alignment = Alignment(
        (pos.dx / size.width) * 2 - 1,
        (pos.dy / size.height) * 2 - 1,
      );
      final pointerPaint = Paint()
        ..shader = RadialGradient(
          center: alignment,
          radius: 0.45,
          colors: [
            tokens.cyan.withValues(alpha: 0.09),
            tokens.mint.withValues(alpha: 0.03),
            const Color(0x00000000),
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(rect);
      canvas.drawRect(rect, pointerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HyprBackdropPainter oldDelegate) {
    return oldDelegate.pointerPos != pointerPos || oldDelegate.tokens != tokens;
  }
}
