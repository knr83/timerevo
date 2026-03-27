import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/widgets/app_dialog_chrome.dart';
import '../data/services/backup_service.dart';
import '../l10n/app_localizations.dart';

/// Shows a blocking dialog when the app starts after a restore was applied.
class RestoreCompletedGate extends StatefulWidget {
  const RestoreCompletedGate({super.key, required this.child});

  final Widget child;

  @override
  State<RestoreCompletedGate> createState() => _RestoreCompletedGateState();
}

class _RestoreCompletedGateState extends State<RestoreCompletedGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowDialog());
  }

  Future<void> _maybeShowDialog() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(restoreCompletedDialogKey) != true) return;
    if (!mounted) return;

    await prefs.remove(restoreCompletedDialogKey);
    final ctx = context;
    if (!ctx.mounted) return;

    final l10n = AppLocalizations.of(ctx);
    await showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      barrierColor: Theme.of(ctx).brightness == Brightness.light
          ? Colors.black54
          : Colors.black87,
      builder: (context) => AlertDialog(
        titlePadding: AppDialogChrome.titlePadding,
        contentPadding: AppDialogChrome.contentPadding,
        actionsPadding: AppDialogChrome.actionsPadding,
        title: Text(l10n.settingsRestoreCompletedTitle),
        content: Text(l10n.settingsRestoreCompletedMessage),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
