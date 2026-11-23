import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/widgets/hypr_background.dart';
import '../../../core/widgets/hypr_button.dart';

/// Centered hero over `HyprHeroBackdrop` with clean crisp monochrome + single
/// ice-cyan typography (`#F8FAFC` / `#58E1FF`) and restrained rectangular CTAs.
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
        ? 84.0
        : (width >= 768 ? 66.0 : (width >= 520 ? 48.0 : 34.0));
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
                  Text(
                    'Low-level craft',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      height: 1.02,
                      letterSpacing: width < 520 ? -1.2 : -2.2,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFF8FAFC),
                    ),
                  ),
                  Text(
                    'with the looks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      height: 1.06,
                      letterSpacing: width < 520 ? -1.2 : -2.2,
                      fontWeight: FontWeight.w800,
                      color: tokens.primary,
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
                    spacing: 20,
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
                        style: HyprButtonStyle.accentOutline,
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
