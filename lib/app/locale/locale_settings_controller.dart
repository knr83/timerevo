import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repo_providers.dart';

/// Locale override stored locally. `null` means "use system locale".
final localeOverrideLanguageCodeProvider =
    AsyncNotifierProvider<LocaleOverrideLanguageCodeController, String?>(
  LocaleOverrideLanguageCodeController.new,
);

class LocaleOverrideLanguageCodeController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async {
    final repo = ref.read(localeSettingsRepoProvider);
    final code = await repo.readOverrideLanguageCode();
    return _normalizeOrNull(code);
  }

  Future<void> setSystemDefault() async {
    final repo = ref.read(localeSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.writeOverrideLanguageCode(null);
    state = const AsyncData(null);
  }

  Future<void> setLanguageCode(String languageCode) async {
    final normalized = _normalizeOrNull(languageCode);
    if (normalized == null) return;

    if (normalized != 'de' && normalized != 'ru' && normalized != 'en') {
      return;
    }

    final repo = ref.read(localeSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.writeOverrideLanguageCode(normalized);
    state = AsyncData(normalized);
  }
}

String? _normalizeOrNull(String? code) {
  final v = code?.trim().toLowerCase();
  if (v == null || v.isEmpty) return null;
  return v;
}

