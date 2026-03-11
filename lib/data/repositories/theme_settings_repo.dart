import 'app_settings_repo.dart';

class ThemeSettingsRepo {
  ThemeSettingsRepo(this._appSettings);

  final AppSettingsRepo _appSettings;

  static const _selectionKey = 'theme_selection'; // absent => system

  Future<String?> readSelection() async {
    final v = await _appSettings.get(_selectionKey);
    if (v == null || v.trim().isEmpty) return null;
    return v.trim().toLowerCase();
  }

  Future<void> writeSelection(String? selection) async {
    final v = selection?.trim().toLowerCase();
    if (v == null || v.isEmpty) {
      await _appSettings.set(_selectionKey, null);
      return;
    }
    await _appSettings.set(_selectionKey, v);
  }
}
