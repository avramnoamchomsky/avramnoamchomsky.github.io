import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/widgets/hypr_card.dart';
import '../../../data/site_data.dart';

/// Port of official hypr.land `FeaturesSlice.svelte`:
/// Centered TitlePre + TitleHeading, asymmetric 2-column Bento grid of pure-black
/// `HyprCard`s (tall left featured card + 2 stacked right cards) with content
/// anchored bottom-left, followed by icon+label focus highlights.
class SubAppsSection extends StatelessWidget {
  const SubAppsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final snakeApp = SiteData.subApps[0];
    final bitfieldApp = SiteData.subApps[1];
    final shellApp = SiteData.subApps[2];

    return Column(
      children: [
        Text(
          'MINI-APPS',
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
          'Sub-Apps',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w800,
            fontSize: 52,
            letterSpacing: -1.4,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Interactive Material 3 Expressive applets built to run on Web, Linux & Mobile.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tokens.slate300,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 44),

        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            final featuredCard = _BentoAppCard(
              app: snakeApp,
              tokens: tokens,
              tall: isDesktop,
              tone: HyprCardTone.cyan,
              onTap: () => _openSubApp(context, snakeApp),
            );
            final topRightCard = _BentoAppCard(
              app: bitfieldApp,
              tokens: tokens,
              tone: HyprCardTone.purple,
              onTap: () => _openSubApp(context, bitfieldApp),
            );
            final bottomRightCard = _BentoAppCard(
              app: shellApp,
              tokens: tokens,
              tone: HyprCardTone.purple,
              onTap: () => _openSubApp(context, shellApp),
            );

            if (isDesktop) {
              return SizedBox(
                height: 540,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: featuredCard),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: topRightCard),
                          const SizedBox(height: 16),
                          Expanded(child: bottomRightCard),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 260),
                  child: featuredCard,
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 220),
                  child: topRightCard,
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 220),
                  child: bottomRightCard,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 48),

        // Official FeaturesSlice-style horizontal icon + label focus row
        Wrap(
          spacing: 32,
          runSpacing: 18,
          alignment: WrapAlignment.center,
          children: [
            for (final domain in SiteData.focusDomains)
              _IconHighlight(
                glyph: domain.glyph,
                label: domain.title,
                tokens: tokens,
              ),
            _IconHighlight(
              glyph: '⚡',
              label: 'Material 3 Expressive',
              tokens: tokens,
            ),
            _IconHighlight(
              glyph: '⌘',
              label: 'Keyboard & Touch Ready',
              tokens: tokens,
            ),
          ],
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
          'Planned for the next milestone — open M3E Snake now to try the live '
          'Material 3 Expressive experience.',
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
            label: const Text('Play M3E Snake'),
          ),
        ],
      ),
    );
  }
}

class _BentoAppCard extends StatelessWidget {
  const _BentoAppCard({
    required this.app,
    required this.tokens,
    required this.tone,
    required this.onTap,
    this.tall = false,
  });

  final SubAppEntry app;
  final HyprTokens tokens;
  final HyprCardTone tone;
  final VoidCallback onTap;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    return HyprCard(
      tone: tone,
      alwaysHighlight: false,
      onTap: onTap,
      padding: const EdgeInsets.all(34),
      child: Stack(
        children: [
          // Soft glowing geometric background motif echoing Image 3 (`Smooth` / `</>` / `[ ]`)
          Positioned(
            right: tall ? -18 : -10,
            top: tall ? 36 : -4,
            child: IgnorePointer(
              child: _CardMotifArtwork(
                appId: app.id,
                tall: tall,
                tokens: tokens,
              ),
            ),
          ),

          // Content anchored cleanly at bottom-left like hypr.land `Features` cards
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                app.title,
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w800,
                  fontSize: tall ? 48 : 30,
                  letterSpacing: -1.0,
                  height: 1.04,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Text(
                  app.description,
                  maxLines: tall ? 4 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ),
              if (app.isLive) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Open App',
                      style: TextStyle(
                        color: tokens.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: tokens.primary,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CardMotifArtwork extends StatelessWidget {
  const _CardMotifArtwork({
    required this.appId,
    required this.tall,
    required this.tokens,
  });

  final String appId;
  final bool tall;
  final HyprTokens tokens;

  @override
  Widget build(BuildContext context) {
    final size = tall ? 290.0 : 185.0;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CardMotifPainter(appId: appId, tokens: tokens),
      ),
    );
  }
}

class _CardMotifPainter extends CustomPainter {
  const _CardMotifPainter({required this.appId, required this.tokens});

  final String appId;
  final HyprTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final grad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        tokens.purple400.withValues(alpha: 0.42),
        tokens.blue500.withValues(alpha: 0.42),
        tokens.cyan500.withValues(alpha: 0.46),
      ],
    ).createShader(rect);

    final glowPaint = Paint()
      ..shader = grad
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final crispPaint = Paint()
      ..shader = grad
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.085
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (appId == 'snake') {
      // Soft glowing orb + stylized curved snake silhouette (matching Image 3 left card)
      canvas.drawCircle(rect.center, size.width * 0.36, glowPaint);
      final path = Path()
        ..moveTo(size.width * 0.25, size.height * 0.65)
        ..cubicTo(
          size.width * 0.25,
          size.height * 0.25,
          size.width * 0.72,
          size.height * 0.72,
          size.width * 0.74,
          size.height * 0.34,
        );
      canvas.drawPath(path, crispPaint);
      canvas.drawCircle(
        Offset(size.width * 0.33, size.height * 0.35),
        size.width * 0.07,
        Paint()..color = tokens.primary.withValues(alpha: 0.55),
      );
      return;
    }

    if (appId == 'bitfield') {
      // Soft glowing `<>` brackets (matching Image 3 top-right `Easy to configure`)
      canvas.drawCircle(rect.center, size.width * 0.32, glowPaint);
      final left = Path()
        ..moveTo(size.width * 0.42, size.height * 0.22)
        ..lineTo(size.width * 0.16, size.height * 0.50)
        ..lineTo(size.width * 0.42, size.height * 0.78);
      final right = Path()
        ..moveTo(size.width * 0.58, size.height * 0.22)
        ..lineTo(size.width * 0.84, size.height * 0.50)
        ..lineTo(size.width * 0.58, size.height * 0.78);
      canvas.drawPath(left, crispPaint);
      canvas.drawPath(right, crispPaint);
      return;
    }

    // Soft glowing `[ ]` brackets (matching Image 3 bottom-right `Dynamic tiling`)
    canvas.drawCircle(rect.center, size.width * 0.32, glowPaint);
    final left = Path()
      ..moveTo(size.width * 0.40, size.height * 0.20)
      ..lineTo(size.width * 0.20, size.height * 0.20)
      ..lineTo(size.width * 0.20, size.height * 0.80)
      ..lineTo(size.width * 0.40, size.height * 0.80);
    final right = Path()
      ..moveTo(size.width * 0.60, size.height * 0.20)
      ..lineTo(size.width * 0.80, size.height * 0.20)
      ..lineTo(size.width * 0.80, size.height * 0.80)
      ..lineTo(size.width * 0.60, size.height * 0.80);
    canvas.drawPath(left, crispPaint);
    canvas.drawPath(right, crispPaint);
  }

  @override
  bool shouldRepaint(covariant _CardMotifPainter oldDelegate) => false;
}

class _IconHighlight extends StatelessWidget {
  const _IconHighlight({
    required this.glyph,
    required this.label,
    required this.tokens,
  });

  final String glyph;
  final String label;
  final HyprTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          glyph,
          style: tokens.monoStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: tokens.primary,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: tokens.slate400,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
