import 'package:flutter/material.dart';

void showAppSnack(
  BuildContext context,
  String text, {
  bool isError = false,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  final cs = Theme.of(context).colorScheme;
  final bg = isError ? cs.errorContainer : cs.inverseSurface;
  final fg = isError ? cs.onErrorContainer : cs.onInverseSurface;

  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: isError ? const Duration(seconds: 4) : const Duration(seconds: 2),
      backgroundColor: bg,
      content: Text(text, style: TextStyle(color: fg)),
    ),
  );
}

