import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

/// Restrained dark-obsidian + single-accent ice-cyan palette inspired by
/// minimalist Hyprland/Wayland setups without multi-hue gradients.
@immutable
class HyprTokens extends ThemeExtension<HyprTokens> {
  const HyprTokens({
    required this.black,
    required this.pureBlack,
    required this.surface,
    required this.primary,
    required this.slate200,
    required this.slate300,
    required this.slate400,
    required this.slate700,
    required this.slate800,
    required this.monoFontFamily,
  });

  static const HyprTokens official = HyprTokens(
    black: Color(0xFF090B0C),
    pureBlack: Color(0xFF050708),
    surface: Color(0xFF0E1216),
    primary: Color(0xFF58E1FF),
    slate200: Color(0xFFE2E8F0),
    slate300: Color(0xFFCBD5E1),
    slate400: Color(0xFF94A3B8),
    slate700: Color(0xFF334155),
    slate800: Color(0xFF1E293B),
    monoFontFamily: 'IBM Plex Mono',
  );

  final Color black;
  final Color pureBlack;
  final Color surface;
  final Color primary;
  final Color slate200;
  final Color slate300;
  final Color slate400;
  final Color slate700;
  final Color slate800;
  final String monoFontFamily;

  TextStyle monoStyle({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: monoFontFamily,
      fontFamilyFallback: const ['JetBrains Mono', 'Fira Code', 'monospace'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? slate200,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  @override
  HyprTokens copyWith({
    Color? black,
    Color? pureBlack,
    Color? surface,
    Color? primary,
    Color? slate200,
    Color? slate300,
    Color? slate400,
    Color? slate700,
    Color? slate800,
    String? monoFontFamily,
  }) {
    return HyprTokens(
      black: black ?? this.black,
      pureBlack: pureBlack ?? this.pureBlack,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      slate200: slate200 ?? this.slate200,
      slate300: slate300 ?? this.slate300,
      slate400: slate400 ?? this.slate400,
      slate700: slate700 ?? this.slate700,
      slate800: slate800 ?? this.slate800,
      monoFontFamily: monoFontFamily ?? this.monoFontFamily,
    );
  }

  @override
  HyprTokens lerp(ThemeExtension<HyprTokens>? other, double t) {
    if (other is! HyprTokens) return this;
    return HyprTokens(
      black: Color.lerp(black, other.black, t)!,
      pureBlack: Color.lerp(pureBlack, other.pureBlack, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      slate200: Color.lerp(slate200, other.slate200, t)!,
      slate300: Color.lerp(slate300, other.slate300, t)!,
      slate400: Color.lerp(slate400, other.slate400, t)!,
      slate700: Color.lerp(slate700, other.slate700, t)!,
      slate800: Color.lerp(slate800, other.slate800, t)!,
      monoFontFamily: t < 0.5 ? monoFontFamily : other.monoFontFamily,
    );
  }
}

/// Builds the default M3E theme seeded with crisp cyan (`#58E1FF`).
M3EThemeData buildDefaultM3ETheme({
  Color seedColor = const Color(0xFF58E1FF),
  Brightness brightness = Brightness.dark,
}) {
  final base = brightness == Brightness.dark
      ? M3EThemeData.dark(seedColor: seedColor)
      : M3EThemeData.light(seedColor: seedColor);
  return base.copyWith(
    fontFamily: 'Inter',
    fontFamilyFallback: const ['Segoe UI', 'Noto Sans', 'sans-serif'],
  );
}

/// Builds the Material theme paired with [HyprTokens.official].
ThemeData buildRootMaterialTheme(M3EThemeData m3e) {
  final base = m3e.toThemeData();
  return base.copyWith(
    scaffoldBackgroundColor: HyprTokens.official.black,
    extensions: const [HyprTokens.official],
  );
}
