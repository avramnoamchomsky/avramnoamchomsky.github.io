import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/utils/external_link.dart';
import '../../../data/site_data.dart';

/// Floating frosted-glass Hyprland-style top bar with workspace indicators.
class HyprNavbar extends StatelessWidget {
  const HyprNavbar({
    super.key,
    required this.onJumpToApps,
    required this.onJumpToFocus,
    required this.onJumpToStack,
    required this.onJumpToTop,
  });

  final VoidCallback onJumpToApps;
  final VoidCallback onJumpToFocus;
  final VoidCallback onJumpToStack;
  final VoidCallback onJumpToTop;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HyprTokens>() ?? HyprTokens.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final showSectionLinks = width >= 840;
              final showWorkspaces = width >= 620;
              final compactMobile = width < 500;

              return ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: compactMobile ? 10 : 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xBD080D16),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: tokens.borderIdle),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x44000000),
                          blurRadius: 28,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (showWorkspaces) ...[
                          _NavBrand(
                            tokens: tokens,
                            onTap: onJumpToTop,
                            compact: compactMobile,
                          ),
                          const SizedBox(width: 16),
                          _WorkspacePills(
                            tokens: tokens,
                            onOpenHome: onJumpToTop,
                            onOpenSnake: () => context.go('/apps/snake'),
                          ),
                          const Spacer(),
                        ] else
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _NavBrand(
                                tokens: tokens,
                                onTap: onJumpToTop,
                                compact: compactMobile,
                              ),
                            ),
                          ),
                        if (showSectionLinks) ...[
                          _NavLink(
                            label: 'Apps',
                            onTap: onJumpToApps,
                            tokens: tokens,
                          ),
                          _NavLink(
                            label: 'Focus',
                            onTap: onJumpToFocus,
                            tokens: tokens,
                          ),
                          _NavLink(
                            label: 'Stack',
                            onTap: onJumpToStack,
                            tokens: tokens,
                          ),
                          const SizedBox(width: 8),
                        ],
                        M3EButton.filled(
                          onPressed: () => context.go('/apps/snake'),
                          size: M3EButtonSize.xs,
                          shape: M3EButtonShape.round,
                          icon: const Icon(
                            Icons.videogame_asset_rounded,
                            size: 16,
                          ),
                          label: const Text('Snake'),
                          decoration: M3EButtonDecoration(
                            backgroundGradient: WidgetStateProperty.all(
                              LinearGradient(
                                colors: [tokens.cyan, tokens.mint],
                              ),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              const Color(0xFF041013),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (compactMobile)
                          M3EIconButton(
                            icon: Icon(
                              Icons.north_east_rounded,
                              size: 18,
                              color: tokens.cyan,
                            ),
                            tooltip: 'GitHub Profile',
                            variant: M3EIconButtonVariant.outlined,
                            size: M3EIconButtonSize.xs,
                            onPressed: () =>
                                openExternalUrl(SiteData.githubProfileUrl),
                          )
                        else
                          M3EButton.outlined(
                            onPressed: () =>
                                openExternalUrl(SiteData.githubProfileUrl),
                            size: M3EButtonSize.xs,
                            shape: M3EButtonShape.round,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'GitHub',
                                  style: TextStyle(
                                    color: tokens.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.north_east_rounded,
                                  size: 14,
                                  color: tokens.cyan,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavBrand extends StatelessWidget {
  const _NavBrand({
    required this.tokens,
    required this.onTap,
    this.compact = false,
  });

  final HyprTokens tokens;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 4 : 6,
            vertical: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '>_',
                style: tokens.monoStyle(
                  fontSize: compact ? 14 : 15,
                  fontWeight: FontWeight.w800,
                  color: tokens.mint,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'chomsky',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 14 : 15,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspacePills extends StatelessWidget {
  const _WorkspacePills({
    required this.tokens,
    required this.onOpenHome,
    required this.onOpenSnake,
  });

  final HyprTokens tokens;
  final VoidCallback onOpenHome;
  final VoidCallback onOpenSnake;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0x6604070C),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tokens.borderIdle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WorkspaceTab(
            label: '1:home',
            active: true,
            tokens: tokens,
            onTap: onOpenHome,
          ),
          const SizedBox(width: 4),
          _WorkspaceTab(
            label: '2:snake',
            active: false,
            tokens: tokens,
            onTap: onOpenSnake,
          ),
        ],
      ),
    );
  }
}

class _WorkspaceTab extends StatefulWidget {
  const _WorkspaceTab({
    required this.label,
    required this.active,
    required this.tokens,
    required this.onTap,
  });

  final String label;
  final bool active;
  final HyprTokens tokens;
  final VoidCallback onTap;

  @override
  State<_WorkspaceTab> createState() => _WorkspaceTabState();
}

class _WorkspaceTabState extends State<_WorkspaceTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: widget.active
                ? LinearGradient(
                    colors: [
                      widget.tokens.cyan.withValues(alpha: 0.25),
                      widget.tokens.mint.withValues(alpha: 0.22),
                    ],
                  )
                : null,
            color: !widget.active && _hovered
                ? const Color(0x16FFFFFF)
                : null,
          ),
          child: Text(
            widget.label,
            style: widget.tokens.monoStyle(
              fontSize: 11.5,
              fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
              color: widget.active
                  ? widget.tokens.mint
                  : widget.tokens.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.onTap,
    required this.tokens,
  });

  final String label;
  final VoidCallback onTap;
  final HyprTokens tokens;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            widget.label,
            style: TextStyle(
              color: _hovered
                  ? widget.tokens.textPrimary
                  : widget.tokens.textSecondary,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
