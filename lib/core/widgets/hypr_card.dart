import 'package:material_ui/material_ui.dart';

import '../theme/hypr_tokens.dart';

/// Crisp matte obsidian card (`#050708` / `#0E1216`) with a restrained
/// single-color border that highlights cleanly in `#58E1FF` on hover.
class HyprCard extends StatefulWidget {
  const HyprCard({
    super.key,
    required this.child,
    this.onTap,
    this.alwaysHighlight = false,
    this.padding = const EdgeInsets.all(28),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool alwaysHighlight;
  final EdgeInsetsGeometry padding;

  @override
  State<HyprCard> createState() => _HyprCardState();
}

class _HyprCardState extends State<HyprCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final active = _hovered || widget.alwaysHighlight;

    Widget card = AnimatedContainer(
      duration: disableMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: _hovered ? tokens.surface : tokens.pureBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _hovered
              ? tokens.primary.withValues(alpha: 0.8)
              : (active
                    ? tokens.primary.withValues(alpha: 0.4)
                    : tokens.slate800),
          width: 1.5,
        ),
      ),
      child: widget.child,
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
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );
  }
}
