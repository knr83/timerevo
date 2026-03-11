// Run: dart run tools/sync_legal_docs.dart
// Copies PRIVACY_POLICY.md and TERMS.md from repo root to assets/legal/.
// Run after updating the root files to keep bundled docs in sync.

import 'dart:io';

void main() {
  final root = Directory.current.path.replaceAll(r'\', '/');
  final projectRoot = root.endsWith('/tools')
      ? root.replaceAll('/tools', '')
      : root;

  final assetsLegal = Directory('$projectRoot/assets/legal');
  if (!assetsLegal.existsSync()) {
    assetsLegal.createSync(recursive: true);
  }

  final files = <(String, String)>[
    (
      '$projectRoot/PRIVACY_POLICY.md',
      '$projectRoot/assets/legal/privacy_policy.md',
    ),
    ('$projectRoot/TERMS.md', '$projectRoot/assets/legal/terms.md'),
  ];

  for (final (src, dst) in files) {
    final srcFile = File(src);
    if (!srcFile.existsSync()) {
      stderr.writeln('Source not found: $src');
      exit(1);
    }
    File(dst).writeAsStringSync(srcFile.readAsStringSync());
    stdout.writeln(
      'Copied: ${src.split(RegExp(r'[/\\]')).last} → assets/legal/',
    );
  }
  stdout.writeln('Done.');
}
