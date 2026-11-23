import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

enum HyprButtonStyle { primary, outline, fancyOutline }

enum HyprButtonSize { md, lg, xl }

/// Port of hypr.land's `Button.svelte` supporting `primary` (`slate-200` on
/// black), `outline`, and `fancyOutline` (animated cycling cyan/blue/purple halo).
class HyprButton extends StatefulWidget {
  const HyprButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = HyprButtonStyle.primary,
    this.size = HyprButtonSize.lg,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback onPressed;
  final HyprButtonStyle style;
  final HyprButtonSize size;
  final IconData? trailingIcon;

  @override
  State<HyprButton> createState() => _HyprButtonState();
}

class _HyprButtonState extends State<HyprButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _haloController;
  bool _hovered = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _haloController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    if (widget.style == HyprButtonStyle.fancyOutline && !disableMotion) {
      if (!_haloController.isAnimating) {
        _haloController.repeat();
      }
    } else {
      _haloController.stop();
    }
  }

  @override
  void dispose() {
    _haloController.dispose();
    super.dispose();
  }

  EdgeInsets get _padding => switch (widget.size) {
    HyprButtonSize.md => const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
    HyprButtonSize.lg => const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
    HyprButtonSize.xl => const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
  };

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final scale = _pressed ? 0.99 : (_hovered && !disableMotion ? 1.02 : 1.0);

    final (bgColor, fgColor, border) = switch (widget.style) {
      HyprButtonStyle.primary => (
        _hovered ? const Color(0xFFFFFFFF) : tokens.slate200,
        tokens.black,
        null,
      ),
      HyprButtonStyle.outline => (
        _hovered ? const Color(0x14FFFFFF) : const Color(0x00000000),
        const Color(0xFFFFFFFF),
        Border.all(color: tokens.slate200, width: 2),
      ),
      HyprButtonStyle.fancyOutline => (
        tokens.black.withValues(alpha: 0.72),
        const Color(0xFFFFFFFF),
        Border.all(color: tokens.primary, width: 2),
      ),
    };

    final buttonCore = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            constraints: const BoxConstraints(minWidth: 96),
            padding: _padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(5),
              border: border,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
                if (widget.trailingIcon != null) ...[
                  const SizedBox(width: 6),
                  Icon(widget.trailingIcon, size: 16, color: fgColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.style != HyprButtonStyle.fancyOutline) {
      return buttonCore;
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _haloController,
              builder: (context, _) {
                final t = disableMotion ? 0.0 : _haloController.value;
                // Cycle smoothly through cyan-500 -> secondary -> purple-500
                final phase = t * 3.0;
                final haloColor = phase < 1.0
                    ? Color.lerp(
                        tokens.cyan500,
                        tokens.secondary,
                        phase,
                      )!
                    : (phase < 2.0
                          ? Color.lerp(
                              tokens.secondary,
                              tokens.purple400,
                              phase - 1.0,
                            )!
                          : Color.lerp(
                              tokens.purple400,
                              tokens.cyan500,
                              phase - 2.0,
                            )!);
                final pulse =
                    0.75 + 0.18 * math.sin(t * math.pi * 2);

                return Transform.scale(
                  scaleX: 1.08,
                  scaleY: 0.78,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: haloColor.withValues(
                            alpha: _hovered ? 0.9 : 0.72 * pulse,
                          ),
                          blurRadius: _hovered ? 32 : 24,
                          spreadRadius: _hovered ? 2 : 0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        buttonCore,
      ],
    );
  }
}
