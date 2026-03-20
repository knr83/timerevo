import 'app_settings_repo.dart';

class TrackingStartSettingsRepo {
  TrackingStartSettingsRepo(this._appSettings);

  final AppSettingsRepo _appSettings;

  static const key = 'tracking_start_date_ymd';

  Future<String?> read() => _appSettings.get(key);

  Future<void> write(String? ymd) => _appSettings.set(key, ymd);
}
