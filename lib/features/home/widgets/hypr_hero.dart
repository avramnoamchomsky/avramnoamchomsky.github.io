import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/widgets/hypr_background.dart';
import '../../../core/widgets/hypr_button.dart';

/// Port of official hypr.land `Hero.svelte`:
/// Full-viewport centered hero over `HyprHeroBackdrop` (top cyan flood +
/// 3D perspective tiling wireframe wings), bold split white + `.hyprgradient`
/// headline, `slate-400` subtitle, and `primary` + `fancyOutline` buttons.
class HyprHero extends StatelessWidget {
  const HyprHero({
    super.key,
    required this.onExploreApps,
  });

  final VoidCallback onExploreApps;

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<HyprTokens>() ?? HyprTokens.official;
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final heroHeight = (size.height * 0.86).clamp(520.0, 820.0);

    final titleSize = width >= 1024
        ? 86.0
        : (width >= 768 ? 68.0 : (width >= 520 ? 50.0 : 34.0));
    final subtitleSize = width >= 768 ? 20.0 : (width >= 520 ? 17.0 : 14.5);

    return Stack(
      children: [
        const Positioned.fill(child: HyprHeroBackdrop()),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: heroHeight),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                width < 520 ? 84 : 72,
                20,
                width < 520 ? 44 : 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Line 1: White fading softly toward cyan (`padding: 0.5rem` avoids tight-tracking clip)
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        tokens.heroWhiteFadeGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Low-level craft',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          height: 1.02,
                          letterSpacing: width < 520 ? -1.2 : -2.2,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  // Line 2: `.hyprgradient` (#00E6CF -> #00C4E3 -> #0081C6)
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        tokens.hyprGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'with the looks',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          height: 1.05,
                          letterSpacing: width < 520 ? -1.2 : -2.2,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: width < 520 ? 14 : 20),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      "I'm Chomsky — exploring embedded systems, NixOS, Linux internals, "
                      'and building cross-platform Flutter & Material 3 Expressive mini-apps.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tokens.slate400,
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: width < 520 ? 24 : 36),

                  Wrap(
                    spacing: 24,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      HyprButton(
                        label: 'Play Snake',
                        style: HyprButtonStyle.primary,
                        size: width >= 640
                            ? HyprButtonSize.xl
                            : HyprButtonSize.lg,
                        onPressed: () => context.go('/apps/snake'),
                      ),
                      HyprButton(
                        label: 'Sub-Apps',
                        style: HyprButtonStyle.fancyOutline,
                        size: width >= 640
                            ? HyprButtonSize.xl
                            : HyprButtonSize.lg,
                        onPressed: onExploreApps,
                      ),
                    ],
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
