import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import 'app_dialog_chrome.dart';

enum UnsavedChangesAction { cancel, discard, save }

Future<UnsavedChangesAction?> showUnsavedChangesDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String discardLabel,
}) async {
  final l10n = AppLocalizations.of(context);
  return showDialog<UnsavedChangesAction>(
    context: context,
    builder: (ctx) => AlertDialog(
      titlePadding: AppDialogChrome.titlePadding,
      contentPadding: AppDialogChrome.contentPadding,
      actionsPadding: AppDialogChrome.actionsPadding,
      title: Text(title),
      content: Text(message),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(ctx).pop(UnsavedChangesAction.cancel),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(UnsavedChangesAction.discard),
          style: AppDialogChrome.destructiveTextStyle(ctx),
          child: Text(discardLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(UnsavedChangesAction.save),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
}
