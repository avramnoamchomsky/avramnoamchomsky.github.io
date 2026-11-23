import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

/// Hyprland-inspired design tokens shared across the homepage and shared shell.
@immutable
class HyprTokens extends ThemeExtension<HyprTokens> {
  const HyprTokens({
    required this.canvasBg,
    required this.surfaceGlass,
    required this.surfaceElevated,
    required this.surfaceInner,
    required this.borderIdle,
    required this.cyan,
    required this.mint,
    required this.indigo,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.monoFontFamily,
  });

  static const HyprTokens dark = HyprTokens(
    canvasBg: Color(0xFF05080D),
    surfaceGlass: Color(0xCC0C121D),
    surfaceElevated: Color(0xE6101827),
    surfaceInner: Color(0xFF090E17),
    borderIdle: Color(0x2299C2FF),
    cyan: Color(0xFF33CCFF),
    mint: Color(0xFF00FF99),
    indigo: Color(0xFF7B6CFF),
    textPrimary: Color(0xFFEEF6FF),
    textSecondary: Color(0xFF93A6BE),
    textMuted: Color(0xFF56677F),
    monoFontFamily: 'JetBrains Mono',
  );

  final Color canvasBg;
  final Color surfaceGlass;
  final Color surfaceElevated;
  final Color surfaceInner;
  final Color borderIdle;
  final Color cyan;
  final Color mint;
  final Color indigo;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final String monoFontFamily;

  /// Signature Hyprland 45-degree cyan-to-mint active window border gradient.
  LinearGradient get activeBorderGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cyan, mint, indigo.withValues(alpha: 0.85)],
  );

  LinearGradient get headlineGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [textPrimary, cyan, mint],
    stops: const [0.05, 0.55, 1.0],
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
      fontFamilyFallback: const ['Fira Code', 'Noto Sans Mono', 'monospace'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  @override
  HyprTokens copyWith({
    Color? canvasBg,
    Color? surfaceGlass,
    Color? surfaceElevated,
    Color? surfaceInner,
    Color? borderIdle,
    Color? cyan,
    Color? mint,
    Color? indigo,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    String? monoFontFamily,
  }) {
    return HyprTokens(
      canvasBg: canvasBg ?? this.canvasBg,
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceInner: surfaceInner ?? this.surfaceInner,
      borderIdle: borderIdle ?? this.borderIdle,
      cyan: cyan ?? this.cyan,
      mint: mint ?? this.mint,
      indigo: indigo ?? this.indigo,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      monoFontFamily: monoFontFamily ?? this.monoFontFamily,
    );
  }

  @override
  HyprTokens lerp(ThemeExtension<HyprTokens>? other, double t) {
    if (other is! HyprTokens) return this;
    return HyprTokens(
      canvasBg: Color.lerp(canvasBg, other.canvasBg, t)!,
      surfaceGlass: Color.lerp(surfaceGlass, other.surfaceGlass, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceInner: Color.lerp(surfaceInner, other.surfaceInner, t)!,
      borderIdle: Color.lerp(borderIdle, other.borderIdle, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      indigo: Color.lerp(indigo, other.indigo, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      monoFontFamily: t < 0.5 ? monoFontFamily : other.monoFontFamily,
    );
  }
}

/// Builds the default M3E theme seeded with Hyprland cyan.
M3EThemeData buildDefaultM3ETheme({
  Color seedColor = const Color(0xFF33CCFF),
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

/// Builds the Material theme paired with [HyprTokens.dark].
ThemeData buildRootMaterialTheme(M3EThemeData m3e) {
  final base = m3e.toThemeData();
  return base.copyWith(
    scaffoldBackgroundColor: HyprTokens.dark.canvasBg,
    extensions: [HyprTokens.dark],
  );
}
