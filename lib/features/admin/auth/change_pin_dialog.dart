import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/usecase_providers.dart';
import '../../../core/domain_errors.dart';
import '../../../core/error_message_helper.dart';
import '../../../core/pin_validation.dart';

class ChangePinDialog extends ConsumerStatefulWidget {
  const ChangePinDialog({super.key});

  @override
  ConsumerState<ChangePinDialog> createState() => _ChangePinDialogState();
}

class _ChangePinDialogState extends ConsumerState<ChangePinDialog> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String? _error;
  bool _isSaving = false;

  bool get _canSave {
    final newPin = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();
    return newPin.isNotEmpty && newPin == confirm;
  }

  @override
  void initState() {
    super.initState();
    _currentCtrl.addListener(() => setState(() {}));
    _newCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.changePinTitle),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.changePinCurrentPin,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.changePinNewPin,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.changePinConfirmNewPin,
                border: const OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: (_isSaving || !_canSave) ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonSave),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isSaving = true;
      _error = null;
    });

    final currentPin = _currentCtrl.text.trim();
    final newPin = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (newPin.isEmpty) {
      setState(() {
        _isSaving = false;
        _error = l10n.changePinNewPinRequired;
      });
      return;
    }
    if (!isValidAdminPinFormat(currentPin) || !isValidAdminPinFormat(newPin)) {
      setState(() {
        _isSaving = false;
        _error = l10n.changePinInvalidFormat;
      });
      return;
    }
    if (newPin != confirm) {
      setState(() {
        _isSaving = false;
        _error = l10n.changePinConfirmationMismatch;
      });
      return;
    }

    try {
      final ok = await ref
          .read(changeAdminPinUseCaseProvider)
          .changeAdminPin(currentPin: currentPin, newPin: newPin);

      if (!mounted) return;
      if (!ok) {
        setState(() {
          _isSaving = false;
          _error = l10n.changePinCurrentInvalid;
        });
        return;
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _error =
            e is DomainValidationException && e.message == 'invalid_pin_format'
            ? l10n.changePinInvalidFormat
            : errorMessageForUser(e, l10n.commonErrorOccurred);
      });
    }
  }
}
