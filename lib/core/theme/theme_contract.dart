import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

/// A theme definition that can be embedded in a screen contract, allowing
/// the backend to control colors and typography per-screen.
class ThemeContract {
  final String? primaryColor;
  final String? secondaryColor;
  final String? backgroundColor;
  final String? surfaceColor;
  final String? errorColor;
  final String? fontFamily;
  final double? defaultFontSize;
  final String? brightness;

  const ThemeContract({
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.surfaceColor,
    this.errorColor,
    this.fontFamily,
    this.defaultFontSize,
    this.brightness,
  });

  factory ThemeContract.fromJson(Map<String, dynamic> json) {
    return ThemeContract(
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      surfaceColor: json['surfaceColor'] as String?,
      errorColor: json['errorColor'] as String?,
      fontFamily: json['fontFamily'] as String?,
      defaultFontSize: (json['defaultFontSize'] as num?)?.toDouble(),
      brightness: json['brightness'] as String?,
    );
  }

  /// Builds a Flutter [ThemeData] by layering the contract's values on top
  /// of the given [base] theme.
  ThemeData applyTo(ThemeData base) {
    final primary = parseHexColor(primaryColor);
    final secondary = parseHexColor(secondaryColor);
    final bg = parseHexColor(backgroundColor);
    final surface = parseHexColor(surfaceColor);
    final error = parseHexColor(errorColor);
    final isDark = brightness == 'dark';

    ColorScheme scheme = isDark
        ? ColorScheme.dark(
            primary: primary ?? base.colorScheme.primary,
            secondary: secondary ?? base.colorScheme.secondary,
            surface: surface ?? base.colorScheme.surface,
            error: error ?? base.colorScheme.error,
          )
        : ColorScheme.light(
            primary: primary ?? base.colorScheme.primary,
            secondary: secondary ?? base.colorScheme.secondary,
            surface: surface ?? base.colorScheme.surface,
            error: error ?? base.colorScheme.error,
          );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: fontFamily != null
          ? base.textTheme.apply(fontFamily: fontFamily)
          : (defaultFontSize != null
              ? base.textTheme.apply(fontSizeDelta: defaultFontSize! - 14)
              : base.textTheme),
    );
  }

}
