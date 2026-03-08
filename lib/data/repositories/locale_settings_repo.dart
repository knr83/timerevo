import 'app_settings_repo.dart';

class LocaleSettingsRepo {
  LocaleSettingsRepo(this._appSettings);

  final AppSettingsRepo _appSettings;

  static const _overrideKey = 'locale_override'; // null/absent => system

  Future<String?> readOverrideLanguageCode() async {
    final v = await _appSettings.get(_overrideKey);
    if (v == null || v.trim().isEmpty) return null;
    return v.trim().toLowerCase();
  }

  Future<void> writeOverrideLanguageCode(String? languageCode) async {
    final code = languageCode?.trim().toLowerCase();
    if (code == null || code.isEmpty) {
      await _appSettings.set(_overrideKey, null);
      return;
    }
    await _appSettings.set(_overrideKey, code);
  }
}

