import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/ports/schedules_repo_port.dart';
import '../db/db_providers.dart';
import 'absences_repo.dart';
import 'app_settings_repo.dart';
import 'auth_repo.dart';
import 'employees_repo.dart';
import 'locale_settings_repo.dart';
import 'schedules_repo.dart';
import 'sessions_repo.dart';
import 'theme_settings_repo.dart';
import 'attendance_settings_repo.dart';
import 'working_hours_settings_repo.dart';
import 'tracking_start_settings_repo.dart';

final attendanceSettingsRepoProvider = Provider<AttendanceSettingsRepo>((ref) {
  return AttendanceSettingsRepo(ref.watch(appSettingsRepoProvider));
});

final authRepoProvider = Provider<AuthRepo>((ref) {
  final db = ref.watch(appDbProvider);
  return AuthRepo(db);
});

final employeesRepoProvider = Provider<EmployeesRepo>((ref) {
  final db = ref.watch(appDbProvider);
  return EmployeesRepo(db, ref.watch(schedulesRepoProvider));
});

final sessionsRepoProvider = Provider<SessionsRepo>((ref) {
  final db = ref.watch(appDbProvider);
  return SessionsRepo(db);
});

final absencesRepoProvider = Provider<AbsencesRepo>((ref) {
  final db = ref.watch(appDbProvider);
  return AbsencesRepo(db);
});

final schedulesRepoProvider = Provider<ISchedulesRepo>((ref) {
  final db = ref.watch(appDbProvider);
  return SchedulesRepo(db);
});

final appSettingsRepoProvider = Provider<AppSettingsRepo>((ref) {
  final db = ref.watch(appDbProvider);
  return AppSettingsRepo(db);
});

final localeSettingsRepoProvider = Provider<LocaleSettingsRepo>((ref) {
  return LocaleSettingsRepo(ref.watch(appSettingsRepoProvider));
});

final themeSettingsRepoProvider = Provider<ThemeSettingsRepo>((ref) {
  return ThemeSettingsRepo(ref.watch(appSettingsRepoProvider));
});

final workingHoursSettingsRepoProvider = Provider<WorkingHoursSettingsRepo>((
  ref,
) {
  return WorkingHoursSettingsRepo(ref.watch(appSettingsRepoProvider));
});

final trackingStartSettingsRepoProvider = Provider<TrackingStartSettingsRepo>((
  ref,
) {
  return TrackingStartSettingsRepo(ref.watch(appSettingsRepoProvider));
});
