import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../common/widgets/app_snack.dart';

/// A reusable screen that renders a bundled markdown document.
class LegalDocPage extends StatelessWidget {
  const LegalDocPage({super.key, required this.title, required this.assetPath});

  final String title;
  final String assetPath;

  static const _privacyPath = 'assets/legal/privacy_policy.md';
  static const _termsPath = 'assets/legal/terms.md';

  static String get privacyPath => _privacyPath;
  static String get termsPath => _termsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Symbols.content_copy),
            onPressed: () => _copyToClipboard(context),
            tooltip: AppLocalizations.of(context).legalCopy,
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorView(
              message: AppLocalizations.of(context).commonErrorOccurred,
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return Markdown(
            data: data,
            selectable: true,
            padding: const EdgeInsets.all(16),
          );
        },
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    try {
      final text = await rootBundle.loadString(assetPath);
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        showAppSnack(context, l10n.legalCopiedToClipboard);
      }
    } catch (e, _) {
      debugPrint('[E] LegalDocPage _copyToClipboard: ${e.runtimeType}');
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        showAppSnack(context, l10n.legalFailedToCopy, isError: true);
      }
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.error,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Document not found in this build.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
