import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';

/// Port of official hypr.land `PreviewRiceSlice` (Image 2):
/// Centered glowing cyan-bordered Wayland desktop preview frame peeking cleanly
/// below the hero. Clicking launches the interactive M3E Snake sub-app.
class PreviewWorkspaceBanner extends StatefulWidget {
  const PreviewWorkspaceBanner({super.key});

  @override
  State<PreviewWorkspaceBanner> createState() => _PreviewWorkspaceBannerState();
}

class _PreviewWorkspaceBannerState extends State<PreviewWorkspaceBanner> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availWidth = constraints.maxWidth;
              final showWaybarCenter = availWidth >= 560;
              final showRightColumn = availWidth >= 660;
              final height = availWidth >= 860
                  ? 460.0
                  : (availWidth >= 560 ? 360.0 : 280.0);

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: GestureDetector(
                  onTap: () => context.go('/apps/snake'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _hovered
                            ? tokens.primary
                            : tokens.primary.withValues(alpha: 0.72),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: tokens.primary.withValues(
                            alpha: _hovered ? 0.34 : 0.20,
                          ),
                          blurRadius: _hovered ? 42 : 28,
                          spreadRadius: _hovered ? 2 : 0,
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0B1C28),
                          Color(0xFF0A1220),
                          Color(0xFF0C1022),
                        ],
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // Waybar-style top status bar echoing Image 2
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.pureBlack.withValues(alpha: 0.72),
                            border: Border(
                              bottom: BorderSide(
                                color: tokens.primary.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  showWaybarCenter
                                      ? 'Desktop  •  Workspace 1'
                                      : 'Workspace 1',
                                  overflow: TextOverflow.ellipsis,
                                  style: tokens.monoStyle(
                                    fontSize: 11,
                                    color: tokens.slate400,
                                  ),
                                ),
                              ),
                              if (showWaybarCenter) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: tokens.black,
                                    border: Border.all(
                                      color: tokens.primary.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '1  2  •  3  4  5',
                                    style: tokens.monoStyle(
                                      fontSize: 10.5,
                                      color: tokens.primary,
                                    ),
                                  ),
                                ),
                              ],
                              const Spacer(),
                              Text(
                                'chomsky@nixos',
                                style: tokens.monoStyle(
                                  fontSize: 11,
                                  color: tokens.slate300,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tiled mock windows inside preview desktop
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                // Left active window: M3E Snake preview
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: tokens.pureBlack.withValues(
                                        alpha: 0.85,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: tokens.primary.withValues(
                                          alpha: 0.7,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'm3e_snake',
                                                overflow: TextOverflow.ellipsis,
                                                style: tokens.monoStyle(
                                                  fontSize: 12,
                                                  color: tokens.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'OPEN →',
                                              style: tokens.monoStyle(
                                                fontSize: 10.5,
                                                color: tokens.cyan300,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: Center(
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: CustomPaint(
                                                painter: _ShowcaseSnakePainter(
                                                  tokens: tokens,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (showRightColumn) ...[
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: tokens.pureBlack
                                                  .withValues(alpha: 0.82),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: tokens.slate800,
                                              ),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '❯ hyprctl monitors',
                                                    style: tokens.monoStyle(
                                                      fontSize: 11.5,
                                                      color: tokens.primary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    'NixOS • Wayland • 120Hz',
                                                    style: tokens.monoStyle(
                                                      fontSize: 11.5,
                                                      color: tokens.slate300,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Flutter 3.47 • M3 Expressive',
                                                    style: tokens.monoStyle(
                                                      fontSize: 11.5,
                                                      color: tokens.slate400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: tokens.pureBlack
                                                  .withValues(alpha: 0.82),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: tokens.slate800,
                                              ),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'CONTROLS',
                                                    style: tokens.monoStyle(
                                                      fontSize: 10.5,
                                                      color: tokens.slate400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    'WASD / Arrows • Space • F Immersive',
                                                    style: tokens.monoStyle(
                                                      fontSize: 12,
                                                      color: const Color(
                                                        0xFFFFFFFF,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
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

class _ShowcaseSnakePainter extends CustomPainter {
  const _ShowcaseSnakePainter({required this.tokens});

  final HyprTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    const n = 10;
    final cell = size.width / n;

    final borderPaint = Paint()
      ..color = tokens.slate800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(10)),
      borderPaint,
    );

    final gridPaint = Paint()
      ..color = tokens.slate800.withValues(alpha: 0.45)
      ..strokeWidth = 0.8;
    for (var i = 1; i < n; i++) {
      final d = i * cell;
      canvas.drawLine(Offset(d, 0), Offset(d, size.height), gridPaint);
      canvas.drawLine(Offset(0, d), Offset(size.width, d), gridPaint);
    }

    final body = [
      const Offset(6, 4),
      const Offset(5, 4),
      const Offset(4, 4),
      const Offset(3, 4),
      const Offset(3, 5),
      const Offset(3, 6),
      const Offset(2, 6),
    ];
    for (var i = 0; i < body.length; i++) {
      final p = body[i];
      final rect = Rect.fromLTWH(
        p.dx * cell + 2,
        p.dy * cell + 2,
        cell - 4,
        cell - 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(5)),
        Paint()
          ..color = i == 0
              ? tokens.primary
              : Color.lerp(tokens.primary, tokens.blue500, i / body.length)!,
      );
    }

    canvas.drawCircle(
      Offset(7.5 * cell, 2.5 * cell),
      cell * 0.35,
      Paint()..color = tokens.cyan300,
    );
  }

  @override
  bool shouldRepaint(covariant _ShowcaseSnakePainter oldDelegate) => false;
}
