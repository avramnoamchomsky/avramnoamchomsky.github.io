import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/utils/external_link.dart';
import '../../../data/site_data.dart';

/// Port of official hypr.land `Navbar.svelte`:
/// Left floating `bg-black/50` brand pill + right floating pill container
/// (`bg-black/40`, subtle primary/10 outline) with links, `GitHub` outline pill,
/// and bright `cyan-300` uppercase primary CTA pill.
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
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final showLinks = width >= 920;
          final showOutlineBtn = width >= 540;
          final isNarrow = width < 440;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left standalone translucent pill brand
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onJumpToTop,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isNarrow ? 12 : 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.pureBlack.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '>_',
                                style: tokens.monoStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: tokens.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Flexible(
                                child: Text(
                                  'chomsky',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Right floating nav bar pill
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      showLinks ? 20 : 8,
                      7,
                      7,
                      7,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.pureBlack.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: tokens.primary.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showLinks) ...[
                          _NavTextLink(
                            label: 'Sub-Apps',
                            tokens: tokens,
                            onTap: onJumpToApps,
                          ),
                          const SizedBox(width: 18),
                          _NavTextLink(
                            label: 'Focus',
                            tokens: tokens,
                            onTap: onJumpToFocus,
                          ),
                          const SizedBox(width: 18),
                          _NavTextLink(
                            label: 'Environment',
                            tokens: tokens,
                            onTap: onJumpToStack,
                          ),
                          const SizedBox(width: 18),
                          _SocialIconLink(
                            icon: Icons.code_rounded,
                            tooltip: 'GitHub Repository',
                            tokens: tokens,
                            onTap: () =>
                                openExternalUrl(SiteData.siteRepoUrl),
                          ),
                          const SizedBox(width: 14),
                        ],
                        if (showOutlineBtn) ...[
                          _NavOutlinePill(
                            label: 'GitHub',
                            tokens: tokens,
                            onTap: () =>
                                openExternalUrl(SiteData.githubProfileUrl),
                          ),
                          const SizedBox(width: 10),
                        ],
                        _NavPrimaryPill(
                          label: isNarrow ? 'SNAKE' : 'PLAY SNAKE',
                          tokens: tokens,
                          onTap: () => context.go('/apps/snake'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavTextLink extends StatefulWidget {
  const _NavTextLink({
    required this.label,
    required this.tokens,
    required this.onTap,
  });

  final String label;
  final HyprTokens tokens;
  final VoidCallback onTap;

  @override
  State<_NavTextLink> createState() => _NavTextLinkState();
}

class _NavTextLinkState extends State<_NavTextLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 140),
          style: TextStyle(
            color: _hovered
                ? widget.tokens.primary
                : const Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _SocialIconLink extends StatefulWidget {
  const _SocialIconLink({
    required this.icon,
    required this.tooltip,
    required this.tokens,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final HyprTokens tokens;
  final VoidCallback onTap;

  @override
  State<_SocialIconLink> createState() => _SocialIconLinkState();
}

class _SocialIconLinkState extends State<_SocialIconLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? widget.tokens.primary.withValues(alpha: 0.2)
                  : const Color(0x00000000),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavOutlinePill extends StatefulWidget {
  const _NavOutlinePill({
    required this.label,
    required this.tokens,
    required this.onTap,
  });

  final String label;
  final HyprTokens tokens;
  final VoidCallback onTap;

  @override
  State<_NavOutlinePill> createState() => _NavOutlinePillState();
}

class _NavOutlinePillState extends State<_NavOutlinePill> {
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
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _hovered
                  ? widget.tokens.primary
                  : widget.tokens.slate700,
              width: 1.5,
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavPrimaryPill extends StatefulWidget {
  const _NavPrimaryPill({
    required this.label,
    required this.tokens,
    required this.onTap,
  });

  final String label;
  final HyprTokens tokens;
  final VoidCallback onTap;

  @override
  State<_NavPrimaryPill> createState() => _NavPrimaryPillState();
}

class _NavPrimaryPillState extends State<_NavPrimaryPill> {
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
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: _hovered
                ? const Color(0xFF8BEAFF)
                : widget.tokens.primary,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.tokens.black,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
