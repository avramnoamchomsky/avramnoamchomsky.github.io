import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

enum HyprCardTone { cyan, purple }

/// Official hypr.land `Card.svelte` port:
/// - `24px` (`rounded-3xl`) corners
/// - Pure `#000000` interior separated by a `2px` border (`slate-800` idle)
/// - Pointer-tracking radial glow on the border + soft internal radial bloom on hover.
class HyprCard extends StatefulWidget {
  const HyprCard({
    super.key,
    required this.child,
    this.tone = HyprCardTone.cyan,
    this.onTap,
    this.alwaysHighlight = false,
    this.padding = const EdgeInsets.all(28),
  });

  final Widget child;
  final HyprCardTone tone;
  final VoidCallback? onTap;
  final bool alwaysHighlight;
  final EdgeInsetsGeometry padding;

  @override
  State<HyprCard> createState() => _HyprCardState();
}

class _HyprCardState extends State<HyprCard> {
  bool _hovered = false;
  Alignment _hoverAlignment = const Alignment(0.7, -0.7);

  void _onHover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    final box = context.findRenderObject() as RenderBox?;
    final size = box?.size;
    if (size == null || size.width <= 0 || size.height <= 0) return;

    setState(() {
      _hoverAlignment = Alignment(
        ((event.localPosition.dx / size.width) * 2 - 1).clamp(-1.0, 1.0),
        ((event.localPosition.dy / size.height) * 2 - 1).clamp(-1.0, 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final active = _hovered || widget.alwaysHighlight;

    final primaryGlow = widget.tone == HyprCardTone.purple
        ? tokens.purple400
        : tokens.cyan500;
    final secondaryGlow = widget.tone == HyprCardTone.purple
        ? const Color(0xFF3730A3)
        : const Color(0xFF1D4ED8);

    Widget card = AnimatedContainer(
      duration: disableMotion
          ? Duration.zero
          : const Duration(milliseconds: 240),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: tokens.slate800,
        gradient: active
            ? RadialGradient(
                center: _hoverAlignment,
                radius: 1.15,
                colors: [
                  primaryGlow.withValues(alpha: _hovered ? 0.85 : 0.45),
                  secondaryGlow.withValues(alpha: 0.45),
                  tokens.slate800,
                ],
                stops: const [0.0, 0.45, 1.0],
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Pure black card background (`background: black` in Card.svelte)
            Positioned.fill(child: ColoredBox(color: tokens.pureBlack)),

            // Subtle internal radial bloom on hover
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _hovered ? 1.0 : (widget.alwaysHighlight ? 0.45 : 0.0),
                duration: disableMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 360),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: _hoverAlignment,
                      radius: 1.1,
                      colors: [
                        primaryGlow.withValues(alpha: 0.22),
                        secondaryGlow.withValues(alpha: 0.12),
                        const Color(0x00000000),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            Padding(padding: widget.padding, child: widget.child),
          ],
        ),
      ),
    );

    if (widget.onTap != null) {
      card = GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onHover: disableMotion ? null : _onHover,
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );
  }
}
