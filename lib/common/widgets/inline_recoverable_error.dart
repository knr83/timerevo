import 'package:flutter/material.dart';

/// Inline error message with a local retry action (desktop-first).
///
/// Matches [docs/UI_UX_STYLE_GUIDE.md]: recoverable errors should offer a short
/// explanation and retry; no I/O here—[onRetry] should only trigger an existing
/// reload (e.g. `ref.invalidate(provider)`).
class InlineRecoverableError extends StatelessWidget {
  const InlineRecoverableError({
    super.key,
    required this.message,
    required this.onRetry,
    required this.retryLabel,
    this.layout = InlineRecoverableErrorLayout.centered,
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  /// [centered] for main panels; [leading] for toolbars and form rows (optionally
  /// wrapped in a fixed-width [SizedBox] by the caller).
  final InlineRecoverableErrorLayout layout;

  static const double _gapCentered = 16;
  static const double _gapLeading = 8;

  @override
  Widget build(BuildContext context) {
    final centered = layout == InlineRecoverableErrorLayout.centered;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(message, textAlign: centered ? TextAlign.center : TextAlign.start),
        SizedBox(height: centered ? _gapCentered : _gapLeading),
        TextButton(onPressed: onRetry, child: Text(retryLabel)),
      ],
    );
  }
}

enum InlineRecoverableErrorLayout { centered, leading }
