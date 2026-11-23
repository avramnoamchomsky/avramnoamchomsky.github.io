import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/widgets/hypr_window_frame.dart';
import '../../../data/site_data.dart';

/// Focus domains section rendered in a Hyprland-inspired tiling layout.
class FocusSection extends StatelessWidget {
  const FocusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HyprTokens>() ?? HyprTokens.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '02',
              style: tokens.monoStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: tokens.mint,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'FOCUS',
              style: tokens.monoStyle(
                fontSize: 12,
                color: tokens.textMuted,
                letterSpacing: 1.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "What I'm exploring",
          style: TextStyle(
            color: tokens.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final cards = [
              for (final item in SiteData.focusDomains)
                HyprWindowFrame(
                  title: 'focus://${item.indexLabel}',
                  badge: item.featured ? 'CORE' : null,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.glyph,
                        style: tokens.monoStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: item.featured ? tokens.mint : tokens.cyan,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: tokens.textPrimary,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: TextStyle(
                          color: tokens.textSecondary,
                          fontSize: 14.5,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 18),
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
                                border: Border.all(color: tokens.borderIdle),
                                color: const Color(0x0AFFFFFF),
                              ),
                              child: Text(
                                tag,
                                style: tokens.monoStyle(
                                  fontSize: 11,
                                  color: tokens.textSecondary,
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

/// Environment pills, NixOS dotfiles link, and minimal footer.
class StackAndFooterSection extends StatelessWidget {
  const StackAndFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HyprTokens>() ?? HyprTokens.dark;
    final year = DateTime.now().year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '03',
              style: tokens.monoStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: tokens.mint,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'ENVIRONMENT',
              style: tokens.monoStyle(
                fontSize: 12,
                color: tokens.textMuted,
                letterSpacing: 1.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Current stack',
          style: TextStyle(
            color: tokens.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final tool in SiteData.environmentStack)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: tokens.surfaceGlass,
                  border: Border.all(color: tokens.borderIdle),
                ),
                child: Text(
                  tool,
                  style: tokens.monoStyle(
                    fontSize: 13,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 28),
        HyprWindowFrame(
          title: 'repo://nixos-config',
          badge: 'GITHUB ↗',
          onTap: () => openExternalUrl(SiteData.nixosConfigUrl),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NixOS Configuration',
                      style: TextStyle(
                        color: tokens.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Declarative NixOS setup, Wayland experiments, and system tooling.',
                      style: TextStyle(
                        color: tokens.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.north_east_rounded, color: tokens.cyan, size: 22),
            ],
          ),
        ),
        const SizedBox(height: 64),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 26),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: tokens.borderIdle)),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '>_ ',
                    style: tokens.monoStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: tokens.mint,
                    ),
                  ),
                  Text(
                    'Chomsky',
                    style: TextStyle(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
              Text(
                'Embedded systems • Linux • Flutter & M3E   |   © $year',
                style: tokens.monoStyle(
                  fontSize: 12,
                  color: tokens.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
