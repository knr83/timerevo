import 'package:flutter/material.dart';

import 'theme_settings_controller.dart';

class AppThemeConfig {
  const AppThemeConfig({
    required this.theme,
    required this.darkTheme,
    required this.highContrastTheme,
    required this.highContrastDarkTheme,
    required this.themeMode,
  });

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeData highContrastTheme;
  final ThemeData highContrastDarkTheme;
  final ThemeMode themeMode;
}

ThemeData _themeFromSeed({
  required Color seed,
  required Brightness brightness,
  bool highContrast = false,
}) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    visualDensity: VisualDensity.compact,
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: highContrast ? 2 : 1,
      space: 1,
    ),
    inputDecorationTheme: highContrast
        ? InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: scheme.outline, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: scheme.outline, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: scheme.primary, width: 2.5),
            ),
          )
        : const InputDecorationTheme(),
    outlinedButtonTheme: highContrast
        ? OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: scheme.outline, width: 2),
            ),
          )
        : null,
  );
}

AppThemeConfig buildAppTheme(AppThemeSelection selection) {
  const seed = Colors.blue;
  final normalLight = _themeFromSeed(seed: seed, brightness: Brightness.light);
  final normalDark = _themeFromSeed(seed: seed, brightness: Brightness.dark);
  final hcLight = _themeFromSeed(
    seed: seed,
    brightness: Brightness.light,
    highContrast: true,
  );
  final hcDark = _themeFromSeed(
    seed: seed,
    brightness: Brightness.dark,
    highContrast: true,
  );

  final themeMode = switch (selection) {
    AppThemeSelection.system => ThemeMode.system,
    AppThemeSelection.light => ThemeMode.light,
    AppThemeSelection.dark => ThemeMode.dark,
    AppThemeSelection.highContrastLight => ThemeMode.light,
    AppThemeSelection.highContrastDark => ThemeMode.dark,
  };

  // `theme` is the light-mode theme, `darkTheme` is the dark-mode theme.
  final theme = switch (selection) {
    AppThemeSelection.highContrastLight => hcLight,
    AppThemeSelection.highContrastDark => normalLight,
    _ => normalLight,
  };
  final darkTheme = switch (selection) {
    AppThemeSelection.highContrastLight => normalDark,
    AppThemeSelection.highContrastDark => hcDark,
    _ => normalDark,
  };

  // Only let OS high-contrast affect UI when selection is System.
  final effectiveHighContrastTheme =
      selection == AppThemeSelection.system ? hcLight : theme;
  final effectiveHighContrastDarkTheme =
      selection == AppThemeSelection.system ? hcDark : darkTheme;

  return AppThemeConfig(
    theme: theme,
    darkTheme: darkTheme,
    highContrastTheme: effectiveHighContrastTheme,
    highContrastDarkTheme: effectiveHighContrastDarkTheme,
    themeMode: themeMode,
  );
}
