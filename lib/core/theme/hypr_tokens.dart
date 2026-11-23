import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

/// Exact design tokens matching the official hypr.land website (`hyprwm/hyprland-website`).
@immutable
class HyprTokens extends ThemeExtension<HyprTokens> {
  const HyprTokens({
    required this.black,
    required this.pureBlack,
    required this.primary,
    required this.secondary,
    required this.cyan300,
    required this.cyan500,
    required this.sky500,
    required this.blue500,
    required this.purple400,
    required this.slate200,
    required this.slate300,
    required this.slate400,
    required this.slate800,
    required this.monoFontFamily,
  });

  static const HyprTokens official = HyprTokens(
    black: Color(0xFF090B0C),
    pureBlack: Color(0xFF000000),
    primary: Color(0xFF58E1FF),
    secondary: Color(0xFF00A2F8),
    cyan300: Color(0xFF67E8F9),
    cyan500: Color(0xFF06B6D4),
    sky500: Color(0xFF0EA5E9),
    blue500: Color(0xFF3B82F6),
    purple400: Color(0xFFC084FC),
    slate200: Color(0xFFE2E8F0),
    slate300: Color(0xFFCBD5E1),
    slate400: Color(0xFF94A3B8),
    slate800: Color(0xFF1E293B),
    monoFontFamily: 'IBM Plex Mono',
  );

  final Color black;
  final Color pureBlack;
  final Color primary;
  final Color secondary;
  final Color cyan300;
  final Color cyan500;
  final Color sky500;
  final Color blue500;
  final Color purple400;
  final Color slate200;
  final Color slate300;
  final Color slate400;
  final Color slate800;
  final String monoFontFamily;

  /// Official `.hyprgradient`: `linear-gradient(to bottom right, #00e6cf, #00c4e3, #0081c6)`.
  LinearGradient get hyprGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00E6CF), Color(0xFF00C4E3), Color(0xFF0081C6)],
  );

  /// Official `.title` white-to-fading-cyan gradient on Hero line 1.
  LinearGradient get heroWhiteFadeGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xFFFFFFFF),
      cyan500.withValues(alpha: 0.35),
    ],
    stops: const [0.0, 0.45, 1.0],
  );

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
    Color? primary,
    Color? secondary,
    Color? cyan300,
    Color? cyan500,
    Color? sky500,
    Color? blue500,
    Color? purple400,
    Color? slate200,
    Color? slate300,
    Color? slate400,
    Color? slate800,
    String? monoFontFamily,
  }) {
    return HyprTokens(
      black: black ?? this.black,
      pureBlack: pureBlack ?? this.pureBlack,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      cyan300: cyan300 ?? this.cyan300,
      cyan500: cyan500 ?? this.cyan500,
      sky500: sky500 ?? this.sky500,
      blue500: blue500 ?? this.blue500,
      purple400: purple400 ?? this.purple400,
      slate200: slate200 ?? this.slate200,
      slate300: slate300 ?? this.slate300,
      slate400: slate400 ?? this.slate400,
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
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      cyan300: Color.lerp(cyan300, other.cyan300, t)!,
      cyan500: Color.lerp(cyan500, other.cyan500, t)!,
      sky500: Color.lerp(sky500, other.sky500, t)!,
      blue500: Color.lerp(blue500, other.blue500, t)!,
      purple400: Color.lerp(purple400, other.purple400, t)!,
      slate200: Color.lerp(slate200, other.slate200, t)!,
      slate300: Color.lerp(slate300, other.slate300, t)!,
      slate400: Color.lerp(slate400, other.slate400, t)!,
      slate800: Color.lerp(slate800, other.slate800, t)!,
      monoFontFamily: t < 0.5 ? monoFontFamily : other.monoFontFamily,
    );
  }
}

/// Builds the default M3E theme seeded with Hyprland cyan (`#58E1FF`).
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
