import '../../core/attendance_mode.dart';
import 'app_settings_repo.dart';

class AttendanceSettingsRepo {
  AttendanceSettingsRepo(this._appSettings);

  final AppSettingsRepo _appSettings;

  static const _modeKey = 'attendance_mode';
  static const _toleranceKey = 'attendance_tolerance_minutes';

  static const defaultToleranceMinutes = 10;

  Future<AttendanceMode?> readMode() async {
    final v = await _appSettings.get(_modeKey);
    if (v == null) return null;
    return switch (v) {
      'fixed' => AttendanceMode.fixed,
      _ => AttendanceMode.flexible,
    };
  }

  Future<int?> readToleranceMinutes() async {
    final v = await _appSettings.get(_toleranceKey);
    if (v == null) return null;
    return int.tryParse(v);
  }

  Future<({AttendanceMode mode, int toleranceMinutes})> read() async {
    final mode = await readMode();
    final tolerance = await readToleranceMinutes();
    return (
      mode: mode ?? AttendanceMode.flexible,
      toleranceMinutes: tolerance ?? defaultToleranceMinutes,
    );
  }

  Future<void> writeMode(AttendanceMode mode) async {
    await _appSettings.set(
      _modeKey,
      mode == AttendanceMode.fixed ? 'fixed' : 'flexible',
    );
  }

  Future<void> writeTolerance(int minutes) async {
    await _appSettings.set(_toleranceKey, minutes.toString());
  }

  Future<void> write({required AttendanceMode mode, required int toleranceMinutes}) async {
    await _appSettings.set(
      _modeKey,
      mode == AttendanceMode.fixed ? 'fixed' : 'flexible',
    );
    await _appSettings.set(_toleranceKey, toleranceMinutes.toString());
  }
}
