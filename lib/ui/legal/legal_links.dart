import 'package:flutter/material.dart';

import 'legal_doc_page.dart';

/// A reusable widget with buttons to open Privacy Policy and Terms.
class LegalLinks extends StatelessWidget {
  const LegalLinks({
    super.key,
    required this.privacyTitle,
    required this.termsTitle,
  });

  final String privacyTitle;
  final String termsTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(privacyTitle),
          onTap: () => _openDoc(context, privacyTitle, LegalDocPage.privacyPath),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(termsTitle),
          onTap: () => _openDoc(context, termsTitle, LegalDocPage.termsPath),
        ),
      ],
    );
  }

  void _openDoc(BuildContext context, String title, String assetPath) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LegalDocPage(title: title, assetPath: assetPath),
      ),
    );
  }
}
