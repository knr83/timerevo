import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared admin UI constants and page chrome widgets.
abstract final class AdminUi {
  /// Outer inset for admin feature pages (high-density desktop default).
  static const EdgeInsets pagePadding = EdgeInsets.all(12);

  /// Max width for a single content lane on very wide viewports (dense admin UIs).
  static const double maxContentWidth = 1600;

  /// Space between the title/actions row and the header divider (avoids visual collision).
  static const double headerRowToDividerGap = 6;
}

/// Theme-aligned divider directly under a page header row (title + actions).
///
/// Uses [DividerTheme]; same appearance as the divider under [AdminPageHeader].
/// Includes a small top gap so the line reads as a separator, not cutting the header.
class AdminPageHeaderDivider extends StatelessWidget {
  const AdminPageHeaderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AdminUi.headerRowToDividerGap),
      child: const Divider(height: 1),
    );
  }
}

/// Caps content width and top-left aligns it so headers, filters, and main area share one lane.
class AdminContentWidth extends StatelessWidget {
  const AdminContentWidth({super.key, required this.child, this.maxWidth});

  final Widget child;

  /// When null, uses [AdminUi.maxContentWidth].
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final cap = maxWidth ?? AdminUi.maxContentWidth;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = math.min(constraints.maxWidth, cap);
        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: w, child: child),
        );
      },
    );
  }
}

/// Page title row with optional trailing control(s) and optional divider below.
class AdminPageHeader extends StatelessWidget {
  const AdminPageHeader({
    super.key,
    required this.title,
    this.trailing,
    this.showBottomDivider = true,
  });

  final String title;
  final Widget? trailing;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style:
                    theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ) ??
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ?trailing,
          ],
        ),
        if (showBottomDivider) const AdminPageHeaderDivider(),
      ],
    );
  }
}
