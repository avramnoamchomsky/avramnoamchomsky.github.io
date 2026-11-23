import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/widgets/hypr_window_frame.dart';
import '../../../data/site_data.dart';

/// Section showcasing secondary M3E mini-apps launchable from the homepage.
class SubAppsSection extends StatelessWidget {
  const SubAppsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HyprTokens>() ?? HyprTokens.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          index: '01',
          eyebrow: 'MINI-APPS // M3E',
          title: 'Interactive Sub-Apps',
          subtitle:
              'Self-contained Material 3 Expressive applets built to run smoothly on Web, Linux desktop, and mobile.',
          tokens: tokens,
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final cards = [
              for (final app in SiteData.subApps)
                _SubAppCard(
                  app: app,
                  tokens: tokens,
                  onActivate: () => _openSubApp(context, app),
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

  void _openSubApp(BuildContext context, SubAppEntry app) {
    if (app.isLive && app.route != null) {
      context.go(app.route!);
      return;
    }

    M3EDialog.show<void>(
      context,
      dialog: M3EDialog(
        title: app.title,
        subhead: 'Upcoming M3E Sub-App',
        icon: Icon(app.icon, color: app.accentColor),
        content: Text(
          '${app.description}\n\n'
          'Currently in planning — try M3E Snake today to test the live '
          'Material 3 Expressive sub-app architecture.',
        ),
        actions: [
          M3EButton.text(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          M3EButton.filled(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/apps/snake');
            },
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Try M3E Snake'),
          ),
        ],
      ),
    );
  }
}

class _SubAppCard extends StatelessWidget {
  const _SubAppCard({
    required this.app,
    required this.tokens,
    required this.onActivate,
  });

  final SubAppEntry app;
  final HyprTokens tokens;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    return HyprWindowFrame(
      title: 'app://${app.id}',
      badge: app.isLive ? 'LIVE • M3E' : 'PLANNED',
      alwaysActive: app.isLive,
      onTap: onActivate,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: app.accentColor.withValues(alpha: 0.14),
                  border: Border.all(
                    color: app.accentColor.withValues(alpha: 0.45),
                  ),
                ),
                child: Icon(app.icon, color: app.accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.category,
                      style: tokens.monoStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: app.accentColor,
                        letterSpacing: 0.9,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.title,
                      style: TextStyle(
                        color: tokens.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            app.description,
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
              for (final tag in app.tags)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: const Color(0x0FFFFFFF),
                    border: Border.all(color: tokens.borderIdle),
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
          const SizedBox(height: 20),
          if (app.isLive)
            M3EButton.filled(
              onPressed: onActivate,
              size: M3EButtonSize.sm,
              shape: M3EButtonShape.round,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Open App'),
              decoration: M3EButtonDecoration(
                backgroundGradient: WidgetStateProperty.all(
                  LinearGradient(colors: [tokens.cyan, tokens.mint]),
                ),
                foregroundColor: WidgetStateProperty.all(
                  const Color(0xFF041013),
                ),
              ),
            )
          else
            M3EButton.outlined(
              onPressed: onActivate,
              size: M3EButtonSize.sm,
              shape: M3EButtonShape.round,
              icon: Icon(Icons.schedule_rounded, size: 16, color: tokens.cyan),
              label: Text(
                'Preview Roadmap',
                style: TextStyle(color: tokens.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.index,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.tokens,
  });

  final String index;
  final String eyebrow;
  final String title;
  final String subtitle;
  final HyprTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              index,
              style: tokens.monoStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: tokens.mint,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              eyebrow,
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
          title,
          style: TextStyle(
            color: tokens.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            subtitle,
            style: TextStyle(
              color: tokens.textSecondary,
              fontSize: 15.5,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
