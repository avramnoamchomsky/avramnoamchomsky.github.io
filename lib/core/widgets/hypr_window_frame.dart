import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

/// A Hyprland-style tiling window container with animated active gradient border
/// on hover/focus and optional window chrome header.
class HyprWindowFrame extends StatefulWidget {
  const HyprWindowFrame({
    super.key,
    required this.child,
    this.title,
    this.badge,
    this.onTap,
    this.alwaysActive = false,
    this.padding = const EdgeInsets.all(22),
    this.borderRadius = 18,
  });

  final Widget child;
  final String? title;
  final String? badge;
  final VoidCallback? onTap;
  final bool alwaysActive;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  State<HyprWindowFrame> createState() => _HyprWindowFrameState();
}

class _HyprWindowFrameState extends State<HyprWindowFrame> {
  bool _hovered = false;
  bool _focused = false;

  bool get _isActive => widget.alwaysActive || _hovered || _focused;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HyprTokens>() ?? HyprTokens.dark;
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final duration = disableMotion
        ? Duration.zero
        : const Duration(milliseconds: 200);
    final radius = BorderRadius.circular(widget.borderRadius);
    final innerRadius = BorderRadius.circular(widget.borderRadius - 1.5);

    Widget content = AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(
        0,
        (_hovered && widget.onTap != null && !disableMotion) ? -3.0 : 0.0,
        0,
      ),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: _isActive ? tokens.activeBorderGradient : null,
        color: _isActive ? null : tokens.borderIdle,
        boxShadow: [
          BoxShadow(
            color: const Color(0x55000000),
            blurRadius: _isActive ? 28 : 16,
            offset: const Offset(0, 14),
          ),
          if (_isActive)
            BoxShadow(
              color: tokens.cyan.withValues(alpha: 0.14),
              blurRadius: 28,
              spreadRadius: -4,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: innerRadius,
        child: Container(
          decoration: BoxDecoration(
            color: _hovered
                ? tokens.surfaceElevated
                : tokens.surfaceGlass,
            borderRadius: innerRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null || widget.badge != null)
                _WindowTitleBar(
                  title: widget.title,
                  badge: widget.badge,
                  active: _isActive,
                  tokens: tokens,
                ),
              Padding(padding: widget.padding, child: widget.child),
            ],
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      content = FocusableActionDetector(
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: content,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: content,
    );
  }
}

class _WindowTitleBar extends StatelessWidget {
  const _WindowTitleBar({
    required this.title,
    required this.badge,
    required this.active,
    required this.tokens,
  });

  final String? title;
  final String? badge;
  final bool active;
  final HyprTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x55060A11),
        border: Border(bottom: BorderSide(color: tokens.borderIdle)),
      ),
      child: Row(
        children: [
          _Dot(color: active ? tokens.cyan : tokens.textMuted),
          const SizedBox(width: 6),
          _Dot(color: active ? tokens.mint : tokens.textMuted.withValues(alpha: 0.7)),
          const SizedBox(width: 6),
          _Dot(color: active ? tokens.indigo : tokens.textMuted.withValues(alpha: 0.45)),
          const SizedBox(width: 12),
          if (title != null)
            Expanded(
              child: Text(
                title!,
                overflow: TextOverflow.ellipsis,
                style: tokens.monoStyle(
                  fontSize: 12,
                  color: active ? tokens.textPrimary : tokens.textSecondary,
                ),
              ),
            )
          else
            const Spacer(),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: active
                    ? tokens.cyan.withValues(alpha: 0.14)
                    : const Color(0x14FFFFFF),
                border: Border.all(
                  color: active
                      ? tokens.cyan.withValues(alpha: 0.45)
                      : tokens.borderIdle,
                ),
              ),
              child: Text(
                badge!,
                style: tokens.monoStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active ? tokens.mint : tokens.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
