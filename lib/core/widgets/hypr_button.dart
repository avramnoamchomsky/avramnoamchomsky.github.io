import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

enum HyprButtonStyle { primary, outline, accentOutline }

enum HyprButtonSize { md, lg, xl }

/// Crisp minimalist Hyprland-style rectangular action button with clean
/// solid/outline states and zero multi-color glow halos.
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

class _HyprButtonState extends State<HyprButton> {
  bool _hovered = false;
  bool _pressed = false;

  EdgeInsets get _padding => switch (widget.size) {
    HyprButtonSize.md => const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
    HyprButtonSize.lg => const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
    HyprButtonSize.xl => const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
  };

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final scale = _pressed ? 0.99 : (_hovered && !disableMotion ? 1.015 : 1.0);

    final (bgColor, fgColor, border) = switch (widget.style) {
      HyprButtonStyle.primary => (
        _hovered ? const Color(0xFFFFFFFF) : tokens.slate200,
        tokens.black,
        null,
      ),
      HyprButtonStyle.outline => (
        _hovered ? tokens.surface : const Color(0x00000000),
        const Color(0xFFFFFFFF),
        Border.all(
          color: _hovered ? tokens.slate200 : tokens.slate700,
          width: 1.5,
        ),
      ),
      HyprButtonStyle.accentOutline => (
        _hovered
            ? tokens.primary.withValues(alpha: 0.12)
            : tokens.black.withValues(alpha: 0.85),
        const Color(0xFFFFFFFF),
        Border.all(
          color: _hovered
              ? tokens.primary
              : tokens.primary.withValues(alpha: 0.75),
          width: 1.5,
        ),
      ),
    };

    return MouseRegion(
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
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            constraints: const BoxConstraints(minWidth: 96),
            padding: _padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
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
  }
}
