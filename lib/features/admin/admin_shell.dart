import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_settings_providers.dart';
import '../../ui/legal/legal_doc_page.dart';
import 'about/about_page.dart';
import '../../app/auth/admin_auth_controller.dart';
import 'admin_home.dart';

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(adminAuthControllerProvider);
    if (!auth.isUnlocked) {
      return const _AdminPinGate();
    }
    return const _AdminScaffold();
  }
}

class _AdminPinGate extends ConsumerStatefulWidget {
  const _AdminPinGate();

  @override
  ConsumerState<_AdminPinGate> createState() => _AdminPinGateState();
}

class _AdminPinGateState extends ConsumerState<_AdminPinGate> {
  final _controller = TextEditingController();
  bool _verifying = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(adminAuthControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.adminEnterPinToContinue,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  enabled: !_verifying,
                  decoration: InputDecoration(
                    labelText: l10n.adminPinLabel,
                    errorText: auth.lastError,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _verifying ? null : _submit,
                    child: _verifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.adminUnlock),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_verifying) return;
    final pin = _controller.text.trim();
    final l10n = AppLocalizations.of(context);

    setState(() => _verifying = true);
    await ref
        .read(adminAuthControllerProvider.notifier)
        .unlockWithPin(
          pin,
          invalidPinMessage: l10n.adminInvalidPin,
          invalidFormatMessage: l10n.adminPinInvalidFormat,
        );
    if (mounted) setState(() => _verifying = false);
  }
}

class _AdminScaffold extends ConsumerStatefulWidget {
  const _AdminScaffold();

  @override
  ConsumerState<_AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends ConsumerState<_AdminScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeShowLegalNotice(),
    );
  }

  Future<void> _maybeShowLegalNotice() async {
    final controller = ref.read(legalNoticeControllerProvider);
    if (await controller.hasSeenLegalNotice()) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.legalNoticeWelcomeTitle),
        content: Text(l10n.legalNoticeWelcomeText),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LegalDocPage(
                    title: l10n.settingsPrivacyPolicy,
                    assetPath: LegalDocPage.privacyPath,
                  ),
                ),
              );
            },
            child: Text(l10n.legalNoticeOpenPrivacy),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LegalDocPage(
                    title: l10n.legalTerms,
                    assetPath: LegalDocPage.termsPath,
                  ),
                ),
              );
            },
            child: Text(l10n.legalNoticeOpenTerms),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.legalNoticeClose),
          ),
        ],
      ),
    );
    await controller.markLegalNoticeSeen();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.help_outline),
            tooltip: l10n.helpTitle,
            onSelected: (value) {
              switch (value) {
                case 'privacy':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LegalDocPage(
                        title: l10n.settingsPrivacyPolicy,
                        assetPath: LegalDocPage.privacyPath,
                      ),
                    ),
                  );
                  break;
                case 'terms':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LegalDocPage(
                        title: l10n.legalTerms,
                        assetPath: LegalDocPage.termsPath,
                      ),
                    ),
                  );
                  break;
                case 'about':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const AboutPage()),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'privacy',
                child: Text(l10n.settingsPrivacyPolicy),
              ),
              PopupMenuItem(value: 'terms', child: Text(l10n.legalTerms)),
              const PopupMenuDivider(),
              PopupMenuItem(value: 'about', child: Text(l10n.aboutTitle)),
            ],
          ),
        ],
      ),
      body: const AdminHome(),
    );
  }
}
