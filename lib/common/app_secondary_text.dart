import 'package:flutter/material.dart';

/// Theme-derived styles for secondary / helper / muted UI copy.
///
/// Aligns with docs/UI_UX_STYLE_GUIDE.md (bodySmall band + onSurfaceVariant).
abstract final class AppSecondaryText {
  AppSecondaryText._();

  /// Muted explanatory copy (empty-state hints, footnotes, inline metadata).
  static TextStyle? muted(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
  }

  /// Body text on [ColorScheme.errorContainer] (inline validation banners).
  static TextStyle? onErrorContainerBody(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onErrorContainer,
    );
  }
}
