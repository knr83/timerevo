import 'app_settings_repo.dart';

class WorkingHoursSettingsRepo {
  WorkingHoursSettingsRepo(this._appSettings);

  final AppSettingsRepo _appSettings;

  static const _startMinKey = 'working_hours_start_min';
  static const _endMinKey = 'working_hours_end_min';

  Future<int?> readStartMin() async {
    final v = await _appSettings.get(_startMinKey);
    if (v == null) return null;
    return int.tryParse(v);
  }

  Future<int?> readEndMin() async {
    final v = await _appSettings.get(_endMinKey);
    if (v == null) return null;
    return int.tryParse(v);
  }

  Future<({int? startMin, int? endMin})> read() async {
    final startStr = await _appSettings.get(_startMinKey);
    final endStr = await _appSettings.get(_endMinKey);
    return (
      startMin: startStr != null ? int.tryParse(startStr) : null,
      endMin: endStr != null ? int.tryParse(endStr) : null,
    );
  }

  Future<void> write({required int startMin, required int endMin}) async {
    await _appSettings.set(_startMinKey, startMin.toString());
    await _appSettings.set(_endMinKey, endMin.toString());
  }
}
