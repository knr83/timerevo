import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared admin UI constants and page chrome widgets.
abstract final class AdminUi {
  /// Outer inset for admin feature pages (high-density desktop default).
  static const EdgeInsets pagePadding = EdgeInsets.all(12);

  /// Max width for a single content lane on very wide viewports (dense admin UIs).
  static const double maxContentWidth = 1600;
}

/// Caps content width and top-left aligns it so headers, filters, and main area share one lane.
class AdminContentWidth extends StatelessWidget {
  const AdminContentWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = math.min(constraints.maxWidth, AdminUi.maxContentWidth);
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
                style: theme.textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ?trailing,
          ],
        ),
        if (showBottomDivider) const Divider(height: 1),
      ],
    );
  }
}
