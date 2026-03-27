import 'package:flutter/widgets.dart';

/// Vertical rhythm for stacked form controls on pages and panels (not dialog chrome).
///
/// See docs/UI_UX_STYLE_GUIDE.md: 12–16dp between form fields; compact desktop density.
abstract final class FormLayout {
  FormLayout._();

  /// Between consecutive full-width inputs or peer control blocks (e.g. dropdown rows).
  static const double fieldGap = 16;
  static const SizedBox betweenFields = SizedBox(height: fieldGap);

  /// Between major groups (section cards, stacked full-width toolbar actions).
  static const double sectionGap = 12;
  static const SizedBox betweenSections = SizedBox(height: sectionGap);
}
