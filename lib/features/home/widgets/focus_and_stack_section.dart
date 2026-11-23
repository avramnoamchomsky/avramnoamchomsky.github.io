import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/widgets/hypr_button.dart';
import '../../../core/widgets/hypr_card.dart';
import '../../../data/site_data.dart';

/// Port of official hypr.land `InstallSlice.svelte` + focus cards + `Footer.svelte`.
class FocusSection extends StatelessWidget {
  const FocusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;

    return Column(
      children: [
        Text(
          'ENGINEERING',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tokens.slate300,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'What I explore',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w800,
            fontSize: 48,
            letterSpacing: -1.3,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Understanding machines from hardware registers up to expressive interfaces.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tokens.slate300,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 40),

        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final cards = [
              for (final item in SiteData.focusDomains)
                HyprCard(
                  alwaysHighlight: item.featured,
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item.glyph,
                        style: tokens.monoStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: item.featured
                              ? tokens.primary
                              : tokens.slate300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: Color(0xB3FFFFFF),
                          fontSize: 14.5,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in item.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: tokens.slate800),
                                color: tokens.black,
                              ),
                              child: Text(
                                tag,
                                style: tokens.monoStyle(
                                  fontSize: 11,
                                  color: tokens.slate300,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
            ];

            if (isDesktop) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      Expanded(child: cards[i]),
                    ],
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  cards[i],
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Official `InstallSlice.svelte` style blue-gradient container + `Footer.svelte` footer.
class StackAndFooterSection extends StatelessWidget {
  const StackAndFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final year = DateTime.now().year;

    return Column(
      children: [
        const Text(
          'Current stack',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w800,
            fontSize: 48,
            letterSpacing: -1.3,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'NixOS, Wayland, embedded tooling & Flutter',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tokens.slate300,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 36),

        // Restrained matte dark container with crisp 1px slate border
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: tokens.slate800, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StackCommandRow(
                  label: 'NixOS',
                  command: 'programs.hyprland.enable = true;',
                  subtitle: 'Declarative Flake config & Wayland workflow',
                  tokens: tokens,
                  linkLabel: 'nixos-config ↗',
                  onLinkTap: () => openExternalUrl(SiteData.nixosConfigUrl),
                ),
                const SizedBox(height: 18),
                _StackCommandRow(
                  label: 'Flutter Web',
                  command: 'flutter run -d chrome',
                  subtitle: 'Material 3 Expressive + cross-platform Linux target',
                  tokens: tokens,
                  linkLabel: 'Play Snake →',
                  onLinkTap: () => context.go('/apps/snake'),
                ),
                const SizedBox(height: 18),
                _StackCommandRow(
                  label: 'Source',
                  command: 'git clone ${SiteData.siteRepoUrl}.git',
                  subtitle: 'Open-source personal site hosted on GitHub Pages',
                  tokens: tokens,
                  linkLabel: 'Repository ↗',
                  onLinkTap: () => openExternalUrl(SiteData.siteRepoUrl),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        HyprButton(
          label: 'GitHub Profile',
          style: HyprButtonStyle.accentOutline,
          size: HyprButtonSize.lg,
          trailingIcon: Icons.north_east_rounded,
          onPressed: () => openExternalUrl(SiteData.githubProfileUrl),
        ),

        const SizedBox(height: 96),

        // Clean matte dark footer
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: tokens.pureBlack,
            border: Border(
              top: BorderSide(color: tokens.slate800),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 64,
                    runSpacing: 32,
                    children: [
                      _FooterCol(
                        title: 'CHOMSKY',
                        tokens: tokens,
                        items: [
                          (
                            label: 'NixOS & Embedded Systems',
                            accent: '[ Core Focus ]',
                            onTap: null,
                          ),
                          (
                            label: 'Flutter & M3 Expressive',
                            accent: '[ Cross-Platform ]',
                            onTap: () => context.go('/apps/snake'),
                          ),
                        ],
                      ),
                      _FooterCol(
                        title: 'APPS',
                        tokens: tokens,
                        items: [
                          (
                            label: 'M3E Snake',
                            accent: 'LIVE',
                            onTap: () => context.go('/apps/snake'),
                          ),
                          (
                            label: 'Bitfield & Register Lab',
                            accent: 'PLANNED',
                            onTap: null,
                          ),
                          (
                            label: 'chomsky@nixos Shell',
                            accent: 'PLANNED',
                            onTap: null,
                          ),
                        ],
                      ),
                      _FooterCol(
                        title: 'LINKS',
                        tokens: tokens,
                        items: [
                          (
                            label: 'GitHub Profile',
                            accent: '↗',
                            onTap: () =>
                                openExternalUrl(SiteData.githubProfileUrl),
                          ),
                          (
                            label: 'nixos-config',
                            accent: '↗',
                            onTap: () =>
                                openExternalUrl(SiteData.nixosConfigUrl),
                          ),
                          (
                            label: 'Site Source',
                            accent: '↗',
                            onTap: () => openExternalUrl(SiteData.siteRepoUrl),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Text(
                    '© Chomsky $year  •  Built with Flutter & Material 3 Expressive  •  Inspired by hypr.land',
                    style: TextStyle(
                      color: tokens.slate400,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StackCommandRow extends StatelessWidget {
  const _StackCommandRow({
    required this.label,
    required this.command,
    required this.subtitle,
    required this.tokens,
    required this.linkLabel,
    required this.onLinkTap,
  });

  final String label;
  final String command;
  final String subtitle;
  final HyprTokens tokens;
  final String linkLabel;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 680;
    final cmdBox = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Text(
            '> ',
            style: tokens.monoStyle(
              fontSize: 13,
              color: tokens.slate400,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              command,
              overflow: TextOverflow.ellipsis,
              style: tokens.monoStyle(fontSize: 13, color: tokens.slate200),
            ),
          ),
          const SizedBox(width: 8),
          M3EIconButton(
            icon: Icon(Icons.copy_rounded, size: 16, color: tokens.slate300),
            tooltip: 'Copy command',
            variant: M3EIconButtonVariant.standard,
            size: M3EIconButtonSize.xs,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: command));
              M3ESnackbar.show(context, message: 'Copied: $command');
            },
          ),
        ],
      ),
    );

    final meta = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(color: tokens.slate300, fontSize: 13),
        ),
        const SizedBox(height: 6),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onLinkTap,
            child: Text(
              linkLabel,
              style: TextStyle(
                color: tokens.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 4, child: meta),
          const SizedBox(width: 20),
          Expanded(flex: 6, child: cmdBox),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [meta, const SizedBox(height: 10), cmdBox],
    );
  }
}

class _FooterCol extends StatelessWidget {
  const _FooterCol({
    required this.title,
    required this.tokens,
    required this.items,
  });

  final String title;
  final HyprTokens tokens;
  final List<({String label, String accent, VoidCallback? onTap})> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: tokens.slate400,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 14),
        for (final item in items) ...[
          MouseRegion(
            cursor: item.onTap != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: GestureDetector(
              onTap: item.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: tokens.slate300,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: '${item.label} '),
                      TextSpan(
                        text: item.accent,
                        style: TextStyle(
                          color: tokens.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
