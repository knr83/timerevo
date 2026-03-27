import 'package:flutter/material.dart';

/// Shared padding and vertical rhythm for compact desktop [AlertDialog]s.
///
/// Aligns with docs/UI_UX_STYLE_GUIDE.md: dialog content padding 16–24dp;
/// form field spacing 12–16dp; actions with primary on the right.
class AppDialogChrome {
  AppDialogChrome._();

  static const EdgeInsets titlePadding = EdgeInsets.fromLTRB(24, 20, 24, 0);
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(24, 16, 24, 16);
  static const EdgeInsets actionsPadding = EdgeInsets.fromLTRB(16, 0, 16, 16);

  /// Between stacked form controls inside dialog [content].
  static const double fieldSpacing = 16;

  /// Destructive filled action (Material 3): error surface + [ColorScheme.onError] label.
  ///
  /// Use with explicit confirmation copy; aligns with docs/UI_UX_STYLE_GUIDE.md.
  static ButtonStyle destructiveFilledStyle(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FilledButton.styleFrom(
      backgroundColor: cs.error,
      foregroundColor: cs.onError,
    );
  }

  /// Destructive tertiary (e.g. discard) so it does not read as a neutral [TextButton].
  static ButtonStyle destructiveTextStyle(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextButton.styleFrom(foregroundColor: cs.error);
  }
}
